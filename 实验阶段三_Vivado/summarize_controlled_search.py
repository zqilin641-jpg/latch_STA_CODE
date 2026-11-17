"""Rank only candidates with matched pins, functional checks and native brackets."""
import csv
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent / 'controlled_search'
def pins(path):
    with path.open(newline='') as stream:
        return {r['port']:r['package_pin'] for r in csv.DictReader(stream, delimiter='\t')}

manifest = {r['design']:r for r in json.loads((ROOT/'manifest.json').read_text())}
results = json.loads((ROOT/'solve/results.json').read_text())
shared = pins(ROOT/'shared_pins.tsv')
hashes, rows = set(), []
if {r['design'] for r in results} != set(manifest):
    raise ValueError('Search coverage incomplete')
for r in results:
    name = r['design']
    run = ROOT/name
    cfg = manifest[name]
    functional = json.loads((run/'functional/result.json').read_text())
    if not r['native_validated'] or not functional['passed']:
        raise ValueError('Unvalidated candidate: '+name)
    if pins(run/'pins.tsv') != shared:
        raise ValueError('IO placement differs: '+name)
    structure = (run/'structure.txt').read_text().splitlines()
    for expected in (f"FF_COUNT {cfg['ff']}",f"LATCH_COUNT {cfg['latch']}",'CLOCK_COUNT 1','UNIQUE_CLOCK_NETS clk'):
        if expected not in structure:
            raise ValueError('Clock/storage mismatch: '+name)
    digest = hashlib.sha256((run/'timing.xdc').read_bytes()).hexdigest()
    hashes.add(digest)
    rows.append(dict(design=name, cuts=cfg['cuts'], period_ns=r['lp_period_ns'], frequency_mhz=r['frequency_mhz'],
                     ff=cfg['ff'], latch=cfg['latch'], native_bracket=r['native_bracket'], critical_edges=r['critical_edges'],
                     pin_map_matches=True, xdc_sha256=digest, checkpoint_sha256=hashlib.sha256((run/'routed.dcp').read_bytes()).hexdigest()))
if len(hashes) != 1:
    raise ValueError('Timing/physical constraints differ')
rows.sort(key=lambda r:r['period_ns'])
best_ff = min((r for r in rows if not r['latch']),key=lambda r:r['period_ns'])
best_latch = min((r for r in rows if r['latch']),key=lambda r:r['period_ns'])
gain = 100*(best_ff['period_ns']/best_latch['period_ns']-1)
result = dict(rows=rows, best_ff=best_ff['design'], best_latch=best_latch['design'],
              best_latch_vs_best_ff_frequency_pct=gain,
              scope='Bounded 5-candidate heuristic search. Actual shared IO pin map verified. Native period brackets are fixed-route, not global Fmax.')
(ROOT/'ranking.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
text = '''# 第三阶段：固定IO的自动候选搜索

2026-11-10。保持16位12运算基准、五个采样沿输出有效、每拍吞吐一个输入。IO引脚从上一轮原始FF实际布局导出，并写入所有候选XDC；每组布线后再次核对35个端口的引脚映射。所有存储连接同一个BUFG时钟，50%占空比，无独立相位或PLL。

自动生成规则：枚举165种三处分界，按最长运算段长度、各段长度平方和进行启发式排序，取两种纯FF候选；对最均衡分界逐一替换三个内部FF级为高透明Latch，共五个物理候选。不是165种全部布局布线，也不是通用网表重定时搜索。每个混合候选补一组输出FF以保持输出拍次，含85 FF与16 Latch；纯FF含85 FF。每组4114次逐拍检查包括复位及valid，零错误；无形式等价证明或SDF仿真。

|候选|固定布线周期(ns)|频率边界约(MHz)|FF|Latch|
|---|---:|---:|---:|---:|
'''
for r in rows:
    text += f"|{r['design']}|{r['period_ns']:.3f}|{r['frequency_mhz']:.3f}|{r['ff']}|{r['latch']}|\n"
text += f"\n本轮最佳纯FF：{best_ff['design']}；最佳混合：{best_latch['design']}。最佳混合相对最佳纯FF频率变化{gain:+.2f}%。\n"
for label, candidate in [('最佳纯FF',best_ff),('最佳混合',best_latch)]:
    witness = candidate['critical_edges'][0]['evidence']
    text += f"\n{label}关键路径：`{witness['start']}` → `{witness['end']}`（{witness['corner']}）。[原生报告]({Path(witness['report']).as_posix()})\n"
text += '''
候选的周期由实际用户Howard可执行程序求解，独立LP一致，再用Vivado在预测周期上下0.01 ns回验通过/失败。最终排序只接受上述检查及物理引脚核对通过的候选。Howard评价单公共时钟的约化约束，不输出各Latch相位；分界和替换位置由外层枚举生成。

这些是同一器件、固定引脚、同一接口约束下各自布线的结果，不是所有分界/布局的全局最优。固定IO不意味着内部布局相同；因此小幅差异也不能证明Latch本身必然带来提升。保留原生DRC，未配置具体开发板电压属性、未生成下载比特流、未上板。

本次最佳两组均受输出接口路径限制。表中频率差异属于这轮候选实现的观测结果，不能单独证明时间借用导致提频；尚未进行多个实现策略的稳健性比较。下一步应控制输出寄存器实现并研究内部路径主导的候选，而不是将本轮小幅领先包装成普遍结论。

关键路径、原生回验报告、Howard日志、约束图、文件哈希均可由ranking.json追溯。search_plan.json记录候选空间与筛选规则；shared_pins.tsv记录共同引脚。

复现入口：python run_controlled_search.py --log，按顺序重新生成/仿真/实现/导出/求解/回验/排序，会重建当前生成产物。--dry-run仅打印命令，--log控制额外流水线控制台日志；Vivado原生报告仍保留。各组成步骤已在本轮执行，入口脚本已做dry-run检查，未为了验证入口再次重跑整批物理实现。
'''
(ROOT/'REPORT.md').write_text(text,encoding='utf-8')
sys.stdout.reconfigure(encoding='utf-8')
print(text)

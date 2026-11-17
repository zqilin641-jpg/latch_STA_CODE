"""Write comparison only after cycle checks, physical invariants and native STA."""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent / 'retiming_benchmark'
results = json.loads((ROOT / 'solve/results.json').read_text())
manifest = {r['design']: r for r in json.loads((ROOT / 'manifest.json').read_text())}
hashes = set()
rows = []
for result in results:
    name = result['design']
    run = ROOT / name
    if not result['native_validated']:
        raise ValueError('Native STA not validated')
    functional = json.loads((run / 'functional/result.json').read_text())
    if not functional['passed']:
        raise ValueError('Cycle check failed')
    structure = (run / 'structure.txt').read_text()
    expected = manifest[name]
    for line in [f"FF_COUNT {expected['ff']}", f"LATCH_COUNT {expected['latch']}", 'CLOCK_COUNT 1', 'UNIQUE_CLOCK_NETS clk']:
        if line not in structure.splitlines():
            raise ValueError('Physical structure mismatch: ' + line)
    digest = hashlib.sha256((run / 'timing.xdc').read_bytes()).hexdigest()
    hashes.add(digest)
    rows.append(dict(design=name, period_ns=result['lp_period_ns'], frequency_mhz=result['frequency_mhz'],
                     ff=expected['ff'], latch=expected['latch'], critical=result['critical_edges'],
                     native_bracket=result['native_bracket'], functional=functional,
                     constraint_sha256=digest, checkpoint_sha256=hashlib.sha256((run/'routed.dcp').read_bytes()).hexdigest()))
if len(rows) != 3 or len(hashes) != 1:
    raise ValueError('Incomplete/unmatched comparison')
by_name = {r['design']: r for r in rows}
comparison = dict(results=rows,
                 ff_retiming_gain_pct=100*(by_name['ff_original']['period_ns']/by_name['ff_retimed']['period_ns']-1),
                 mixed_vs_original_gain_pct=100*(by_name['ff_original']['period_ns']/by_name['mixed_aligned']['period_ns']-1),
                 mixed_vs_retimed_ff_gain_pct=100*(by_name['ff_retimed']['period_ns']/by_name['mixed_aligned']['period_ns']-1))
(ROOT/'comparison.json').write_text(json.dumps(comparison, indent=2), encoding='utf-8')
text = '''# 第三阶段：保持输出拍次的重定时对照

2026-11-10。新基准为16位、12个串联旋转加常数运算，吞吐率每拍一个输入。三个版本使用相同XDC、器件xc7a35tcpg236-1、公共BUFG时钟和50%占空比。复位后前四个采样沿valid_out=0、输出为0；第五个采样沿开始输出第一个样本。功能检查包含反复复位与有效信号，三组各4114次检查零错误。这是仿真覆盖，不是形式等价证明或SDF仿真。

原始FF在第1、2、11、12个运算后寄存；FF重划分在第3、6、9、12个运算后寄存。混合方案将第3个运算后的FF换成同相高透明Latch，并在末端补回一拍，因此所有方案有效输出拍次一致。包含valid流水线后，原始/重划分各85 FF；混合85 FF+16 Latch。补偿寄存器已计入，未隐瞒面积代价。分界是手工构造的受控候选，非自动retiming搜索。

|方案|固定布线周期边界(ns)|约频率(MHz)|FF|Latch|
|---|---:|---:|---:|---:|
'''
for row in rows:
    text += f"|{row['design']}|{row['period_ns']:.3f}|{row['frequency_mhz']:.3f}|{row['ff']}|{row['latch']}|\n"
text += f"\nFF重划分相对原始频率变化：{comparison['ff_retiming_gain_pct']:.2f}%；混合相对原始：{comparison['mixed_vs_original_gain_pct']:.2f}%；混合相对重划分FF：{comparison['mixed_vs_retimed_ff_gain_pct']:.2f}%。\n"
text += '''
本轮结论：纯FF重新划分已经取得提频；混合方案未比重划分FF更快，因此没有证据把原始到混合的15.77%变化归因于Latch。原始的关键路径是ff_cut2_15/C→ff_cut11_13/D；重划分FF与混合分别受ff_cut12_09/C→result[9]、alignment_ff_15/C→result[15]输出路径限制。约0.93%的差异不能推广为Latch一般更慢，尤其两组IO布局未固定一致。

后续优化需要把候选分界/替换位置作为外层搜索变量，Howard作为单公共时钟可行周期评价器，并保留纯FF候选。若要判断Latch的独立收益，应控制IO布局并检查内部路径瓶颈，而不是恢复逐Latch独立移相。当前尚未实现自动重定时搜索，第三阶段未宣告完成。

Howard实际调用用户仓库build_howard_app/pds_howard，使用独立LP复核；各候选的原生Vivado回验必须在预测周期+0.01 ns通过、−0.01 ns失败，才纳入此表。模型是固定公共时钟、孤立Latch的约化约束图，输入沿用每个候选自己的布线数据，保留G/D传播及关闭界限，不分配独立相位。候选选择在Howard外部完成。数字是当前布线的边界估计，不是多次重新布局搜索的全局Fmax。

端口未绑定开发板，自动放置IO，保留UCIO/配置电压相关DRC记录；没有生成板级比特流或上板测试。三组相同XDC不等于完全相同IO物理位置。新的较宽基准不能与旧25节点电路直接算提升比；只能在本表内部比较。原始到混合的收益不能全部归因于Latch，必须同时看纯FF重划分对照。

复现：build_retiming_benchmark.py生成；check_retiming_function.py检查输出拍次；Vivado运行本目录build.tcl、export.tcl；stage3_solve.py指定--root本目录 --out本目录/solve --expected-count 0 --designs ff_original ff_retimed mixed_aligned；Vivado运行solve/validate.tcl；stage3_verify.py --out本目录/solve；report_retiming.py生成本报告。
'''
(ROOT/'REPORT.md').write_text(text, encoding='utf-8')
sys.stdout.reconfigure(encoding='utf-8')
print(text)

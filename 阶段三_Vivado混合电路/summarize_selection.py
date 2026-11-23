"""Summarize selection candidates without treating internal bounds as device Fmax."""
import hashlib
import csv
import sys
import json
from stage3_solve import ROOT, OUT

results = json.loads((OUT / 'results.json').read_text())
rows = []
hashes = set()
internal_native = []
if (OUT / 'internal_native.tsv').exists():
    with (OUT / 'internal_native.tsv').open(newline='') as stream:
        internal_native = list(csv.DictReader(stream, delimiter='\t'))
for result in results:
    name = result['design']
    if not result['native_validated']:
        raise ValueError('Native validation missing: ' + name)
    functional = json.loads((ROOT / name / 'functional/result.json').read_text())
    if not functional['passed']:
        raise ValueError('Functional mismatch: ' + name)
    structure = (ROOT / name / 'structure.txt').read_text()
    if 'CLOCK_COUNT 1' not in structure or 'UNIQUE_CLOCK_NETS clk' not in structure:
        raise ValueError('Common-clock invariant violated: ' + name)
    constraint_hash = hashlib.sha256((ROOT / name / 'timing.xdc').read_bytes()).hexdigest()
    hashes.add(constraint_hash)
    graph = json.loads((OUT / name / 'graph.json').read_text())
    internal = [e for e in graph['edges'] if '/' in e['evidence'].get('start', '')
                and '/' in e['evidence'].get('end', '') and e['k'] > 0]
    worst = max(internal, key=lambda e: e['d_ns'] / e['k'])
    native_checks = [r for r in internal_native if r['design'] == name]
    if internal_native:
        if len(native_checks) != 8:
            raise ValueError('Missing internal corner checks: ' + name)
        if any(float(r['slack']) < 0 for r in native_checks if r['tag'] == 'above'):
            raise ValueError('Internal predicted passing bound failed: ' + name)
        if not any(float(r['slack']) < 0 for r in native_checks if r['tag'] == 'below' and r['check'] == 'max'):
            raise ValueError('Internal predicted failing bound did not fail: ' + name)
    rows.append(dict(design=name, period_ns=result['lp_period_ns'], approximate_frequency_mhz=result['frequency_mhz'],
                     internal_constraint_period_lower_bound_ns=worst['d_ns']/worst['k'],
                     internal_constraint_witness=worst['evidence'],
                     internal_native_checks=native_checks,
                     latency_cycles=functional['latency_cycles'],
                     xdc_sha256=constraint_hash, checkpoint_sha256=hashlib.sha256((ROOT / name / 'routed.dcp').read_bytes()).hexdigest(),
                     native_bracket=result['native_bracket']))
if len(hashes) != 1:
    raise ValueError('Candidate constraints differ')
(OUT / 'selection_results.json').write_text(json.dumps(rows, indent=2), encoding='utf-8')
text = '''# 第三阶段：单级选择性替换搜索

内部级1、2、3分别替换为5个高透明Latch，其余20个存储保留FF。所有存储连接同一个BUFG输出clk，无独立相位或PLL。三个候选使用与纯FF相同的XDC（SHA256核对一致），输入/输出FF及接口延时约束保留。只新增第2、3级候选的综合实现；第1级与纯FF复用原有检查点。

|候选|固定布线周期边界(ns)|约频率(MHz)|内部约束周期下界(ns)|功能延迟(周期)|
|---|---:|---:|---:|---:|
'''
for row in rows:
    text += f"|{row['design']}|{row['period_ns']:.3f}|{row['approximate_frequency_mhz']:.3f}|{row['internal_constraint_period_lower_bound_ns']:.3f}|{row['latency_cycles']}|\n"
text += '''
所有候选Howard与独立LP一致，并经Vivado验证12.91 ns通过、12.89 ns setup失败。新增候选的AMD原语功能仿真各2048次输出0错误（无SDF）；混合方案减少一周期延迟，非逐拍等价。均无整体频率提升，关键路径仍是ff_22/C→result[2]。

“内部约束周期下界”仅用于定位被接口瓶颈遮盖的内部变化，不是移除接口约束后的实测Fmax。它来自当前受限模型，尚未针对内部成为瓶颈的周期点单独验证。当前Howard在固定公共时钟下求约束周期，选择性替换由外层候选枚举完成；不声称Howard自动选择替换位置。

这轮搜索仅覆盖三个单级候选，未覆盖按bit替换、连续Latch透明链、retiming。器件端口仍自动放置，未做板级实现。固定布线边界不是重新布局搜索得到的全局最高频率。

下一步应构建内部组合路径主导的基准，并先保证纯FF/混合功能语义可比，再进行替换搜索。不能通过删除接口约束把本次结果改称提频。
'''
if internal_native:
    text = text.replace('它来自当前受限模型，尚未针对内部成为瓶颈的周期点单独验证。', '它来自当前受限模型，并已针对内部边界进行原生STA专项回验。')
    text = text.replace('下一步应构建内部组合路径主导的基准，并先保证纯FF/混合功能语义可比，再进行替换搜索。不能通过删除接口约束把本次结果改称提频。', '后续需先修正候选变换方式：保持事务语义，联合重定时与逻辑划分，并采用纯FF重定时对照。不能通过删除接口约束把本次结果改称提频。')
    text += '''
## 内部边界专项回验（追加）

已保留完整XDC，对20个内部存储D端进行Slow/Fast、max/min原生查询。每组在表中内部下界+0.02 ns时内部setup/hold通过，下界−0.02 ns时内部setup失败。32项查询及完整路径报告见internal_native.tsv与各候选internal_*.rpt。此时外部IO可能违规，不能称整个电路能够以该内部周期运行。

结果：直接把正沿FF替换为同相高透明Latch，在本例没有改善内部时序，三个候选都退化。模型保留了借用，而不是漏算借用；第2级候选的失败见证还明确从Latch的D端出发。高透明Latch在T/2关闭，给前一级的数据截止时间与原先下一上升沿T不同，且替换使事务延迟由5周期降为4周期。因此不能把这种直接替换视作保证提频的优化。

下一轮应先引入保持事务语义的重定时与逻辑划分候选，并以纯FF重定时作为对照；仅扩大电路规模或继续同样的整级替换不能保证收益。所有时钟仍须共享同一波形。
'''
(OUT / 'SELECTION_REPORT.md').write_text(text, encoding='utf-8')
sys.stdout.reconfigure(encoding='utf-8')
print(text)

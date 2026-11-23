"""Verify actual invariants and publish the matched frequency experiment."""
import csv
import json
import re
from pathlib import Path

B=Path(__file__).resolve().parent
R=B/'frequency_search'
def tsv(p):
    with p.open() as f: return list(csv.DictReader(f,delimiter='\t'))
results=json.loads((R/'solve/results.json').read_text())
manifest={x['design']:x for x in json.loads((R/'manifest.json').read_text())}
pins={x['port']:x['package_pin'] for x in tsv(R/'shared_pins.tsv')}
sites=None
for x in results:
    name=x['design']; run=R/name; cfg=manifest[name]
    assert x['native_validated'], name
    f=json.loads((run/'functional/result.json').read_text())
    assert f['passed'] and f['observations']==[['4114','0']]
    assert {p['port']:p['package_pin'] for p in tsv(run/'pins.tsv')}==pins
    actual={p['cell']:(p['loc'],p['bel']) for p in tsv(run/'output_registers.tsv') if p['ref_name']=='FDCE'}
    assert len(actual)==17 and all('OUTFF' in p[1] for p in actual.values())
    if sites is None: sites=actual
    assert sites==actual
    struct=(run/'structure.txt').read_text().splitlines()
    for check in (f"FF_COUNT {cfg['ff']}",f"LATCH_COUNT {cfg['latch']}",'CLOCK_COUNT 1','UNIQUE_CLOCK_NETS clk'):
        assert check in struct, (name,check)
    x['ff']=cfg['ff']; x['latch']=cfg['latch']; x['checks']=4114
    graph=json.loads((R/'solve'/name/'graph.json').read_text())
    internal=[e['d_ns']/e['k'] for e in graph['edges'] if '/' in e['evidence'].get('start','') and '/' in e['evidence'].get('end','')]
    x['internal_only_bound_ns']=max(internal)
old=json.loads((B/'output_control/solve/results.json').read_text())
old_l=next(x for x in old if x['design']=='latch6_output_iob')
new_l=next(x for x in results if x['design']=='latch_short_4')
new_f=next(x for x in results if x['design']=='ff_balanced')
gain=(new_l['frequency_mhz']/old_l['frequency_mhz']-1)*100
delta=(new_l['frequency_mhz']/new_f['frequency_mhz']-1)*100
state=dict(results=results,native_screen=tsv(R/'screen.tsv'),latch_gain_vs_previous_pct=gain,latch_vs_matched_ff_pct=delta,
           conclusions='Latch frequency improved; no Latch advantage over matched FF. Same output path limits both.',
           scope='Fixed-route STA period bounds, not global optimal frequency or board measurement.')
(R/'comparison.json').write_text(json.dumps(state,indent=2),encoding='utf-8')
text=f'''# 单时钟部分替换：频率提升实验

2026-11-11。延续Pairl式候选变换，但本轮采用缩短Latch前逻辑段的定向候选筛选，不宣称论文完整复现或全局最优。

## 改动与公平对照

三组均用同一器件xc7a35tcpg236-1、35个相同引脚、单BUFG时钟、50%占空比，以及相同输入/输出延时与不确定度。最终17个输出FF均在同一IOB位置/BEL。对两类电路统一设置输出SLEW FAST，以10 ns目标实施布局、物理优化和布线。未放松接口延时，未使用多时钟或独立相位。

FF边界为3、6、9、12；选中的混合候选为FF3、Latch4、FF8、FF12，另有补偿输出FF。只转换一组16位存储，其余原有69个FF保留，另插入16个补偿FF，总计85 FF和16 Latch。补偿FF保持原有五个采样沿后的输出/valid语义。另一混合候选FF4、Latch5、FF9、FF12的原生筛选频率相同，未重复进行完整Howard导出。

## 结果

|方案|固定布线周期边界(ns)|频率约(MHz)|FF|Latch|
|---|---:|---:|---:|---:|
'''
for x in results:
    text+=f"|{x['design']}|{x['lp_period_ns']:.3f}|{x['frequency_mhz']:.3f}|{x['ff']}|{x['latch']}|\n"
text+=f'''
混合候选相对此前80.489 MHz提高约{gain:.2f}%；相对本轮同条件FF为{delta:.2f}%。这证明本轮消除了先前Latch候选的额外内部瓶颈，并提高了其整体频率，但没有证明Latch优于FF。提升包含候选边界、布局目标和IO驱动的共同影响，不能单独归因于时间借用。

最差路径仍为output_ff_08/C到result[8]。后续要突破这一频率，须优化公共时钟/输出接口这一共同瓶颈；仅继续移动内部Latch不能保证提高整机频率。修改公共时钟架构或接口时，必须对FF与混合电路做相同改动。

每版4114次RTL厂商原语模型功能检查零错误；原生STA二分筛选检查setup、hold和脉宽；两个入选候选完整导出相邻节点证据，执行实际Howard、独立LP，并以原生STA在求解周期上下0.01 ns回验。日志和各条路径报告均保留。IO快速边沿尚未做板级信号完整性验证，未进行SDF或上板测试。本结果是固定布线边界，不是全局最高频率证明。

复现入口：prepare_frequency_search.py → check_retiming_function.py → frequency_search/build.tcl → screen_frequency.tcl → frequency_search/export_finalists.tcl → stage3_solve.py → solve/validate.tcl → stage3_verify.py → report_frequency_search.py。
'''
(R/'REPORT.md').write_text(text,encoding='utf-8')
print(json.dumps(state,indent=2))

"""Audit a bounded post-STA selective-replacement iteration and retain best-so-far."""
import csv
import hashlib
import json
import sys
from pathlib import Path

BASE = Path(__file__).resolve().parent
ROOT = BASE/'pairl_iteration'
plan = json.loads((ROOT/'candidate_plan.json').read_text(encoding='utf-8'))
def table(path):
    with path.open() as f:
        return list(csv.DictReader(f,delimiter='\t'))
shared_pins = {r['port']:r['package_pin'] for r in table(ROOT/'shared_pins.tsv')}
reference_sites = None
rows = []
for group in ('output_control','pairl_iteration'):
    root = BASE/group
    manifest = {r['design']:r for r in json.loads((root/'manifest.json').read_text())}
    for result in json.loads((root/'solve/results.json').read_text()):
        name = result['design']
        run = root/name
        functional = json.loads((run/'functional/result.json').read_text())
        if not result['native_validated'] or not functional['passed']:
            raise ValueError('Unvalidated candidate '+name)
        actual_pins = {r['port']:r['package_pin'] for r in table(run/'pins.tsv')}
        if actual_pins != shared_pins:
            raise ValueError('Physical IO mismatch')
        outputs = {r['cell']:(r['loc'],r['bel']) for r in table(run/'output_registers.tsv') if r['ref_name']=='FDCE'}
        if len(outputs)!=17 or not all('OUTFF' in p[1] for p in outputs.values()):
            raise ValueError('Output registers did not enter IOB')
        if reference_sites is None:
            reference_sites = outputs
        if outputs != reference_sites:
            raise ValueError('Final output FF LOC/BEL differ')
        structure = (run/'structure.txt').read_text().splitlines()
        cfg = manifest[name]
        for expected in (f"FF_COUNT {cfg['ff']}",f"LATCH_COUNT {cfg['latch']}",'CLOCK_COUNT 1','UNIQUE_CLOCK_NETS clk'):
            if expected not in structure:
                raise ValueError('Clock/storage invariant failed: '+name)
        rows.append(dict(group=group,design=name,period_ns=result['lp_period_ns'],frequency_mhz=result['frequency_mhz'],
                         ff=cfg['ff'],latch=cfg['latch'],critical=result['critical_edges'],
                         native=result['native_bracket'],output_sites=outputs,
                         rtl=str(run/'design.v'),rtl_sha256=hashlib.sha256((run/'design.v').read_bytes()).hexdigest()))
if len(rows)!=4:
    raise ValueError('Expected both prior candidates and both new candidates')
prior = min((r for r in rows if r['group']=='output_control'),key=lambda r:r['period_ns'])
new = min((r for r in rows if r['group']=='pairl_iteration'),key=lambda r:r['period_ns'])
# Require margin exceeding report rounding/native bracket width before accepting.
accepted = new['period_ns'] < prior['period_ns']-.02
best = new if accepted else prior
state = dict(iteration=1,max_iterations_this_run=1,source_plan=plan,
             candidates=rows,previous_best=prior['design'],best_new=new['design'],
             accepted_new_best=accepted,best_so_far=best['design'],best_period_ns=best['period_ns'],
             stop_reason='Bounded first physical-feedback iteration complete',
             implemented_rules=['Post-route eligible critical path','Backward-first or forward fallback',
                                'Selective boundary replacement','Cycle-aligned validation','Physical STA re-evaluation','Best-so-far retention'],
             excluded_scope=['Arbitrary RTL/netlist retiming','General multi-latch transparency graph','Custom configurable FPGA architecture','Formal equivalence'])
(ROOT/'iteration_result.json').write_text(json.dumps(state,indent=2,ensure_ascii=False),encoding='utf-8')
text = '''# Pairl思路接入：STA驱动的部分FF替换（第一轮）

2026-11-11。依据本地《Pairl-ZKX_FPT25投稿版》III-A、III-B及图1/图2（第3–5页）实现：用布线后时序报告选择关键路径边界；优先合法后移，否则前移；只在选中的边界生成Latch替换候选；重新实现并保留历史最好结果。未宣称完整复现论文，也未使用论文定制VTR/HSPICE架构的延时替代AMD原生数据。

本轮选择来自ff_output_iob/setup.rpt：ff_cut9_03/C→output_ff_15/D。输出级受保护，不能后移；源边界从第9个运算后前移到第10个运算后。生成纯FF重定时对照，以及只将新边界16个FF转换为16个LDCE的混合版本。其余69个原有FF保留；为维持原有效输出拍次，混合版另插入16个补偿FF，最终85 FF+16 Latch。每个实例名和原始报告哈希记录在candidate_plan.json。

这是当前顺序数据通路的整字/运算边界变换，不是任意LUT网表的合法重定时器。受保护的全局IO路径跳过后选择最差可处理内部路径，这一范围限制已记录。两版各4114次逐拍检查（复位、valid、数据）零错误，属于仿真覆盖，不是形式等价证明。

为控制上一轮输出布局差异，已将有效数据屏蔽逻辑移到最终FF的D端，并用v[3]保持拍次；将16个数据输出FF及1个valid输出FF放入IOB。四组候选的35个实际引脚及17个输出FF的LOC/BEL逐项完全一致。所有存储仍接一根BUFG时钟，50%占空比。

|方案|周期边界(ns)|频率约(MHz)|FF|Latch|
|---|---:|---:|---:|---:|
'''
for r in rows:
    text += f"|{r['design']}|{r['period_ns']:.3f}|{r['frequency_mhz']:.3f}|{r['ff']}|{r['latch']}|\n"
text += f"\n是否接受新最优：{accepted}。保留最佳：{best['design']}，周期{best['period_ns']:.3f} ns。\n"
text += '''
所有周期经过实际Howard程序、独立LP与Vivado上下0.01 ns的通过/失败回验。最优结果是这些固定布线候选中的最好值，不是全局Fmax。原生hold及脉宽均在通过点检查，不用可自由推迟的最早到达变量替代hold验证。

当前已实现并实际综合了部分FF替换，且替换位置由STA反馈决定；尚未证明这一替换优于同条件纯FF。不能把上一轮0.90%的输出路径差异当作时间借用的独立收益。后续重点是扩展可证明合法的变换与内部关键路径优化，而非继续宣称小幅输出布线差异就是Latch优势。

文件：sta_retime_latch/design.v为部分替换的可综合RTL；candidate_plan.json为位置选择和替换清单；iteration_result.json为回验与保留最优决策。原生时序、单时钟结构、实际引脚和输出寄存器位置均保留在各候选目录。无SDF仿真、未上板；板级配置电压仍未指定。
'''
(ROOT/'REPORT.md').write_text(text,encoding='utf-8')
sys.stdout.reconfigure(encoding='utf-8')
print(text)

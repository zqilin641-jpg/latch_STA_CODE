from pathlib import Path
B=Path.cwd(); R=B/'mmcm_howard'; R.mkdir(exist_ok=True)
# Preserve original checkpoints; enforce explicit cross-clock uncertainty in both groups.
lines=[]
for name,source in [('ff','common_mmcm/ff_balanced'),('mixed','mmcm_retime/balanced_latch5')]:
 d=R/name; d.mkdir(exist_ok=True)
 lines += ['open_checkpoint {'+(B/source/'routed.dcp').as_posix()+'}', 'set_clock_uncertainty -setup 0.2 -from [get_clocks common_clock] -to [get_clocks mm_out]', 'set_clock_uncertainty -hold 0.2 -from [get_clocks common_clock] -to [get_clocks mm_out]', 'set_clock_uncertainty -setup 0.2 -from [get_clocks mm_out] -to [get_clocks common_clock]', 'set_clock_uncertainty -hold 0.2 -from [get_clocks mm_out] -to [get_clocks common_clock]', 'write_checkpoint -force {'+(d/'routed.dcp').as_posix()+'}', 'close_design']
(R/'prepare.tcl').write_text('\n'.join(lines+['exit']))
p=(B/'export_adjacent.tcl').read_text(encoding='utf-8').replace('set root [file dirname [info script]]','set root [file dirname [info script]]').replace('set designs {ff mixed_stage1}','set designs {ff mixed}').replace('-period 20 -waveform {0 10}','-period 10 -waveform {0 5}')
p=p.replace('if {$ref ni {FDCE LDCE}}', 'if {$ref eq "MMCME2_BASE" || $ref eq "MMCME2_ADV"} {continue}\n        if {$ref ni {FDCE LDCE}}')
(R/'export.tcl').write_text(p)
# Explicit reference period supplied by adapter; no changes to prior scripts/results.
p=(B/'stage3_solve.py').read_text(encoding='utf-8').replace(' / 20',' / 10').replace('k * 20','k * 10').replace('10-float(row[8])','5-float(row[8])').replace('t0_ns=20','t0_ns=10').replace('20*e[','10*e[').replace("} 20\"]","} 10\"]")
(B/'solve_mmcm_local.py').write_text(p,encoding='utf-8')


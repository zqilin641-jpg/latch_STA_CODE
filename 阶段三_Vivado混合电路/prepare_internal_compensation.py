import json,shutil,subprocess,sys
from pathlib import Path
B=Path.cwd(); raw=B/'internal_comp_raw'; raw.mkdir(exist_ok=True)
for f in ['shared_pins.xdc','shared_pins.tsv']: shutil.copy2(B/'frequency_search'/f,raw/f)
v={'lat4_ff3_6_10':{str(c):('LATCH' if c==4 else 'FF') for c in [3,4,6,10,12]},'lat7_ff3_6_10':{str(c):('LATCH' if c==7 else 'FF') for c in [3,6,7,10,12]}}
(raw/'variants.json').write_text(json.dumps(v))
subprocess.run([sys.executable,'build_internal_compensation.py','--out',str(raw),'--variants',str(raw/'variants.json')],check=True)
subprocess.run([sys.executable,'prepare_internal_output.py','--source',str(raw),'--out','internal_comp'],check=True)
R=B/'internal_comp'
old='BUFG clock_buffer(.I(clk_in),.O(clk));'
ref=(B/'common_mmcm/ff_balanced/design.v').read_text(); block=ref[ref.index('wire mm_out'):ref.index('wire [15:0] q0')]
for n in v:
 d=R/n
 (d/'design.v').write_text((d/'design.v').read_text().replace(old,block))
 x=(d/'timing.xdc').read_text().replace('-period 20 -waveform {0 10}','-period 10 -waveform {0 5}')
 (d/'timing.xdc').write_text(x+'\nset_property SLEW FAST [get_ports {result[*] valid_out}]\nset_clock_uncertainty 0.2 [get_clocks -include_generated_clocks common_clock]\n')
 t=(d/'build.tcl').read_text().replace(' || [llength [get_clocks]]!=1','').replace('place_design\nroute_design','place_design\nphys_opt_design\nroute_design')
 (d/'build.tcl').write_text(t)

import shutil
shutil.copy2(B/'mmcm_retime/tb.v',R/'tb.v')
for n in v:
 x=R/n/'timing.xdc'
 with x.open('a') as f:
  for a,b in [('common_clock','mm_out'),('mm_out','common_clock')]:
   f.write(f'\nset_clock_uncertainty -setup 0.2 -from [get_clocks {a}] -to [get_clocks {b}]\nset_clock_uncertainty -hold 0.2 -from [get_clocks {a}] -to [get_clocks {b}]\n')

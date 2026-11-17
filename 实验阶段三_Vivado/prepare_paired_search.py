import json,shutil,subprocess,sys
from pathlib import Path
B=Path.cwd(); raw=B/'paired_search_raw'; raw.mkdir(exist_ok=True)
for f in ['shared_pins.xdc','shared_pins.tsv']: shutil.copy2(B/'frequency_search'/f,raw/f)
v={}
for cuts,lat in [([4,8,11,12],5),([3,7,11,12],4)]:
 tag='_'.join(map(str,cuts[:-1])); v['ff_'+tag]={str(c):'FF' for c in cuts}; v['mixed_'+tag]={**v['ff_'+tag],str(lat):'LATCH'}
(raw/'variants.json').write_text(json.dumps(v))
subprocess.run([sys.executable,'build_paired_candidates.py','--out',str(raw),'--variants',str(raw/'variants.json')],check=True)
subprocess.run([sys.executable,'prepare_internal_output.py','--source',str(raw),'--out','paired_search'],check=True)
R=B/'paired_search'
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

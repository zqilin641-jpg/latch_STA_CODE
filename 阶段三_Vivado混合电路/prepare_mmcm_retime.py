import json,shutil,subprocess,sys
from pathlib import Path
B=Path.cwd(); raw=B/'mmcm_retime_raw'; raw.mkdir(exist_ok=True)
for f in ['shared_pins.xdc','shared_pins.tsv']: shutil.copy2(B/'frequency_search'/f,raw/f)
v={'balanced_latch5':{'4':'FF','5':'LATCH','8':'FF','12':'FF'},'balanced_latch6':{'4':'FF','6':'LATCH','8':'FF','12':'FF'}}
(raw/'variants.json').write_text(json.dumps(v))
subprocess.run([sys.executable,'build_retiming_benchmark.py','--out',str(raw),'--variants',str(raw/'variants.json')],check=True)
subprocess.run([sys.executable,'prepare_output_control.py','--source',str(raw),'--out','mmcm_retime'],check=True)
R=B/'mmcm_retime'
old='BUFG clock_buffer(.I(clk_in),.O(clk));'
ref=(B/'common_mmcm/ff_balanced/design.v').read_text(); block=ref[ref.index('wire mm_out'):ref.index('wire [15:0] q0')]
for n in v:
 d=R/n
 (d/'design.v').write_text((d/'design.v').read_text().replace(old,block))
 x=(d/'timing.xdc').read_text().replace('-period 20 -waveform {0 10}','-period 10 -waveform {0 5}')
 (d/'timing.xdc').write_text(x+'\nset_property SLEW FAST [get_ports {result[*] valid_out}]\nset_clock_uncertainty 0.2 [get_clocks -include_generated_clocks common_clock]\n')
 t=(d/'build.tcl').read_text().replace(' || [llength [get_clocks]]!=1','').replace('place_design\nroute_design','place_design\nphys_opt_design\nroute_design')
 (d/'build.tcl').write_text(t)

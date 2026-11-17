"""Matched FAST IO candidates; preserve previous results and common clock."""
import json
import shutil
import subprocess
import sys
from pathlib import Path

B = Path(__file__).resolve().parent
raw, out = B/'frequency_search_raw', B/'frequency_search'
raw.mkdir(exist_ok=True)
for f in ('shared_pins.xdc','shared_pins.tsv'):
    shutil.copy2(B/'controlled_search'/f, raw/f)
variants = {
    'ff_balanced': {'3':'FF','6':'FF','9':'FF','12':'FF'},
    'latch_short_4': {'3':'FF','4':'LATCH','8':'FF','12':'FF'},
    'latch_short_5': {'4':'FF','5':'LATCH','9':'FF','12':'FF'},
}
(raw/'variants.json').write_text(json.dumps(variants,indent=2))
subprocess.run([sys.executable,str(B/'build_retiming_benchmark.py'),'--out',str(raw),'--variants',str(raw/'variants.json')],check=True)
subprocess.run([sys.executable,str(B/'prepare_output_control.py'),'--source',str(raw),'--out',str(out)],check=True)
for name in variants:
    xdc=out/name/'timing.xdc'
    xdc.write_text(xdc.read_text()+'\nset_property SLEW FAST [get_ports {result[*] valid_out}]\n')
    # Implement at the target rather than only evaluating a loose 20 ns route.
    xdc.write_text(xdc.read_text().replace('-period 20 -waveform {0 10}', '-period 10 -waveform {0 5}'))
    tcl=out/name/'build.tcl'
    tcl.write_text(tcl.read_text().replace('place_design\nroute_design', 'place_design\nphys_opt_design\nroute_design'))
(out/'experiment.json').write_text(json.dumps(dict(target_period_ns=10,output_slew='FAST',clock_count=1,duty_cycle=.5,variants=variants,limits='Unchanged IO delays/pins; no board signal-integrity validation; compensation FF retained for mixed candidates'),indent=2))
print(out)

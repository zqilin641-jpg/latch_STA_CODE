"""Reproduce the bounded fixed-pin search. Existing generated artifacts are rebuilt."""
import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

BASE = Path(__file__).resolve().parent
ROOT = BASE/'controlled_search'
VIVADO = 'D:/xilinx/Vivado/2024.1/bin/vivado.bat'
parser = argparse.ArgumentParser(__doc__)
parser.add_argument('--dry-run', action='store_true', help='Print commands without executing or changing files')
parser.add_argument('--log', action='store_true', help='Also save pipeline subprocess console logs')
args = parser.parse_args()
def python(script, *extra):
    return [sys.executable, str(BASE/script), *map(str, extra)]
def vivado(script, name):
    return [VIVADO,'-mode','batch','-source',str(script),'-log',str(ROOT/(name+'.log')),'-journal',str(ROOT/(name+'.jou'))]
names = ['ff_3_6_9','ff_2_5_8','latch_at_3','latch_at_6','latch_at_9']
steps = [
    ('pins',vivado(BASE/'extract_shared_pins.tcl','pins')),
    ('plan',python('plan_controlled_search.py')),
    ('generate',python('build_retiming_benchmark.py','--out',ROOT,'--variants',ROOT/'variants.json')),
    ('functional',python('check_retiming_function.py','--root',ROOT)),
    ('implementation',vivado(ROOT/'build.tcl','build')),
    ('export',vivado(ROOT/'export.tcl','export')),
    ('howard',python('stage3_solve.py','--root',ROOT,'--out',ROOT/'solve','--expected-count',0,'--designs',*names)),
    ('native_validation',vivado(ROOT/'solve/validate.tcl','validate')),
    ('verify',python('stage3_verify.py','--out',ROOT/'solve')),
    ('rank',python('summarize_controlled_search.py')),
]
if args.dry_run:
    print(json.dumps(steps,indent=2))
    raise SystemExit(0)
ROOT.mkdir(exist_ok=True)
for name, command in steps:
    print('RUN '+name, flush=True)
    result = subprocess.run(command, cwd=BASE, capture_output=True, timeout=1800)
    content = result.stdout + result.stderr
    if args.log:
        (ROOT/f'pipeline_{name}.log').write_bytes(content)
    if result.returncode or re.search(rb'^ERROR:', content, re.M):
        sys.stderr.buffer.write(content[-10000:])
        raise RuntimeError('Pipeline stopped at '+name)
    print('DONE '+name, flush=True)
print(ROOT/'REPORT.md')

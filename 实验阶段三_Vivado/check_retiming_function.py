"""Independent cycle/valid reference with reset re-entry, using AMD models."""
import json
import re
import subprocess
import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parent / 'retiming_benchmark'
parser = argparse.ArgumentParser(__doc__)
parser.add_argument('--root', type=Path, default=ROOT)
ROOT = parser.parse_args().root.resolve()
vendor = Path('D:/xilinx/Vivado/2024.1/data/verilog/src')
sim = Path('E:/real-modelsim/win64')
results = []
for item in json.loads((ROOT / 'manifest.json').read_text()):
    name = item['design']
    out = ROOT / name / 'functional'
    out.mkdir(exist_ok=True)
    commands = [['vmap', '-c'], ['vlib', 'work'], ['vlog', '-sv', str(vendor/'glbl.v'),
        *[str(vendor/'unisims'/f'{cell}.v') for cell in ('BUFG','FDCE','LDCE')], str(ROOT/name/'design.v'), str(ROOT/'tb.v')],
        ['vsim','-c','-novopt','-t','1ps','work.tb','work.glbl','-do','onerror {quit -code 2}; run -all; quit -f']]
    log = ''
    for cmd in commands:
        p = subprocess.run([str(sim/(cmd[0]+'.exe')), *cmd[1:]], cwd=out, capture_output=True, timeout=120)
        log += (p.stdout+p.stderr).decode(errors='replace')
        (out/'run.log').write_text(log)
        if p.returncode:
            raise RuntimeError(str(out/'run.log'))
    matches = re.findall(r'ALIGNED_RESULT checks=(\d+) errors=(\d+)', log)
    passed = len(matches) == 1 and int(matches[0][0]) > 4096 and int(matches[0][1]) == 0
    result = dict(design=name, passed=passed, observations=matches, scope='RTL vendor-model simulation, reset and validity included; no SDF or formal proof')
    (out/'result.json').write_text(json.dumps(result, indent=2))
    results.append(result)
    if not passed:
        raise ValueError(result)
(ROOT/'functional_results.json').write_text(json.dumps(results, indent=2))
print(json.dumps(results, indent=2))

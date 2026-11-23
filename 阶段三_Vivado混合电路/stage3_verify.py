"""Require a native passing/failing bracket before reporting a period boundary."""
import json
import argparse
import re
from pathlib import Path
from stage3_solve import OUT

parser = argparse.ArgumentParser(__doc__)
parser.add_argument('--out', type=Path, default=OUT)
OUT = parser.parse_args().out.resolve()

results = json.loads((OUT / 'results.json').read_text())
for result in results:
    native = {}
    for tag in ('pass', 'fail'):
        report = OUT / result['design'] / f'{tag}.rpt'
        text = report.read_text()
        row = next(l.split() for l in text.split('WNS(ns)', 1)[1].splitlines()
                   if re.match(r'^\s*-?\d+\.\d+\s', l))
        native[tag] = dict(period_ns=result['lp_period_ns'] + (.01 if tag == 'pass' else -.01),
                           setup_wns_ns=float(row[0]), hold_whs_ns=float(row[4]), pulse_slack_ns=float(row[8]),
                           passed='All user specified timing constraints are met.' in text, report=str(report))
    if not native['pass']['passed'] or native['fail']['passed']:
        raise ValueError(f"Native bracket mismatch: {result['design']}")
    if native['fail']['setup_wns_ns'] >= 0:
        raise ValueError('Failing boundary is not a setup-period failure')
    result['native_validated'] = True
    result['native_bracket'] = native
    result['scope'] = 'Fixed-route period boundary within 0.02 ns; not fresh-route global Fmax; one common clock, isolated latch stage only.'
    (OUT / result['design'] / 'result.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
(OUT / 'results.json').write_text(json.dumps(results, indent=2), encoding='utf-8')
print(json.dumps([{k: r[k] for k in ('design', 'native_validated', 'native_bracket')} for r in results], indent=2))

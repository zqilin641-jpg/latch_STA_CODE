import json,re
from pathlib import Path
root=Path(__file__).resolve().parent
results=[]
for name in ('ff','mixed_stage1'):
    run=root/name
    for fname,period in [('timing_summary.rpt',12.121212),('timing_T20.rpt',20.0)]:
        text=(run/fname).read_text()
        rows=text.split('WNS(ns)',1)[1].splitlines()
        row=next(line.split() for line in rows if re.match(r'^\s*-?\d+\.\d+\s',line))
        assert len(row)==12
        results.append(dict(design=name,period_ns=period,setup_wns_ns=float(row[0]),hold_whs_ns=float(row[4]),pulse_width_slack_ns=float(row[8]),sta_passed='All user specified timing constraints are met.' in text,report=str(run/fname),fixed_routing_reanalysis=(period==20)))
    assert json.loads((run/'functional/result.json').read_text())['passed']
    structure=(run/'structure.txt').read_text()
    assert 'CLOCK_COUNT 1' in structure and 'UNIQUE_CLOCK_NETS clk' in structure
assert all(r['sta_passed'] for r in results if r['period_ns']==20)
(root/'results.json').write_text(json.dumps(dict(tool='Vivado 2024.1',part='xc7a35tcpg236-1',results=results,scope='Tool feasibility, auto placed IO, not board constraints, no bitstream/SDF simulation/Fmax/Howard claim'),indent=2))
print(json.dumps(results,indent=2))

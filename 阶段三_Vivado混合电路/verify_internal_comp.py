from pathlib import Path
import csv,json,re
B=Path.cwd();R=B/'internal_comp'
def tab(p):
 with p.open() as f:return list(csv.DictReader(f,delimiter='\t'))
rows=tab(R/'screen.tsv');ref=B/'ff_control/ff_3_6_10'
for x in rows:
 d=R/x['design']; assert 'All user specified timing constraints are met.' in (d/'screen_pass.rpt').read_text()
 x['lower_bound_only']=not (d/'screen_fail.rpt').exists()
 if x['lower_bound_only']:x['scan_lower_limit_ns']=x.pop('fail_ns')
 else:assert 'All user specified timing constraints are met.' not in (d/'screen_fail.rpt').read_text()
 if x['design']!='ff_reference':
  assert tab(d/'pins.tsv')==tab(ref/'pins.tsv')
  assert tab(d/'output_registers.tsv')==tab(ref/'output_registers.tsv')
  assert json.loads((d/'functional/result.json').read_text())['passed']
  s=(d/'structure.txt').read_text(); assert 'UNIQUE_CLOCK_NETS clk' in s and 'FF_COUNT 85' in s and 'LATCH_COUNT 16' in s
 x['drc_report']=str(d/'screen_drc.rpt')
(R/'comparison.json').write_text(json.dumps(rows,indent=2))
print(json.dumps(rows,indent=2))

import csv,json
from pathlib import Path
B=Path.cwd(); R=B/'ff_control'
def tab(p):
 with p.open() as f:return list(csv.DictReader(f,delimiter='\t'))
rows=tab(R/'screen.tsv'); ref=B/'mmcm_retime/balanced_latch5'
for r in rows:
 d=R/r['design']; passing=(d/'screen_pass.rpt').read_text()
 assert 'All user specified timing constraints are met.' in passing
 r['lower_bound_only']=not (d/'screen_fail.rpt').exists()
 if r['lower_bound_only']: r['scan_lower_limit_ns']=r.pop('fail_ns')
 else: assert 'All user specified timing constraints are met.' not in (d/'screen_fail.rpt').read_text()
 if r['design']!='mixed_reference':
  assert tab(d/'pins.tsv')==tab(ref/'pins.tsv')
  assert tab(d/'output_registers.tsv')==tab(ref/'output_registers.tsv')
  assert 'UNIQUE_CLOCK_NETS clk' in (d/'structure.txt').read_text()
  assert json.loads((d/'functional/result.json').read_text())['passed']
best=max((r for r in rows if r['design']!='mixed_reference'),key=lambda r:float(r['frequency_mhz']))
mix=next(r for r in rows if r['design']=='mixed_reference')
result={'rows':rows,'best_new_ff':best,'mixed':mix,'mixed_gain_vs_best_new_ff_pct':(float(mix['frequency_mhz'])/float(best['frequency_mhz'])-1)*100}
(R/'comparison.json').write_text(json.dumps(result,indent=2))
print(json.dumps(result,indent=2))

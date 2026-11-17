from pathlib import Path
import json,re,shutil
B=Path.cwd();R=B/'selective_bits';R.mkdir(exist_ok=True);src=B/'internal_comp/lat4_ff3_6_10'
for f in ['tb.v','shared_pins.tsv','shared_pins.xdc']: shutil.copy2(B/'internal_comp'/f,R/f)
manifest=[]
for name,bits in [('latch4_bits',set(range(12,16))),('latch8_bits',set(range(8,16)))]:
 d=R/name;d.mkdir(exist_ok=True);s=(src/'design.v').read_text()
 for bit in range(16):
  if bit not in bits:
   s,n=re.subn(r'^.*LDCE.*latch_cut4_'+f'{bit:02d}'+r'\(.*$',f'assign q4[{bit}]=op4[{bit}];',s,flags=re.M);assert n==1
 (d/'design.v').write_text(s);shutil.copy2(src/'timing.xdc',d/'timing.xdc')
 t=(src/'build.tcl').read_text().replace(src.as_posix(),d.as_posix()).replace('[llength $lat]!=16',f'[llength $lat]!={len(bits)}')
 (d/'build.tcl').write_text(t);manifest.append(dict(design=name,ff=85,latch=len(bits),selected_bits=sorted(bits)))
(R/'manifest.json').write_text(json.dumps(manifest,indent=2))
(R/'build.tcl').write_text('\n'.join('source {'+(R/r['design']/'build.tcl').as_posix()+'}' for r in manifest)+'\nexit')

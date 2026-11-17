from pathlib import Path
import shutil,re,json
B=Path.cwd();R=B/'pulse_direct';R.mkdir(exist_ok=True);s=B/'ff_control/ff_3_6_10';manifest=[]
for name,mixed in [('ff_pulse',False),('mixed_pulse',True)]:
 d=R/name;d.mkdir(exist_ok=True)
 rtl=(s/'design.v').read_text().replace('.CLKOUT0_PHASE(0.0)', '.CLKOUT0_PHASE(0.0),.CLKOUT0_DUTY_CYCLE(0.125)')
 if mixed:
  for bit in range(16):
   pat=r'^.*FDCE.*ff_cut6_'+f'{bit:02d}'+r'\(.*$'
   line=re.search(pat,rtl,re.M)[0]
   new=line.replace('FDCE','LDCE').replace('ff_cut6','latch_cut6').replace('.C(clk)','.G(clk)').replace('.CE(','.GE(')
   rtl=rtl.replace(line,new)
 (d/'design.v').write_text(rtl);shutil.copy2(s/'timing.xdc',d/'timing.xdc')
 t=(s/'build.tcl').read_text().replace(s.as_posix(),d.as_posix())
 if mixed:t=t.replace('[llength $ff]!=85','[llength $ff]!=69').replace('[llength $lat]!=0','[llength $lat]!=16')
 (d/'build.tcl').write_text(t);manifest.append(dict(design=name,ff=69 if mixed else 85,latch=16 if mixed else 0,duty=.125,compensating_ff=0))
(R/'manifest.json').write_text(json.dumps(manifest,indent=2))
(R/'build.tcl').write_text('\n'.join('source {'+(R/x['design']/'build.tcl').as_posix()+'}' for x in manifest)+'\nexit')

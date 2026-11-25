"""Export routed timing netlist/SDF and validate real clock activity and data."""
import argparse,re,subprocess,json
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('design',type=Path);p.add_argument('--reuse-export',action='store_true');p.add_argument('--no-sdf',action='store_true');p.add_argument('--period',type=float,default=10.0);p.add_argument('--cycles',type=int,default=256);p.add_argument('--corner',choices=['slow','fast'],default='slow');a=p.parse_args()
B=Path(__file__).resolve().parent;d=a.design.resolve();o=d/('timed_'+a.corner);o.mkdir(exist_ok=True)
def run(tool,args,log):
 with (o/log).open('w') as f:subprocess.run(['D:/xilinx/Vivado/2024.1/bin/'+tool+'.bat',*args],cwd=o,stdout=f,stderr=subprocess.STDOUT,check=True,timeout=600)
t=(B/'pulse_direct/mixed_pulse/timed/tb.v').read_text().replace('i<4096',f'i<{a.cycles}').replace('always @(posedge dut.clk) begin', 'always @(posedge clk) begin').replace(' #4;', ' #9;').replace('@(negedge clk); #1;', '@(posedge clk); #2;').replace('MAXIMUM','MINIMUM' if a.corner=='fast' else 'MAXIMUM');t=re.sub(r'initial \$sdf_annotate[^;]+;', '', t);t=t.replace('reg [15:0] queue[0:4];','reg [15:0] raw[0:4]; integer stage_errors=0; function [15:0] partial; input [15:0] x; input integer stop; reg [15:0] y; integer n; begin y=x; for(n=1;n<=stop;n=n+1) y={y[12:0],y[15:13]}+((16\'h1357*n+16\'h2461)&16\'hffff); partial=y; end endfunction\nreg [15:0] queue[0:4];')
t=t.replace('count=count+1;','count=count+1; for(k=4;k>0;k=k-1) raw[k]=raw[k-1]; raw[0]=data_in;')
t=t.replace('checks=checks+1;','checks=checks+1; if(count>=5 && stage_errors<5 && ({dut.input_ff_15.Q,dut.input_ff_14.Q,dut.input_ff_13.Q,dut.q0[12:0]}!==raw[0] || dut.q3!==partial(raw[1],3) || dut.q6!==partial(raw[2],6) || dut.q10!==partial(raw[3],10))) begin stage_errors=stage_errors+1; $display("STAGE count=%0d q0=%h/%h q3=%h/%h q6=%h/%h q10=%h/%h",count,{dut.input_ff_15.Q,dut.input_ff_14.Q,dut.input_ff_13.Q,dut.q0[12:0]},raw[0],dut.q3,partial(raw[1],3),dut.q6,partial(raw[2],6),dut.q10,partial(raw[3],10)); end')
t=t.replace('endmodule', """
function [15:0] segment; input [15:0] x; input integer start_n,end_n; reg [15:0] y; integer n; begin y=x; for(n=start_n;n<=end_n;n=n+1) y={y[12:0],y[15:13]}+((16'h1357*n+16'h2461)&16'hffff);segment=y;end endfunction
always @(negedge clk) begin
 #4;
 if(count>=5 && count<15) $display("COMB count=%0d q6=%h op7=%h/%h op8=%h/%h op9=%h/%h op10=%h/%h",count,dut.q6,dut.op7,segment(dut.q6,7,7),dut.op8,segment(dut.q6,7,8),dut.op9,segment(dut.q6,7,9),dut.op10,segment(dut.q6,7,10));
end
endmodule
""")
t=t.replace('always #5' ,f'always #{a.period/2}');(o/'tb.v').write_text(t)
(o/'export.tcl').write_text('open_checkpoint {'+(d/'routed.dcp').as_posix()+'}\nset_property CLKIN1_PERIOD '+str(a.period)+' [get_cells common_mmcm]\nset rename_index 0\nforeach c [get_cells -hier] {if {[regexp {[^A-Za-z0-9_]} $c]} {rename_cell $c -to sim_cell_$rename_index; incr rename_index}}\nwrite_verilog -force -mode timesim {'+(o/'netlist.v').as_posix()+'}\nwrite_sdf -force -process_corner '+a.corner+' {'+(o/'routed.sdf').as_posix()+'}\nexit')
if not a.reuse_export: run('vivado',['-mode','batch','-source','export.tcl'],'export.log')
run('xvlog',['netlist.v','tb.v'],'compile.log')
(o/'elaborate.opts').write_text('--transport_int_delays\n--pulse_int_r 0\n--pulse_int_e 0\n--pulse_r 0\n--pulse_e 0\n-L simprims_ver\n-L unisims_ver\n--sdf'+('min' if a.corner=='fast' else 'max')+' /tb/dut=routed.sdf\nwork.tb work.glbl\n-s timed\n')
if a.no_sdf:
 opts=o/'elaborate.opts';opts.write_text('\n'.join(x for x in opts.read_text().splitlines() if not x.startswith('--sdf')))
run('xelab',['-f','elaborate.opts'],'elaborate.log')
el=(o/'elaborate.log').read_text();
if 'without back annotation' in el or 'annotation will be skipped' in el or 'ERROR:' in el: raise RuntimeError('SDF annotation failed')
run('xsim',['timed','-runall'],'simulate.log')
s=(o/'simulate.log').read_text();m=re.search(r'ALIGNED_RESULT checks=(\d+) errors=(\d+)',s);c=re.search(r'CLOCK_DIAG external=(\d+) internal=(\d+) locked=1',s)
passed=bool(m and c and int(m[1])>=a.cycles and int(c[2])>=a.cycles and int(m[2])==0)
r=dict(passed=passed,corner=a.corner,stimuli=a.cycles,checks=int(m[1]) if m else None,errors=int(m[2]) if m else None,clock_evidence=c[0] if c else None,period_ns=a.period,sdf_enabled=not a.no_sdf,scope=('Native timing netlist without SDF; functional control only' if a.no_sdf else 'Native timing netlist with SDF; not formal proof'))
(o/'result.json').write_text(json.dumps(r,indent=2));print(json.dumps(r,indent=2))
if not passed:raise SystemExit(2)


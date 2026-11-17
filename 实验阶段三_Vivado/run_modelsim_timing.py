"""Cross-simulator scoreboard; timing-warning limitations reported separately."""
import argparse,subprocess,re,json,shutil
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('source',type=Path);p.add_argument('--cycles',type=int,default=4096);a=p.parse_args()
b=Path(__file__).resolve().parent;src=a.source.resolve();o=src/'modelsim_check';o.mkdir(exist_ok=True)
net=(src/'netlist.v').read_text();period=float(re.search(r'CLKIN1_PERIOD\(([0-9.]+)\)',net)[1])
for n in ['netlist.v','routed.sdf']:shutil.copy2(src/n,o/n)
t=(b/'pulse_direct/mixed_pulse/timed/tb.v').read_text();t=re.sub(r'initial \$sdf_annotate[^;]+;','',t)
t=t.replace('always #5',f'always #{period/2}').replace('always @(posedge dut.clk) begin','always @(posedge clk) begin').replace(' #4;',f' #{period-1};').replace('@(negedge clk); #1;','@(posedge clk); #2;').replace('i<4096',f'i<{a.cycles}')
t=t.replace('integer i,j,k,count=0,checks=0,errors=0;', 'reg reset_at_edge; integer skipped_reset_transition=0; integer i,j,k,count=0,checks=0,errors=0;')
t=t.replace('always @(posedge clk) begin\n if(reset)', 'always @(posedge clk) begin\n reset_at_edge=reset;\n if(reset)')
t=t.replace('checks=checks+1;', 'if(reset!==reset_at_edge) skipped_reset_transition=skipped_reset_transition+1;\n else begin\n checks=checks+1;')
t=t.replace('end\ninitial begin', 'end\nend\ninitial begin')
t=t.replace('$display("ALIGNED_RESULT', '$display("RESET_TRANSITIONS skipped=%0d",skipped_reset_transition);\n $display("ALIGNED_RESULT')
(o/'tb.v').write_text(t)
def run(exe,args,log):
 with (o/log).open('w') as f:subprocess.run(['E:/real-modelsim/win64/'+exe+'.exe',*args],cwd=o,stdout=f,stderr=subprocess.STDOUT,check=True,timeout=600)
run('vlib',['work'],'vlib.log')
types=sorted(set(re.findall(r'^  ([A-Z][A-Z0-9_]*) (?:#\(|[A-Za-z_])',net,re.M)))
v=Path('D:/xilinx/Vivado/2024.1/data/verilog/src/unisims');files=[str(v/(x+'.v')) for x in types];assert all(Path(f).is_file() for f in files)
run('vlog',['+define+XIL_TIMING',*files,'netlist.v','tb.v'],'compile.log')
run('vsim',['-c','-t','1ps','+transport_int_delays','+pulse_int_r/0','+pulse_int_e/0','+ntc_warn','-sdfmax','/tb/dut=routed.sdf','work.tb','work.glbl','-do','run -all; quit -f'],'simulate.log')
s=(o/'simulate.log').read_text();m=re.search(r'ALIGNED_RESULT checks=(\d+) errors=(\d+)',s);c=re.search(r'CLOCK_DIAG external=(\d+) internal=(\d+) locked=1',s)
r={'period_ns':period,'stimuli':a.cycles,'checks':int(m[1]) if m else None,'data_errors':int(m[2]) if m else None,'clock_evidence':c[0] if c else None,'negative_check_adjustments':s.count('Setting negative limit to zero'),'warning_lines':[x for x in s.splitlines() if '** Warning:' in x and 'negative limit' not in x]}
r['scoreboard_pass']=bool(m and c and int(m[2])==0 and int(m[1])>=a.cycles and int(c[2])>=a.cycles);r['full_timing_signoff']=False
(o/'result.json').write_text(json.dumps(r,indent=2));print(json.dumps(r,indent=2))

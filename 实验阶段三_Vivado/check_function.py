"""Functional check using unchanged AMD primitive models, no SDF."""
import json,re,subprocess,argparse
from pathlib import Path
base=Path(__file__).resolve().parent
vendor=Path('D:/xilinx/Vivado/2024.1/data/verilog/src')
sim=Path('E:/real-modelsim/win64')
parser=argparse.ArgumentParser(__doc__)
parser.add_argument('--designs',nargs='+',default=['ff','mixed_stage1'])
args=parser.parse_args()
for name in args.designs:
    source='functional_ff' if name=='ff' else 'functional_'+name.removeprefix('mixed_stage')
    run=base/name;out=run/'functional';out.mkdir(exist_ok=True)
    tb=(base.parent/'single_clock_experiment'/source/'functional_ideal/tb.v').read_text()
    tb=tb.replace('GTP_GRS GRS_INST(.GRS_N(grs_n));','')
    tb=tb.replace('small25 dut(clk_in,reset,clocks,data_in,result,locked);','small25 dut(.clk_in(clocks[0]),.reset(reset),.data_in(data_in),.result(result));')
    (out/'tb.v').write_text(tb)
    commands=[['vmap','-c'],['vlib','work'],['vlog','-sv',str(vendor/'glbl.v'),*[str(vendor/'unisims'/f'{cell}.v') for cell in ['BUFG','FDCE','LDCE']],str(run/'design.v'),'tb.v'],['vsim','-c','-novopt','-t','1fs','work.tb','work.glbl','-do','onerror {quit -code 2}; run -all; quit -f']]
    log=''
    for cmd in commands:
        p=subprocess.run([str(sim/(cmd[0]+'.exe')),*cmd[1:]],cwd=out,capture_output=True,timeout=90)
        log+=(p.stdout+p.stderr).decode(errors='replace');(out/'run.log').write_text(log)
        if p.returncode: raise RuntimeError(str(out/'run.log'))
    result=dict(passed=re.findall(r'FUNCTION_RESULT checks=(\d+) errors=(\d+)',log)==[('2048','0')],scope='AMD LDCE/FDCE/BUFG RTL models; ideal single input clock; no SDF/board test',latency_cycles=5 if name=='ff' else 4)
    (out/'result.json').write_text(json.dumps(result,indent=2));print(name,result)
    assert result['passed']

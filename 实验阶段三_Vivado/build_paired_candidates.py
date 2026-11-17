"""Generate a new cycle-aligned benchmark; preserve all previous experiments."""
import json
import argparse
from pathlib import Path

BASE = Path(__file__).resolve().parent
parser = argparse.ArgumentParser(__doc__)
parser.add_argument('--out', type=Path, default=BASE / 'retiming_benchmark')
parser.add_argument('--variants', type=Path)
args = parser.parse_args()
ROOT = args.out.resolve()
ROOT.mkdir(exist_ok=True)
W = 16
VARIANTS = {
    'ff_original': {1: 'FF', 2: 'FF', 11: 'FF', 12: 'FF'},
    'ff_retimed': {3: 'FF', 6: 'FF', 9: 'FF', 12: 'FF'},
    'mixed_aligned': {3: 'LATCH', 6: 'FF', 9: 'FF', 12: 'FF'},
}
if args.variants:
    VARIANTS = {name: {int(k): v for k, v in cuts.items()} for name, cuts in json.loads(args.variants.read_text()).items()}


def storage(name, source, dest, kind, width=16):
    primitive, pin, enable = ('FDCE', 'C', 'CE') if kind == 'FF' else ('LDCE', 'G', 'GE')
    return ''.join(f'(* DONT_TOUCH="TRUE" *) {primitive} #(.INIT(0)) {name}_{b:02d}(.D({source}[{b}]),.Q({dest}[{b}]),.{pin}(clk),.{enable}(1\'b1),.CLR(reset));\n' for b in range(width))


manifest = []
for name, cuts in VARIANTS.items():
    has_latch = any(k == 'LATCH' for k in cuts.values())
    if (len(cuts),sum(k == 'LATCH' for k in cuts.values())) not in [(4,0),(5,1)] or max(cuts) != 12 or cuts[12] != 'FF':
        raise ValueError('Candidates require four cuts ending at 12, at most one internal latch')
    out = ROOT / name
    out.mkdir(exist_ok=True)
    rtl = 'module small25(input clk_in,reset,input [15:0] data_in,output [15:0] result,output valid_out);\nwire clk; BUFG clock_buffer(.I(clk_in),.O(clk));\nwire [15:0] q0;\n'
    rtl += storage('input_ff', 'data_in', 'q0', 'FF')
    source = 'q0'
    for op in range(1, 13):
        const = (0x1357 * op + 0x2461) & 65535
        rtl += f'(* KEEP="TRUE" *) wire [15:0] op{op};\nassign op{op}={{ {source}[12:0],{source}[15:13] }}+16\'h{const:04x};\n'
        source = f'op{op}'
        if op in cuts:
            dest = f'q{op}'
            rtl += f'wire [15:0] {dest};\n'
            rtl += storage(('latch' if cuts[op] == 'LATCH' else 'ff')+f'_cut{op}', source, dest, cuts[op])
            source = dest
    if False: # compensation bank is now an internal FF cut
        rtl += 'wire [15:0] aligned;\n' + storage('alignment_ff', source, 'aligned', 'FF')
        source = 'aligned'
    rtl += "wire [4:0] v; wire [4:0] vd={v[3:0],1'b1};\n"
    rtl += storage('valid_ff', 'vd', 'v', 'FF', 5)
    rtl += f"assign valid_out=v[4]; assign result=v[4]?{source}:16'b0;\nendmodule\n"
    (out / 'design.v').write_text(rtl)
    xdc = '''create_clock -name common_clock -period 20 -waveform {0 10} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
set_input_delay -clock common_clock -max 2.0 [get_ports {data_in[*]}]
set_input_delay -clock common_clock -min 0.2 [get_ports {data_in[*]}]
set_output_delay -clock common_clock -max 2.0 [get_ports {result[*] valid_out}]
set_output_delay -clock common_clock -min 0.2 [get_ports {result[*] valid_out}]
set_false_path -from [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports *]
'''
    if (ROOT / 'shared_pins.xdc').exists():
        xdc += (ROOT / 'shared_pins.xdc').read_text()
    (out / 'timing.xdc').write_text(xdc)
    ff, latch = 85, (16 if has_latch else 0)
    template = (BASE / 'mixed_stage1/build.tcl').read_text()
    template = template.replace((BASE / 'mixed_stage1').as_posix(), out.as_posix())
    template = template.replace('[llength $ff]!=20 || [llength $lat]!=5', f'[llength $ff]!={ff} || [llength $lat]!={latch}')
    pin_report = f'''set pf [open {{{(out / 'pins.tsv').as_posix()}}} w]
puts $pf "port\\tpackage_pin"
foreach port [lsort [get_ports]] {{puts $pf "$port\\t[get_property PACKAGE_PIN [get_ports $port]]"}}
close $pf
'''
    template = template.replace('close_project', pin_report + 'close_project')
    (out / 'build.tcl').write_text(template)
    manifest.append(dict(design=name, cuts=cuts, ff=ff, latch=latch, input_to_output_sample_edges=5,
                         interface_validity='valid_out false for first four sample edges after reset; result masked to zero',
                         comparison='Same function, one word per clock, same valid output edge; manual candidate cuts, not automatic retiming'))
(ROOT / 'manifest.json').write_text(json.dumps(manifest, indent=2))
(ROOT / 'build.tcl').write_text('\n'.join(f'source {{{(ROOT / name / "build.tcl").as_posix()}}}' for name in VARIANTS) + '\nexit\n')
(ROOT / 'export.tcl').write_text(f'set export_root {{{ROOT.as_posix()}}}\nset argv {{{" ".join(VARIANTS)}}}\nsource {{{(BASE / "export_adjacent.tcl").as_posix()}}}\n')
tb = '''`timescale 1ns/1ps
module tb;
reg clk=0,reset=1; reg [15:0] data_in=0;
wire [15:0] result; wire valid_out;
small25 dut(.clk_in(clk),.reset(reset),.data_in(data_in),.result(result),.valid_out(valid_out));
always #10 clk=~clk;
reg [15:0] queue[0:4]; reg [31:0] rng=32'h12345678;
integer i,j,k,count=0,checks=0,errors=0;
function [15:0] reference;
input [15:0] x; reg [15:0] y; integer n;
begin y=x; for(n=1;n<=12;n=n+1) y={y[12:0],y[15:13]}+((16'h1357*n+16'h2461)&16'hffff); reference=y; end
endfunction
always @(posedge clk) begin
 if(reset) begin count=0; for(k=0;k<5;k=k+1) queue[k]=0; end
 else begin
  count=count+1;
  for(k=4;k>0;k=k-1) queue[k]=queue[k-1]; queue[0]=reference(data_in);
 end
 #1;
 checks=checks+1;
 if(valid_out !== (count>=5) || result !== ((count>=5)?queue[4]:16'b0)) begin
  errors=errors+1; if(errors<6) $display("MISMATCH count=%0d got=%h expected=%h valid=%b",count,result,queue[4],valid_out);
 end
end
initial begin
 #201;
 for(i=0;i<4096;i=i+1) begin
  @(negedge clk); #1;
  reset=(i%1024<6);
  rng=rng^(rng<<13); rng=rng^(rng>>17); rng=rng^(rng<<5);
  case(i%8)
   0:data_in=0; 1:data_in=16'hffff; 2:data_in=16'h8000; 3:data_in=16'h7fff;
   default:data_in=rng[15:0];
  endcase
 end
 repeat(8) @(negedge clk);
 $display("ALIGNED_RESULT checks=%0d errors=%0d",checks,errors); $finish;
end
endmodule
'''
(ROOT / 'tb.v').write_text(tb)
print(ROOT)

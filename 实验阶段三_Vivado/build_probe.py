"""Native Vivado single-clock feasibility probe, not a Pango Fmax comparison."""
from pathlib import Path
root=Path(__file__).resolve().parent
for mixed in (False,True):
    out=root/('mixed_stage1' if mixed else 'ff');out.mkdir(exist_ok=True)
    rtl='module small25(input clk_in,reset,input [4:0] data_in,output [4:0] result);\nwire clk; BUFG clock_buffer(.I(clk_in),.O(clk));\n'
    for stage in range(5):
        rtl+=f'wire [4:0] q{stage},d{stage};\n'
        expr='data_in' if stage==0 else (f"q{stage-1}+5'd{[0,3,7,11,1][stage]}" if stage%2 else f"{{q{stage-1}[2:0],q{stage-1}[4:3]}}^5'd{stage+3}")
        rtl+=f'assign d{stage}={expr};\n'
        for bit in range(5):
            i=stage*5+bit
            if mixed and stage==1:
                rtl+=f'(* DONT_TOUCH="TRUE" *) LDCE #(.INIT(0)) latch_{i:02}(.D(d{stage}[{bit}]),.Q(q{stage}[{bit}]),.G(clk),.GE(1\'b1),.CLR(reset));\n'
            else:
                rtl+=f'(* DONT_TOUCH="TRUE" *) FDCE #(.INIT(0)) ff_{i:02}(.D(d{stage}[{bit}]),.Q(q{stage}[{bit}]),.C(clk),.CE(1\'b1),.CLR(reset));\n'
    rtl+='assign result=q4;endmodule\n';(out/'design.v').write_text(rtl)
    (out/'timing.xdc').write_text('''create_clock -name common_clock -period 12.121212 -waveform {0 6.060606} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
set_input_delay -clock common_clock -max 2.0 [get_ports {data_in[*]}]
set_input_delay -clock common_clock -min 0.2 [get_ports {data_in[*]}]
set_output_delay -clock common_clock -max 2.0 [get_ports {result[*]}]
set_output_delay -clock common_clock -min 0.2 [get_ports {result[*]}]
set_false_path -from [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports *]
''')
    tcl=f'''set_param general.maxThreads 4
create_project -in_memory -part xc7a35tcpg236-1
read_verilog {{{out.as_posix()}/design.v}}
read_xdc {{{out.as_posix()}/timing.xdc}}
synth_design -top small25 -flatten_hierarchy none
opt_design
place_design
route_design
write_checkpoint -force {{{out.as_posix()}/routed.dcp}}
write_verilog -force -mode funcsim {{{out.as_posix()}/routed_func.v}}
write_sdf -force {{{out.as_posix()}/routed.sdf}}
report_timing_summary -delay_type min_max -report_unconstrained -file {{{out.as_posix()}/timing_summary.rpt}}
report_timing -delay_type max -max_paths 100 -nworst 10 -path_type full_clock_expanded -file {{{out.as_posix()}/setup.rpt}}
report_timing -delay_type min -max_paths 100 -nworst 10 -path_type full_clock_expanded -file {{{out.as_posix()}/hold.rpt}}
report_utilization -file {{{out.as_posix()}/utilization.rpt}}
report_clocks -file {{{out.as_posix()}/clocks.rpt}}
report_drc -file {{{out.as_posix()}/drc.rpt}}
set f [open {{{out.as_posix()}/structure.txt}} w]
set ff [get_cells -hier -filter {{REF_NAME == FDCE}}]
set lat [get_cells -hier -filter {{REF_NAME == LDCE}}]
puts $f "FF_COUNT [llength $ff]"
puts $f "LATCH_COUNT [llength $lat]"
puts $f "CLOCK_COUNT [llength [get_clocks]]"
set clocknets {{}}
foreach c [concat $ff $lat] {{
  set pin [get_pins -of_objects $c -filter {{REF_PIN_NAME == C || REF_PIN_NAME == G}}]
  set net [get_nets -of_objects $pin]
  lappend clocknets $net
  puts $f "$c : $net : [get_clocks -of_objects $pin]"
}}
puts $f "UNIQUE_CLOCK_NETS [lsort -unique $clocknets]"
close $f
if {{[llength $ff]!={20 if mixed else 25} || [llength $lat]!={5 if mixed else 0} || [llength [lsort -unique $clocknets]]!=1 || [llength [get_clocks]]!=1}} {{error "Storage or single-clock structure mismatch"}}
close_project
'''
    (out/'build.tcl').write_text(tcl)
(root/'run.tcl').write_text('\n'.join('source {'+(root/name/'build.tcl').as_posix()+'}' for name in ['ff','mixed_stage1'])+'\nexit\n')
print(root/'run.tcl')

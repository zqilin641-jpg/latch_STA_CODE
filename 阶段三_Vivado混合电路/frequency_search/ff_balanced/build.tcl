set_param general.maxThreads 4
create_project -in_memory -part xc7a35tcpg236-1
read_verilog {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/design.v}
read_xdc {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/timing.xdc}
synth_design -top small25 -flatten_hierarchy none
opt_design
place_design
phys_opt_design
route_design
write_checkpoint -force {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/routed.dcp}
write_verilog -force -mode funcsim {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/routed_func.v}
write_sdf -force {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/routed.sdf}
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/timing_summary.rpt}
report_timing -delay_type max -max_paths 100 -nworst 10 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/setup.rpt}
report_timing -delay_type min -max_paths 100 -nworst 10 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/hold.rpt}
report_utilization -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/utilization.rpt}
report_clocks -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/clocks.rpt}
report_drc -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/drc.rpt}
set f [open {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/structure.txt} w]
set ff [get_cells -hier -filter {REF_NAME == FDCE}]
set lat [get_cells -hier -filter {REF_NAME == LDCE}]
puts $f "FF_COUNT [llength $ff]"
puts $f "LATCH_COUNT [llength $lat]"
puts $f "CLOCK_COUNT [llength [get_clocks]]"
set clocknets {}
foreach c [concat $ff $lat] {
  set pin [get_pins -of_objects $c -filter {REF_PIN_NAME == C || REF_PIN_NAME == G}]
  set net [get_nets -of_objects $pin]
  lappend clocknets $net
  puts $f "$c : $net : [get_clocks -of_objects $pin]"
}
puts $f "UNIQUE_CLOCK_NETS [lsort -unique $clocknets]"
close $f
if {[llength $ff]!=85 || [llength $lat]!=0 || [llength [lsort -unique $clocknets]]!=1 || [llength [get_clocks]]!=1} {error "Storage or single-clock structure mismatch"}
set pf [open {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/pins.tsv} w]
puts $pf "port\tpackage_pin"
foreach port [lsort [get_ports]] {puts $pf "$port\t[get_property PACKAGE_PIN [get_ports $port]]"}
close $pf
set f [open {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/output_registers.tsv} w]
puts $f "cell\tloc\tbel\tref_name\tiob"
foreach c [lsort [get_cells -filter {REF_NAME == FDCE} {output_ff_* valid_ff_04}]] {
    puts $f "$c\t[get_property LOC $c]\t[get_property BEL $c]\t[get_property REF_NAME $c]\t[get_property IOB $c]"
}
close $f
close_project

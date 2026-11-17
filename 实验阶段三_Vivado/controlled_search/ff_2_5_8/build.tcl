set_param general.maxThreads 4
create_project -in_memory -part xc7a35tcpg236-1
read_verilog {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/design.v}
read_xdc {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/timing.xdc}
synth_design -top small25 -flatten_hierarchy none
opt_design
place_design
route_design
write_checkpoint -force {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/routed.dcp}
write_verilog -force -mode funcsim {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/routed_func.v}
write_sdf -force {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/routed.sdf}
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/timing_summary.rpt}
report_timing -delay_type max -max_paths 100 -nworst 10 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/setup.rpt}
report_timing -delay_type min -max_paths 100 -nworst 10 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/hold.rpt}
report_utilization -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/utilization.rpt}
report_clocks -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/clocks.rpt}
report_drc -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/drc.rpt}
set f [open {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/structure.txt} w]
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
set pf [open {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/ff_2_5_8/pins.tsv} w]
puts $pf "port\tpackage_pin"
foreach port [lsort [get_ports]] {puts $pf "$port\t[get_property PACKAGE_PIN [get_ports $port]]"}
close $pf
close_project

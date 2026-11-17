set base {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pulse_cycle}
file mkdir "$base/mixed_sdf_fix"
open_checkpoint "$base/mixed/routed.dcp"
route_design -unroute -nets [get_nets -of_objects [get_pins latch_cut6_00/D]]
set_property PROHIBIT true [get_bels SLICE_X3Y12/A5LUT]
route_design
write_checkpoint -force "$base/mixed_sdf_fix/routed.dcp"
report_timing_summary -delay_type min_max -file "$base/mixed_sdf_fix/timing_summary.rpt"
report_drc -file "$base/mixed_sdf_fix/drc.rpt"
set rename_index 0
foreach c [get_cells -hier] {if {[regexp {[^A-Za-z0-9_]} $c]} {rename_cell $c -to sim_cell_$rename_index; incr rename_index}}
write_verilog -force -mode timesim "$base/mixed_sdf_fix/netlist.v"
write_sdf -force -process_corner slow "$base/mixed_sdf_fix/routed.sdf"
exit

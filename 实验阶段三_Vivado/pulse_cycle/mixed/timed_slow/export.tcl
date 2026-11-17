open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pulse_cycle/mixed/routed.dcp}
set rename_index 0
foreach c [get_cells -hier] {if {[regexp {[^A-Za-z0-9_]} $c]} {rename_cell $c -to sim_cell_$rename_index; incr rename_index}}
write_verilog -force -mode timesim {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pulse_cycle/mixed/timed_slow/netlist.v}
write_sdf -force -process_corner slow {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pulse_cycle/mixed/timed_slow/routed.sdf}
exit
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pulse_direct/mixed_pulse/routed.dcp}
report_timing -to [get_pins -hier -filter {NAME =~ latch_cut6_*/D}] -delay_type min -max_paths 16 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pulse_direct/latch_hold_default.rpt}
set_multicycle_path 2 -setup -to [get_pins -hier -filter {NAME =~ latch_cut6_*/D}]
report_timing -to [get_pins -hier -filter {NAME =~ latch_cut6_*/D}] -delay_type min -max_paths 16 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pulse_direct/latch_hold_cycle.rpt}
report_timing_summary -delay_type min_max -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pulse_direct/cycle_summary.rpt}
exit
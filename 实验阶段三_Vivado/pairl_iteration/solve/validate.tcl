open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pairl_iteration/sta_retime_ff/routed.dcp}
create_clock -name common_clock -period 11.439000 -waveform {0 5.719500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pairl_iteration/solve/sta_retime_ff/pass.rpt}
create_clock -name common_clock -period 11.419000 -waveform {0 5.709500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pairl_iteration/solve/sta_retime_ff/fail.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pairl_iteration/sta_retime_latch/routed.dcp}
create_clock -name common_clock -period 14.978000 -waveform {0 7.489000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pairl_iteration/solve/sta_retime_latch/pass.rpt}
create_clock -name common_clock -period 14.958000 -waveform {0 7.479000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pairl_iteration/solve/sta_retime_latch/fail.rpt}
close_design
exit

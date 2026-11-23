open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/output_control/ff_output_iob/routed.dcp}
create_clock -name common_clock -period 11.439000 -waveform {0 5.719500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/output_control/solve/ff_output_iob/pass.rpt}
create_clock -name common_clock -period 11.419000 -waveform {0 5.709500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/output_control/solve/ff_output_iob/fail.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/output_control/latch6_output_iob/routed.dcp}
create_clock -name common_clock -period 12.434000 -waveform {0 6.217000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/output_control/solve/latch6_output_iob/pass.rpt}
create_clock -name common_clock -period 12.414000 -waveform {0 6.207000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/output_control/solve/latch6_output_iob/fail.rpt}
close_design
exit

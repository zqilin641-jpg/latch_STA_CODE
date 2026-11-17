open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mixed_stage2/routed.dcp}
create_clock -name common_clock -period 12.910000 -waveform {0 6.455000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage2/pass.rpt}
create_clock -name common_clock -period 12.890000 -waveform {0 6.445000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage2/fail.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mixed_stage3/routed.dcp}
create_clock -name common_clock -period 12.910000 -waveform {0 6.455000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage3/pass.rpt}
create_clock -name common_clock -period 12.890000 -waveform {0 6.445000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage3/fail.rpt}
close_design
exit

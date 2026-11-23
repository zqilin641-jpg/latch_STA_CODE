open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/latch_at_3/routed.dcp}
create_clock -name common_clock -period 14.839000 -waveform {0 7.419500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/solve/latch_at_3/pass.rpt}
create_clock -name common_clock -period 14.819000 -waveform {0 7.409500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/solve/latch_at_3/fail.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/latch_at_6/routed.dcp}
create_clock -name common_clock -period 14.570000 -waveform {0 7.285000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/solve/latch_at_6/pass.rpt}
create_clock -name common_clock -period 14.550000 -waveform {0 7.275000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/solve/latch_at_6/fail.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/latch_at_9/routed.dcp}
create_clock -name common_clock -period 14.764000 -waveform {0 7.382000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/solve/latch_at_9/pass.rpt}
create_clock -name common_clock -period 14.744000 -waveform {0 7.372000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/controlled_search/solve/latch_at_9/fail.rpt}
close_design
exit

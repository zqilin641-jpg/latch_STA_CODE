open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/ff_balanced/routed.dcp}
create_clock -name common_clock -period 10.907000 -waveform {0 5.453500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/solve/ff_balanced/pass.rpt}
create_clock -name common_clock -period 10.887000 -waveform {0 5.443500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/solve/ff_balanced/fail.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/latch_short_4/routed.dcp}
create_clock -name common_clock -period 10.907000 -waveform {0 5.453500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/solve/latch_short_4/pass.rpt}
create_clock -name common_clock -period 10.887000 -waveform {0 5.443500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/frequency_search/solve/latch_short_4/fail.rpt}
close_design
exit

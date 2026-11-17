open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/retiming_benchmark/ff_original/routed.dcp}
create_clock -name common_clock -period 17.177000 -waveform {0 8.588500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/retiming_benchmark/solve/ff_original/pass.rpt}
create_clock -name common_clock -period 17.157000 -waveform {0 8.578500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/retiming_benchmark/solve/ff_original/fail.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/retiming_benchmark/ff_retimed/routed.dcp}
create_clock -name common_clock -period 14.701000 -waveform {0 7.350500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/retiming_benchmark/solve/ff_retimed/pass.rpt}
create_clock -name common_clock -period 14.681000 -waveform {0 7.340500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/retiming_benchmark/solve/ff_retimed/fail.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/retiming_benchmark/mixed_aligned/routed.dcp}
create_clock -name common_clock -period 14.839000 -waveform {0 7.419500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/retiming_benchmark/solve/mixed_aligned/pass.rpt}
create_clock -name common_clock -period 14.819000 -waveform {0 7.409500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/retiming_benchmark/solve/mixed_aligned/fail.rpt}
close_design
exit

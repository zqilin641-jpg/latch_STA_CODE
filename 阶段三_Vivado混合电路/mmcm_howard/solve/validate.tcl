open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mmcm_howard/ff/routed.dcp}
create_clock -name common_clock -period 9.213000 -waveform {0 4.606500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mmcm_howard/solve/ff/pass.rpt}
create_clock -name common_clock -period 9.193000 -waveform {0 4.596500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mmcm_howard/solve/ff/fail.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mmcm_howard/mixed/routed.dcp}
create_clock -name common_clock -period 8.583000 -waveform {0 4.291500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mmcm_howard/solve/mixed/pass.rpt}
create_clock -name common_clock -period 8.563000 -waveform {0 4.281500} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
report_timing_summary -delay_type min_max -report_unconstrained -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mmcm_howard/solve/mixed/fail.rpt}
close_design
exit

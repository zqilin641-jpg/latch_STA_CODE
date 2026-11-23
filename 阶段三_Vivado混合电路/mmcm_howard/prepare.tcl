open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/common_mmcm/ff_balanced/routed.dcp}
set_clock_uncertainty -setup 0.2 -from [get_clocks common_clock] -to [get_clocks mm_out]
set_clock_uncertainty -hold 0.2 -from [get_clocks common_clock] -to [get_clocks mm_out]
set_clock_uncertainty -setup 0.2 -from [get_clocks mm_out] -to [get_clocks common_clock]
set_clock_uncertainty -hold 0.2 -from [get_clocks mm_out] -to [get_clocks common_clock]
write_checkpoint -force {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mmcm_howard/ff/routed.dcp}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mmcm_retime/balanced_latch5/routed.dcp}
set_clock_uncertainty -setup 0.2 -from [get_clocks common_clock] -to [get_clocks mm_out]
set_clock_uncertainty -hold 0.2 -from [get_clocks common_clock] -to [get_clocks mm_out]
set_clock_uncertainty -setup 0.2 -from [get_clocks mm_out] -to [get_clocks common_clock]
set_clock_uncertainty -hold 0.2 -from [get_clocks mm_out] -to [get_clocks common_clock]
write_checkpoint -force {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mmcm_howard/mixed/routed.dcp}
close_design
exit
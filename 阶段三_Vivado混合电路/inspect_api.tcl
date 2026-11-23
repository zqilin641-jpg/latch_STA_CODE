set root [file dirname [info script]]
open_checkpoint $root/mixed_stage1/routed.dcp
create_clock -name common_clock -period 20 -waveform {0 10} [get_ports clk_in]
puts "FANIN_LATCH [all_fanin -flat -startpoints_only -to [get_pins latch_09/D]]"
puts "FANIN_FF [all_fanin -flat -startpoints_only -to [get_pins ff_14/D]]"
set path [get_timing_paths -from [get_pins latch_07/G] -to [get_pins ff_14/D] -delay_type max -max_paths 1]
report_property $path
help get_timing_paths
report_timing -from [get_pins latch_07/G] -to [get_pins ff_14/D] -delay_type max -path_type full_clock_expanded -file $root/inspect_latch_ff.rpt
report_timing -from [get_pins latch_07/D] -to [get_pins ff_14/D] -delay_type max -path_type full_clock_expanded -file $root/inspect_latch_d_ff.rpt
report_timing -from [get_pins latch_07/Q] -to [get_pins ff_14/D] -delay_type max -path_type full_clock_expanded -file $root/inspect_latch_q_ff.rpt
report_timing -from [get_pins ff_00/C] -to [get_pins latch_07/D] -delay_type min -path_type full_clock_expanded -file $root/inspect_ff_latch_hold.rpt
exit

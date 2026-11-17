set f [open {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/internal_native.tsv} w]
puts $f "design	tag	period	corner	check	slack	start	end"
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/ff/routed.dcp}
set endpoints [get_pins {ff_05/D ff_06/D ff_07/D ff_08/D ff_09/D ff_10/D ff_11/D ff_12/D ff_13/D ff_14/D ff_15/D ff_16/D ff_17/D ff_18/D ff_19/D ff_20/D ff_21/D ff_22/D ff_23/D ff_24/D}]
if {[llength $endpoints] != 20} {error "Internal endpoint count mismatch"}
create_clock -name common_clock -period 1.996000 -waveform {0 0.998000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
set p [get_timing_paths -to $endpoints -corner Slow -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "ff	above	1.996000	Slow	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/ff/internal_above_Slow_max.rpt}
set p [get_timing_paths -to $endpoints -corner Slow -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "ff	above	1.996000	Slow	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/ff/internal_above_Slow_min.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "ff	above	1.996000	Fast	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/ff/internal_above_Fast_max.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "ff	above	1.996000	Fast	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/ff/internal_above_Fast_min.rpt}
create_clock -name common_clock -period 1.956000 -waveform {0 0.978000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
set p [get_timing_paths -to $endpoints -corner Slow -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "ff	below	1.956000	Slow	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/ff/internal_below_Slow_max.rpt}
set p [get_timing_paths -to $endpoints -corner Slow -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "ff	below	1.956000	Slow	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/ff/internal_below_Slow_min.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "ff	below	1.956000	Fast	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/ff/internal_below_Fast_max.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "ff	below	1.956000	Fast	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/ff/internal_below_Fast_min.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mixed_stage1/routed.dcp}
set endpoints [get_pins {ff_10/D ff_11/D ff_12/D ff_13/D ff_14/D ff_15/D ff_16/D ff_17/D ff_18/D ff_19/D ff_20/D ff_21/D ff_22/D ff_23/D ff_24/D latch_05/D latch_06/D latch_07/D latch_08/D latch_09/D}]
if {[llength $endpoints] != 20} {error "Internal endpoint count mismatch"}
create_clock -name common_clock -period 3.382000 -waveform {0 1.691000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
set p [get_timing_paths -to $endpoints -corner Slow -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage1	above	3.382000	Slow	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage1/internal_above_Slow_max.rpt}
set p [get_timing_paths -to $endpoints -corner Slow -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage1	above	3.382000	Slow	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage1/internal_above_Slow_min.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage1	above	3.382000	Fast	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage1/internal_above_Fast_max.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage1	above	3.382000	Fast	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage1/internal_above_Fast_min.rpt}
create_clock -name common_clock -period 3.342000 -waveform {0 1.671000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
set p [get_timing_paths -to $endpoints -corner Slow -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage1	below	3.342000	Slow	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage1/internal_below_Slow_max.rpt}
set p [get_timing_paths -to $endpoints -corner Slow -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage1	below	3.342000	Slow	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage1/internal_below_Slow_min.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage1	below	3.342000	Fast	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage1/internal_below_Fast_max.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage1	below	3.342000	Fast	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage1/internal_below_Fast_min.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mixed_stage2/routed.dcp}
set endpoints [get_pins {ff_05/D ff_06/D ff_07/D ff_08/D ff_09/D ff_15/D ff_16/D ff_17/D ff_18/D ff_19/D ff_20/D ff_21/D ff_22/D ff_23/D ff_24/D latch_10/D latch_11/D latch_12/D latch_13/D latch_14/D}]
if {[llength $endpoints] != 20} {error "Internal endpoint count mismatch"}
create_clock -name common_clock -period 2.858000 -waveform {0 1.429000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
set p [get_timing_paths -to $endpoints -corner Slow -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage2	above	2.858000	Slow	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage2/internal_above_Slow_max.rpt}
set p [get_timing_paths -to $endpoints -corner Slow -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage2	above	2.858000	Slow	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage2/internal_above_Slow_min.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage2	above	2.858000	Fast	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage2/internal_above_Fast_max.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage2	above	2.858000	Fast	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage2/internal_above_Fast_min.rpt}
create_clock -name common_clock -period 2.818000 -waveform {0 1.409000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
set p [get_timing_paths -to $endpoints -corner Slow -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage2	below	2.818000	Slow	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage2/internal_below_Slow_max.rpt}
set p [get_timing_paths -to $endpoints -corner Slow -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage2	below	2.818000	Slow	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage2/internal_below_Slow_min.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage2	below	2.818000	Fast	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage2/internal_below_Fast_max.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage2	below	2.818000	Fast	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage2/internal_below_Fast_min.rpt}
close_design
open_checkpoint {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mixed_stage3/routed.dcp}
set endpoints [get_pins {ff_05/D ff_06/D ff_07/D ff_08/D ff_09/D ff_10/D ff_11/D ff_12/D ff_13/D ff_14/D ff_20/D ff_21/D ff_22/D ff_23/D ff_24/D latch_15/D latch_16/D latch_17/D latch_18/D latch_19/D}]
if {[llength $endpoints] != 20} {error "Internal endpoint count mismatch"}
create_clock -name common_clock -period 3.190000 -waveform {0 1.595000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
set p [get_timing_paths -to $endpoints -corner Slow -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage3	above	3.190000	Slow	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage3/internal_above_Slow_max.rpt}
set p [get_timing_paths -to $endpoints -corner Slow -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage3	above	3.190000	Slow	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage3/internal_above_Slow_min.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage3	above	3.190000	Fast	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage3/internal_above_Fast_max.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage3	above	3.190000	Fast	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage3/internal_above_Fast_min.rpt}
create_clock -name common_clock -period 3.150000 -waveform {0 1.575000} [get_ports clk_in]
set_clock_uncertainty 0.2 [get_clocks common_clock]
set p [get_timing_paths -to $endpoints -corner Slow -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage3	below	3.150000	Slow	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage3/internal_below_Slow_max.rpt}
set p [get_timing_paths -to $endpoints -corner Slow -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage3	below	3.150000	Slow	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Slow -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage3/internal_below_Slow_min.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type max -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage3	below	3.150000	Fast	max	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type max -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage3/internal_below_Fast_max.rpt}
set p [get_timing_paths -to $endpoints -corner Fast -delay_type min -max_paths 1]
if {[llength $p] != 1} {error "Missing internal timing witness"}
puts $f "mixed_stage3	below	3.150000	Fast	min	[get_property SLACK $p]	[get_property STARTPOINT_PIN $p]	[get_property ENDPOINT_PIN $p]"
report_timing -to $endpoints -corner Fast -delay_type min -max_paths 1 -path_type full_clock_expanded -file {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/stage3/mixed_stage3/internal_below_Fast_min.rpt}
close_design
close $f
exit

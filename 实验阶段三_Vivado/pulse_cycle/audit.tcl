set base {E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pulse_cycle/mixed}
open_checkpoint "$base/routed.dcp"
set f [open "$base/latch_pin_audit.txt" w]
foreach c [get_cells latch_cut6_*] {
 puts $f "CELL $c LOC=[get_property LOC $c] BEL=[get_property BEL $c]"
 foreach p [get_pins -of_objects $c] {puts $f " PIN $p NET=[get_nets -of_objects $p] BELPIN=[get_bel_pins -of_objects $p]"}
}
close $f
report_timing -through [get_pins latch_cut6_00/D] -max_paths 4 -file "$base/latch00_paths.rpt"
exit

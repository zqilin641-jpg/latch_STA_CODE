onerror {quit -code 1 -force}
onbreak {quit -code 1 -force}
vsim -voptargs=+acc -t 1ps work.tb_borrow_concept
log -r sim:/tb_borrow_concept/*
vcd file borrow_concept.vcd
vcd add -r sim:/tb_borrow_concept/*
if {$env(LATCH_BORROW_SIM_GUI) eq "1"} {
    add wave -group Gates sim:/tb_borrow_concept/phase_a sim:/tb_borrow_concept/phase_b
    add wave -group Input sim:/tb_borrow_concept/early_data sim:/tb_borrow_concept/late_data sim:/tb_borrow_concept/missed_data
    add wave -group FirstStage sim:/tb_borrow_concept/early/stage_one sim:/tb_borrow_concept/late/stage_one sim:/tb_borrow_concept/missed/stage_one
    add wave -group Output sim:/tb_borrow_concept/early_result sim:/tb_borrow_concept/late_result sim:/tb_borrow_concept/missed_result
}
run -all
if {[examine -radix binary sim:/tb_borrow_concept/test_done] ne "1" ||
    [examine -radix decimal sim:/tb_borrow_concept/errors] != 0 ||
    [examine -radix decimal sim:/tb_borrow_concept/checks] != 22} {
    quit -code 1 -force
}
set output [open result.txt w]
puts $output "PASS: 22 concept checks; launch shift=20 ns; expected negative control detected; RTL only, no SDF"
close $output
if {$env(LATCH_BORROW_SIM_GUI) eq "1"} {wave zoom full} else {quit -code 0 -force}

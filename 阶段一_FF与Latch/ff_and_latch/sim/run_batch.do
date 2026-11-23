onerror {quit -code 1 -force}
onbreak {quit -code 1 -force}
vsim -voptargs=+acc -t 1ps work.tb_independent_timing
log -r sim:/tb_independent_timing/*
vcd file tb_independent_timing.vcd
vcd add -r sim:/tb_independent_timing/*
run -all
set finished [examine -radix binary sim:/tb_independent_timing/test_done]
set failures [examine -radix decimal sim:/tb_independent_timing/errors]
set count [examine -radix decimal sim:/tb_independent_timing/checks]
if {$finished ne "1" || $failures != 0 || $count != 777} {
    puts "FAIL: independent timing test incomplete or incorrect"
    quit -code 1 -force
}
set result [open result.txt w]
puts $result "PASS: independent timing wrappers; checks=$count; errors=$failures"
close $result
quit -code 0 -force

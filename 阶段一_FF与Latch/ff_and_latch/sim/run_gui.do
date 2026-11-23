vsim -voptargs=+acc -t 1ps work.tb_independent_timing
add wave -group Clocks sim:/tb_independent_timing/clk_reference sim:/tb_independent_timing/phase_a sim:/tb_independent_timing/phase_b sim:/tb_independent_timing/phase_a40 sim:/tb_independent_timing/phase_b40
add wave -group Data sim:/tb_independent_timing/data_in sim:/tb_independent_timing/ff_result sim:/tb_independent_timing/latch_result sim:/tb_independent_timing/latch40_result
add wave -group Checks sim:/tb_independent_timing/reset sim:/tb_independent_timing/ff_checks sim:/tb_independent_timing/latch_checks sim:/tb_independent_timing/latch40_checks sim:/tb_independent_timing/errors
log -r sim:/tb_independent_timing/*
run -all
wave zoom full

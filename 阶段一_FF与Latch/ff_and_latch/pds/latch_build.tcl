set experiment_root [file normalize [file join [file dirname [info script]] ..]]
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
add_design [file join $experiment_root .. single_latch rtl datapath_compare.v]
add_design [file join $experiment_root rtl timing_boundaries.v]
add_design [file join $experiment_root rtl latch_timing_top.v]
add_constraint [file join $experiment_root constraints latch_timing.fdc]
compile -top_module latch_timing_top
synthesize -ads
dev_map -detail
pnr
gen_netlist -func_sim_only
report_timing -delay_type min_max -nworst 1 -max_path 128

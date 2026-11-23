set experiment_root [file normalize [file join [file dirname [info script]] ..]]
set case_name $::env(LATCH_BORROW_CASE)
if {[lsearch -exact {baseline borrow overflow} $case_name] < 0} {
    error "Unsupported time-borrow case"
}
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
add_design [file join $experiment_root .. single_latch rtl datapath_compare.v]
add_design [file join $experiment_root .. ff_and_latch rtl timing_boundaries.v]
add_design [file join $experiment_root .. ff_and_latch rtl latch_timing_top.v]
add_constraint [file join $experiment_root constraints ${case_name}.fdc]
compile -top_module latch_timing_top
synthesize -ads
dev_map -detail
pnr
gen_netlist -func_sim_only
report_timing -delay_type min_max -nworst 1 -max_path 128

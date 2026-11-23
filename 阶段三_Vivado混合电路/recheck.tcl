set root [file dirname [info script]]
foreach name {ff mixed_stage1} {
    open_checkpoint $root/$name/routed.dcp
    create_clock -name common_clock -period 20 -waveform {0 10} [get_ports clk_in]
    set_clock_uncertainty 0.2 [get_clocks common_clock]
    report_timing_summary -delay_type min_max -report_unconstrained -file $root/$name/timing_T20.rpt
    report_timing -delay_type max -max_paths 100 -nworst 10 -path_type full_clock_expanded -file $root/$name/setup_T20.rpt
    report_timing -delay_type min -max_paths 100 -nworst 10 -path_type full_clock_expanded -file $root/$name/hold_T20.rpt
    report_clocks -file $root/$name/clocks_T20.rpt
    close_design
}
exit

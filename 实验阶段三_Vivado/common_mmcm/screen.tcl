# Native min/max/pulse-width binary search, fixed routed checkpoint.
set root [lindex $argv 0]
set names [lrange $argv 1 end]
set f [open "$root/screen.tsv" w]
puts $f "design\tfail_ns\tpass_ns\tfrequency_mhz"
foreach name $names {
    open_checkpoint "$root/$name/routed.dcp"
    set low 8.0
    set high 12.0
    for {set n 0} {$n < 14} {incr n} {
        if {$n == 0} {set t $high} else {set t [expr {($low+$high)/2.0}]}
        create_clock -name common_clock -period $t -waveform [list 0 [expr {$t/2.0}]] [get_ports clk_in]
        set_clock_uncertainty 0.2 [get_clocks common_clock]
        set report [report_timing_summary -delay_type min_max -report_unconstrained -return_string]
        set pass [expr {[string first "All user specified timing constraints are met." $report] >= 0}]
        if {$n == 0 && !$pass} {error "Candidate fails even at 10 ns: $name"}
        if {$pass} {set high $t; set tag pass} else {set low $t; set tag fail}
        set rf [open "$root/$name/screen_${tag}.rpt" w]
        puts $rf $report
        close $rf
    }
    puts $f "$name\t$low\t$high\t[expr {1000.0/$high}]"
    flush $f
    close_design
}
close $f
exit


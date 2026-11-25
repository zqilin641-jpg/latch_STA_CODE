# Native fixed-route timing evidence. Run with Vivado -mode batch -source.
set root [file dirname [info script]]
if {[info exists export_root]} {set root $export_root}
proc prop {obj key} {
    if {[lsearch -exact [list_property $obj] $key] < 0} {return ""}
    return [get_property $key $obj]
}
set designs {ff mixed}
if {[llength $argv]} {set designs $argv}
foreach design $designs {
    open_checkpoint $root/$design/routed.dcp
    create_clock -name common_clock -period 10 -waveform {0 5} [get_ports clk_in]
    set_clock_uncertainty 0.2 [get_clocks common_clock]
    set out $root/$design/adjacent
    file mkdir $out
    set nf [open $out/nodes.tsv w]
    puts $nf "name\tprimitive\tclock_net"
    set cells [get_cells -hier -filter {IS_SEQUENTIAL == 1}]
    set ends {}
    foreach c $cells {
        set ref [get_property REF_NAME $c]
        if {$ref eq "MMCME2_BASE" || $ref eq "MMCME2_ADV"} {continue}
        if {$ref ni {FDCE LDCE}} {error "Unsupported sequential cell: $c ($ref)"}
        set cp C
        if {$ref eq "LDCE"} {set cp G}
        puts $nf "$c\t$ref\t[get_nets -of_objects [get_pins $c/$cp]]"
        lappend ends [get_pins $c/D]
    }
    close $nf
    foreach p [get_ports -filter {DIRECTION == OUT}] {lappend ends $p}
    set mf [open $out/paths.tsv w]
    set fields {STARTPOINT_PIN ENDPOINT_PIN STARTPOINT_CLOCK ENDPOINT_CLOCK STARTPOINT_CLOCK_EDGE ENDPOINT_CLOCK_EDGE STARTPOINT_CLOCK_DELAY ENDPOINT_CLOCK_DELAY DATAPATH_DELAY DATAPATH_LOGIC_DELAY DATAPATH_NET_DELAY ARRIVAL_TIME REQUIRED_TIME SLACK REQUIREMENT CLOCK_PESSIMISM UNCERTAINTY EXCEPTION}
    puts $mf "id\tadjacent_start\tend\tquery_start\tcorner\tdelay_type\tstatus\t[join $fields \t]"
    set id 0
    foreach ep $ends {
        set starts [all_fanin -flat -startpoints_only -to $ep]
        foreach sp $starts {
            set queries [list $sp]
            if {[regexp {^(.*)/G$} $sp -> cell] && [get_property REF_NAME [get_cells $cell]] eq "LDCE"} {
                lappend queries [get_pins $cell/D]
            }
            foreach qs $queries {
                foreach corner {Slow Fast} {
                    foreach delay {max min} {
                        incr id
                        set paths [get_timing_paths -quiet -from $qs -to $ep -corner $corner -delay_type $delay -max_paths 1 -nworst 1]
                        set vals {}
                        set status NO_TIMED_PATH
                        if {[llength $paths]} {
                            set status OK
                            set path [lindex $paths 0]
                            foreach f $fields {lappend vals [prop $path $f]}
                            report_timing -from $qs -to $ep -corner $corner -delay_type $delay -max_paths 1 -nworst 1 -path_type full_clock_expanded -input_pins -significant_digits 3 -file $out/path_$id.rpt
                        }
                        puts $mf "$id\t$sp\t$ep\t$qs\t$corner\t$delay\t$status\t[join $vals \t]"
                    }
                }
            }
        }
    }
    close $mf
    report_timing_summary -delay_type min_max -report_unconstrained -file $out/summary.rpt
    report_clocks -file $out/clocks.rpt
    check_timing -verbose -file $out/check_timing.rpt
    puts "ADJACENT_EXPORT_DONE $design $id"
    close_design
}
exit

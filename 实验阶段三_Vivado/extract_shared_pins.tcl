set base [file dirname [info script]]
set out $base/controlled_search
file mkdir $out
open_checkpoint $base/retiming_benchmark/ff_original/routed.dcp
set f [open $out/shared_pins.xdc w]
set p [open $out/shared_pins.tsv w]
puts $p "port\tpackage_pin"
foreach port [lsort [get_ports]] {
    set pin [get_property PACKAGE_PIN [get_ports $port]]
    if {$pin eq ""} {error "Missing package pin: $port"}
    puts $f [format {set_property PACKAGE_PIN %s [get_ports {%s}]} $pin $port]
    puts $p "$port\t$pin"
}
close $f
close $p
close_design
exit

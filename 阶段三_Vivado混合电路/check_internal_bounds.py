"""Generate targeted native checks; I/O constraints remain in force."""
import json
from stage3_solve import ROOT, OUT

rows = json.loads((OUT / 'selection_results.json').read_text())
lines = [f'set f [open {{{(OUT / "internal_native.tsv").as_posix()}}} w]',
         'puts $f "design\ttag\tperiod\tcorner\tcheck\tslack\tstart\tend"']
for row in rows:
    name = row['design']
    nodes = json.loads((ROOT / name / 'adjacent/evidence.json').read_text())['nodes']
    endpoints = ' '.join(n['name'] + '/D' for n in nodes if int(n['name'].rsplit('_', 1)[1]) >= 5)
    lines += [f'open_checkpoint {{{(ROOT / name / "routed.dcp").as_posix()}}}',
              f'set endpoints [get_pins {{{endpoints}}}]',
              'if {[llength $endpoints] != 20} {error "Internal endpoint count mismatch"}']
    for tag, delta in [('above', .02), ('below', -.02)]:
        period = row['internal_constraint_period_lower_bound_ns'] + delta
        lines += [f'create_clock -name common_clock -period {period:.6f} -waveform {{0 {period/2:.6f}}} [get_ports clk_in]',
                  'set_clock_uncertainty 0.2 [get_clocks common_clock]']
        for corner in ['Slow', 'Fast']:
            for delay in ['max', 'min']:
                lines += [f'set p [get_timing_paths -to $endpoints -corner {corner} -delay_type {delay} -max_paths 1]',
                          'if {[llength $p] != 1} {error "Missing internal timing witness"}',
                          f'puts $f "{name}\t{tag}\t{period:.6f}\t{corner}\t{delay}\t[get_property SLACK $p]\t[get_property STARTPOINT_PIN $p]\t[get_property ENDPOINT_PIN $p]"',
                          f'report_timing -to $endpoints -corner {corner} -delay_type {delay} -max_paths 1 -path_type full_clock_expanded -file {{{(OUT / name / ("internal_"+tag+"_"+corner+"_"+delay+".rpt")).as_posix()}}}']
    lines += ['close_design']
lines += ['close $f', 'exit']
(OUT / 'check_internal.tcl').write_text('\n'.join(lines) + '\n')
print(OUT / 'check_internal.tcl')

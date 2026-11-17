# Stage 3 verification checkpoint — 2026-11-16

Direct replacement remains 69 FF + 16 latch (versus 85 FF control), single shared pulsed data clock. Native STA at 10 ns passes for the cycle-constrained mixed implementation. This is NOT yet a functional or frequency-improvement result.

## Controlled simulation evidence
Same routed pure-FF control, 12 ns external period, 256 stimulus iterations, 318 scoreboard checks:

| Configuration | Output errors | Interpretation |
|---|---:|---|
| Timing netlist without SDF | 0 | Functional control only |
| Full slow/max SDF, transport interconnect, pulse thresholds 0 | 23 | Unresolved timing simulation failure |
| SDF with interconnect delays disabled | 9 | Diagnostic only; invalid for timing signoff |
| Full SDF with default cell path pulse thresholds | 24 | Threshold change does not resolve failure |

First full-SDF corruption: count 9, q6=902e, op7=2d36 matches reference; op8=88ca instead of 28ca, then op10=abe7 instead of abcf. At count 10 q10 captures abe7, output mismatch follows at count 11. The discrepancy localizes to op8 carry-chain behavior under annotated delays; root cause is not yet established. Removing interconnect delays fixes this particular example but does not fix all failures.

q0[13:14] are aliases optimized to op1 nets; diagnostic reconstruction uses input_ff_13/14.Q. Undriven aliases must not be classified as hardware failures.

Evidence: ../pulse_direct/ff_pulse/timed_slow/{simulate.log,cell_only_simulate.log,default_path_simulate.log}; runner ../../vivado_single_clock/run_timed_checkpoint.py.

Next: isolate op8_inferred_i_1 carry input/output event sequence; compare annotation behavior against another simulator or a minimal carry-chain reproducer. Do not suppress delays/timing checks to claim success. No new Howard/Fmax claim is justified by this experiment.

## Follow-up isolation
See ../carry_reproducer/README.md. Standalone primitive stable, skewed, and captured-input replay tests all pass; full design still fails with simulator optimization disabled. Root cause remains unresolved; no frequency claim added.

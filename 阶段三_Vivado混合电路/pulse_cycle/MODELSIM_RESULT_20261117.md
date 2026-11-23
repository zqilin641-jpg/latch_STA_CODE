# Direct selective latch replacement: simulation checkpoint

Date: 2026-11-17

The mixed implementation contains 69 FF + 16 latch instead of 85 FF, with one shared pulsed data clock. It has no compensating FF bank.

## New data-scoreboard evidence

Full routed slow/max SDF, unchanged vendor primitive models, ModelSim 10.4, transport interconnect, 4096 input stimuli including repeated resets:

| Design | Period | Scoreboard checks | Data errors | Internal clock edges |
|---|---:|---:|---:|---:|
| Mixed, pulse_cycle/mixed | 10 ns | 4153 | 0 | 4130 |
| FF control, existing export | 12 ns | 4151 | 0 | 4130 |

These periods are not a matched Fmax comparison and do not establish speedup.

Initial larger runs had three mismatches each, all at count=1018 around asynchronous reset assertion. The bench asserted reset at clock+2 ns but compared the old transaction at clock+9/11 ns during reset propagation. Updated checker records reset at the reference edge, excludes sample windows where reset changes, and continues checking zero output on subsequent stable-reset samples. Stimulus, netlist and SDF are unchanged. Seven reset-transition windows were excluded in each run. This does not prove transient reset behavior or formal equivalence.

## Timing verification limits

Both runs report 408 negative timing-check limit adjustments (vsim-3004). Detailed +ntc_warn identifies FDCE setuphold/recrem checks, including valid pipeline registers. No timing-check suppression switches were used, but ModelSim automatically modifies those limits. Therefore full timing signoff remains false in result.json. Native STA remains required. Existing mixed 10 ns STA passed, but no new maximum frequency search was performed here.

The mixed SDF export also previously warned about a missing valid location for one latch D-to-Q delay; this limitation must be resolved or explicitly retained before signoff. Passing scoreboard alone cannot validate incomplete delay coverage.

## Reproduction

python run_modelsim_timing.py pulse_cycle/mixed/timed_slow
python run_modelsim_timing.py pulse_direct/ff_pulse/timed_slow

Results are stored in each source directory's modelsim_check/result.json and simulate.log. Script defaults to 4096 stimuli. Next steps: resolve annotation/timing-check limitations, generate matched-period exports for both designs, then search frequency using native setup/hold/pulse-width checks plus functional validation.

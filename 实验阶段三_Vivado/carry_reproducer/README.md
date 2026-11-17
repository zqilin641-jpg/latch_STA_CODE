# Carry timing diagnostic (2026-11-16)

Extracted unmodified CARRY4 cell delay block for op8_inferred_i_1 from the routed FF slow SDF. Instance name changed to dut only. Compiled against installed simprims_ver/unisims_ver libraries with glbl.

- stable_tb.v: 4096 random input combinations, 10 ns settling each: 0 errors (stable_simulate.log).
- stagger_tb.v: 4096 combinations with 31/71/13 ps input-group skew: 0 errors (stagger_simulate.log).
- tb.v: replay observed full-design input transitions (161,336,321,58,179 ps intervals): final CO=0111, O=1001, correct (replay_simulate.log).
- Full-design result at the corresponding settled point: CO=0111 correct, O=1100 incorrect. Disabling xelab optimization (--O0) leaves 23 scoreboard failures unchanged.

The isolated primitive does NOT reproduce the full-design failure. Therefore neither a primitive-model bug nor a hardware defect is established. Remaining suspects include interconnect-annotation/event interaction; capture of visible ports may not reflect delayed internal input events. Do not modify vendor models or suppress timing to force a passing result.

The current minimal test is reproducible by xvlog tb.v plus glbl.v, xelab -f elaborate.opts, xsim carry -runall. Keep the full-design events_simulate.log and no_opt_simulate.log in ../pulse_direct/ff_pulse/timed_slow as evidence.

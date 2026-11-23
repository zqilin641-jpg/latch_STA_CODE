# Cross-simulator evidence — 2026-11-17

Same routed pure-FF netlist and slow/max SDF at 12 ns, 256 stimuli, 318 checks. Vendor primitive sources compiled unchanged with XIL_TIMING.

XSIM: 23 scoreboard errors, internal clock edges=290. Recompiling original vendor CARRY4 into work library did not change this. Internal S_in=0110, CO_fb=1111, ideal XOR=1001 but delayed O=1100 at the first error.

ModelSim SE-64 10.4: with +transport_int_delays +pulse_int_r/0 +pulse_int_e/0, internal edges=290, 318 checks, zero scoreboard errors. Same observed point O=1001. See transport_simulate.log. Without transport settings clock pulses were suppressed (only one internal edge), so that run is invalid as functional timing evidence.

IMPORTANT: ModelSim warning vsim-3316 reports 408 negative timing check limits zeroed because no solution was possible for some delayed timing check nets. Thus this proves data-scoreboard agreement under that simulation configuration, NOT full timing signoff. Native STA must remain authoritative for setup/hold and this warning must be investigated before calling SDF validation complete.

No latch speedup is claimed. Next: inspect negative-check warning, run mixed candidate with identical simulator configuration, and compare native STA and functional cycle behavior separately.

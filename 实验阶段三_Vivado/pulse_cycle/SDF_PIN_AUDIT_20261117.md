# SDF pin audit — 2026-11-17

latch_cut6_00 is placed at SLICE_X3Y12/SLICEL.AFF. Its D pin maps to two BEL pins: SLICE_X3Y12/A5LUT/A1 and SLICE_X3Y12/AFF/D. Other inspected latch D pins map to one FF D BEL pin. This is evidence of a physical mapping difference, not yet a proven cause of the SDF writer limitation.

The native timing report includes routed paths through latch_cut6_00/D. The SDF writer nevertheless reports Timing 38-5/SDFWriter-1 and substitutes zero for its D-to-Q arc.

Two isolated experiments preserve the original:
1. mixed_sdf_fix: unroute target net, prohibit A5LUT, reroute. Warning remains.
2. mixed_sdf_fullroute: unroute entire design, prohibit A5LUT, reroute. Warning remains. Native timing at 10 ns still passes: WNS 1.042 ns, WHS 0.198 ns, WPWS 0.750 ns.

Neither experiment repairs the export. Do not use these files to claim complete SDF coverage or improved Fmax. Next investigation should inspect site-level mappings and exporter handling, or change the latch placement in another isolated implementation; repeating routing alone has not worked.

ModelSim +ntc_warn also identifies automatic negative-check adjustment at FDCE setuphold/recrem checks. These include data/CE and reset checks; the warning cannot be dismissed as reset-only. Existing successful scoreboard result remains conditional, not full timing signoff.

Evidence: audit.tcl, mixed/latch_pin_audit.txt, mixed/latch00_paths.rpt, fix_sdf.log, fix_sdf_fullroute.log; detailed NTC log in ../modelsim_timing_crosscheck/ntc_simulate.log.

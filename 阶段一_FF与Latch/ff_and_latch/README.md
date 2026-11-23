# Independent FF / Latch Timing Baseline

This directory contains two independent PGL50H-6/FBG484 PDS projects, not a
board image. Do not download these projects to the MES50HP: there is no board
pin assignment or implemented phase generator, and no bitstream is generated.
The tested second-stage board image remains under `../single_latch/`.

## Files

| Location | Purpose |
| --- | --- |
| `rtl/timing_boundaries.v` | Identical eight-bit input and output register boundaries. |
| `rtl/ff_timing_top.v` | Two-stage FF core, sampled once per transaction clock. |
| `rtl/latch_timing_top.v` | Two-stage latch core with related external phase inputs. |
| `../single_latch/rtl/datapath_compare.v` | Reused, unchanged arithmetic cores. No duplicate core source. |
| `constraints/ff_timing.fdc` | FF clock, IO-delay assumptions and reset exception. |
| `constraints/latch_timing.fdc` | Same reference period and related phase waveforms. |
| `pds/ff_build.tcl`, `pds/latch_build.tcl` | Independent compile through timing-report generation. |
| `scripts/run_build.ps1` | Build, check mapped storage and export comparisons. |
| `scripts/export_comparison.ps1` | Extract core paths and verify destination-macro coverage. |
| `sim/tb_independent_timing.v` | Transaction-aligned tests, two phase configurations and reset. |
| `scripts/run_sim.ps1` | RTL or post-route functional simulation. |

## Contracts

Both cores compute `rotl8((x + 0x39) mod 256, 3) XOR 0xA7`.
The transaction period is 640 ns in both projects, not 20 ns. The FF core now
uses that transaction clock directly instead of the second-stage board's
50 MHz controller with a once-per-32-cycle enable. There is no checker or
stimulus generator inside either synthesis project.

Both versions add identical input/output register boundaries. Including
those boundaries, the FF result is returned three reference-clock cycles
after sampling the input; the latch result is returned one cycle afterwards.
The testbench checks transaction identities rather than same-time output equality.
Each core still has sixteen storage cells. The latch version also has sixteen
boundary FFs; the FF version has thirty-two FFs including its boundaries.

Latch default clocks share a nominal time origin:

- `transaction_clock`: period 640 ns, waveform [0,320) ns.
- `phase_a`: period 640 ns, high [40,200) ns, 25% duty.
- `phase_b`: period 640 ns, high [320,480) ns, 25% duty.

These are assumptions about related ideal external clocks. They are not PLL
outputs or evidence of actual waveform generation on the board. The separate
40% simulation uses A=[40,296), B=[360,616) ns at the same period; it does not
change the PDS constraints or imply that 40% timing closure has been checked.
IO delays (max 2 ns, min 0.2 ns) and clock uncertainty (0.2 ns) are assumptions.
Only the asynchronous reset port has a false-path exception.

## Build and Simulate

Run from this directory:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_sim.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\run_build.ps1 -Variant all
powershell -ExecutionPolicy Bypass -File .\scripts\run_sim.ps1 -PostRoute
```

Use `-Variant ff` or `-Variant latch` for one build. Run
`scripts/export_comparison.ps1` after both reports are available when using
separate builds. Append `-Gui` to either simulation command for waveforms.
Both simulation modes require 777 checks and zero errors. The mapped mode
uses the exported physical netlists without SDF annotation.

## PDS UI and Reports

Open these existing projects in PDS via File > Open Project:

- `build/ff/ff_timing_top.pds`
- `build/latch/latch_timing_top.pds`

Each project has its own sources, FDC, synthesis, mapping, placement/routing
and Report Timing step. Re-running reports in the UI is supported. Report
options use min/max analysis, one worst path per endpoint and up to 128 paths
per group; retain sufficient path count if re-exporting comparisons.
Do not run Generate Bit Stream or program either timing-only project.

Original reports:

- `build/ff/report_timing/ff_timing_top.rtr`
- `build/latch/report_timing/latch_timing_top.rtr`

Core-only extracts are under each project's `core_reports/` directory:
`input_to_first.txt`, `first_to_second.txt`, `second_to_output.txt`.
`build/comparison/core_paths.csv` contains the numeric path records.
`build/comparison/comparison.md` contains a short table with explicit limits.

PDS can pack adders and FFs into composite macros. Their timing endpoints may
be macro input pins, with part of the arithmetic absorbed into the endpoint's
timing requirement. Therefore path count is not register-bit count, and reported
logic-plus-route delay is not necessarily the entire arithmetic delay. Export
validation checks eight mapped cells in each storage bank and all destination
macro groups for setup/hold at both corners; it does not claim to list every
possible combinational path. Original reports remain the primary evidence.

## Limits and Next Work

The 640 ns case is a conservative analysis baseline. A larger reported slack
does not establish a higher Fmax: FF and latch capture edges and latency differ.
The PDS Performance Summary also includes boundary IO paths. Automatic pin
placement, different clock routing and packed resource types affect the reports.
Do not derive measured Fmax from that summary or compare only LUT counts.

Inspect the latch `Time borrow` and `Max time borrow` fields. A borrowing window
alone does not mean borrowing is being used; selected baseline paths currently
report zero actual borrowing. No SDF validation, real phase-generator design,
board frequency sweep, Howard Tmin or independent LP prediction is provided.
Keep library setup/hold values and clock assumptions explicit in the next model;
do not replace them by zero or assume that FPGA timing equals ASIC timing.

## Recorded Verification: 2026-10-14

- Full two-project build and report export completed successfully.
- FF mapped core: sixteen FFs, no latches; latch mapped core: sixteen latches,
  no FFs inside the arithmetic core. Both retain sixteen boundary FFs.
- RTL simulation: 777 checks, zero errors/warnings.
- Post-route functional simulation: 777 checks, zero errors/warnings, no SDF.
- Export: 216 selected timing paths, with mapped destination-macro coverage
  verified for all three groups, both checks and both corners.
- Largest selected actual latch borrowing: 0 ns at the baseline period.

PDS warnings about unspecified physical IO placement are expected for these
analysis-only wrappers. The reset port is intentionally asynchronous and
excluded from timing, so this is not proof of reset recovery/removal closure.
No hardware execution or frequency measurement was performed for these projects.

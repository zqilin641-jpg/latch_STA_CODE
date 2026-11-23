# Controlled Time-Borrowing Experiment

This is a timing-analysis experiment, not a board image. No board pin assignment,
real clock generator, bitstream, SDF run or measured Fmax is provided. The
earlier `single_latch` and `ff_and_latch` source files are reused unchanged.
Howard and its independent LP reference have not been integrated here.

## PDS Cases

All cases use `latch_timing_top`, a 640 ns transaction period, related ideal
external clocks, 16 core latches and 16 input/output boundary FFs. Phase B is
high over [320,480) ns. IO budgets and user uncertainty match the old baseline.

| Case | Phase A high (ns) | Purpose |
| --- | --- | --- |
| baseline | [40,200) | Data arrives before opening; no borrowing required. |
| borrow | [2,162) | Earlier opening, same 160 ns pulse; exercise borrowing. |
| overflow | [2,3) | Deliberately too-short capture window; expect setup failures. |

The 1 ns pulse is an intentionally unrealistic negative control, not a
recommendation for generating such clocks on the MES50HP. Each case is placed
and routed independently. Differences between cases are not a fixed-route
measurement and do not prove an Fmax improvement.

Build from this directory:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_build.ps1 -Case all
powershell -ExecutionPolicy Bypass -File .\scripts\check_reports.ps1
```

Use `-Case baseline`, `borrow` or `overflow` for one build. The checker requires
all three reports. A successful tool execution is not sufficient: it also
checks storage mapping, eight destinations per core stage/check/corner,
slack arithmetic, positive borrowing, downstream launch adjustment, and the
expected negative-control setup failures. `Some Constraints Violated` is the
intended result of `overflow`, not permission to use that case on hardware.

## Open in PDS UI

Use File > Open Project; there is no need to run Generate Bitstream.

- `build/baseline/latch_timing_top.pds`
- `build/borrow/latch_timing_top.pds`
- `build/overflow/latch_timing_top.pds`

For `borrow`, open Report Timing > Slow Corner > Worst Case Timing Path > Setup.
Paths ending at `u_stage_one` can report Slack=0 after the tool adds borrowing.
This does not mean no time was borrowed. Read `Time borrow`, `Max time borrow`
and `time borrowed from endpoint` in the original text report:
`build/borrow/report_timing/latch_timing_top.rtr`.

For the following stage, look for a startpoint ending in `/D` and
`time given to startpoint`: data is launched later than the nominal G opening
reference. The available next-stage time is reduced by this adjustment relative
to that path's own opening-based budget. Do not compare raw stage slack across
different A phases as though all capture relationships were identical.

Borrowing fields include the tool's uncertainty and early/late accounting.
For example, reported borrowing is not necessarily D arrival minus the
unadjusted local gate opening. Always retain the original report evidence.
Do not interpret the min/hold report's borrow-window labels as the max/setup
transparent window; the checker uses max/slow records for borrowing evidence.

Results: `build/comparison/comparison.md`, `summary.csv`, `paths.csv`, and
per-case `build/<case>/evidence/` detailed path extracts. The reference-clock
Performance Summary can show a positive Estimated Frequency even while the
separate phase-A paths fail. It is not whole-design Fmax or board measurement.

## Separate RTL Illustration

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_concept_sim.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\run_concept_sim.ps1 -Gui
```

This test reuses the original arithmetic core with the vendor GTP latch model.
It has no synthesized boundary FFs and no SDF delays. All three instances use
A=[40,200), B=[320,480) ns. The stimulus deliberately changes inputs at 20, 60
and 220 ns, respectively. These stimulus times are not measured FPGA delays
and are not the PDS cases' phase-A waveforms.

- Early input: the new first-stage value launches at A opening, 40 ns.
- Input during transparency: it launches at 60 ns, losing 20 ns of the next
  stage's opening-based budget, while still returning the correct transaction.
- Input after closing: the expected transaction is missed and appears one
  cycle later. The test must detect this failure, not silently shift its
  scoreboard to accept the wrong transaction.

The batch script requires exactly 22 checks and zero unexpected errors. A VCD
and transcript are generated in `build/modelsim_concept/`. This is conceptual
functional evidence, not independent verification of the physical STA numbers.

## Recorded Verification: 2026-10-19

All three projects were rebuilt through placement/routing and report generation.
The checker verified 288 selected core path records across all cases, three
stages, max/min checks and slow/fast corners, including all eight destinations.

| Case | Maximum slow setup borrowing (ns) | Worst first-latch slow setup slack (ns) | Slow / fast failing first-latch endpoints |
| --- | ---: | ---: | --- |
| baseline | 0.000 | 34.370 | 0 / 0 |
| borrow | 3.514 | 0.000 | 0 / 0 |
| overflow | 1.020 | -2.465 | 8 / 6 |

The passing borrowed case also reports a maximum 3.264 ns next-stage source
adjustment. It includes paths starting at the first latch's D rather than G,
confirming that the reported borrowing is propagated into the following stage.
The overflow borrowing values are limited by its short window and do not
make that timing-violating case valid.

The separate RTL illustration passed 22 checks with zero unexpected errors;
its 20 ns late-data launch shift and missed-window negative control were both
detected. The original independent FF/latch RTL regression was rerun and passed
777 checks. No original arithmetic or wrapper RTL was edited.

These are analysis and functional-simulation results, not hardware execution.
Expected PDS warnings include unassigned physical IO placement and the
asynchronous reset exception. Recovery/removal closure, a real phase generator,
SDF simulation, Howard/LP agreement and an actual Fmax comparison remain future
work. In particular, neither a 1 ns pulse nor the library's very small pulse
width requirements should be treated as an achievable board-clock waveform.

# Howard validation

Scope: Howard result status, MCR-LP status and period comparison. YTO and
ELL implementations are unchanged. The standalone test target does not
compile or execute either algorithm and does not require LEDA or xtensor.

## Build and run in the existing Linux/WSL development environment

From the repository root, with a C++17 compiler, Boost headers and GLPK installed:

```sh
cmake -S tests -B build_howard_tests -DCMAKE_BUILD_TYPE=Debug
cmake --build build_howard_tests -j2
ctest --test-dir build_howard_tests --output-on-failure
```

The main CMake build also registers this test when BP_BUILD_TESTS is enabled.
No package installation is performed by these commands.

## Semantics

- Tsu and Th are signed finite timing requirements in both CLI defaults and
  per-node files. Tcq and Tdq remain finite nonnegative propagation delays.
  Negative setup/hold are passed unchanged to both Howard and LP graph models.
  Tests include -0.012 ns setup and -0.014 ns hold, individually and together,
  plus per-node overrides, nonfinite/malformed input and negative Tcq/Tdq.
  These checks validate the existing model, not full PDS model equivalence.

- Howard solves cyclic strongly connected components (SCCs) separately.
  Isolated vertices, sinks and acyclic components no longer invalidate a policy.
  A wholly acyclic graph returns NoCycle, not a finite timing result.
- Converged requires a finite nonnegative period, a closed critical cycle
  matching the selected ratio, and a full-graph numerical certificate.
  The certificate includes bridges and acyclic nodes, not only the best SCC.
  For every edge u -> v it checks d[u] <= d[v] + weight - ratio * transit.
  maxViolation and cycleResidual must each be <= the caller's eps (1e-10
  in the validation suite). These are floating-point checks, not an exact
  arithmetic proof or a proof of physical timing-model correctness.
- The iteration limit applies per cyclic SCC; iterations is the aggregate
  across attempted cyclic SCCs. cyclicComponents counts attempted SCCs.
- UnsupportedCycle means an encountered policy cycle has total transit <= eps.
  It does NOT establish that the timing model is infeasible. This conservative
  policy-iteration limitation is retained; such SCCs are never silently skipped.
  Negative-transit edges with positive total cycle transit are supported.
- ConstraintViolation means the final global certificate failed. It must not
  be interpreted as a general proof of infeasibility. maxViolation is retained
  for diagnosis; the invalid ratio/period/cycle are not exported.
- On Howard failure, ratio/period are NaN and the critical cycle is cleared.
- MCR-LP reports Optimal only when simplex returns 0, GLPK reports GLP_OPT,
  and the objective is finite and nonnegative. Slacks are exported only then.
- Only Converged Howard and Optimal LP periods are compared. The tolerance
  in ns is 1e-4 + 1e-8 * max(abs(T_Howard), abs(T_LP)).
- The main program exits 2 for non-comparable results and 3 for a mismatch,
  before legacy YTO/ELL comparisons or CSV export. Every requested iteration
  must pass. A failed run does not overwrite a report from an earlier run.
- Existing CLI parameters, duty cycles and per-latch overrides are preserved.

## Tests

Self-loop and repeated-run behavior; missing cycles; invalid indices and
policies; zero/negative-transit cycles; nonfinite weights; iteration limit;
GLPK status classification; matched/mismatched/non-comparable periods;
invalid input; Howard versus real GLPK on a one-latch fixture with duty
cycles 0.5 and 0.4, zero/nonzero parameters and per-latch overrides.

## Verification recorded on 2026-10-11

The initial sandbox could not access WSL. After the user enabled access,
the standalone tests and full application compiled under Ubuntu/WSL with
GCC 13.3.0, Boost 1.83.0 and GLPK 5.0. All 6 full-project CTest entries passed.

The 31 benchmark/*.out inputs were checked in four configurations (124 cases):
baseline (duty 0.5, zero parameters), duty 0.4, all four parameters 0.1 ns
with duty 0.5, and the first non-IO latch overridden to four 0.1 ns parameters
with duty 0.4. All final comparisons passed. Maximum period gap was
1.4210854715202004e-14 ns.

The four s38417 cases exceeded the initial 30-second per-case timeout and
passed on retry with a 180-second timeout. A separate baseline probe took
34.39 seconds. These timings include both solvers and are not Howard-only
performance measurements. Initial and retry results are retained separately
under results/2026-10-11, alongside the merged final-results.csv.

CLI checks verified a valid CSV report, failure exit code 2, suppression of
failed reports, preservation of an existing report, and the zero-delay
boundary. YTO/ELL were not executed or modified. The full build still compiles
their unchanged source files. Existing compiler/CMake warnings remain.

Reproduce the matrix and the extended-timeout retry from the repository root:

```sh
python3 tests/run_benchmarks.py build_howard_tests/howard_benchmark_validation build_howard_tests/benchmark-results.csv
python3 tests/run_benchmarks.py build_howard_tests/howard_benchmark_validation build_howard_tests/benchmark-retry.csv 180 s38417.blif.out
```

The runner exits nonzero on any failure or timeout. The initial run above can
therefore fail on slower machines even when the extended retry passes.
These checks establish numerical agreement on the tested model and parameter
samples, not physical correctness of the timing model or all possible inputs.

## Phase 2 coverage and costs

The howard_graphs test covers isolated vertices, DAGs, multiple cyclic SCCs,
bridges, sinks, permuted node indices, parallel arcs, mixed-sign transit,
unsupported SCCs and conflicting bounds across SCCs. It also compares 200
fixed-seed random positive-transit graphs against independent enumeration
of all simple cycles. An explicit six-vertex regression guards against
resetting only the critical anchor's offset and stalling policy iteration.

The certificate uses long-double potentials and at most V full edge sweeps,
so its worst-case time is O(VE), with O(V) auxiliary storage. It exits early
when a sweep makes no changes. This phase targets reliability, not a speedup.
Policy scratch arrays still use full-graph indices and are reinitialized for
each cyclic SCC; many tiny SCCs can therefore add O(number_of_SCCs * V) work.
Very small transit totals (<= eps), extreme numeric scales, and difficult
policy iterations can still return a non-success status. LP stays independent.

The benchmark harness now emits ten detail fields: Howard status, LP status,
Howard period, LP period, gap, comparison tolerance, maximum edge violation,
critical-cycle ratio residual, attempted cyclic SCCs, total policy iterations.
Historical phase-1 CSV files retain their original six-field detail format.

Phase-2 verification on 2026-10-11: all 7 full-project CTest entries, 200
exhaustive-reference random graph comparisons, graph ASan/UBSan checks and
all 124 benchmark configurations passed. No case exceeded the 180-second
limit. Howard periods were unchanged from phase 1. Maximum LP gap was
1.4210854715202004e-14 ns; maximum edge violation was
2.7755575615628914e-17; maximum cycle-ratio residual was
4.163336342344337e-17. Logs and CSVs are under results/2026-10-11-phase2.

Reproduce the phase-2 matrix and graph memory checks:

```sh
python3 tests/run_benchmarks.py build_howard_tests/howard_benchmark_validation build_howard_tests/phase2-results.csv 180
g++ -std=c++17 -g -O1 -fsanitize=address,undefined -fno-omit-frame-pointer -Iinclude tests/test_howard_graphs.cpp src/howard.cpp -o build_howard_tests/howard_graph_sanitized
ASAN_OPTIONS=detect_leaks=1 build_howard_tests/howard_graph_sanitized
```

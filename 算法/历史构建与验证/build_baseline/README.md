# Zero-Parameter Baseline

This directory records the baseline before non-zero latch timing parameters are introduced.

`baseline.py` independently reconstructs the current C++ MCR graph and locates the cycle-ratio boundary with negative-cycle detection. For every recorded case, two runs produced identical results; `ratio - 1e-7` had no negative cycle and `ratio + 1e-7` had a negative cycle.

The Linux executable was subsequently run through WSL. Howard and the MCR GLPK model agree with the independently reconstructed boundary for all three recorded benchmarks. `verify_constraints.py` also recovers feasible `a/A/d/D` potentials and directly checks the ten zero-parameter constraints from Table I of the paper. Increasing the reported period by `1e-6 ns` remains feasible, while decreasing it by `1e-6 ns` is infeasible.

YTO is intentionally excluded from the trusted baseline because it disagrees with Howard and GLPK on every recorded benchmark. The ellipsoid/ELL model is also excluded because it treats `W` as a separate optimization variable and is not the fixed-50%-duty-cycle MCR model being established here.

## Non-zero global parameters

The fixed-50%-duty-cycle executable accepts four optional global latch parameters, in nanoseconds:

```text
main <input> <iterations> <ellipsoid-radius> [Tsu Th Tcq Tdq]
```

## Per-latch parameters

An optional text file can override the global defaults for selected delay-graph nodes:

```text
main <input> <iterations> <ellipsoid-radius> Tsu Th Tcq Tdq node_params_file
```

Each non-comment line contains five whitespace-separated fields:

```text
# node Tsu Th Tcq Tdq
INPUT 0.21 0.11 0.07 0.16
L1    0.13 0.09 0.18 0.06
```

`INPUT` and `OUTPUT` both refer to the parser's canonical `IO` node. Parameters
not listed in the file keep the four command-line defaults. Unknown nodes,
duplicate entries, negative values, malformed rows, and unreadable files are
rejected instead of being silently ignored.

For an edge from latch `i` to latch `j`, `Tcq_i` and `Tdq_i` are properties of
the sending latch, while `Tsu_j` and `Th_j` are properties of the receiving
latch. The MCR graph and GLPK model both generate eight local constraints per
node and two path constraints per delay edge.

Two asymmetric two-latch tests exercise both override directions and global
fallback behavior. Their independently reconstructed periods are `5.085 ns`
and `5.035 ns`; Howard and GLPK match both values.

## Global benchmark results

With `Tsu=0.05`, `Th=0.03`, `Tcq=0.02`, and `Tdq=0.01`, Howard, GLPK, and the independent constraint checker agree on:

```text
s27     5.46621 ns
s298   11.44425 ns
s1423  78.42318 ns
```

The maximum direct-formula residuals are `0`, `1.78e-15`, and `1.71e-14`, respectively. Zero-valued optional parameters reproduce the original baseline.

## Fixed non-50% duty cycle

The pulse-width ratio `q = W/T` can be supplied after the four global latch
parameters. The supported range is `0 < q <= 0.5`, matching the paper's
`W <= T/2` restriction:

```text
main <input> <iterations> <ellipsoid-radius> Tsu Th Tcq Tdq q
main <input> <iterations> <ellipsoid-radius> Tsu Th Tcq Tdq q node_params_file
```

The old form with the node parameter file directly after `Tdq` remains valid.
In the departure constraints, `T/2` becomes `(1-q)T`. Consequently, the two
MCR edges use cost `-(1-q)T0-Tcq` and transit `-2(1-q)`; changing only the
cost would produce the wrong period.

An analytic self-loop case with `q=0.35` and `Tcq=3 ns` gives
`Tmin = 16/3 ns`. The same case at `q=0.5` gives `4.8 ns`, confirming that the
duty-cycle term can become critical rather than merely passing through the
implementation unused.

## Critical-cycle and slack reporting

Howard now retains the minimum-ratio cycle and maps every graph vertex back to
its latch and `a/A/d/D` timing variable. The executable prints every edge on
that cycle, including its constraint type, cost, and transit. It also reports
GLPK constraints with slack at most `1e-7 ns` as *active constraints*. An active
LP row is not necessarily part of the Howard critical cycle.

A machine-readable report can be requested without changing the legacy
positional arguments:

```text
main <input> <iterations> <radius> [timing parameters...] \
  --report timing_report.csv
```

The CSV contains `critical_cycle` rows and all `lp_constraint` rows with their
slacks. For the branched test, reducing the critical `INPUT -> L2` maximum
delay by `0.01 ns` reduces `Tmin` from `6.08 ns` to `6.07 ns`; reducing the
noncritical `L2 -> INPUT` maximum delay by the same amount leaves `Tmin` at
`6.08 ns`.

## Systematic model validation

Run the reproducible validation suite in WSL with:

```text
python3 build_baseline/validate_model.py \
  --exe build_baseline/cpp/main \
  --random-count 25 \
  --seed 20220928
```

The suite contains eleven hand-checkable cases whose simple cycles are exhaustively enumerated:

```text
single_self       4.15 ns
two_latch_ring    5.01 ns
branched_ring     6.08 ns
no_io_ring        5.01 ns
per_latch_io      5.085 ns
per_latch_l1      5.035 ns
duty_035          4.15 ns
duty_030_params   5.085 ns
duty_035_critical 5.333333333333 ns
critical_Dmax_minus_001    6.07 ns
noncritical_Dmax_minus_001 6.08 ns
```

It also generates 25 deterministic, strongly connected graphs with 2-6 delay
vertices, independent non-zero global timing parameters, and duty cycles
uniformly sampled from 20% to 50%. Every case must satisfy all of the following:

- exhaustive cycle enumeration, where enabled, agrees with the negative-cycle boundary;
- Howard and GLPK agree with the independent boundary;
- the reported critical cycle satisfies `sum(cost)/sum(transit) = Howard ratio`;
- directly evaluated Table I constraints have residual at most `1e-9`;
- `T + 1e-6 ns` is feasible and `T - 1e-6 ns` is infeasible.

The recorded run passed all 36 cases with a maximum formula residual of `1.78e-15`.

The `.out` and `.rslt` parsers now create the merged IO vertex lazily, so inputs that never reference `INPUT` or `OUTPUT` no longer acquire an isolated synthetic vertex. `no_io_ring` exercises this case directly.

Node-local MCR constraints are added once per delay vertex and path constraints once per delay edge, reducing the graph from `10E` edges to `8V + 2E` without changing the feasible region. The recorded benchmark edge counts changed from `140/840/18970` to `60/288/4394` for `s27/s298/s1423`, respectively, while all optimal periods remained unchanged.

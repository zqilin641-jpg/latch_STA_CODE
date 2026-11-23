from __future__ import annotations

import argparse
import math
import os
import random
import re
import subprocess
from dataclasses import dataclass
from pathlib import Path

import baseline
import verify_constraints


@dataclass(frozen=True)
class Case:
    path: Path
    params: baseline.LatchTimingParams
    expected_period: float | None = None
    node_params: dict[str, baseline.LatchTimingParams] | None = None
    params_file: Path | None = None
    duty_cycle: float = 0.5


def enumerate_cycle_ratio(node_count, edges):
    outgoing = [[] for _ in range(node_count)]
    for edge in edges:
        outgoing[edge.source].append(edge)

    best_ratio = math.inf
    best_cycle = None

    # Restrict intermediate vertices to indices >= start so each simple cycle
    # is considered from its smallest vertex only.
    for start in range(node_count):
        visited = {start}
        path = []

        def visit(node):
            nonlocal best_ratio, best_cycle
            for edge in outgoing[node]:
                target = edge.target
                if target == start:
                    cycle = path + [edge]
                    total_transit = sum(item.transit for item in cycle)
                    total_weight = sum(item.weight for item in cycle)
                    if total_transit > 1e-12:
                        ratio = total_weight / total_transit
                        if ratio < best_ratio:
                            best_ratio = ratio
                            best_cycle = cycle
                    elif abs(total_transit) <= 1e-12 and total_weight < -1e-12:
                        raise AssertionError("negative zero-transit cycle")
                    continue
                if target < start or target in visited:
                    continue
                visited.add(target)
                path.append(edge)
                visit(target)
                path.pop()
                visited.remove(target)

        visit(start)

    if best_cycle is None:
        raise AssertionError("no positive-transit cycle found")
    return best_ratio, best_cycle


def write_random_cases(directory: Path, count: int, seed: int):
    directory.mkdir(parents=True, exist_ok=True)
    rng = random.Random(seed)
    cases = []
    for case_index in range(count):
        node_count = rng.randint(2, 6)
        names = ["INPUT"] + [f"N{i}" for i in range(1, node_count)]
        arcs = set()

        # A directed ring guarantees every modeled latch is active and the
        # delay graph is strongly connected.
        for node in range(node_count):
            arcs.add((node, (node + 1) % node_count))
        for source in range(node_count):
            for target in range(node_count):
                if rng.random() < 0.30:
                    arcs.add((source, target))

        path = directory / f"random_{case_index:02d}.blif.out"
        lines = ["Network generated", "latch latch max_delay min_delay"]
        for source, target in sorted(arcs):
            maximum = rng.uniform(1.0, 12.0)
            minimum = rng.uniform(0.05, maximum)
            lines.append(
                f"{names[source]} {names[target]} {maximum:.9f} {minimum:.9f}"
            )
        path.write_text("\n".join(lines) + "\n", encoding="ascii")

        params = baseline.LatchTimingParams(
            setup=rng.uniform(0.005, 0.08),
            hold=rng.uniform(0.005, 0.08),
            clock_to_q=rng.uniform(0.005, 0.08),
            data_to_q=rng.uniform(0.005, 0.08),
        )
        cases.append(Case(path, params, duty_cycle=rng.uniform(0.20, 0.50)))
    return cases


def run_cpp(executable: Path, case: Case):
    params = case.params
    command = [
        str(executable),
        str(case.path),
        "1",
        "100",
        str(params.setup),
        str(params.hold),
        str(params.clock_to_q),
        str(params.data_to_q),
    ]
    if case.duty_cycle != 0.5:
        command.append(str(case.duty_cycle))
    if case.params_file is not None:
        command.append(str(case.params_file))
    environment = os.environ.copy()
    project_root = executable.parents[2]
    environment["LD_LIBRARY_PATH"] = str(project_root)
    result = subprocess.run(
        command,
        check=True,
        capture_output=True,
        text=True,
        env=environment,
    )
    howard_match = re.search(r"T_Howard's = ([0-9.eE+-]+)", result.stdout)
    glpk_match = re.search(r"T_LP_MCR = ([0-9.eE+-]+)", result.stdout)
    cycle_match = re.search(
        r"cycle cost=([0-9.eE+-]+), transit=([0-9.eE+-]+), "
        r"ratio=([0-9.eE+-]+), Howard ratio=([0-9.eE+-]+)",
        result.stdout,
    )
    if not howard_match or not glpk_match or not cycle_match:
        raise AssertionError(f"could not parse C++ output for {case.path.name}")
    cycle_cost = float(cycle_match.group(1))
    cycle_transit = float(cycle_match.group(2))
    cycle_ratio = float(cycle_match.group(3))
    howard_ratio = float(cycle_match.group(4))
    if not math.isclose(cycle_cost / cycle_transit, cycle_ratio, abs_tol=1e-5):
        raise AssertionError(f"{case.path.name}: invalid reported cycle ratio")
    if not math.isclose(cycle_ratio, howard_ratio, abs_tol=1e-5):
        raise AssertionError(f"{case.path.name}: reported cycle is not Howard-critical")
    return float(howard_match.group(1)), float(glpk_match.group(1))


def validate_case(executable: Path, case: Case, enumerate_cycles: bool):
    delay_nodes, delays, initial_period, node_names = baseline.read_delay_graph(
        case.path
    )
    graph_nodes, edges = baseline.build_mcr_graph(
        delay_nodes,
        delays,
        initial_period,
        case.params,
        node_names,
        case.node_params,
        case.duty_cycle,
    )
    ratio = baseline.solve_ratio(graph_nodes, edges, initial_period)
    expected = initial_period - 2.0 * ratio

    if case.expected_period is not None and not math.isclose(
        expected, case.expected_period, abs_tol=1e-9
    ):
        raise AssertionError(
            f"{case.path.name}: expected {case.expected_period}, reconstructed {expected}"
        )

    if enumerate_cycles:
        enumerated_ratio, _ = enumerate_cycle_ratio(graph_nodes, edges)
        enumerated_period = initial_period - 2.0 * enumerated_ratio
        if not math.isclose(expected, enumerated_period, abs_tol=1e-9):
            raise AssertionError(
                f"{case.path.name}: cycle enumeration gives {enumerated_period}, "
                f"boundary solver gives {expected}"
            )

    verification = verify_constraints.verify(
        case.path, 1e-6, case.params, case.node_params, case.duty_cycle
    )
    if not verification["potentials_feasible"]:
        raise AssertionError(f"{case.path.name}: no feasible potentials")
    if verification["formula_residual"] > 1e-9:
        raise AssertionError(
            f"{case.path.name}: formula residual {verification['formula_residual']}"
        )
    if not verification["larger_period_feasible"]:
        raise AssertionError(f"{case.path.name}: larger period is infeasible")
    if verification["smaller_period_feasible"]:
        raise AssertionError(f"{case.path.name}: smaller period is feasible")

    howard, glpk = run_cpp(executable, case)
    # The executable currently prints six significant digits.
    output_tolerance = max(1e-5, abs(expected) * 1e-5)
    if abs(howard - expected) > output_tolerance:
        raise AssertionError(
            f"{case.path.name}: Howard {howard}, expected {expected}"
        )
    if abs(glpk - expected) > output_tolerance:
        raise AssertionError(f"{case.path.name}: GLPK {glpk}, expected {expected}")

    return expected, verification["formula_residual"]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--exe", type=Path, required=True)
    parser.add_argument("--random-count", type=int, default=25)
    parser.add_argument("--seed", type=int, default=20220928)
    args = parser.parse_args()

    root = Path(__file__).resolve().parent
    analytic_cases = [
        Case(
            root / "testdata/single_self.blif.out",
            baseline.LatchTimingParams(0.2, 0.1, 0.05, 0.15),
            4.15,
        ),
        Case(
            root / "testdata/two_latch_ring.blif.out",
            baseline.LatchTimingParams(0.05, 0.03, 0.02, 0.01),
            5.01,
        ),
        Case(
            root / "testdata/branched_ring.blif.out",
            baseline.LatchTimingParams(0.05, 0.03, 0.02, 0.01),
            6.08,
        ),
        Case(
            root / "testdata/no_io_ring.blif.out",
            baseline.LatchTimingParams(0.05, 0.03, 0.02, 0.01),
            5.01,
        ),
        Case(
            root / "testdata/two_latch_ring.blif.out",
            baseline.LatchTimingParams(0.04, 0.03, 0.02, 0.01),
            expected_period=5.085,
            node_params={
                "IO": baseline.LatchTimingParams(0.21, 0.11, 0.07, 0.16)
            },
            params_file=root / "testdata/per_latch_io.params",
        ),
        Case(
            root / "testdata/two_latch_ring.blif.out",
            baseline.LatchTimingParams(0.04, 0.03, 0.02, 0.01),
            expected_period=5.035,
            node_params={
                "L1": baseline.LatchTimingParams(0.13, 0.09, 0.18, 0.06)
            },
            params_file=root / "testdata/per_latch_l1.params",
        ),
        Case(
            root / "testdata/single_self.blif.out",
            baseline.LatchTimingParams(0.2, 0.1, 0.05, 0.15),
            expected_period=4.15,
            duty_cycle=0.35,
        ),
        Case(
            root / "testdata/two_latch_ring.blif.out",
            baseline.LatchTimingParams(0.04, 0.03, 0.02, 0.01),
            node_params={
                "IO": baseline.LatchTimingParams(0.21, 0.11, 0.07, 0.16)
            },
            params_file=root / "testdata/per_latch_io.params",
            expected_period=5.085,
            duty_cycle=0.30,
        ),
        Case(
            root / "testdata/single_self.blif.out",
            baseline.LatchTimingParams(0.2, 0.1, 3.0, 0.0),
            expected_period=16.0 / 3.0,
            duty_cycle=0.35,
        ),
        Case(
            root / "testdata/branched_ring_critical_minus_001.blif.out",
            baseline.LatchTimingParams(0.05, 0.03, 0.02, 0.01),
            expected_period=6.07,
        ),
        Case(
            root / "testdata/branched_ring_noncritical_minus_001.blif.out",
            baseline.LatchTimingParams(0.05, 0.03, 0.02, 0.01),
            expected_period=6.08,
        ),
    ]
    random_cases = write_random_cases(root / "generated", args.random_count, args.seed)

    max_residual = 0.0
    for case in analytic_cases:
        period, residual = validate_case(args.exe.resolve(), case, True)
        max_residual = max(max_residual, residual)
        print(f"analytic,{case.path.name},{period:.12g},{residual:.3g}")
    for case in random_cases:
        period, residual = validate_case(args.exe.resolve(), case, False)
        max_residual = max(max_residual, residual)
        print(f"random,{case.path.name},{period:.12g},{residual:.3g}")

    print(
        f"PASS analytic={len(analytic_cases)} random={len(random_cases)} "
        f"max_formula_residual={max_residual:.3g} seed={args.seed}"
    )


if __name__ == "__main__":
    main()

from __future__ import annotations

import argparse
from collections import defaultdict
from pathlib import Path

import baseline


def feasible_potentials(node_count, edges, ratio, tolerance=1e-10):
    values = [0.0] * node_count
    for _ in range(node_count - 1):
        changed = False
        for edge in edges:
            candidate = values[edge.source] + edge.weight - ratio * edge.transit
            if candidate < values[edge.target]:
                values[edge.target] = candidate
                changed = True
        if not changed:
            break

    max_graph_residual = max(
        values[edge.target]
        - (values[edge.source] + edge.weight - ratio * edge.transit)
        for edge in edges
    )
    return values, max_graph_residual <= tolerance, max_graph_residual


def check_original_constraints(
    values,
    node_count,
    delays,
    period,
    params,
    node_names,
    node_params,
    duty_cycle,
):
    reference = values[0]
    residuals = defaultdict(lambda: float("-inf"))

    def sub(node, offset):
        return values[1 + 4 * node + offset]

    for node in range(node_count):
        timing = node_params.get(node_names[node], params)
        earliest_arrival = sub(node, 0)
        latest_arrival = sub(node, 1)
        earliest_departure = sub(node, 2)
        latest_departure = sub(node, 3)

        residuals["t-a<=-Th"] = max(
            residuals["t-a<=-Th"], reference - earliest_arrival + timing.hold
        )
        residuals["A-t<=T-Tsu"] = max(
            residuals["A-t<=T-Tsu"],
            latest_arrival - reference - period + timing.setup,
        )
        residuals["a-A<=0"] = max(
            residuals["a-A<=0"], earliest_arrival - latest_arrival
        )
        residuals["d-D<=0"] = max(
            residuals["d-D<=0"], earliest_departure - latest_departure
        )
        residuals["t-d<=-(1-q)T-Tcq"] = max(
            residuals["t-d<=-(1-q)T-Tcq"],
            reference
            - earliest_departure
            + (1.0 - duty_cycle) * period
            + timing.clock_to_q,
        )
        residuals["a-d<=-Tdq"] = max(
            residuals["a-d<=-Tdq"],
            earliest_arrival - earliest_departure + timing.data_to_q,
        )
        residuals["t-D<=-(1-q)T-Tcq"] = max(
            residuals["t-D<=-(1-q)T-Tcq"],
            reference
            - latest_departure
            + (1.0 - duty_cycle) * period
            + timing.clock_to_q,
        )
        residuals["A-D<=-Tdq"] = max(
            residuals["A-D<=-Tdq"],
            latest_arrival - latest_departure + timing.data_to_q,
        )

    for (source, target), (maximum, minimum) in delays.items():
        earliest_departure = sub(source, 2)
        latest_departure = sub(source, 3)
        earliest_arrival = sub(target, 0)
        latest_arrival = sub(target, 1)

        residuals["a_j-d_i<=dij-T"] = max(
            residuals["a_j-d_i<=dij-T"],
            earliest_arrival - earliest_departure - minimum + period,
        )
        residuals["D_i-A_j<=-Dij+T"] = max(
            residuals["D_i-A_j<=-Dij+T"],
            latest_departure - latest_arrival + maximum - period,
        )

    return dict(residuals)


def verify(path: Path, margin: float, params, node_params=None, duty_cycle=0.5):
    node_params = node_params or {}
    delay_nodes, delays, initial_period, node_names = baseline.read_delay_graph(path)
    graph_nodes, edges = baseline.build_mcr_graph(
        delay_nodes,
        delays,
        initial_period,
        params,
        node_names,
        node_params,
        duty_cycle,
    )
    optimum_ratio = baseline.solve_ratio(graph_nodes, edges, initial_period)
    optimum_period = initial_period - 2.0 * optimum_ratio

    # Move an insignificant amount into the feasible side to avoid classifying
    # a zero-weight critical cycle as negative due to floating-point rounding.
    checked_ratio = optimum_ratio - 1e-10
    checked_period = initial_period - 2.0 * checked_ratio
    values, feasible, graph_residual = feasible_potentials(
        graph_nodes, edges, checked_ratio
    )
    residuals = check_original_constraints(
        values,
        delay_nodes,
        delays,
        checked_period,
        params,
        node_names,
        node_params,
        duty_cycle,
    )
    max_name, max_residual = max(residuals.items(), key=lambda item: item[1])

    larger_period_ratio = (initial_period - (optimum_period + margin)) / 2.0
    smaller_period_ratio = (initial_period - (optimum_period - margin)) / 2.0

    return {
        "file": path.name,
        "period": optimum_period,
        "potentials_feasible": feasible,
        "graph_residual": graph_residual,
        "formula_residual": max_residual,
        "worst_constraint": max_name,
        "larger_period_feasible": not baseline.has_negative_cycle(
            graph_nodes, edges, larger_period_ratio
        ),
        "smaller_period_feasible": not baseline.has_negative_cycle(
            graph_nodes, edges, smaller_period_ratio
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("inputs", nargs="+", type=Path)
    parser.add_argument("--margin", type=float, default=1e-6)
    parser.add_argument("--tsu", type=float, default=0.0)
    parser.add_argument("--th", type=float, default=0.0)
    parser.add_argument("--tcq", type=float, default=0.0)
    parser.add_argument("--tdq", type=float, default=0.0)
    parser.add_argument("--duty-cycle", type=float, default=0.5)
    args = parser.parse_args()
    params = baseline.LatchTimingParams(
        setup=args.tsu,
        hold=args.th,
        clock_to_q=args.tcq,
        data_to_q=args.tdq,
    )

    print(
        "file,T_baseline,potentials_feasible,max_graph_residual,"
        "max_formula_residual,worst_constraint,T_plus_margin_feasible,"
        "T_minus_margin_feasible"
    )
    for path in args.inputs:
        result = verify(path, args.margin, params, duty_cycle=args.duty_cycle)
        print(
            ",".join(
                str(result[key])
                for key in (
                    "file",
                    "period",
                    "potentials_feasible",
                    "graph_residual",
                    "formula_residual",
                    "worst_constraint",
                    "larger_period_feasible",
                    "smaller_period_feasible",
                )
            )
        )


if __name__ == "__main__":
    main()

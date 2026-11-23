from __future__ import annotations

import argparse
import math
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class Edge:
    source: int
    target: int
    weight: float
    transit: float


@dataclass(frozen=True)
class LatchTimingParams:
    setup: float = 0.0
    hold: float = 0.0
    clock_to_q: float = 0.0
    data_to_q: float = 0.0


def read_delay_graph(path: Path):
    node_ids = {}
    node_names = []
    delays: dict[tuple[int, int], tuple[float, float]] = {}
    initial_period = 0.0

    def node_id(name: str) -> int:
        if name in ("INPUT", "OUTPUT"):
            name = "IO"
        if name not in node_ids:
            node_ids[name] = len(node_ids)
            node_names.append(name)
        return node_ids[name]

    with path.open(encoding="utf-8", errors="replace") as stream:
        for line in stream:
            words = line.split()
            if len(words) < 4:
                continue
            if words[0] == "Network" or words[2:4] == ["max_delay", "min_delay"]:
                continue
            try:
                maximum = float(words[2])
                minimum = float(words[3])
            except ValueError:
                continue
            source = node_id(words[0])
            target = node_id(words[1])
            key = (source, target)
            if key in delays:
                old_maximum, old_minimum = delays[key]
                maximum = max(maximum, old_maximum)
                minimum = min(minimum, old_minimum)
            delays[key] = (maximum, minimum)
            initial_period = max(initial_period, maximum)

    return len(node_ids), delays, initial_period, node_names


def build_mcr_graph(
    node_count,
    delays,
    initial_period,
    params=None,
    node_names=None,
    node_params=None,
    duty_cycle=0.5,
):
    params = params or LatchTimingParams()
    if not 0.0 < duty_cycle <= 0.5:
        raise ValueError("duty_cycle must be in (0, 0.5]")
    node_names = node_names or [str(node) for node in range(node_count)]
    node_params = node_params or {}
    # Node 0 is the reference. Each delay-graph node becomes a, A, d, D.
    graph_node_count = 1 + 4 * node_count
    edges: list[Edge] = []
    def sub(node: int, offset: int) -> int:
        return 1 + 4 * node + offset

    def add(source: int, target: int, weight: float, transit: float):
        edges.append(Edge(source, target, weight, transit))

    for node in range(node_count):
        timing = node_params.get(node_names[node], params)
        add(sub(node, 0), 0, -timing.hold, 0.0)
        add(0, sub(node, 1), initial_period - timing.setup, 2.0)
        add(sub(node, 2), sub(node, 0), -timing.data_to_q, 0.0)
        add(
            sub(node, 2),
            0,
            -(1.0 - duty_cycle) * initial_period - timing.clock_to_q,
            -2.0 * (1.0 - duty_cycle),
        )
        add(sub(node, 3), sub(node, 1), -timing.data_to_q, 0.0)
        add(
            sub(node, 3),
            0,
            -(1.0 - duty_cycle) * initial_period - timing.clock_to_q,
            -2.0 * (1.0 - duty_cycle),
        )
        add(sub(node, 1), sub(node, 0), 0.0, 0.0)
        add(sub(node, 3), sub(node, 2), 0.0, 0.0)

    for (source, target), (maximum, minimum) in delays.items():
        add(sub(source, 2), sub(target, 0), minimum - initial_period, -2.0)
        add(sub(target, 1), sub(source, 3), initial_period - maximum, 2.0)

    return graph_node_count, edges


def has_negative_cycle(node_count: int, edges: list[Edge], ratio: float) -> bool:
    # A zero-distance super-source reaches every component.
    distance = [0.0] * node_count
    epsilon = 1e-12
    for iteration in range(node_count):
        changed = False
        for edge in edges:
            candidate = distance[edge.source] + edge.weight - ratio * edge.transit
            if candidate < distance[edge.target] - epsilon:
                distance[edge.target] = candidate
                changed = True
                if iteration == node_count - 1:
                    return True
        if not changed:
            return False
    return False


def solve_ratio(node_count: int, edges: list[Edge], initial_period: float):
    low = 0.0
    high = max(initial_period, 1.0)
    low_negative = has_negative_cycle(node_count, edges, low)
    while not has_negative_cycle(node_count, edges, high):
        high *= 2.0
        if high > 1e9:
            raise RuntimeError("could not bracket the cycle-ratio boundary")

    if low_negative:
        low = -high
        while has_negative_cycle(node_count, edges, low):
            low *= 2.0
            if low < -1e9:
                raise RuntimeError("could not find a feasible lower ratio")

    for _ in range(64):
        middle = (low + high) / 2.0
        if has_negative_cycle(node_count, edges, middle):
            high = middle
        else:
            low = middle
    return (low + high) / 2.0


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("inputs", nargs="+", type=Path)
    args = parser.parse_args()

    print("file,delay_vertices,delay_edges,mcr_vertices,mcr_edges,T_initial,ratio,T_baseline")
    for path in args.inputs:
        delay_nodes, delays, initial_period, node_names = read_delay_graph(path)
        graph_nodes, edges = build_mcr_graph(
            delay_nodes, delays, initial_period, node_names=node_names
        )
        ratio = solve_ratio(graph_nodes, edges, initial_period)
        period = initial_period - 2.0 * ratio
        values = (
            path.name,
            delay_nodes,
            len(delays),
            graph_nodes,
            len(edges),
            initial_period,
            ratio,
            period,
        )
        print(",".join(str(value) for value in values))


if __name__ == "__main__":
    main()

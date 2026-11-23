#include <functional>
#include <iostream>
#include <random>
#include <stdexcept>
#include "howard.hpp"

static void require(bool condition, const std::string &message) {
    if (!condition) throw std::runtime_error(message);
}

static Graph makeGraph(size_t n) {
    Graph graph;
    for (size_t i = 0; i < n; ++i)
        boost::add_vertex(NodeProperties{i, std::to_string(i), "a"}, graph);
    return graph;
}

static void arc(Graph &graph, size_t u, size_t v, double weight, double transit) {
    boost::add_edge(u, v, ArcProperties{0, weight, transit, "test"}, graph);
}

// Independent reference: enumerate simple cycles on small graphs, not policies.
static double enumerateRatio(const Graph &graph) {
    long double best = std::numeric_limits<long double>::infinity();
    std::vector<bool> seen(boost::num_vertices(graph), false);
    for (size_t start = 0; start < seen.size(); ++start) {
        std::function<void(Vertex, long double, long double)> visit;
        visit = [&](Vertex u, long double weight, long double transit) {
            seen[u] = true;
            auto edges = boost::out_edges(u, graph);
            for (auto it = edges.first; it != edges.second; ++it) {
                const auto v = boost::target(*it, graph);
                const auto w = weight + graph[*it].weight;
                const auto t = transit + graph[*it].delay;
                if (v == start && t > 0.0L) best = std::min(best, w / t);
                else if (v > start && !seen[v]) visit(v, w, t);
            }
            seen[u] = false;
        };
        visit(start, 0.0L, 0.0L);
    }
    return static_cast<double>(best);
}

static void check(Graph &graph, const std::string &label) {
    const double expected = enumerateRatio(graph);
    Howard solver(graph, boost::num_vertices(graph), 1000.0, 1e-10);
    solver.run();
    if (solver.getResult().status != HowardStatus::Converged) {
        for (auto e : boost::make_iterator_range(boost::edges(graph)))
            std::cerr << boost::source(e, graph) << ' ' << boost::target(e, graph)
                      << ' ' << graph[e].weight << ' ' << graph[e].delay << '\n';
    }
    require(solver.getResult().status == HowardStatus::Converged,
            label + ": " + statusName(solver.getResult().status));
    require(std::fabs(solver.getRatio() - expected) <= 1e-8, label + ": wrong ratio");
    require(std::isfinite(solver.getResult().maxViolation) &&
            solver.getResult().maxViolation <= 1e-10, label + ": uncertified constraints");
    require(std::isfinite(solver.getResult().cycleResidual) &&
            solver.getResult().cycleResidual <= 1e-10, label + ": uncertified cycle");
    const auto cycle = solver.getCycle();
    require(!cycle.empty(), label + ": empty cycle");
    long double weight = 0, transit = 0;
    for (size_t i = 0; i < cycle.size(); ++i) {
        require(boost::target(cycle[i], graph) == boost::source(cycle[(i + 1) % cycle.size()], graph),
                label + ": disconnected cycle edges");
        weight += graph[cycle[i]].weight;
        transit += graph[cycle[i]].delay;
    }
    require(transit > 0 && std::fabs(static_cast<double>(weight / transit) - expected) <= 1e-8,
            label + ": incorrect critical cycle");
}

int main() {
    try {
        auto isolated = makeGraph(2);
        arc(isolated, 0, 0, 2, 1);
        check(isolated, "self-loop plus isolated vertex");

        auto dag = makeGraph(3);
        arc(dag, 0, 1, -10, 1);
        arc(dag, 1, 2, 3, -1);
        Howard noCycle(dag, 3, 1000, 1e-10);
        noCycle.run();
        require(noCycle.getResult().status == HowardStatus::NoCycle, "DAG status");

        auto multi = makeGraph(5);
        arc(multi, 0, 0, 3, 1);
        arc(multi, 1, 2, 1, 1);
        arc(multi, 2, 1, 3, 1);
        arc(multi, 0, 1, -100, -2);
        arc(multi, 2, 3, -100, 0);
        check(multi, "multiple SCCs with bridge and sink");
        for (size_t i = 0; i < 5; ++i) multi[i].nodeIndex = 4 - i;
        check(multi, "permuted node indices");

        auto mixed = makeGraph(2);
        arc(mixed, 0, 1, 3, -1);
        arc(mixed, 1, 0, 5, 3);
        check(mixed, "mixed edge transit, positive cycle total");

        auto unsupported = makeGraph(2);
        arc(unsupported, 0, 0, 1, 1);
        arc(unsupported, 1, 1, -1, 0);
        Howard bad(unsupported, 2, 1000, 1e-10);
        bad.run();
        require(bad.getResult().status == HowardStatus::UnsupportedCycle,
                "unsupported SCC must not be silently skipped");
        require(std::isnan(bad.getRatio()) && bad.getCycle().empty(), "failed result leakage");

        // Each SCC admits its own ratio, but their combined bounds conflict.
        auto conflict = makeGraph(2);
        arc(conflict, 0, 0, 1, 1);
        arc(conflict, 1, 1, 10, 1);
        arc(conflict, 1, 1, -5, -1);
        Howard global(conflict, 2, 1000, 1e-10);
        global.run();
        require(global.getResult().status == HowardStatus::ConstraintViolation,
                "global certificate must reject conflicting SCC bounds");
        require(global.getResult().maxViolation > 1e-10, "missing violation diagnostic");
        require(std::isnan(global.getRatio()) && global.getCycle().empty(), "certificate failure leakage");

        // Regression: resetting only the critical anchor to zero prevented convergence.
        auto offsets = makeGraph(6);
        const int offsetEdges[][4] = {
            {0,1,20,3}, {1,2,9,3}, {2,3,1,4}, {3,4,1,2}, {4,5,10,3}, {5,0,15,1},
            {0,3,4,4}, {0,4,16,1}, {5,1,-5,2}, {2,0,16,3}, {0,2,1,4}, {2,3,12,1},
            {0,1,0,2}, {0,0,11,2}, {3,5,9,1}, {0,0,1,2}, {5,2,6,1}, {3,1,8,1}
        };
        for (const auto &e : offsetEdges) arc(offsets, e[0], e[1], e[2], e[3]);
        check(offsets, "critical anchor offset regression");

        std::mt19937 random(20261011);
        for (int sample = 0; sample < 200; ++sample) {
            const size_t n = 2 + random() % 5;
            auto graph = makeGraph(n);
            for (size_t i = 0; i < n; ++i)
                arc(graph, i, (i + 1) % n, static_cast<int>(random() % 26) - 5, 1 + random() % 4);
            for (size_t i = 0; i < n * 2; ++i) {
                const auto u = random() % n, v = random() % n;
                const int weight = static_cast<int>(random() % 26) - 5;
                const auto transit = 1 + random() % 4;
                arc(graph, u, v, weight, transit);
            }
            check(graph, "random graph " + std::to_string(sample));
        }
        std::cout << "Graph structure and 200 exhaustive-reference comparisons passed\n";
        return 0;
    } catch (const std::exception &error) {
        std::cerr << error.what() << '\n';
        return 1;
    }
}

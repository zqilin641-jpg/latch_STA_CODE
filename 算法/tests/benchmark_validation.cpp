#include <iomanip>
#include <iostream>
#include <glpk.h>
#include "howard.hpp"
#include "LP.hpp"

int main(int argc, char **argv) {
    if (argc != 3) return 1;
    glp_term_out(GLP_OFF);
    const std::string mode = argv[2];
    const double duty = mode == "duty" || mode == "override" ? 0.4 : 0.5;
    LatchTimingParams params;
    LatchTimingParamMap overrides;
    if (mode == "nonzero") params = {0.1, 0.1, 0.1, 0.1};
    if (mode == "override") {
        DelayGraph delays;
        double initial;
        if (!getDelayGraph(argv[1], delays, initial)) return 1;
        for (size_t i = 0; i < boost::num_vertices(delays); ++i) {
            if (delays[i].name != "IO") {
                overrides[delays[i].name] = {0.1, 0.1, 0.1, 0.1};
                break;
            }
        }
        if (overrides.empty()) return 1;
    }
    Graph graph;
    double initial;
    getMcrGraph(argv[1], graph, initial, params, overrides, duty);
    Howard solver(graph, boost::num_vertices(graph), initial, 1e-10);
    solver.run();
    McrLpResult lp;
    double period;
    mcrLP(argv[1], period, params, overrides, duty, nullptr, &lp);
    const auto comparison = comparePeriods(solver.getResult(), lp, period);
    std::cout << std::setprecision(17) << statusName(solver.getResult().status) << ','
              << statusName(lp.status) << ',' << solver.getResult().period << ','
              << period << ',' << comparison.gap << ',' << comparison.tolerance << ','
              << solver.getResult().maxViolation << ',' << solver.getResult().cycleResidual << ','
              << solver.getResult().cyclicComponents << ',' << solver.getResult().iterations << '\n';
    return comparison.status == ComparisonStatus::Match ? 0 : 2;
}

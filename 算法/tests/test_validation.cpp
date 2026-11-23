#include <cmath>
#include <iostream>
#include <stdexcept>
#include "howard.hpp"
#include "LP.hpp"
#include "lp_result.hpp"

#define CHECK(expr) do { if (!(expr)) throw std::runtime_error(#expr); } while (false)

static Graph loop(double weight, double transit) {
    Graph graph;
    auto v = boost::add_vertex(NodeProperties{0, "A", "a"}, graph);
    boost::add_edge(v, v, ArcProperties{0, weight, transit, "test"}, graph);
    return graph;
}

static void checkFailure(Graph &graph, HowardStatus expected, size_t limit = 10000) {
    Howard solver(graph, boost::num_vertices(graph), 10.0, 1e-10, limit);
    solver.run();
    CHECK(solver.getResult().status == expected);
    CHECK(std::isnan(solver.getRatio()));
    CHECK(std::isnan(solver.getResult().period));
    CHECK(solver.getCycle().empty());
}

int main(int argc, char **argv) {
    try {
        CHECK(argc == 2);
        auto graph = loop(1.0, 1.0);
        Howard solver(graph, 1, 10.0, 1e-10);
        CHECK(solver.getResult().status == HowardStatus::NotRun);
        solver.run();
        CHECK(solver.getResult().status == HowardStatus::Converged);
        CHECK(std::fabs(solver.getResult().period - 8.0) < 1e-10);
        CHECK(solver.getCycle().size() == 1);
        solver.run();
        CHECK(solver.getResult().status == HowardStatus::Converged);
        CHECK(solver.getResult().iterations == 1);
        checkFailure(graph, HowardStatus::IterationLimit, 0);
        Graph empty;
        checkFailure(empty, HowardStatus::NoCycle);
        auto zero = loop(1.0, 0.0);
        checkFailure(zero, HowardStatus::UnsupportedCycle);
        auto negative = loop(1.0, -1.0);
        checkFailure(negative, HowardStatus::UnsupportedCycle);
        auto invalid = loop(1.0, 1.0);
        invalid[0].nodeIndex = 1;
        checkFailure(invalid, HowardStatus::InvalidVertexIndex);
        auto disconnected = loop(1.0, 1.0);
        boost::add_vertex(NodeProperties{1, "B", "a"}, disconnected);
        Howard isolated(disconnected, 2, 10.0, 1e-10);
        isolated.run();
        CHECK(isolated.getResult().status == HowardStatus::Converged);
        CHECK(isolated.getResult().period == 8.0);
        auto nonfinite = loop(std::numeric_limits<double>::infinity(), 1.0);
        checkFailure(nonfinite, HowardStatus::NumericalError);

        auto lp = classifyMcrLpResult(0, GLP_OPT, 8.0);
        CHECK(lp.status == LpStatus::Optimal);
        CHECK(classifyMcrLpResult(GLP_EITLIM, GLP_OPT, 8.0).status == LpStatus::SolverError);
        CHECK(classifyMcrLpResult(0, GLP_FEAS, 8.0).status == LpStatus::SolverError);
        CHECK(classifyMcrLpResult(0, GLP_NOFEAS, 8.0).status == LpStatus::Infeasible);
        CHECK(classifyMcrLpResult(GLP_ENOPFS, GLP_UNDEF, 8.0).status == LpStatus::Infeasible);
        CHECK(classifyMcrLpResult(0, GLP_UNBND, 8.0).status == LpStatus::Unbounded);
        CHECK(classifyMcrLpResult(0, GLP_OPT, NAN).status == LpStatus::NumericalError);
        CHECK(comparePeriods(solver.getResult(), lp, 8.0).status == ComparisonStatus::Match);
        CHECK(comparePeriods(solver.getResult(), lp, 8.1).status == ComparisonStatus::Mismatch);
        CHECK(comparePeriods(solver.getResult(), lp, NAN).status == ComparisonStatus::NotComparable);
        CHECK(comparePeriods(HowardResult{}, lp, 8.0).status == ComparisonStatus::NotComparable);
        CHECK(comparePeriods(solver.getResult(), McrLpResult{}, 8.0).status == ComparisonStatus::NotComparable);

        double period = 123.0;
        std::vector<TimingConstraintSlack> slacks(1);
        mcrLP("missing.unsupported", period, {}, {}, 0.5, &slacks, &lp);
        CHECK(lp.status == LpStatus::InputError && std::isnan(period) && slacks.empty());
        for (double duty : {0.5, 0.4}) {
            for (const LatchTimingParams params : {
                    LatchTimingParams{}, LatchTimingParams{0.1, 0.1, 0.1, 0.1},
                    LatchTimingParams{-0.012, 0.1, 0.1, 0.1},
                    LatchTimingParams{0.1, -0.014, 0.1, 0.1},
                    LatchTimingParams{-0.012, -0.014, 0.1, 0.1}}) {
                Graph timing;
                double t0;
                getMcrGraph(argv[1], timing, t0, params, {}, duty);
                Howard model(timing, boost::num_vertices(timing), t0, 1e-10);
                model.run();
                mcrLP(argv[1], period, params, {}, duty, &slacks, &lp);
                CHECK(lp.status == LpStatus::Optimal);
                CHECK(comparePeriods(model.getResult(), lp, period).status == ComparisonStatus::Match);
            }
            LatchTimingParamMap overrides{{"A", {-0.012, -0.014, 0.1, 0.1}}};
            Graph timing;
            double t0;
            getMcrGraph(argv[1], timing, t0, {}, overrides, duty);
            Howard model(timing, boost::num_vertices(timing), t0, 1e-10);
            model.run();
            mcrLP(argv[1], period, {}, overrides, duty, &slacks, &lp);
            CHECK(comparePeriods(model.getResult(), lp, period).status == ComparisonStatus::Match);
        }
        std::cout << "Howard/LP validation tests passed\n";
        return 0;
    } catch (const std::exception &error) {
        std::cerr << error.what() << '\n';
        return 1;
    }
}

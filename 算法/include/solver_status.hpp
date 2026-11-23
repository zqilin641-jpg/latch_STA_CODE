#pragma once

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <limits>

enum class HowardStatus {
    NotRun, Converged, NoCycle, InvalidVertexIndex, InvalidPolicy,
    UnsupportedCycle, NumericalError, IterationLimit, ConstraintViolation
};

inline const char *statusName(HowardStatus status) {
    switch (status) {
    case HowardStatus::NotRun: return "NotRun";
    case HowardStatus::Converged: return "Converged";
    case HowardStatus::NoCycle: return "NoCycle";
    case HowardStatus::InvalidVertexIndex: return "InvalidVertexIndex";
    case HowardStatus::InvalidPolicy: return "InvalidPolicy";
    case HowardStatus::UnsupportedCycle: return "UnsupportedCycle";
    case HowardStatus::NumericalError: return "NumericalError";
    case HowardStatus::IterationLimit: return "IterationLimit";
    case HowardStatus::ConstraintViolation: return "ConstraintViolation";
    }
    return "Unknown";
}

struct HowardResult {
    HowardStatus status = HowardStatus::NotRun;
    double ratio = std::numeric_limits<double>::quiet_NaN();
    double period = std::numeric_limits<double>::quiet_NaN();
    std::size_t iterations = 0;
    std::size_t cyclicComponents = 0;
    double maxViolation = std::numeric_limits<double>::quiet_NaN();
    double cycleResidual = std::numeric_limits<double>::quiet_NaN();
};

enum class LpStatus { NotRun, Optimal, Infeasible, Unbounded, SolverError, NumericalError, InputError };

inline const char *statusName(LpStatus status) {
    switch (status) {
    case LpStatus::NotRun: return "NotRun";
    case LpStatus::Optimal: return "Optimal";
    case LpStatus::Infeasible: return "Infeasible";
    case LpStatus::Unbounded: return "Unbounded";
    case LpStatus::SolverError: return "SolverError";
    case LpStatus::NumericalError: return "NumericalError";
    case LpStatus::InputError: return "InputError";
    }
    return "Unknown";
}

struct McrLpResult {
    LpStatus status = LpStatus::NotRun;
    int returnCode = 0;
    int solutionStatus = 0;
};

enum class ComparisonStatus { NotComparable, Match, Mismatch };

struct PeriodComparison {
    ComparisonStatus status = ComparisonStatus::NotComparable;
    double gap = std::numeric_limits<double>::quiet_NaN();
    double tolerance = std::numeric_limits<double>::quiet_NaN();
};

inline PeriodComparison comparePeriods(const HowardResult &howard,
                                       const McrLpResult &lp, double lpPeriod) {
    PeriodComparison result;
    if (howard.status != HowardStatus::Converged || lp.status != LpStatus::Optimal ||
        !std::isfinite(howard.period) || !std::isfinite(lpPeriod) ||
        howard.period < 0.0 || lpPeriod < 0.0)
        return result;
    result.gap = std::fabs(howard.period - lpPeriod);
    result.tolerance = 1e-4 + 1e-8 * std::max(std::fabs(howard.period), std::fabs(lpPeriod));
    result.status = result.gap <= result.tolerance ? ComparisonStatus::Match : ComparisonStatus::Mismatch;
    return result;
}

#pragma once

#include <glpk.h>
#include "solver_status.hpp"

inline McrLpResult classifyMcrLpResult(int returnCode, int solutionStatus, double objective) {
    McrLpResult result;
    result.returnCode = returnCode;
    result.solutionStatus = solutionStatus;
    if (returnCode == 0 && solutionStatus == GLP_OPT)
        result.status = std::isfinite(objective) && objective >= 0.0 ?
                        LpStatus::Optimal : LpStatus::NumericalError;
    else if (returnCode == GLP_ENOPFS || (returnCode == 0 && solutionStatus == GLP_NOFEAS))
        result.status = LpStatus::Infeasible;
    else if (returnCode == 0 && solutionStatus == GLP_UNBND)
        result.status = LpStatus::Unbounded;
    else
        result.status = LpStatus::SolverError;
    return result;
}

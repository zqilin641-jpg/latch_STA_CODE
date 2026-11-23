#pragma once
#include <stdio.h>
#include <stdlib.h>
#include <chrono>
#include <vector>
#include "timing_graph.hpp"
#include "solver_status.hpp"

using namespace chrono;

struct TimingConstraintSlack
{
    string source;
    string target;
    string constraintType;
    double slack;
};
/**
 * @brief Linear programing for mcr using GLPK
 * 
 * @param fileName 
 */
nanoseconds mcrLP(const string &fileName, double &tlp,
                  const LatchTimingParams &params = {},
                  const LatchTimingParamMap &nodeParams = {},
                  double dutyCycle = 0.5,
                  vector<TimingConstraintSlack> *slacks = nullptr,
                  McrLpResult *result = nullptr);
/**
 * @brief Linear programing for ell using GLPK
 * 
 * @param fileName 
 */
nanoseconds ellLP(const string &fileName,double &tlp,double &wlp);

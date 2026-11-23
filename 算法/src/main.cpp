#include <limits>
#include <tuple>
#include <map>
#include <set>
#include <fstream>
#include <sstream>
#include <iostream>
#include <chrono>
#include <string>
#include <cmath>
#include <algorithm>
#include <iomanip>
#include "ell.hpp"
#include "cutting_plane.hpp"
#include "timing_graph.hpp"
#include "timing_oracle.hpp"
#include "howard.hpp"
#include "YTO.hpp"
#include "LP.hpp"
using namespace std;
using namespace chrono;
using Arr = xt::xarray<double, xt::layout_type::row_major>;
double a = 1.0;

static string canonicalNodeName(const string &name)
{
     return name == "INPUT" || name == "OUTPUT" ? "IO" : name;
}

static bool parseDouble(const string &text, double &value)
{
     try
     {
          size_t consumed = 0;
          value = stod(text, &consumed);
          return consumed == text.size() && isfinite(value);
     }
     catch (...)
     {
          return false;
     }
}

static bool loadNodeParams(const string &fileName, LatchTimingParamMap &nodeParams)
{
     ifstream input(fileName);
     if (!input)
     {
          cerr << "Cannot open latch parameter file: " << fileName << endl;
          return false;
     }

     string line;
     size_t lineNumber = 0;
     while (getline(input, line))
     {
          ++lineNumber;
          istringstream stream(line);
          string name;
          if (!(stream >> name) || name[0] == '#')
               continue;

          LatchTimingParams values;
          if (!(stream >> values.setup >> values.hold >> values.clockToQ >> values.dataToQ))
          {
               cerr << fileName << ':' << lineNumber
                    << ": expected: node Tsu Th Tcq Tdq" << endl;
               return false;
          }
          string trailing;
          if ((stream >> trailing) && trailing[0] != '#')
          {
               cerr << fileName << ':' << lineNumber << ": unexpected extra field" << endl;
               return false;
          }
          if (!isfinite(values.setup) || !isfinite(values.hold) ||
              !isfinite(values.clockToQ) || !isfinite(values.dataToQ) ||
              values.clockToQ < 0 || values.dataToQ < 0)
          {
               cerr << fileName << ':' << lineNumber
                    << ": timing parameters must be finite; Tcq and Tdq must be nonnegative" << endl;
               return false;
          }

          name = canonicalNodeName(name);
          if (!nodeParams.emplace(name, values).second)
          {
               cerr << fileName << ':' << lineNumber
                    << ": duplicate node parameter entry: " << name << endl;
               return false;
          }
     }
     return true;
}

static bool validateNodeNames(const string &fileName,
                              const LatchTimingParamMap &nodeParams)
{
     if (nodeParams.empty())
          return true;

     DelayGraph graph;
     double ignoredPeriod = 0.0;
     bool loaded = extension(fileName) == "out"
                       ? getDelayGraph(fileName, graph, ignoredPeriod)
                       : getRsltDelayGraph(fileName, graph, ignoredPeriod);
     if (!loaded)
          return false;

     set<string> names;
     for (auto vertex : boost::make_iterator_range(boost::vertices(graph)))
          names.insert(graph[vertex].name);
     for (const auto &entry : nodeParams)
     {
          if (names.count(entry.first) == 0)
          {
               cerr << "Latch parameter file contains unknown node: "
                    << entry.first << endl;
               return false;
          }
     }
     return true;
}

static string graphNodeLabel(const NodeProperties &node)
{
     return node.latchName + ":" + node.timingVariable;
}

static void printCriticalCycle(const Graph &graph, const vector<Edge> &cycle,
                               double ratio)
{
     cout << "Critical MCR cycle:" << endl;
     if (cycle.empty())
     {
          cout << "\tUnavailable" << endl;
          return;
     }

     double totalWeight = 0.0;
     double totalTransit = 0.0;
     for (const auto &edge : cycle)
     {
          auto source = boost::source(edge, graph);
          auto target = boost::target(edge, graph);
          totalWeight += graph[edge].weight;
          totalTransit += graph[edge].delay;
          cout << "\t[" << graph[edge].constraintType << "] "
               << graphNodeLabel(graph[source]) << " -> "
               << graphNodeLabel(graph[target])
               << ", cost=" << graph[edge].weight
               << ", transit=" << graph[edge].delay << endl;
     }
     cout << "\tcycle cost=" << totalWeight
          << ", transit=" << totalTransit
          << ", ratio=" << totalWeight / totalTransit
          << ", Howard ratio=" << ratio << endl;
}

static void printActiveConstraints(vector<TimingConstraintSlack> slacks)
{
     constexpr double tolerance = 1e-7;
     sort(slacks.begin(), slacks.end(), [](const auto &left, const auto &right) {
          return left.slack < right.slack;
     });
     size_t activeCount = count_if(slacks.begin(), slacks.end(), [](const auto &item) {
          return item.slack <= tolerance;
     });

     cout << "Active LP constraints (slack <= " << tolerance << " ns): "
          << activeCount << endl;
     const size_t shown = min<size_t>(activeCount, 20);
     for (size_t i = 0; i < shown; ++i)
          cout << "\t[" << slacks[i].constraintType << "] "
               << slacks[i].source << " -> " << slacks[i].target
               << ", slack=" << slacks[i].slack << " ns" << endl;
     if (activeCount > shown)
          cout << "\t... " << activeCount - shown
               << " more active constraints" << endl;
}

static string csvField(string value)
{
     size_t position = 0;
     while ((position = value.find('"', position)) != string::npos)
     {
          value.insert(position, 1, '"');
          position += 2;
     }
     return '"' + value + '"';
}

static bool writeTimingReport(const string &fileName, const Graph &graph,
                              const vector<Edge> &cycle,
                              const vector<TimingConstraintSlack> &slacks)
{
     ofstream output(fileName);
     if (!output)
     {
          cerr << "Cannot write timing report: " << fileName << endl;
          return false;
     }

     output << "record_type,constraint_type,source,target,cost,transit,slack_ns\n";
     for (const auto &edge : cycle)
     {
          auto source = boost::source(edge, graph);
          auto target = boost::target(edge, graph);
          output << "critical_cycle," << csvField(graph[edge].constraintType)
                 << ',' << csvField(graphNodeLabel(graph[source]))
                 << ',' << csvField(graphNodeLabel(graph[target]))
                 << ',' << graph[edge].weight << ',' << graph[edge].delay << ",\n";
     }
     for (const auto &item : slacks)
          output << "lp_constraint," << csvField(item.constraintType)
                 << ',' << csvField(item.source) << ',' << csvField(item.target)
                 << ",,," << item.slack << '\n';
     return true;
}

int main(int argc, char *const argv[])
{
     string reportFile;
     int positionalArgc = argc;
     if (argc >= 3 && string(argv[argc - 2]) == "--report")
     {
          reportFile = argv[argc - 1];
          positionalArgc -= 2;
     }
     if (positionalArgc != 4 && positionalArgc != 8 &&
         positionalArgc != 9 && positionalArgc != 10)
     {
          cerr << "Usage: " << argv[0]
               << " <input_file> <iterations> <ellipsoid_radius>"
               << " [Tsu Th Tcq Tdq [duty_cycle] [node_params_file]]"
               << " [--report report.csv]" << endl;
          return 1;
     }
     auto change = high_resolution_clock::now() - high_resolution_clock::now();
     string filename(argv[1]);
     cout << filename << endl;
     int iter = atoi(argv[2]);
     double alpha = atof(argv[3]);
     LatchTimingParams params;
     if (positionalArgc >= 8)
     {
          if (!parseDouble(argv[4], params.setup) ||
              !parseDouble(argv[5], params.hold) ||
              !parseDouble(argv[6], params.clockToQ) ||
              !parseDouble(argv[7], params.dataToQ))
          {
               cerr << "Timing parameters must be finite numbers." << endl;
               return 1;
          }
     }
     LatchTimingParamMap nodeParams;
     string nodeParamsFile;
     double dutyCycle = 0.5;
     if (positionalArgc == 9)
     {
          if (!parseDouble(argv[8], dutyCycle))
               nodeParamsFile = argv[8];
     }
     else if (positionalArgc == 10)
     {
          if (!parseDouble(argv[8], dutyCycle))
          {
               cerr << "Duty cycle must be a finite number." << endl;
               return 1;
          }
          nodeParamsFile = argv[9];
     }
     if (!nodeParamsFile.empty())
     {
          if (!loadNodeParams(nodeParamsFile, nodeParams) ||
              !validateNodeNames(filename, nodeParams))
               return 1;
     }
     if (iter <= 0 || !isfinite(alpha) || alpha <= 0 ||
         params.clockToQ < 0 || params.dataToQ < 0 ||
         dutyCycle <= 0.0 || dutyCycle > 0.5)
     {
          cerr << "Iterations and radius must be positive and finite; Tsu/Th may be signed; Tcq/Tdq must be nonnegative; duty cycle must be in (0, 0.5]." << endl;
          return 1;
     }
     const bool hasNonzeroParams = params.setup != 0 || params.hold != 0 ||
                                   params.clockToQ != 0 || params.dataToQ != 0 ||
                                   !nodeParams.empty() || dutyCycle != 0.5;
     Graph g_mcr;
     Graph g_ell;
     double tInitial;
     getMcrGraph(filename, g_mcr, tInitial, params, nodeParams, dutyCycle);
     if (!hasNonzeroParams)
          getEllGraph(filename, g_ell, tInitial);
     nanoseconds time_howard(0), time_yto(0), time_lp_mcr(0), time_ell(0), time_lp_ell(0);

     double t_lp_mcr, t_lp_ell, w_lp_ell;
     double t_howard, t_yto, t_ell, w_ell;
     vector<Edge> criticalCycle;
     vector<TimingConstraintSlack> constraintSlacks;
     HowardResult howardResult;
     McrLpResult lpResult;
     PeriodComparison comparison;
     for (int iq = 0; iq < iter; iq++)
     {
          //solve mcr by howard
          Howard how(g_mcr, boost::num_vertices(g_mcr), tInitial, 1e-10);
          auto beginTime = high_resolution_clock::now();
          how.run();
          auto endTime = high_resolution_clock::now();
          time_howard += endTime - beginTime;
          howardResult = how.getResult();
          t_howard = howardResult.period;
          criticalCycle = how.getCycle();
          // Verify the MCR results before running legacy comparisons or exporting reports.
          time_lp_mcr += mcrLP(filename, t_lp_mcr, params, nodeParams,
                              dutyCycle, &constraintSlacks, &lpResult);
          comparison = comparePeriods(howardResult, lpResult, t_lp_mcr);
          if (comparison.status != ComparisonStatus::Match)
          {
               cerr << "MCR validation failed at iteration " << iq + 1
                    << ": Howard=" << statusName(howardResult.status)
                    << ", LP=" << statusName(lpResult.status)
                    << ", GLPK return=" << lpResult.returnCode
                    << ", GLPK status=" << lpResult.solutionStatus << endl;
               cerr << "Howard diagnostics: iterations=" << howardResult.iterations
                    << ", cyclic SCCs=" << howardResult.cyclicComponents
                    << ", max violation=" << howardResult.maxViolation
                    << ", cycle ratio residual=" << howardResult.cycleResidual << endl;
               if (comparison.status == ComparisonStatus::Mismatch)
                    cerr << "Period mismatch: Howard=" << t_howard
                         << " ns, LP=" << t_lp_mcr << " ns, gap=" << comparison.gap
                         << " ns, tolerance=" << comparison.tolerance << " ns" << endl;
               else
                    cerr << "Periods are not comparable; no validated timing report was written." << endl;
               return comparison.status == ComparisonStatus::Mismatch ? 3 : 2;
          }
          if (!hasNonzeroParams)
          {
               // Legacy comparison only: the current YTO implementation is not trusted.
               YTO yto(g_mcr, boost::num_vertices(g_mcr));
               beginTime = high_resolution_clock::now();
               yto.run();
               endTime = high_resolution_clock::now();
               time_yto += endTime - beginTime;
               t_yto = tInitial - 2 * yto.getRatio();
          }
          if (!hasNonzeroParams)
          {
               //solve ell
               auto P = timing_oracle<Graph>(g_ell);
               auto E = ell(alpha, Arr{tInitial, 0});
               const auto options = Options{1000000, 1e-6};
               auto t = std::numeric_limits<double>::max();
               beginTime = high_resolution_clock::now();
               auto [x, ell_info] = cutting_plane_dc(P, E, t, options);
               endTime = high_resolution_clock::now();
               time_ell += endTime - beginTime;
               t_ell = x[0];
               w_ell = x[1];
               //solve ell by LP
               time_lp_ell += ellLP(filename, t_lp_ell, w_lp_ell);
          }
     }
     cout << "=====================SUMMARY====================" << endl;
     cout << "Input file is " << filename << endl;
     cout << "Initial T is " << tInitial << " ns" << endl;
     cout << "Latch parameters: Tsu = " << params.setup << " ns, Th = " << params.hold
          << " ns, Tcq = " << params.clockToQ << " ns, Tdq = " << params.dataToQ << " ns" << endl;
     cout << "Clock duty cycle: " << dutyCycle << " (W = "
          << dutyCycle << " * T)" << endl;
     if (!nodeParams.empty())
          cout << "Per-latch overrides: " << nodeParams.size()
               << " from " << nodeParamsFile << endl;
     cout << "MCR:" << endl;
     cout << "Howard status: " << statusName(howardResult.status)
          << ", iterations: " << howardResult.iterations
          << ", cyclic SCCs: " << howardResult.cyclicComponents << endl;
     cout << "Howard certificate: max violation=" << howardResult.maxViolation
          << ", cycle ratio residual=" << howardResult.cycleResidual << endl;
     cout << "LP status: " << statusName(lpResult.status) << endl;
     cout << "Howard/LP validation: PASS, gap=" << comparison.gap
          << " ns, tolerance=" << comparison.tolerance << " ns" << endl;
     cout << "\t"
          << "#vertices = " << boost::num_vertices(g_mcr) << ", #edges = " << boost::num_edges(g_mcr) << endl;
     cout << "\t"
          << "T_Howard's = " << t_howard << " ns, time is " << time_howard.count() / (1000000. * iter) << " ms" << endl;
     if (!hasNonzeroParams)
          cout << "\t"
               << "T_YTO's (untrusted) = " << t_yto << " ns, time is " << time_yto.count() / (1000000. * iter) << " ms" << endl;
     cout << "\t"
          << "T_LP_MCR = " << t_lp_mcr << " ns, time is " << time_lp_mcr.count() / (1000000. * iter) << " ms" << endl;
     printCriticalCycle(g_mcr, criticalCycle, (tInitial - t_howard) / 2.0);
     printActiveConstraints(constraintSlacks);
     if (!reportFile.empty())
     {
          if (!writeTimingReport(reportFile, g_mcr, criticalCycle,
                                 constraintSlacks))
               return 1;
          cout << "Timing report written to " << reportFile << endl;
     }
     if (!hasNonzeroParams)
     {
          cout << "ELL:" << endl;
          cout << "\t"
               << "#vertices = " << boost::num_vertices(g_ell) << ", #edges = " << boost::num_edges(g_ell) << endl;
          cout << "\t"
               << "T_ELL = " << t_ell << " ns, W_ELL = " << w_ell << " ns, time is " << time_ell.count() / (1000000. * iter) << " ms" << endl;
          cout << "\t"
               << "T_LP_ELL = " << t_lp_ell << " ns, W_LP_ELL = " << w_lp_ell << " ns, time is " << time_lp_ell.count() / (1000000. * iter) << " ms" << endl;
     }
     else
     {
          cout << "YTO and ELL are skipped for fixed-duty non-zero-parameter validation." << endl;
     }
     return 0;
}

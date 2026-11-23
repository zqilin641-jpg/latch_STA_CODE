#pragma once
#include <boost/graph/adjacency_list.hpp>
#include <map>
#include <string>
#include "strOperation.hpp"

using namespace std;
struct NodeIdx
{
    size_t idx;
    string name;
};
struct EdgeDelay
{
    double maxDelay;
    double minDelay;
};

struct LatchTimingParams
{
    // Setup/hold are signed timing requirements, not propagation delays.
    double setup = 0.0;
    double hold = 0.0;
    double clockToQ = 0.0;
    double dataToQ = 0.0;
};

using LatchTimingParamMap = map<string, LatchTimingParams>;

inline const LatchTimingParams &resolveLatchTimingParams(
    const string &nodeName, const LatchTimingParams &defaults,
    const LatchTimingParamMap &overrides)
{
    auto iter = overrides.find(nodeName);
    return iter == overrides.end() ? defaults : iter->second;
}

struct NodeProperties
{
    size_t nodeIndex; /**< node index, range: [0, num_vertices-1] */
    string latchName;
    string timingVariable;
};

/**
 * Definitions for Arc Properties.
 *
 */
struct ArcProperties
{
    int mode;      /*the flag of different constraint edge*/
    double weight; /* weight */
    double delay;  /*max delay of setup edge or min delay of hold edge in ell, transit time in mcr*/
    string constraintType;
};

using Graph = boost::adjacency_list<boost::multisetS, boost::vecS, boost::bidirectionalS, NodeProperties,
                                    ArcProperties>;
using DelayGraph = boost::adjacency_list<boost::vecS, boost::vecS, boost::bidirectionalS, NodeIdx,
                                         EdgeDelay>; // store the delay information (max & min) between two
                                                     // flip-flops
using Vertex = boost::graph_traits<Graph>::vertex_descriptor;
using Edge = boost::graph_traits<Graph>::edge_descriptor;
using InEdgeIterator = boost::graph_traits<Graph>::in_edge_iterator;
using OutEdgeIterator = boost::graph_traits<Graph>::out_edge_iterator;
using VertexIterator = boost::graph_traits<Graph>::vertex_iterator;
using EdgeIterator = boost::graph_traits<Graph>::edge_iterator;
//use graph to imitate tree
using ShortestPathTree = boost::adjacency_list<boost::listS, boost::vecS, boost::bidirectionalS>;
using SPTVertex = boost::graph_traits<ShortestPathTree>::vertex_descriptor;
using SPTEdge = boost::graph_traits<ShortestPathTree>::edge_descriptor;

void generateSimpleGraph(Graph &g);
/**
 * Read blif out file into a delay graph
 *
 * @param fileName
 * @param string
 * @param nodeIdxMap
 * @param g
 * @param tInitial
 *
 * @return
 */
bool getDelayGraph(const string &fileName, DelayGraph &dg, double &tInitial);
/**
 * @brief Get the Delay Graph from rslt file
 * 
 * @param fileName 
 * @param g 
 * @param tInitial 
 * @return true 
 * @return false 
 */
bool getRsltDelayGraph(const string &fileName, DelayGraph &dg, double &tInitial);
/**
 * @brief Generate constraint graph for MCR
 * 
 * @param g 
 * @param tInitial 
 */
void getMcrGraph(const string &fileName, Graph &g, double &tInitial,
                 const LatchTimingParams &params = {},
                 const LatchTimingParamMap &nodeParams = {},
                 double dutyCycle = 0.5);
/**
 * @brief Generate constraint graph for ellipsoid
 * 
 * @param g 
 * @param tInitial 
 */
void getEllGraph(const string &fileName, Graph &g, double &tInitial);

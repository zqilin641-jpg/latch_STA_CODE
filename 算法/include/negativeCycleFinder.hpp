#pragma once

#include <limits>
#include <queue>
#include <list>
#include <vector>
#include "timing_graph.hpp"
using namespace std;

class negCycleFinder
{
public:
    negCycleFinder(Graph &g, size_t n) : _g{g}, _n{n}, _Tp(n), _dist(n, numeric_limits<double>::infinity()), _node_in_cycle(-1), _q(), _inQuene(n, false),_pre(n) {}
    bool hasNegCycle();
    void getNegCycle(list<Edge> &cycle);

private:
    const Graph &_g;
    size_t _n;            //num of nodes
    ShortestPathTree _Tp; //save ShortestPathTree, there are _n nodes in tree, the edges denote the association between useful nodes
    vector<double> _dist; //save distances
    size_t _node_in_cycle;
    queue<size_t> _q;
    vector<bool> _inQuene;
    vector<Edge> _pre; //save the predecessor edge of nodes
    /**
     * @brief Judge whether vextex u is in the tree rooted by v
     * 
     * @param v root node
     * @param u 
     * @return true 
     * @return false 
     */
    bool inSubTree(size_t v, size_t u);
    /**
     * @brief Remove nodes in the subtree rooted by node u from queue 
     * 
     * @param u 
     */
    void removeNodeInQueue(size_t u);
    /**
     * @brief Remove the subtree rooted by node u from ShortestPathTree
     * 
     * @param u 
     */
    void removeSubtree(size_t u);
};
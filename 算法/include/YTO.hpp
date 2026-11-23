#pragma once

#include <vector>
#include <limits>
#include <LEDA/core/p_queue.h>
#include "timing_graph.hpp"

/**
 * @brief minimum cycle ratio solver using YTO's algorithm
 * 
 */
using namespace std;
using PriorityQueue = leda::p_queue<double, Vertex>;
using pq_item = PriorityQueue::item;
class YTO
{
public:
    YTO(Graph &g, size_t n) : _g{g}, _n{n}, _r(0), _Tp(n), _dist(n), _transit(n), _nodeKey(n), _arcKey(n, numeric_limits<double>::infinity()), _pq(), _items(n)
    {
    }
    void run();
    double getRatio();

private:
    const Graph &_g;                  //the given graph
    size_t _n;                  //num of nodes
    double _r;                        //ratio
    ShortestPathTree _Tp;             //save ShortestPathTree, there are _n nodes in tree but the edges denote the association between useful nodes
    vector<double> _dist;             //save distances
    vector<double> _transit;          //save transit
    vector<Edge> _nodeKey;            //save node key (the in_edge with minimum arc key )
    vector<double> _arcKey;           //save arc key calculated by findArKey()
    PriorityQueue _pq;                //PriorityQueue keyed on arc keys
    vector<pq_item> _items;           //The item corresponding to the node in priority queue
    double findArcKey(const Edge &e); //calculate the arc key of e
    /**
     * @brief Judge whether vextex u is in the tree rooted by v
     * 
     * @param v root node
     * @param u 
     * @return true 
     * @return false 
     */
    bool inSubTree(size_t v, size_t u);
};
#pragma once

#include <vector>
#include <limits>
#include <tuple>
#include "timing_graph.hpp"
#include "solver_status.hpp"
/**
 * @brief minimum cycle ratio solver using Howard's algorithm
 * 
 */
using namespace std;
class Howard
{
public:
    Howard(const Graph &g,size_t n, double x, double y, size_t maxIterations = 10000) : _g{g}, _n{n},_r{x}, _eps{y},_minRatioCycle(0),_su(n),_dist(n,numeric_limits<double>::infinity()), _t0{x}, _maxIterations{maxIterations}, _suValid(n, false)
    {
    }
    void run();
    double getRatio();
    vector<Edge> getCycle();
    const HowardResult &getResult() const { return _result; }
private:
    const Graph &_g;           //the given graph
    const size_t _n;//num of nodes
    double _r;                 //ratio
    const double _eps;               //precision
    
    vector<Edge> _minRatioCycle; //save the minimum ratio cycle
    vector<Edge> _su;//save the successor edge of nodes
    vector<double> _dist;
    const double _t0;
    const size_t _maxIterations;
    vector<bool> _suValid;
    HowardResult _result;
    vector<Vertex> _activeVertices;
    vector<Edge> _activeEdges;
    void fail(HowardStatus status);
    void runComponent();
    bool certify();
    tuple<double,Vertex> findRatio();
};

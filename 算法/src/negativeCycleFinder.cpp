#include "negativeCycleFinder.hpp"
#include <iostream>
bool negCycleFinder::inSubTree(size_t v, size_t u)
{
    boost::graph_traits<ShortestPathTree>::in_edge_iterator inei, ineiend;
    if (u == v)
        return true;
    tie(inei, ineiend) = boost::in_edges(u, _Tp);
    while (inei != ineiend)
    {
        SPTVertex v_Spt = boost::source(*inei, _Tp);
        if (v_Spt == v)
            return true;
        tie(inei, ineiend) = boost::in_edges(v_Spt, _Tp);
    }
    return false;
}
void negCycleFinder::removeNodeInQueue(size_t u)
{

    boost::graph_traits<ShortestPathTree>::out_edge_iterator oei, oeiend;
    for (tie(oei, oeiend) = boost::out_edges(u, _Tp); oei != oeiend; ++oei)
    {
        SPTVertex v = boost::target(*oei, _Tp);
        _inQuene[v] = false;
        removeNodeInQueue(v);
    }
}
void negCycleFinder::removeSubtree(size_t u)
{
    queue<size_t> nodes_in_Tpu;
    nodes_in_Tpu.push(u);
    while (!nodes_in_Tpu.empty())
    {
        size_t tmp = nodes_in_Tpu.front();
        nodes_in_Tpu.pop();
        boost::graph_traits<ShortestPathTree>::in_edge_iterator ineispt, ineiendspt;
        tie(ineispt, ineiendspt) = boost::in_edges(tmp, _Tp);
        if (ineispt != ineiendspt)
            boost::remove_edge(boost::source(*ineispt, _Tp), tmp, _Tp);
        boost::graph_traits<ShortestPathTree>::out_edge_iterator oei, oeiend;
        for (tie(oei, oeiend) = boost::out_edges(tmp, _Tp); oei != oeiend; ++oei)
        {
            size_t v = boost::target(*oei, _Tp);
            nodes_in_Tpu.push(v);
        }
    }
}

bool negCycleFinder::hasNegCycle()
{
    while (!_q.empty())
    {
        _q.pop();
    }
    //node s is arbitrary but fixed.(less than _n)
    size_t s = 0;
    _dist[s] = 0;
    _q.push(s);
    _inQuene[s] = true;
    while (!_q.empty())
    {
        size_t u = _q.front();
        _q.pop();
        if (!_inQuene[u])
            continue;
        _inQuene[u] = false;
        Vertex u_node = boost::vertex(u, _g);
        OutEdgeIterator oei, oeiend;
        for (tie(oei, oeiend) = boost::out_edges(u_node, _g); oei != oeiend; ++oei)
        {
            Vertex v_node = boost::target(*oei, _g);
            size_t v = _g[v_node].nodeIndex;
            if (_dist[v] > _dist[u] + _g[*oei].weight)
            {

                if (inSubTree(v, u))
                {
                    _node_in_cycle = v;
                    _pre[v] = *oei;
                    return true;
                }
                _dist[v] = _dist[u] + _g[*oei].weight;
                removeNodeInQueue(v);
                removeSubtree(v);
                _pre[v] = *oei;
                if (!_inQuene[v])
                    _q.push(v);
                _inQuene[v] = true;
                boost::graph_traits<ShortestPathTree>::in_edge_iterator ineispt, ineiendspt;
                tie(ineispt, ineiendspt) = boost::in_edges(v, _Tp);
                if (ineispt != ineiendspt)
                    boost::remove_edge(boost::source(*ineispt, _Tp), v, _Tp);
                boost::add_edge(u, v, _Tp);
            }
        }
    }
    return false;
}
void negCycleFinder::getNegCycle(list<Edge> &cycle)
{
    cycle.clear();
    if (_node_in_cycle < 0)
        return;
    Vertex u = boost::vertex(_node_in_cycle, _g);
    Vertex v = u;
    do
    {
        Edge pe = _pre[u];
        cycle.push_back(pe);
        u = boost::source(pe, _g);
    } while (u != v);
}
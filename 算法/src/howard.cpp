#include <queue>
#include <boost/graph/graph_traits.hpp>
#include <boost/graph/strong_components.hpp>
#include "howard.hpp"

double Howard::getRatio()
{
    return _r;
}
vector<Edge> Howard::getCycle()
{
    return _minRatioCycle;
}
void Howard::fail(HowardStatus status)
{
    _result.status = status;
    _r = _result.ratio = _result.period = numeric_limits<double>::quiet_NaN();
    _minRatioCycle.clear();
}
tuple<double, Vertex> Howard::findRatio()
{
    vector<size_t> visited(_n, size_t(-1));
    double r = numeric_limits<double>::infinity();
    Vertex handle = boost::graph_traits<Graph>::null_vertex();
    for (auto vi = _activeVertices.begin(); vi != _activeVertices.end(); ++vi)
    {   
        size_t start_idx = _g[*vi].nodeIndex;
        if (start_idx >= _n) {
            fail(HowardStatus::InvalidVertexIndex);
            return {_r, handle};
        }
        if (visited[start_idx] != size_t(-1)) continue;
        Vertex u = *vi;
        do
        {   
            if (_g[u].nodeIndex >= _n) {
                fail(HowardStatus::InvalidVertexIndex);
                return {_r, handle};
            }
            visited[_g[u].nodeIndex] = _g[*vi].nodeIndex;
            Edge e = _su[_g[u].nodeIndex];
            if (!_suValid[_g[u].nodeIndex]) {
                fail(HowardStatus::InvalidPolicy);
                return {_r, handle};
            }
            u = boost::target(e, _g);
        } while (visited[_g[u].nodeIndex] == size_t(-1));
        if (visited[_g[u].nodeIndex] != _g[*vi].nodeIndex)
            continue;
        Vertex x = u;
        double sum = 0, len = 0;
        do
        {
            Edge e = _su[_g[x].nodeIndex];
            sum += _g[e].weight;
            len += _g[e].delay;
            x = boost::target(e, _g);
        } while (x != u);
        if (!std::isfinite(sum) || !std::isfinite(len)) {
            fail(HowardStatus::NumericalError);
            return {_r, handle};
        }
        // The legacy iteration does not certify zero/negative-transit cycles.
        // Report this limitation instead of dividing by zero or claiming infeasibility.
        if (len <= _eps) {
            fail(HowardStatus::UnsupportedCycle);
            return {_r, handle};
        }
        const double ratio = sum / len;
        if (!std::isfinite(ratio)) {
            fail(HowardStatus::NumericalError);
            return {_r, handle};
        }
        if (r > ratio || (handle == boost::graph_traits<Graph>::null_vertex() && r == ratio))
        {
            r = ratio;
            handle = u;
        }
    }
    return {r,handle};
}
void Howard::runComponent()
{
    _result = HowardResult{};
    _r = _t0;
    _minRatioCycle.clear();
    if (_n != boost::num_vertices(_g)) {
        fail(HowardStatus::InvalidVertexIndex);
        return;
    }
    if (!std::isfinite(_t0) || !std::isfinite(_eps) || _eps <= 0.0) {
        fail(HowardStatus::NumericalError);
        return;
    }
    if (_n == 0 || boost::num_edges(_g) == 0) {
        fail(HowardStatus::NoCycle);
        return;
    }
    vector<bool> indices(_n, false);
    VertexIterator vi, vend;
    for (tie(vi, vend) = boost::vertices(_g); vi != vend; ++vi) {
        const size_t index = _g[*vi].nodeIndex;
        if (index >= _n || indices[index]) {
            fail(HowardStatus::InvalidVertexIndex);
            return;
        }
        indices[index] = true;
    }
    _su.assign(_n, boost::graph_traits<Graph>::edge_descriptor());
    _suValid.assign(_n, false);
    _dist.assign(_n, std::numeric_limits<double>::infinity());
    for (auto ei = _activeEdges.begin(); ei != _activeEdges.end(); ++ei)
    {
        if (!std::isfinite(_g[*ei].weight) || !std::isfinite(_g[*ei].delay) ||
            !std::isfinite(_g[*ei].weight - _r * _g[*ei].delay)) {
            fail(HowardStatus::NumericalError);
            return;
        }
        size_t i = _g[source(*ei, _g)].nodeIndex;
        if (_g[*ei].weight - _r * _g[*ei].delay < _dist[i])
        {
            _dist[i] = _g[*ei].weight - _r * _g[*ei].delay;
            _su[i] = *ei;
            _suValid[i] = true;
        }
    }
    for (Vertex v : _activeVertices) {
        if (!_suValid[_g[v].nodeIndex]) {
            fail(HowardStatus::InvalidPolicy);
            return;
        }
    }
    bool changed = true;
    Vertex handle;
    while (changed)
    {
        if (_result.iterations >= _maxIterations) {
            fail(HowardStatus::IterationLimit);
            return;
        }
        ++_result.iterations;
        tie(_r, handle) = findRatio();
        if (_result.status != HowardStatus::NotRun)
            return;
        if (handle != boost::graph_traits<Graph>::null_vertex())
        {
            queue<Vertex> que;
            InEdgeIterator inei, ineiend;
            vector<bool> visited(_n, false);
            // Keep the anchor's current offset so policy improvements remain monotone.
            visited[_g[handle].nodeIndex] = true;
            que.push(handle);
            while (!que.empty())
            {
                Vertex u = que.front();
                que.pop();
                size_t i = _g[u].nodeIndex;
                visited[i] = true;
                Edge e = _su[i];
                Vertex v = boost::target(e, _g);
                if (u != handle)
                    _dist[i] = _dist[_g[v].nodeIndex] + _g[e].weight - _r * _g[e].delay;
                if (!std::isfinite(_dist[i])) {
                    fail(HowardStatus::NumericalError);
                    return;
                }
                for (tie(inei, ineiend) = boost::in_edges(u, _g); inei != ineiend; ++inei)
                {
                    Vertex source = boost::source(*inei, _g);
                    if (!visited[_g[source].nodeIndex] && _suValid[_g[source].nodeIndex] && _su[_g[source].nodeIndex] == *inei) {
                        visited[_g[source].nodeIndex] = true;
                        que.push(source);
                    }
                }
            }
            if (_minRatioCycle.size() != 0)
                _minRatioCycle.clear();
            Vertex u = handle;
            do
            {
                Edge e = _su[_g[u].nodeIndex];
                _minRatioCycle.push_back(e);
                u = boost::target(e, _g);
            } while (u != handle);
        }
        changed = false;
        for (auto ei = _activeEdges.begin(); ei != _activeEdges.end(); ++ei)
        {
            size_t i = _g[boost::source(*ei, _g)].nodeIndex,
                   j = _g[boost::target(*ei, _g)].nodeIndex;
            const double candidate = _dist[j] + _g[*ei].weight - _g[*ei].delay * _r;
            if (!std::isfinite(candidate)) {
                fail(HowardStatus::NumericalError);
                return;
            }
            if (_dist[i] > candidate + _eps)
            {
                _dist[i] = candidate;
                _su[i] = *ei;
                changed = true;
            }
        }
    }
    const double period = _t0 - 2.0 * _r;
    if (_minRatioCycle.empty()) {
        fail(HowardStatus::InvalidPolicy);
        return;
    }
    if (!std::isfinite(period)) {
        fail(HowardStatus::NumericalError);
        return;
    }
    _result.status = HowardStatus::Converged;
    _result.ratio = _r;
    _result.period = period;
}

void Howard::run()
{
    _result = HowardResult{};
    _minRatioCycle.clear();
    if (_n != boost::num_vertices(_g)) {
        fail(HowardStatus::InvalidVertexIndex);
        return;
    }
    if (!std::isfinite(_t0) || !std::isfinite(_eps) || _eps <= 0.0) {
        fail(HowardStatus::NumericalError);
        return;
    }
    vector<bool> indices(_n, false);
    for (auto v : boost::make_iterator_range(boost::vertices(_g))) {
        if (_g[v].nodeIndex >= _n || indices[_g[v].nodeIndex]) {
            fail(HowardStatus::InvalidVertexIndex);
            return;
        }
        indices[_g[v].nodeIndex] = true;
    }
    for (auto e : boost::make_iterator_range(boost::edges(_g))) {
        if (!std::isfinite(_g[e].weight) || !std::isfinite(_g[e].delay)) {
            fail(HowardStatus::NumericalError);
            return;
        }
    }
    if (_n == 0) {
        fail(HowardStatus::NoCycle);
        return;
    }
    vector<int> component(_n);
    const int count = boost::strong_components(_g, boost::make_iterator_property_map(
        component.begin(), boost::get(boost::vertex_index, _g)));
    vector<vector<Vertex>> vertices(count);
    vector<vector<Edge>> edges(count);
    for (auto v : boost::make_iterator_range(boost::vertices(_g)))
        vertices[component[v]].push_back(v);
    for (auto e : boost::make_iterator_range(boost::edges(_g))) {
        const int c = component[boost::source(e, _g)];
        if (c == component[boost::target(e, _g)]) edges[c].push_back(e);
    }
    double best = numeric_limits<double>::infinity();
    vector<Edge> cycle;
    size_t iterations = 0, cyclic = 0;
    for (int c = 0; c < count; ++c) {
        if (edges[c].empty()) continue;
        ++cyclic;
        _activeVertices = std::move(vertices[c]);
        _activeEdges = std::move(edges[c]);
        runComponent();
        iterations += _result.iterations;
        _result.iterations = iterations;
        _result.cyclicComponents = cyclic;
        if (_result.status != HowardStatus::Converged) return;
        if (_r < best) {
            best = _r;
            cycle = _minRatioCycle;
        }
    }
    if (cycle.empty()) {
        fail(HowardStatus::NoCycle);
        return;
    }
    _r = best;
    _minRatioCycle = std::move(cycle);
    _result.ratio = best;
    _result.period = _t0 - 2.0 * best;
    if (!std::isfinite(_result.period) || _result.period < 0.0) {
        fail(HowardStatus::NumericalError);
        return;
    }
    if (certify()) _result.status = HowardStatus::Converged;
}

bool Howard::certify()
{
    long double weight = 0.0L, transit = 0.0L;
    for (size_t i = 0; i < _minRatioCycle.size(); ++i) {
        const Edge e = _minRatioCycle[i];
        const Edge next = _minRatioCycle[(i + 1) % _minRatioCycle.size()];
        if (boost::target(e, _g) != boost::source(next, _g)) {
            fail(HowardStatus::InvalidPolicy);
            return false;
        }
        weight += _g[e].weight;
        transit += _g[e].delay;
    }
    _result.cycleResidual = static_cast<double>(std::fabs(weight / transit - _r));
    if (transit <= _eps || !std::isfinite(_result.cycleResidual) ||
        _result.cycleResidual > _eps) {
        fail(HowardStatus::NumericalError);
        return false;
    }
    // Virtual zero source: certify every edge, including bridges and acyclic nodes.
    // These potentials are graph certificates, not physical clock skew values.
    vector<long double> potential(_n, 0.0L);
    for (size_t pass = 0; pass < _n; ++pass) {
        bool changed = false;
        for (auto e : boost::make_iterator_range(boost::edges(_g))) {
            const Vertex u = boost::source(e, _g), v = boost::target(e, _g);
            const long double candidate = potential[v] + _g[e].weight -
                static_cast<long double>(_r) * _g[e].delay;
            if (!std::isfinite(candidate)) {
                fail(HowardStatus::NumericalError);
                return false;
            }
            if (potential[u] > candidate + _eps) {
                potential[u] = candidate;
                changed = true;
            }
        }
        if (!changed) break;
    }
    long double violation = 0.0L;
    for (auto e : boost::make_iterator_range(boost::edges(_g))) {
        const auto u = boost::source(e, _g), v = boost::target(e, _g);
        violation = std::max(violation, potential[u] - potential[v] -
            _g[e].weight + static_cast<long double>(_r) * _g[e].delay);
    }
    _result.maxViolation = static_cast<double>(violation);
    if (!std::isfinite(_result.maxViolation) || _result.maxViolation > _eps) {
        fail(HowardStatus::ConstraintViolation);
        return false;
    }
    return true;
}

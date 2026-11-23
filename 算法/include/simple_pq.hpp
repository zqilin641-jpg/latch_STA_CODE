// ============================================================
// simple_pq.hpp — 替代 LEDA p_queue
// 基于 std::set，稳定的 ascending tie-breaking
// ============================================================

#pragma once

#include <set>
#include <limits>

template <typename P, typename I>
class simple_pq {
    struct Node {
        P priority;
        mutable I info;
        bool operator<(const Node& o) const {
            if (priority != o.priority) return priority < o.priority;
            return info < o.info;
        }
    };
    std::set<Node> _data;

public:
    using pq_item = typename std::set<Node>::iterator;
    using item = pq_item;
    simple_pq() = default;

    pq_item insert(const P& prio, const I& inf) {
        return _data.insert({prio, inf}).first;
    }
    pq_item find_min() {
        return _data.empty() ? _data.end() : _data.begin();
    }
    const P& prio(pq_item it) const { return it->priority; }
    const I& inf(pq_item it) const { return it->info; }
    void del_item(pq_item it) { _data.erase(it); }
    void decrease_p(pq_item& it, const P& new_prio) {
        Node node = *it;
        _data.erase(it);
        node.priority = new_prio;
        it = _data.insert(node).first;
    }
    int size() const { return static_cast<int>(_data.size()); }
    void clear() { _data.clear(); }
};

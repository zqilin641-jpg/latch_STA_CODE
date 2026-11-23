#pragma once

#include <tuple>
#include <xtensor-blas/xlinalg.hpp>
#include <iostream>
#include "timing_graph.hpp"
#include "negativeCycleFinder.hpp"

/**
 * @brief To solve timing constraints:
 *        min T+aW
 *        s.t
 * 1
 * @tparam Graph
 */
extern double a;
template <typename Graph>
class timing_oracle
{
  using Arr = xt::xarray<double, xt::layout_type::row_major>;
  using Cut = std::tuple<Arr, double>;
	using Edge=typename boost::graph_traits<Graph>::edge_descriptor;

private:
  Graph &_G;
  // timing parameter
  constexpr static double Tsu = 0;
  constexpr static double Tdq = 0;
  constexpr static double Tcq = 0;
  constexpr static double Th = 0;

public:
  /**
     * @brief Construct a new timing oracle object
     *
     * @param G timing constraints graph
     */
  timing_oracle(Graph &G)
      : _G{G}
  {
  }

  auto getGraph(){
    return _G;
  }
  /**
     * @brief Make object callable for cutting_plane_dc()
     *
     * @param z[0]-T ,Z[1]-W
     * @param t the best-so-far optimal value
     * @return std::tuple<Cut, double>
     */

  auto operator()(const Arr &z, double t) -> std::tuple<Cut, double>
  {
    auto T = z[0];
    auto W = z[1];

    // -T<=0 && -W+Tcq+Tsu-Tdq <=0 && W<=T/2
    auto f0 = -T;
    if (f0 > 0.)
    {
      return {{Arr{-1., 0.}, f0}, t};
    }
    auto f1 = Tcq + Tsu - Tdq - W;
    if (f1 > 0.)
    {
      return {{Arr{0., -1.}, f1}, t};
    }
    auto f2 = W - T / 2;
    if (f2 > 0.)
    {
      return {{Arr{-0.5, 1.}, f2}, t};
    }

    negCycleFinder N(_G,boost::num_vertices(_G)) ;
    if (N.hasNegCycle())
    {
      list<Edge> cycle;
      N.getNegCycle(cycle);
      double grad_T = 0.;
      double grad_W = 0.;
      double total_w = 0.;
      for (auto &e : cycle)
      {
        total_w += _G[e].weight;
        if (_G[e].mode==0)
        {
          grad_T -= 1.0;
        }
        else if(_G[e].mode==1){
          grad_T -= 1.0;
          grad_W -= 1.0;
        }
        else
        {
          grad_W += 1.0;
        }
      }
      return {{Arr{grad_T, grad_W}, total_w}, t};
    }

    //satisfy constraints
    auto s = T + a * W;
    auto f = s - t;
    if (f < 0.)
    { //value is lower the best-so-far t,update t
      t = s;
      f = 0.;
    }
    return {{Arr{1., a}, f}, t};
  }
  /**
     * @brief update weight for each iteration in ellcpp
     *
     */
  void update_w(const Arr &z)
  {
    auto T = z[0];
    auto W = z[1];
    typename boost::graph_traits<Graph>::edge_iterator eiG, eiendG;	
    for (tie(eiG,eiendG) = boost::edges(this->_G); eiG != eiendG; ++eiG)
    {
      if (this->_G[*eiG].mode == 0)
      {
        this->_G[*eiG].weight = T - Tdq - this->_G[*eiG].delay;
       //std::cout << boost::source(*eiG, _G) << " -> " << boost::target(*eiG, _G)<<" S-"<<this->_G[*eiG].weight<<std::endl;

      }
      else if(this->_G[*eiG].mode == 1){
        this->_G[*eiG].weight = T +W- Tsu - this->_G[*eiG].delay;
      }
      else
      {
        this->_G[*eiG].weight = this->_G[*eiG].delay - W - Th + Tcq;
       // std::cout << boost::source(*eiG, _G) << " -> " << boost::target(*eiG, _G)<<" H-"<<this->_G[*eiG].weight<<std::endl;
      }
    }
  }
};


/**
 * @file build_map.cpp
 * @brief 为所有的函数建立一张映射表
 * @details
 * @author zli
 * @email lizhen19@fudan.edu.cn
 * @version 1.0
 * @date 2020-12-07
*/


#include "build_map.h"
#include "SLICE.h"

using std::string;
using std::map;
using std::function;

map<string, function<void(const string&)>> build_map()
{
    static map<string, function<void(const string&)>> functions;

    functions["G1_LS2INV_Q_LCNAND2_YB_B2W22_0"] = G1_LS2INV_Q_LCNAND2_YB_B2W22_0;


    return functions;

}
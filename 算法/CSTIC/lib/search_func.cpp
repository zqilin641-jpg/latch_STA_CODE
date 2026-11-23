/**
 * @file search_func.cpp
 * @brief 找到对应的函数并执行
 * @details
 * @author zli
 * @email lizhen19@fudan.edu.cn
 * @version 1.0
 * @date 2020-12-07
*/

#include "search_func.h"
#include "build_map.h"
#include <functional>
#include <map>
#include <stdexcept>

using std::string;
using std::map;
using std::function;
using std::domain_error;


void search_func(const string& s)
{
    static map<string, function<void(const string&)>> functions = build_map();


    if (functions.find(s) != functions.end()) {
        functions[s](s);
    } else {
        throw domain_error("未匹配的函数名");
    }

}
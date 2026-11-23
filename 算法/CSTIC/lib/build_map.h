/**
 * @file build_map.h
 * @brief 为所有的函数建立一张映射表
 * @details
 * @author zli
 * @email lizhen19@fudan.edu.cn
 * @version 1.0
 * @date 2020-12-07
*/

#ifndef GUARD_build_map
#define GUARD_build_map

#include <map>
#include <functional>
#include <string>

std::map<std::string, std::function<void(const std::string&)>> build_map();

#endif
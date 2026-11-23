/**
 * @file hspice.cpp
 * @brief 调用hspice
 * @details
 * @author zli
 * @email lizhen19@fudan.edu.cn
 * @version 1.0
 * @date 2020-12-07
*/

#include "hspice.h"
#include <cstdlib>
#include <fstream>

using std::string;
using std::ofstream;

void hspice(const string& s)
{
    string command = "hspice " + s + "/" + s + ".sp";
    system(command.c_str());


    ///< TODO 解析结果
    

}
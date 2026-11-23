/**
 * @file file.cpp
 * @brief 生成文件夹并在文件夹中生成对应.sp文件
 * @details
 * @author zli
 * @email lizhen19@fudan.edu.cn
 * @version 1.0
 * @date 2020-12-06
*/

#include "file.h"
#include <cstdlib>
#include <fstream>

using std::string;
using std::ofstream;

void file(const string& s)
{
    string command = "mkdir " + s;
    system(command.c_str());
    string sp = s + "/" + s + ".sp";
    ofstream outfile(sp.c_str());
}
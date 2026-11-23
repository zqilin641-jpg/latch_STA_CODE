/**
 * @mainpage fdp3p7的建库代码
 * @section 代码说明
 * 代码分为三个部分，读入.txt文件中的信息，然后生成对应的spice网表并仿真，最后提取相关延迟。
*/



/**
 * @file main.cpp
 * @brief 主函数
 * @details 程序唯一入口，顺序仿真spice网表
 * @param
 * @param
 * @return 程序执行成功与否
 *     @retval 0 程序执行成功
 *     @retval
 * @note
 * @author zli
 * @email lizhen19@fudan.edu.cn
 * @version 1.0
 * @date 2020-12-07
*/
#include "split.h"
#include "file.h"
#include "hspice.h"
#include "search_func.h"
#include "SLICE.h"

#include <fstream>

using std::string;
using std::vector;
using std::ifstream;

int main()
{
    ifstream infile("SLICE_path.txt");
    string s;
    vector<string> SLICE_path;

    while(getline(infile, s))
    {
        vector<string> v = split(s);
        SLICE_path.insert(SLICE_path.end(), v.begin(), v.end());
    }

    for (vector<string>::const_iterator iter = SLICE_path.begin(); iter != SLICE_path.end(); ++iter) {
        file(s);
        search_func(s);
    }

    return 0;

}
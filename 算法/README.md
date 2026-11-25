# Latch 时序算法使用说明

## 目录与入口

| 位置 | 用途 |
|---|---|
| src/main.cpp | 命令行入口。解析输入，运行 Howard，并用 mcrLP 核对最小周期。默认参数下还会运行 ELL 对照。 |
| src/timing_graph.cpp、src/howard.cpp | 读取电路延时，建立时序约束图，求解限制周期的关键环。 |
| src/LP.cpp | mcrLP 用 GLPK 求 MCR 模型；ellLP 对另一套含节点偏移的约束进行线性规划。 |
| include/ | 与源码配套的头文件和接口声明。 |
| benchmark/、tests/ | 基准电路延时输入与自动化验证。首次运行可用 benchmark/s27.blif.out。 |
| cmake/、CMakeLists.txt、libleda.so | 构建模块、编译入口和本工程使用的 Linux 动态库。CMake 还引用同仓库的阶段二_PDS时钟调度/tools/pds_howard.cpp。 |
| CSTIC/ | 独立的器件延时建库工程，涉及 SPICE 网表生成、仿真与延时提取。 |
| 历史构建与验证/、latch-STA/ | 旧构建及验证记录、历史嵌套 Git 目录。 |

## 在 VS Code 中编译和运行

1. 在 Windows 版 VS Code 点击 **文件 → 打开文件夹**，选中本 README 所在的 **算法** 文件夹。
2. 点击 **终端 → 运行生成任务**，或按 **Ctrl+Shift+B**。默认任务 **编译并运行 main** 会通过 WSL Ubuntu 编译整个工程并执行。
3. 在底部终端找到 `Input file is ...` 确认电路名，再看 `T_Howard's` 和 `T_LP_MCR` 两行的周期。

### 更换电路

在 `src/main.cpp` 的 `main()` 开头搜索 `defaultCircuit`。例如，要切换到 s1196，只启用对应的一行：

```cpp
// const char *defaultCircuit = "benchmark/s27.blif.out";
const char *defaultCircuit = "benchmark/s1196.blif.out";
```

按 **Ctrl+S** 保存，再按 **Ctrl+Shift+B**。终端应显示 `Input file is benchmark/s1196.blif.out`。手动传入文件名时，以命令行参数为准。

### 用断点调试

在可执行语句的行号左边单击设置断点。打开左侧 **运行和调试**，在顶部下拉框选 **调试 main**，点击绿色三角形或按 **F5**。如果弹出“选择调试器”，本工程对应 **C++ (GDB/LLDB)**。如果下一步提示选择“调试活动文件”，按 Esc 返回，使用工程已有的 **调试 main** 配置。

本机已验证 WSL 编译、样例运行及 GDB 在 main 断点停下。VS Code 图形界面的 F5 启动仍待确认；当前编辑器仍报告“无法打开源文件”，头文件诊断留待后续排查。

### 手动运行

如需手动调整参数，可在 PowerShell 中先输入：

~~~powershell
wsl -d Ubuntu
~~~

进入 Ubuntu 终端后执行以下命令。源码放在 E 盘，生成文件写入 Ubuntu 用户目录，便于重复构建。

~~~bash
cd '/mnt/e/大四上/曦源项目/现LatchSTA_Code/latch-STA/算法'
build_dir="$HOME/latchsta-build"
cmake -S . -B "$build_dir"
cmake --build "$build_dir" --target main -j4
"$build_dir/main" benchmark/s27.blif.out 1 100
~~~

最后一行的三个参数分别是电路延时文件、重复运行次数、椭球法初始半径。修改源码后，重新执行编译和运行两行即可。在单独打开的 Ubuntu 终端里也可使用同样的命令。

## 怎样读结果

先对照 Howard 和 T_LP_MCR。两者求同一个 MCR 模型的最小周期，程序会检查求解状态和数值误差。默认样例还会列出 ELL 相关结果。T_LP_ELL 和 W_LP_ELL 来自独立的 ellLP 模型；该函数内部有每个节点的偏移变量，当前命令行只报告这组模型结果中的 T 和 W。输出时间单位见各行标签。

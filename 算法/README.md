# FPGA Latch-based Timing Analysis Tool

本项目是一款针对 FPGA 设计的时序分析与优化工具。主要功能是通过解析基于寄存器（Register-based）的时序报告，建立锁存器（Latch）时序模型。利用锁存器特有的时序借用（Time Borrowing）特性，并结合椭球法（Ellipsoid Method）优化算法，计算设计在引入锁存器后能够达到的最高运行频率。

---


---

## 一、 编译指南

请在项目根目录下执行以下命令进行构建：

```bash
# 1. 创建并进入构建目录
mkdir -p build && cd build

# 2. 运行 CMake 配置
cmake ..

# 3. 编译（使用 8 线程并行）
make -j8

## 二、 使用说明

程序编译完成后生成 `main` 可执行文件，运行格式如下：

```bash
./main <input_file> <iterations> <ellipsoid_radius>

参数说明：
input_file: 输入的网表或时序报告文件路径（如 ../benchmark/s27.blif.out）。
iterations: 算法优化迭代次数（如 1 或 100）。
ellipsoid_radius: 椭球法搜索的初始半径（如 100）。

运行示例：
./main ../benchmark/s27.blif.out 1 100


##三、 目录结构说明
src/: 项目核心源代码目录 (.cpp)。
include/: 项目头文件目录 (.h)。
benchmark/: 存放标准测试数据集。
benchmark_rslt/: 存放参考测试结果数据。
CSTIC/:专门用于对基于寄存器的时序报告进行解析，重点分析在锁存器依赖环境下FPGA 设计能够达到的时序提升空间。
cmake/: 包含 CMake 构建系统的相关配置文件。

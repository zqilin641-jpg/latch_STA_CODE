# 实验一　比较触发器与锁存器的时序

本实验用两个独立的 PDS 工程，在 PGL50H-6/FBG484 上实现相同的八位运算，观察存储单元改变后，数据在哪个时刻被接收、经过几级、何时到达输出。阶段一的完整报告见[实验阶段一](../实验阶段一.docx)。

| 对照项 | FF 工程 | Latch 工程 |
| --- | --- | --- |
| 算术核心 | 两级，共 16 个 FF | 两级，共 16 个高电平透明 Latch |
| 输入与输出边界 | 输入、输出各 8 个 FF | 输入、输出各 8 个 FF |
| 采入输入后，输出对应结果的时间 | 第 3 个参考时钟周期 | 第 1 个参考时钟周期 |

两组都先将输入加上 `0x39` 并保留低八位，再循环左移三位，最后与 `0xA7` 异或。仿真按输入事务核对输出，以适应表中的延迟差异。

## 怎样读时序报告

在 PDS 的 **File → Open Project** 中打开 `build/ff/ff_timing_top.pds` 或 `build/latch/latch_timing_top.pds`。参考时钟周期为 640 ns。Latch 工程的一级在 40～200 ns 透明，二级在 320～480 ns 透明。FDC 将两相定义为相关的外部时钟。输入输出最大、最小延时分别设为 2 ns 和 0.2 ns，用户时钟不确定度为 0.2 ns。

在 **Report Timing → Slow Corner → Worst Case Timing Path → Setup** 中，按起点和终点辨认“输入 FF → 第一级”“第一级 → 第二级”“第二级 → 输出 FF”。`build/comparison/core_paths.csv` 给出两组提取的路径，原始 `.rtr` 位于各工程的 `report_timing` 目录。部分加法器和 FF 被映射进同一个宏，报告的终点可能显示为宏的输入引脚。

## 怎样运行

从本实验目录打开 PowerShell。归档脚本按相对路径引用 `../single_latch/rtl/datapath_compare.v`；当前阶段目录缺少这个同级工程。原工作区保留了该依赖，可从 `E:\pds\lacth\latch_validation\ff_and_latch` 运行以下命令。

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_sim.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\run_build.ps1 -Variant all
powershell -ExecutionPolicy Bypass -File .\scripts\run_sim.ps1 -PostRoute
```

三条命令依次执行 RTL 仿真、两个工程的布局布线与时序报告导出、布线后网表功能仿真。仿真命令可加 `-Gui` 查看波形。后者未回标 SDF 延时。

## 已有结果

2026-10-14 的实验记录中，两种仿真均通过 777 项检查，错误数为 0。共导出 216 条选定路径，涵盖三级路径的建立和保持检查及快慢工艺角。基准条件下，所选路径实际借用时间最大为 **0 ns**。这一组建立了功能与时序对照；两种实现的最高频率仍需单独扫周期验证。观察实际发生借时的例子，可继续读[时间借用实验](../time_borrow/README.md)。

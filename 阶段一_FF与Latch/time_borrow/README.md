# 实验二　验证锁存器的时间借用

本实验沿用[FF 与 Latch 对照实验](../ff_and_latch/README.md)的两级 Latch 核心。它回答两个问题：数据在第一级开门之后到达时，还能否通过？如果可以，第二级还剩多少时间？阶段一的完整报告见[实验阶段一](../实验阶段一.docx)。

## 三组对照与结果

参考时钟周期均为 640 ns，第二级的 B 相透明窗口均为 320～480 ns。三组分别修改第一级的 A 相窗口并独立布局布线。下表来自 2026-10-19 的 PDS 检查记录。

| 工程 | A 相透明窗口（ns） | 慢角最大实际借时（ns） | 第一级慢角最差 setup slack（ns） | 第一级 setup 违例端点数（慢角 / 快角） |
| --- | --- | ---: | ---: | --- |
| baseline | 40～200 | 0.000 | 34.370 | 0 / 0 |
| borrow | 2～162 | 3.514 | 0.000 | 0 / 0 |
| overflow | 2～3 | 1.020 | −2.465 | 8 / 6 |

**borrow** 把开门时刻提前，同时保留 160 ns 的透明窗口。第一级借到时间后满足建立要求，下一级的起算时刻也随之推迟。**overflow** 把窗口缩到 1 ns，即使计入允许的借时，最差路径仍晚到 2.465 ns。三组共检查了 288 条选定的路径记录；这些数据用于验证借时机制，未测量板上最高频率。

## 在报告中找到借时

在 PDS 打开 `build/borrow/latch_timing_top.pds`，选择 **Report Timing → Slow Corner → Worst Case Timing Path → Setup**。也可以直接搜索原始文本 `build/borrow/report_timing/latch_timing_top.rtr`。

1. 选终点为第一级 Latch 的路径，在 **Data required time** 明细中找 `time borrowed from endpoint`。例如，借时前允许到达时刻为 4.025 ns，实际到达时刻为 6.624 ns，借入 2.599 ns 后，报告的 slack 恰为 0。
2. 再选从同一个 Latch 的 `/D` 出发、到第二级的路径，在 **Data arrival time** 明细中找 `time given to startpoint`。该项推迟下一段路径的起算时刻。报告在两侧分别计入时钟延时与不确定度，两个字段应按各自的路径明细读取。
3. 三组汇总见 `build/comparison/summary.csv`，逐条数据见 `build/comparison/paths.csv`。借时组中，下一级最大的起点时间调整为 3.264 ns。

## 怎样复现

脚本依赖同级的 `ff_and_latch` 和 `single_latch` 工程。归档目录缺少同级的 `single_latch`，可从原工作区 `E:\pds\lacth\latch_validation\time_borrow` 打开 PowerShell，依次执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_build.ps1 -Case all
powershell -ExecutionPolicy Bypass -File .\scripts\check_reports.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\run_concept_sim.ps1
```

第一条运行三组布局布线，第二条检查全部三份报告，包括预期的 overflow 违例。第三条单独运行 RTL 示意仿真，加 `-Gui` 可看波形：在 A 相 40～200 ns 的共同窗口下，输入于 20 ns 改变会等到开门，于 60 ns 改变可在透明期通过，于 220 ns 改变则要等下一周期。历史记录中的 22 项仿真检查全部符合预期。这三个激励时刻用于解释行为，物理路径延时请读 PDS 报告。

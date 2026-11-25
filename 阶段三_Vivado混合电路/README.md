# 阶段三　Vivado 单时钟混合电路

[进入五组实验](experiments/README.md)。目标是在保留输出拍次和吞吐率的条件下，比较纯 FF 与部分引入 Latch 后的布线时序。

| 要回答的问题 | 直接查看 |
| --- | --- |
| 一个时钟下，哪条路径实际借了时间？ | [25 节点公共时钟对照](experiments/01_公共时钟与借时/README.md) |
| 怎样根据关键路径选择替换位置，输出拍次如何对齐？ | [候选选择与重定时](experiments/02_关键路径选择与重定时/README.md) |
| 哪一次提频由 Howard 和 Vivado 同时核验？ | [公共 MMCM 的配对回验](experiments/03_公共MMCM与Howard提频/mmcm_howard/REPORT.md) |
| 加强纯 FF 基准以后，混合版还能赢吗？ | [同边界成对结果](experiments/04_纯FF与混合方案的公平对照/paired_search/REPORT.md) |
| 只替换 16 个 FF 的真实电路在哪里？ | [直接替换的 Verilog](experiments/05_直接替换与门级时序仿真/pulse_cycle/mixed/design.v) 和 [布线后数据核对](experiments/05_直接替换与门级时序仿真/pulse_cycle/MODELSIM_RESULT_20261117.md) |

归档与复现说明见[实验导航](experiments/README.md)。[关键文件新旧路径](work/实验关键文件路径.csv)用于按旧名称找新位置。[原目录压缩包](archive/experiments_整理前.zip)保存整理前的完整相对路径和文件。

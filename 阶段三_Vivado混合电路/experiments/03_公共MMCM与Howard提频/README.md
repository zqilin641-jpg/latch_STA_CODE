# 公共MMCM与Howard提频

在同一公共时钟架构下调整运算边界，并把 Howard 的预测周期送回 Vivado 核验。配对的纯 FF、混合实现分别在 9.213 ns、8.583 ns 通过。在这个对照中，混合实现保持输出拍次，且通过周期更短。

| 子实验 | 用途 | 先看 |
| --- | --- | --- |
| [frequency_search](frequency_search/) | 在给定接口约束下筛选短周期的 FF 和混合候选。 | [REPORT.md](frequency_search/REPORT.md) |
| [common_mmcm](common_mmcm/) | 改用一个公共 MMCM，重新建立两版时钟条件一致的基准。 | [REPORT.md](common_mmcm/REPORT.md) |
| [mmcm_retime](mmcm_retime/) | 移动内部 Latch 边界，比较 Latch5 和 Latch6，同时维持输出拍次。 | [REPORT.md](mmcm_retime/REPORT.md) |
| [mmcm_howard](mmcm_howard/) | 对公共 MMCM 方案建图，用 Howard 和 LP 预测周期，再以 Vivado 检查边界两侧；solve 内保留输入图、求解结果与原始通过/失败报告。 | [REPORT.md](mmcm_howard/REPORT.md) |

工程内的 design.v、timing.xdc 和 routed.dcp 分别用于看逻辑、核对约束和打开已布线设计。各轮可用的文件随实验而异。

本组保留的源码或结果入口：[solve_mmcm_local.py](solve_mmcm_local.py)。批量脚本重跑方法见上级说明。

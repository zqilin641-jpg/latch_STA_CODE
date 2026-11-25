# 关键路径选择与重定时

固定功能和输出拍次，比较移动存储边界、添加补偿 FF、选择性换用 Latch 的影响。这里开始借鉴 Pairl 的候选选择方法。

| 子实验 | 用途 | 先看 |
| --- | --- | --- |
| [retiming_benchmark](retiming_benchmark/) | 以原 FF、重定时 FF、对齐输出的混合设计建立三方对照。 | [REPORT.md](retiming_benchmark/REPORT.md) |
| [controlled_search](controlled_search/) | 固定 I/O 引脚，搜索不同切分位置，比较每个候选的功能和时序。 | [REPORT.md](controlled_search/REPORT.md) |
| [output_control](output_control/) | 将输出寄存器约束到 IOB，检查接口条件对关键路径的影响。 | [native_verification.json](output_control/native_verification.json) |
| [pairl_iteration](pairl_iteration/) | 从布线后 STA 的关键路径选取边界，生成重定时 FF 与 Latch 候选并复验。 | [REPORT.md](pairl_iteration/REPORT.md) |

工程内的 design.v、timing.xdc 和 routed.dcp 分别用于看逻辑、核对约束和打开已布线设计。各轮可用的文件随实验而异。

本组保留的源码或结果入口：[pairl_sta_candidates.py](pairl_sta_candidates.py)、[build_retiming_benchmark.py](build_retiming_benchmark.py)。批量脚本重跑方法见上级说明。

# 公共时钟与借时

先验证在一条 BUFG 时钟网上部分替换 FF 后，Latch 能否借时。初始 25 个存储位中替换了 5 个，混合版的事务延迟从 5 拍变为 4 拍。20 ns 下出现借时，约 12.121 ns 下两版都受到输出接口限制。

| 子实验 | 用途 | 先看 |
| --- | --- | --- |
| [ff](ff/) | 25 个 FF 的直接对照。 | [setup_T20.rpt](ff/setup_T20.rpt) |
| [mixed_stage1](mixed_stage1/) | 替换内部第一级；setup_T20.rpt 给出 1.724 ns 借时。 | [setup_T20.rpt](mixed_stage1/setup_T20.rpt) |
| [mixed_stage2](mixed_stage2/) | 把替换位置移到第二级，检查位置变化。 | [timing_summary.rpt](mixed_stage2/timing_summary.rpt) |
| [mixed_stage3](mixed_stage3/) | 把替换位置移到第三级，与前两个候选对照。 | [timing_summary.rpt](mixed_stage3/timing_summary.rpt) |
| [stage3](stage3/) | 对四个设计导出约束、运行 Howard 与独立 LP，并回查通过和失败周期。 | [STATUS.md](stage3/STATUS.md) |

工程内的 design.v、timing.xdc 和 routed.dcp 分别用于看逻辑、核对约束和打开已布线设计。各轮可用的文件随实验而异。

本组保留的源码或结果入口：[results.json](results.json)、[export_adjacent.tcl](export_adjacent.tcl)、[pack_adjacent.py](pack_adjacent.py)、[stage3_solve.py](stage3_solve.py)、[stage3_verify.py](stage3_verify.py)、[test_stage3.py](test_stage3.py)、[test_pack_adjacent.py](test_pack_adjacent.py)。批量脚本重跑方法见上级说明。

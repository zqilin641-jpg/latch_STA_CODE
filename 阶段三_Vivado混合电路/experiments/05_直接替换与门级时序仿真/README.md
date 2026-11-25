# 直接替换与门级时序仿真

原 85 个 FF 中直接替换 16 个，得到 69 FF + 16 Latch；所有存储单元共用脉冲时钟。混合电路在 10 ns 下通过指定的慢角 SDF 数据核对，FF 对照使用 12 ns；这两个仿真点不能给出同条件最高频率差。

| 子实验 | 用途 | 先看 |
| --- | --- | --- |
| [pulse_direct](pulse_direct/) | 构造全 FF 和直接替换的脉冲时钟方案，检查保持时间和周期关系。 | [manifest.json](pulse_direct/manifest.json) |
| [pulse_cycle](pulse_cycle/) | 保留直接替换的电路、原布线、两种重布线版本和逐引脚 SDF 审查。 | [MODELSIM_RESULT_20261117.md](pulse_cycle/MODELSIM_RESULT_20261117.md) |
| [modelsim_timing_crosscheck](modelsim_timing_crosscheck/) | 使用 ModelSim 交叉检查时序网表和 SDF 的仿真行为。 | [README.md](modelsim_timing_crosscheck/README.md) |
| [carry_reproducer](carry_reproducer/) | 抽取进位链单元做最小复现，用于解释时序仿真器的差异。 | [README.md](carry_reproducer/README.md) |

工程内的 design.v、timing.xdc 和 routed.dcp 分别用于看逻辑、核对约束和打开已布线设计。各轮可用的文件随实验而异。

本组保留的源码或结果入口：[run_modelsim_timing.py](run_modelsim_timing.py)、[run_timed_checkpoint.py](run_timed_checkpoint.py)。批量脚本重跑方法见上级说明。

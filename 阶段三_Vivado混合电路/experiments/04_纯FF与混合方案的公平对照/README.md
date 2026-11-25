# 纯FF与混合方案的公平对照

检验提频能否在更强的 FF 基准上保持。成对比较中一组从 115.236 提到 117.072 MHz，另一组从 121.464 降到 116.481 MHz。这批搜索记录中的最佳纯 FF 为 129.203 MHz，最佳混合候选为 127.992 MHz。

| 子实验 | 用途 | 先看 |
| --- | --- | --- |
| [ff_control](ff_control/) | 单独优化纯 FF 的切分位置，避免低估 FF 对照。 | [REPORT.md](ff_control/REPORT.md) |
| [internal_comp](internal_comp/) | 将位于末端的补偿 FF 移进运算链，检查收益来自重平衡还是 Latch。 | [REPORT.md](internal_comp/REPORT.md) |
| [paired_search](paired_search/) | 固定相同 FF 边界逐对比较，是引用上述两组成对频率的入口。 | [REPORT.md](paired_search/REPORT.md) |
| [selective_bits](selective_bits/) | 只给部分数据位插入 Latch，比较高 4 位和高 8 位候选。 | [REPORT.md](selective_bits/REPORT.md) |

工程内的 design.v、timing.xdc 和 routed.dcp 分别用于看逻辑、核对约束和打开已布线设计。各轮可用的文件随实验而异。

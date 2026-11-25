# Latch位子集筛选

2026-11-14。在FF3/6/10/12流水边界不变时，减少运算4之后额外插入的Latch数量。测试高4位[15:12]及高8位[15:8]；其他位直接连接组合逻辑。位集合是预设筛选候选，不是Howard优化输出，不宣称覆盖所有位组合或复现论文任意网表替换。

|方案|FF|Latch|原生STA通过频率MHz|
|---|---:|---:|---:|
|强纯FF对照|85|0|129.203|
|此前16位Latch|85|16|127.992|
|高4位Latch|85|4|124.956|
|高8位Latch|85|8|124.956|

新候选失败/通过周期区间均为8.002197–8.002808ns，未改善最佳频率。4位和8位方案降低额外存储开销，但不能据此宣称提频。保留现有纯FF最佳与混合最佳，不接受新候选为速度最优。

相同器件、公共MMCM、单数据时钟网clk、50%占空比、IO延时、交叉时钟不确定度及SLEW FAST。实际引脚和17个输出FF位置/BEL与纯FF对照逐项一致。两版各4132次MMCM厂商模型功能检查零错误，输出拍次不变；原生通过点setup/hold/脉宽满足，保存失败点及DRC报告。

实际网表是相同FF流水线上额外插入少量Latch，不是删除相同数量FF的直接替换。没有新增Howard求解、SDF、形式验证或上板测试。结果属于固定布线候选，不能推出所有Latch结构均不如FF。

上一轮成对边界对照详见../paired_search/REPORT.md：两组成对结果一升一降，但均未超过历史最佳。

证据：verified_results.json、manifest.json、functional_results.json、各设计的screen_pass.rpt/screen_fail.rpt与functional/run.log。复现入口为prepare_selective_bits.py、check_mmcm_function.py和../internal_comp/screen.tcl。

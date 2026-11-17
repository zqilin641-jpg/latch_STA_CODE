# 公共MMCM架构的Howard回验

日期：2026-11-14。

完成实际Vivado相邻节点时序导出、原Howard可执行程序求解、独立LP交叉检查，以及Vivado边界两侧回验。两组均显式补充 common_clock→mm_out 和 mm_out→common_clock 的setup/hold不确定度0.2 ns；保留原检查点，修正后的检查点在本目录ff和mixed中。

|方案|Howard局部模型周期ns|模型频率MHz|原生通过周期ns|原生失败周期ns|
|---|---:|---:|---:|---:|
|纯FF|9.203|108.660|9.213|9.193|
|部分Latch|8.573|116.645|8.583|8.563|

模型频率差约7.35%。混合版通过点hold余量0.082 ns、最小脉宽余量2.291 ns；纯FF对应0.202 ns和2.606 ns。通过点的所有用户时序约束满足，失败点均出现setup违例。

模型范围：一个公共MMCM的1:1生成时钟、50%占空比，数据存储共用clk；没有逐Latch相位优化。MMCM属于时钟生成资源，不作为数据存储节点；其时钟延时、抖动及生成时钟关系由Vivado原生路径报告提供。数据相邻节点覆盖Slow/Fast与max/min；Latch D起点无原生min路径的情况保留为不可用，不填零。反馈时钟不作为独立数据域。

本次使用合法的10 ns参考周期导出，未沿用20 ns（8倍频下VCO仅400MHz）。求解是固定布线、10 ns工作点附近的局部线性模型。MMCM抖动随频率变化，模型预测并非严格精确的全局边界；通过原生上下0.01 ns回验限制误差。这里只验证约8.56–9.22 ns邻域，不推广到任意MMCM倍分频或任意透明Latch网络。

Howard本次用于评估已有候选的周期，不负责选择替换位置，也没有动态分配相位。候选来自此前时序驱动的边界调整，功能仿真证据仍在mmcm_retime目录（4132次零错误）。尚未穷尽纯FF重定时候选；混合方案额外含16个Latch，不能宣称无面积代价或全局优于FF。未上板、未做SDF或形式等价验证。

证据：solve/results.json、各方案的adjacent路径报告与clocks.rpt、solve下的graph.json/constraints.graph/howard.stdout.json/pass.rpt/fail.rpt。入口为prepare_mmcm_howard.py、export.tcl、solve_mmcm_local.py、solve/validate.tcl、stage3_verify.py。

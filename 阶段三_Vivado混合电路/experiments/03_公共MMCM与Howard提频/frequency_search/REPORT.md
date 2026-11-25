# 单时钟部分替换：频率提升实验

2026-11-11。延续Pairl式候选变换，但本轮采用缩短Latch前逻辑段的定向候选筛选，不宣称论文完整复现或全局最优。

## 改动与公平对照

三组均用同一器件xc7a35tcpg236-1、35个相同引脚、单BUFG时钟、50%占空比，以及相同输入/输出延时与不确定度。最终17个输出FF均在同一IOB位置/BEL。对两类电路统一设置输出SLEW FAST，以10 ns目标实施布局、物理优化和布线。未放松接口延时，未使用多时钟或独立相位。

FF边界为3、6、9、12；选中的混合候选为FF3、Latch4、FF8、FF12，另有补偿输出FF。只转换一组16位存储，其余原有69个FF保留，另插入16个补偿FF，总计85 FF和16 Latch。补偿FF保持原有五个采样沿后的输出/valid语义。另一混合候选FF4、Latch5、FF9、FF12的原生筛选频率相同，未重复进行完整Howard导出。

## 结果

|方案|固定布线周期边界(ns)|频率约(MHz)|FF|Latch|
|---|---:|---:|---:|---:|
|ff_balanced|10.897|91.768|85|0|
|latch_short_4|10.897|91.768|85|16|

混合候选相对此前80.489 MHz提高约14.01%；相对本轮同条件FF为0.00%。这证明本轮消除了先前Latch候选的额外内部瓶颈，并提高了其整体频率，但没有证明Latch优于FF。提升包含候选边界、布局目标和IO驱动的共同影响，不能单独归因于时间借用。

最差路径仍为output_ff_08/C到result[8]。后续要突破这一频率，须优化公共时钟/输出接口这一共同瓶颈；仅继续移动内部Latch不能保证提高整机频率。修改公共时钟架构或接口时，必须对FF与混合电路做相同改动。

每版4114次RTL厂商原语模型功能检查零错误；原生STA二分筛选检查setup、hold和脉宽；两个入选候选完整导出相邻节点证据，执行实际Howard、独立LP，并以原生STA在求解周期上下0.01 ns回验。日志和各条路径报告均保留。IO快速边沿尚未做板级信号完整性验证，未进行SDF或上板测试。本结果是固定布线边界，不是全局最高频率证明。

复现入口：prepare_frequency_search.py → check_retiming_function.py → frequency_search/build.tcl → screen_frequency.tcl → frequency_search/export_finalists.tcl → stage3_solve.py → solve/validate.tcl → stage3_verify.py → report_frequency_search.py。

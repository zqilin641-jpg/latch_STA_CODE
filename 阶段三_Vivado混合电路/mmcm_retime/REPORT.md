# 单时钟部分FF替换：内部路径重平衡

日期：2026-11-13。

前轮关键路径为 latch_cut4_15/D → ff_cut8_14/D。本轮调整运算边界，把计算分配到FF4、Latch5、FF8、FF12，保持末端补偿FF和原输出拍次。另测试Latch6边界。使用一个公共MMCM（8倍频、8分频、零相位），全部数据存储连接同一BUFG网，无逐Latch相位分配。

|候选|原生STA通过周期ns|通过频率MHz|
|---|---:|---:|
|此前纯FF基线|9.198730|108.711|
|此前混合候选|10.602539|94.317|
|本轮Latch5|8.565918|116.742|
|本轮Latch6|8.677734|115.237|

Latch5相对此前混合候选提高23.78%，相对已测试纯FF基线提高7.39%。原生STA二分的失败/通过区间为8.565430–8.565918 ns；工具有皮秒舍入，不能把区间小数位理解为同等精度的硅片测量。

验证：同器件、同IO时序约束、同输出SLEW FAST；实际pins.tsv及17个输出FF的LOC/BEL与纯FF基线逐项一致。单数据时钟网检查通过。通过点setup、hold及脉宽均满足。两种新候选使用AMD的MMCME2_BASE/MMCME2_ADV模型，等待LOCKED后测试数据、valid和重复数据通路复位，各4132次检查零错误。此测试未覆盖运行中MMCM失锁/重锁；电路尚未加入生产用途的锁定监测及同步复位释放逻辑。

混合电路仍为85 FF＋16 Latch：转换16个原FF，保留69个原FF，并增加16个补偿FF。因此相对85 FF基线有额外存储面积；不能描述为无代价的FF替换。提升是边界重平衡、Latch与物理实现的组合效果，不是单独隔离出的时间借用收益。

这些是固定布线STA结果，不是上板实测或全局Fmax证明。尚未穷尽纯FF重定时候选；不能推断所有FF实现均慢于Latch。新增MMCM的Howard导出/建图尚未适配，本轮没有宣称Howard生成了该方案。无SDF或形式等价验证。

证据：verified_results.json、screen.tsv、functional_results.json，以及各候选的screen_pass.rpt、screen_fail.rpt、routed.dcp、structure.txt、pins.tsv、output_registers.tsv和functional/run.log。生成脚本为上级prepare_mmcm_retime.py，功能检查入口为check_mmcm_function.py。

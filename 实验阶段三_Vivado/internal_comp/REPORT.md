# 补偿FF内部化的对照实验

2026-11-14。保留输出拍次和存储数量，把此前放在末端的补偿FF移入组合计算链。新混合候选的FF边界为3/6/10/12，分别在运算4或7之后设置一组16位高电平透明Latch。实际网表相对于相同FF边界的纯FF方案，相当于额外插入一组Latch；不能称为单纯减少FF数量的替换。

|方案|原生STA通过频率MHz|失败/通过周期区间ns|
|---|---:|---|
|纯FF 3/6/10/12|129.203|7.739136–7.739746|
|同FF边界＋Latch4|127.992|7.812378–7.812988|
|同FF边界＋Latch7|124.889|8.006470–8.007080|

混合方案从此前约116.74MHz提升到约127.99MHz，约提高9.64%，但仍比同条件FF慢约0.94%。原纯FF“至少124.99MHz”的截断扫描已补出固定布线边界。区间存在工具皮秒舍入，不代表硅片测量精度，也不是全局最优频率证明。

比较保持相同器件、公共MMCM、1:1生成时钟、50%占空比、35个实际引脚、17个输出FF的LOC/BEL、SLEW FAST、接口延时及包含交叉时钟路径的不确定度。实际位置表、时钟网与存储数量检查通过。混合为85FF＋16Latch，纯FF为85FF，保留混合方案的面积开销。

两个新候选各通过4132次厂商MMCM模型功能检查，包含等待LOCKED、数据/valid及重复数据通路复位；没有增加额外可见输出拍次。通过点的原生setup、hold、脉宽均满足，保存通过/失败报告及该通过点DRC报告。没有上板、SDF或形式等价验证。本轮使用原生STA筛选，未对这两个新网表重新运行Howard；不能沿用旧网表的Howard证据。

文件：comparison.json、functional_results.json、各候选的design.v/routed.dcp/screen_pass.rpt/screen_fail.rpt/screen_drc.rpt。入口prepare_internal_compensation.py、check_mmcm_function.py、screen.tcl、verify_internal_comp.py。

后续应针对真正能获得跨边界时间借用收益的变换继续研究，而不能仅靠向已有均衡FF流水线插入Latch宣称提频。

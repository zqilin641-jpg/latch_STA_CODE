# 成对寄存器边界对照

2026-11-14。相同公共MMCM、IO约束、引脚和输出FF位置，分别为两组FF边界测试纯FF与额外Latch候选。各4132次功能检查零错误；原生STA通过点满足setup/hold/脉宽并有失败点。

|FF边界|纯FF MHz|混合 MHz|Latch边界|
|---|---:|---:|---|
|4/8/11/12|115.236|117.072|5|
|3/7/11/12|121.464|116.481|4|

一组成对结果略有提升，另一组降低，全部未超过已测试的最佳FF 129.203MHz或最佳混合127.992MHz，因此不更新最佳方案。不能只取第一组结果宣称Latch优势。候选是顺序运算链边界调整，未实现任意LUT网表自动重定时；混合额外包含16个Latch，无面积等价主张。

证据见verified_results.json、functional_results.json、各设计的screen_pass.rpt和screen_fail.rpt。本轮原生STA筛选，未重跑Howard，无SDF/形式验证或上板测量。

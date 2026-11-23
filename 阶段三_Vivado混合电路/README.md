# Vivado 单公共时钟迁移探测

2026-11-09。Vivado 2024.1安装于D:/xilinx/Vivado/2024.1；xc7a35tcpg236-1综合与实现许可证已实际获取。

采用原25节点算术功能，分别生成25 FDCE，以及20 FDCE+5 LDCE（内部第1级替换）。输入时钟经一只BUFG驱动全部存储单元。无PLL、MMCM、反相时钟、独立移相。布局布线后的structure.txt核验存储数量、唯一时钟对象和唯一时钟网络。

两组完成综合、优化、布局布线，保存routed.dcp、routed.sdf、routed_func.v以及setup/hold/摘要/资源/DRC报告。AMD原始FDCE/LDCE/BUFG模型功能仿真各2048次输出0错误。FF流水延迟5周期，混合4周期，非逐拍等价；未进行SDF仿真。

在12.121212 ns下两组setup WNS均-0.779 ns，输出IO路径失败。随后打开相同routed.dcp，将公共时钟改为20 ns、50%占空比，并重新分析，双方setup/hold/脉宽通过。该步骤为固定布线重分析，并非20 ns目标重新布局。results.json保存数值。

mixed_stage1/setup_T20.rpt明确记录Latch借用，例如首条路径time borrowed from endpoint=1.724 ns，computed max time borrow=10.043 ns。这是同一公共时钟下的借用报告证据；不等于频率提升。

未绑定具体AMD开发板，端口位置由实现工具选择。DRC记录UCIO-1和缺少配置电压属性，未降低告警等级，未生成比特流。这里证明Vivado可以承担后续单时钟混合实验，而非可直接下载的板级工程。与Pango器件不同，不能与先前82.5/89.5/93 MHz跨平台直接比较。

下一步需要适配Vivado的相邻时序节点、库时序与完整路径导出，然后建立混合约束图并接入Howard。当前100条报告仅为探测，未证明相邻节点全覆盖；旧PDS解析器不能直接读取这些报告。当前未完成新的Howard优化或最高频率搜索。

复现入口：build_probe.py生成RTL/XDC/Tcl；run.tcl运行两组完整实现；recheck.tcl执行20 ns固定布线分析；check_function.py运行AMD原语功能检查；summarize.py核验并汇总。

## 原生相邻节点导出（2026-11-09追加）

export_adjacent.tcl重新打开两个routed.dcp，在20 ns、50%占空比的公共时钟下，用all_fanin逐个枚举25个存储D端及5个输出端的时序起点；逐对查询Slow/Fast、max/min，保存完整路径报告与属性表。两组均50对原生相邻节点，FF得到200/200条主查询，混合得到200/200条主查询。Latch源额外查询D端：20次中10次max有结果，10次min无结果，全部显式保留。此处的覆盖是Vivado原生时序边界覆盖，不代表已经证明任意Latch透明链所需的独立延时信息完整。

pack_adjacent.py生成每组adjacent/evidence.json；加--log才写可读audit.log，不加则不创建或更新日志（已有日志保留）。记录借用/继承时间、带符号的库setup/hold增量、原始报告路径及无返回查询。三项验证已通过：真实导出核验、删除主查询后拒绝、篡改Slack后拒绝。check_timing显示内部无未约束端点、无缺失/多时钟、无组合及Latch环；reset为显式false path，不纳入本次数据路径覆盖。

本次原生报告总uncertainty包含工具计算项，例如0.235 ns，而用户设置值为0.200 ns，导出器保留实际值，不能把旧摘要与新导出数字混作完全相同分析设置。报告精度为工具支持的3位小数，算术核验容差0.0031 ns。

当前howard_ready=false：仍需完成透明传播与hold语义适配，不能把未返回的D端min查询当作0，也不能仅凭主查询齐全宣称所有Howard输入齐全。尚未运行新的单公共时钟Howard求解，未得到新的最高频率或提升结论。

复现：Vivado批处理运行export_adjacent.tcl，然后python pack_adjacent.py --log；python -m unittest test_pack_adjacent -v。

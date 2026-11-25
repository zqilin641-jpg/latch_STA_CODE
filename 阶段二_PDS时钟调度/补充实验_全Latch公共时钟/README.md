# 第四组　25 个 Latch 共用全 FF 的时钟

对照点为 82.5 MHz。design.v 复用原全 FF 版本的 PLL 实例、五级算术与复位，把 25 个存储位换成与原 Latch 组相同的高电平透明原语，所有 G 端直接连接 clocks[0]。timing.fdc 与 FF 对照逐字节一致。ff_reference.v 只修改全 FF 顶层模块名，以便同一个测试平台同时实例化两组。

## 结果

厂商 PLL 与 Latch 模型、ModelSim 10.4、无 SDF。PLL 锁定后测得周期 12.1212 ns，高电平 6.0606 ns。沿用原阶段二 Latch 计分器，2048 项检查有 1984 项不匹配，见 result.json。

为确定输出属于哪一笔事务，tb.v 将输入在上升沿后 0.2 ns 更新，在下一上升沿前 0.05 ns 比较，两组电路接受相同输入。在统一的 2048 个采样点，全 FF 按前五拍比较零错误；全 Latch 按本拍比较零错误，按前一拍错 1982 项，按前五拍错 1984 项。统一窗口和原 Latch 计分器的取样索引范围不同。原始计数见 run.log 中的 ALIGNMENT 和 FUNCTION_RESULT。

这个结果表明在上述激励和无 SDF 模型中，高电平时五级一起透明，本拍数据可以传到末级。当前输入的算术结果正确，但原流水线的事务拍次已改变。实际硅片传播时间和可工作频率不能由此推断。

PDS 在综合前退出，当前许可证过期，另一份本机许可证的格式也未被该版本接受。见 console.log 和 license_retry.log。本组尚无物理映射核验、STA 或最高通过频率。原实验目录为 E:/pds/lacth/latch_validation/howard_bridge/small25_experiment/common_latch_ffwave_82p5，其中保留 build.tcl、原始工程输入、两次仿真和日志。

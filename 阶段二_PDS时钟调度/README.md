# 阶段二　PDS 多相时钟调度

本阶段研究同一个 25 节点电路在三种实现下能跑多快。先用全 FF 建立基准，再用 Latch 检验借时，最后把求解得到的时序目标落实到 PLL 可配置的相位与脉宽，由 PDS 检查布局布线后的时序。实验使用 PGL50H-6FBG484、PDS 2022.2-SP6.4，按 0.5 MHz 步长搜索。

| 实现 | 搜索中通过的最高频率 | 实现中不同的时钟波形数 |
| --- | ---: | ---: |
| 全 FF | 82.5 MHz | 1 |
| Latch，未使用 Howard | 89.5 MHz | 5 |
| Latch，使用 Howard 的调度流程 | 93.0 MHz | 14 |

以未调度的 Latch 为基准，调度组多通过了 3.5 MHz，约提高 3.91%。Howard 连续模型得到的周期为 10.5485 ns，93 MHz 对应的实现周期约为 10.753 ns。引用结果时应注明这是已搜索实现中的布线后 STA 通过点，板上最高频率仍待测量。

## 怎样找到证据

| 想了解的问题 | 从哪里看 |
| --- | --- |
| 三组电路如何设置、怎样比较 | [实验阶段二.docx](实验阶段二.docx) 是主报告。 |
| 哪个频率通过，再提高一档为什么失败 | [FINAL_RESULTS.json](FINAL_RESULTS.json) 的每个 `cases` 条目记录通过点、重复运行、下一失败点以及快慢角的 setup、hold、脉宽余量。`coverage` 记录 50 对相邻节点的 200 个检查场景。 |
| 某一个 Latch 接哪路 PLL，开门和关门各在何时 | 在 [FINAL_CLOCKS.csv](FINAL_CLOCKS.csv) 按 `latch` 找行。`pll`、`output` 定位物理输出，`open_ns`、`close_ns` 描述时间，后面三列保留原语配置。逐节点都有记录，多个节点可以采用相同波形。 |
| 求解与分配分别在哪里发生 | [tools/pds_howard.cpp](tools/pds_howard.cpp) 把参数化约束图交给仓库的 Howard 实现，输出周期、临界环和收敛信息。最终逐节点配置见上面的 CSV；接口本身只输出求解结果。 |

## 怎样单独运行求解器

[build_howard_app](build_howard_app/) 保存已构建的 Linux 程序和 CMake 构建产物。已有图文件时，在 WSL 中进入本阶段目录，执行：

```bash
./build_howard_app/pds_howard /实际路径/约束图文件
```

输入文本首行为 `PDS_GRAPH_V1 节点数 边数 初始周期`，之后每条边一行，依次为源编号、目标编号、权重、transit 和数字边编号。成功时标准输出的 JSON 包含 `period_ns` 和 `cycle`。重新求解需要与对应电路匹配的图；两个 FINAL 文件保存的是已完成实验的结果。要追溯原始 PDS 运行，可按 JSON 中的 `run`、`repeat` 和 `next_failure` 标识查找原实验工作区。

## 补充对照：所有 Latch 共用 FF 时钟

[第四组实验记录](补充实验_全Latch公共时钟/README.md)给出 82.5 MHz 对照点的厂商模型仿真。25 个 Latch 同时透明时输出对应本拍输入，原流水线拍次检查失败。PDS 许可证阻塞了布线后时序验证，本组最高频率待测。

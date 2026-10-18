# s27 行为级对照仿真

本目录用事件级行为仿真独立检验 LatchSTA 工具在 s27 上的两个关键结论：

1. 寄存器（边沿触发）实现的最小可行周期 = 最长单边延迟 **6.58383 ns**（工具的 `Initial T`）；
2. 锁存器（透明窗口 + 逐锁存器 skew）实现的最小可行周期 = 工具给出的 **T\***，新版捕获为 **5.0607 ns**。

> 这是行为级验证，不是 SPICE / 门级 / 上板验证。它检验的是时序模型的可实现性，
> 不能据此宣称工具已被"物理验证"。

## 文件清单

| 路径 | 内容 |
| --- | --- |
| `sim.py` | 行为仿真器：s27 时序图 + 事件驱动引擎（透明窗口、逐锁存器 skew、关窗捕获）+ 判定 |
| `sweep.py` | 系统性扫描与出图：六个变体的最小可行周期、skew 网格、三张图 |
| `data/s27.blif.out` | 工具基准输入（与仓库 `benchmark/s27.blif.out` 字节相同，MD5 `6fa6d9bce4fa1f1e9b2df74ccd6f16e2`） |
| `data/tool_reference_frozen_binary.txt` | 冻结版二进制本次实跑 s27 的原始输出 |
| `data/tool_reference_newer_capture.txt` | `BailuFrost/LatchSTA_Code` 仓库 `test_result_css/` 的新版捕获（含逐锁存器 skew 表） |
| `results/summary.txt` | 各变体最小可行周期汇总 + 解析参照值 |
| `results/sweep_points.csv` | 扫描逐点明细：变体 / T / W / 通过否 / 最佳偏移 / 匹配率 |
| `results/skew_grid.csv` | T = 5.1 ns 处 (s_G5, s_G6, s_G7) 网格 75 点的可行性 |
| `figures/pass_fail.png` | 各变体通过/失败随 T 的分布 + 工具参考线 |
| `figures/waveform_T6.png` | T = 6.0 ns 波形：寄存器失败机理 vs 锁存器借时 |
| `figures/skew_grid.png` | skew 可行性热图 |

## 模型假设

与 `include/timing_oracle.hpp` 的模型假设一一对应：

- 每个节点建模为一个锁存器；IO 节点时钟 skew 固定为 0。
- 锁存器 k 的透明窗口 = `[s_k + n*T, s_k + n*T + W]`，窗口内输入直通输出，
  关窗时刻捕获（`Tsu = Th = Tcq = Tdq = 0`，恰在关窗时刻到达也算捕获）。
- 寄存器变体 = `W = 0`；锁存器变体的无竞争窗口 `W = min(T/2, 2.6138)`。
- 逐锁存器 skew 表直接采用工具输出（LP 表或 Howard/YTO 表）。
- 理想时钟；未建模亚稳态、边沿速率、脉冲宽度限制。
- 只建 max 延迟（setup / 借时），未建 min 延迟与 hold。
- 判定准则：与同一电路、同一参数、30 ns 慢时钟下的参考行为逐拍一致
  （允许整体恒定流水线延迟），比较窗口取周期 80–160。

## 版本与数据来源

本验证完成于 2026-10-12，工具侧参考输出有两份，均保存在 `data/`：

| 参考 | 来源 | 关键值 |
| --- | --- | --- |
| 冻结版二进制 | WSL `~/LatchSTA/code/build/main`（用户工作区同源副本，mtime 2025-09-14，无 LEDA），命令 `./build/main benchmark/s27.blif.out 1 100` | Initial 6.58383；YTO 5.0607；Howard = LP_MCR = **5.38621**；ELL 5.06076 |
| 新版捕获 | `BailuFrost/LatchSTA_Code` 仓库 `test_result_css/` 的输出捕获 | Howard = YTO = LP_MCR = **5.0607**，并含逐锁存器 skew 表 |

本目录中的仿真使用新版捕获的 skew 表：

- LP：`s[0]=0, s[1]=0.32551, s[2]=0, s[3]=0`
- Howard/YTO：`s[0]=0, s[1]=0.8165, s[2]=2.15822, s[3]=0`

注意：上传目标仓库（`zqilin641-jpg/latch_STA_CODE`）的 HEAD 为 `bf392e2`（2026-10-16），
与上述两个参考版本都不完全相同。若作为该仓库的正式验证，建议用该 commit 重新构建、
重跑工具并把新的参考输出更新到 `data/` 后再合并。

仿真器**不读取** `data/s27.blif.out`：s27 的时序图硬编码在 `sim.py` 中，该文件仅作来源存证。
如果合并进仓库，可删除 `data/s27.blif.out` 以避免与 `benchmark/s27.blif.out` 重复。

## 复现

依赖：Python 3.12；`sim.py` 只用标准库，`sweep.py` 需要 matplotlib。

```bash
cd tests/s27_behavioral

# 寄存器实现单点（对照 Initial T）
python sim.py 6.0 --mode ff

# 锁存器 + LP 表单点（对照 T*）
python sim.py 5.06 --skew 0.32551 0 0

# 诊断模式：打印逐节点对照细节
python sim.py 5.06 --mode ff --diag

# 全量扫描 + 重出三张图（约 1–2 分钟）
python sweep.py
```

## 结果

工具参考：`Initial T = 6.58383`；新版 `T* = 5.0607`；冻结版 `Howard = LP_MCR = 5.38621`；
`T_ELL = 5.06076`。

| 变体 | W (ns) | skew | 仿真最小可行周期 (ns) | 解析参照 (ns) | 结论 |
| --- | --- | --- | --- | --- | --- |
| `ff` | 0 | 全 0 | 6.584 | 6.58383 = IO→G5 最长边 | 与 `Initial T` 一致 |
| `ff_lp_skew` | 0 | LP 表 | 6.259 | 6.25832 = 6.58383 − 0.32551 | 无窗口时 skew 只省自身数值 |
| `lat_Wsafe_s0` | min(T/2, 2.614) | 全 0 | 5.059 | 5.0607 = G6→G6 自环 | 与 `T*` 一致；不排 skew 也够 |
| `lat_Wsafe_lp` | min(T/2, 2.614) | LP 表 | 5.057 | 5.0607 | 工具 LP 表可行 |
| `lat_Wsafe_howard` | min(T/2, 2.614) | Howard 表 | 8.644 | 8.64734 ≈ 环延迟之和 | 工具 Howard/YTO 表不可行 |
| `lat_Wmax_lp` | T/2 | LP 表 | 5.10–6.40 通过 | —（竞争区无解析值） | T > 6.4 起窗口内整环竞争 |

仿真边界与解析值之差 ≤ 0.004 ns，属零裕量处判据的量化分辨率
（有限比较窗口内，子周期相位漂移不可分辨），不影响量级与结论。

## 主要发现

- **两个锚点都被独立复现**：寄存器版 6.58383 ns（= IO→G5 最长边）；
  锁存器版 5.0607 ns（= G6→G6 自环）。单锁存器自环无法借时，这是硬下界，
  与工具在 s27 最优点处 `W ≈ 0` 的现象一致。
- **收益主要来自透明窗口，而不是 skew**：s27 从 6.58 → 5.06 ns 主要靠窗口吸收
  IO→G5 的 6.58 ns 长路径；skew 本身只贡献 0.325 ns（见 `ff_lp_skew` 对照）。
- **Howard/YTO skew 表物理不可行**：`(s5=0.8165, s6=2.15822)` 需要 T ≥ 8.64 ns
  才能保持功能（≈ G5↔G6 环的延迟和 8.64734 = 2.889 + 5.75834
  = 3.58664 + 5.06070），与"它能达到 T\*"的输出矛盾；LP 表在 T = 5.1 ns 起可行。
  这与工具自己给出的提示 "Use T_LP_MCR with the LP skew schedule" 一致。
- **W 不能盲目取满 T/2**：当 W ≥ 最短环路延迟（G7 自环 2.61382 ns）时，
  整条环可以在一个透明窗口内绕回 → 竞争/振荡；实测 T ≥ 6.45 ns 起功能被破坏。
- **结构性巧合**：G5↔G6 环两个方向的延迟和与两个自环之和相等，
  都 = 8.64734，恰与 Howard 边界吻合。

## 限制与未验证项

- 只建了 max 延迟（setup / 借时），**未建 min 延迟与 hold**；
  "LP 表物理可行"的结论限定在无 hold 的 setup 语义下。补 hold 是明确的下一步。
- 理想化：无亚稳态、无边沿速率/脉冲宽度限制；逻辑函数选用 XOR 形式以保证每条边被激励；
  IO 节点做了特殊处理（输入激励、输出抽头仅观测）。
- 行为级仿真，不是外部物理真值；不能替代 SPICE/门级或上板测量。
- 版本注记：冻结版二进制（2025-09-14）Howard/LP_MCR = 5.38621 ns，
  新版仓库捕获为 5.0607 ns——两版本来就不一致（两份参考原文都在 `data/` 里）。
  本仿真从物理侧支持 5.0607 这一侧。
- 结果依赖上述参考输出；换代码版本后必须重跑，不能直接引用旧数字。

## 下一步

- 补 min 延迟 / hold 建模（benchmark 数据里本来就有 min 列），复核 LP 表在 hold 约束下是否仍可行。
- 把同一套对照仿真流程搬到更大电路：`CSTIC/test.zip` 的 VTR 流程可产出同格式 `.blif.out`。
- 用 git 历史 `7a19c60` 里可恢复的 s27 Vivado 真实后布线延迟重跑本对照。
- 顺着"Howard/YTO 偏斜表不可行"这条线，检查工具内部 Howard/YTO 偏斜输出的生成逻辑。

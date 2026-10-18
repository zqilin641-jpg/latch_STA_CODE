#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
s27 行为级对照仿真 (independent behavioral cross-check for LatchSTA_Code)

目的
----
用"真的把电路跑起来"的事件级仿真，独立检验 LatchSTA 工具对 s27 的两个结论：
  1) 寄存器(边沿触发)实现下，最小可行时钟周期 == 最长单边延迟 6.58383 ns (工具的 "Initial T")；
  2) 换成锁存器(透明窗口 W + 逐锁存器 skew)后，最小可行周期 == 工具给出的 T*
     (冻结版二进制: YTO/LP_ELL = 5.0607 ns, Howard/LP_MCR = 5.38621 ns;
      新版捕获: Howard=YTO=LP_MCR=5.0607 ns)。

电路模型 (忠实复刻 benchmark/s27.blif.out 的时序图)
----------------------------------------------------
- 顶点: IO(0, 时钟 skew 钉 0), G5(1), G6(2), G7(3)，每个顶点一个锁存/寄存器；
- 数据边 (重复边按 max-of-max 合并，与工具解析器一致):
    IO->G5 6.58383, IO->G6 5.88619, IO->G7 2.44382,
    G5->G5 3.58664, G5->G6 2.88900,
    G6->G5 5.75834, G6->G6 5.06070,
    G7->G5 4.84438, G7->G6 4.14674, G7->G7 2.61382;
- 输出抽头(仅观测，不参与反馈): G5->OUT 1.74252, G6->OUT 3.91422, G7->OUT 3.00026;
- 每个锁存器的逻辑: 输出 = 自己所有入边的 xor (保证每条边都被激励到);
- 输入 IO: 每周期一个随机比特 stim[n] (快慢两种时钟共用同一条序列)。

时序语义 (与 timing_oracle.hpp 的模型假设一一对应)
--------------------------------------------------
- 锁存器 k 的透明窗口 = [skew_k + n*T, skew_k + n*T + W]，窗口内输入直通输出，
  窗口关闭时捕获 (capture in_k at close; Tsu = 0 -> "恰在关窗时刻到达"也算被捕获);
- 寄存器变体 = W = 0 (退化为边沿捕获);
- 锁存器变体= W = T/2 (模型允许的最大借时窗口)。

判定准则 ("功能正确" = 与慢时钟参考逐拍一致, 允许恒定流水线延迟)
----------------------------------------------------------------
- 参考: 同一电路、同一 (W, skew)，T = 30 ns 慢时钟下跑出的状态序列;
- 待测: 快时钟 T 下跑出的状态序列，与参考在某个恒定周期偏移下逐拍完全一致
  -> 等价于"每个环路的周期比/吞吐率正确，且功能未被破坏"；
- 快慢两轮共用同一条激励序列 stim。

运行:
  python sim.py <T> [--mode ff|lat] [--W W] [--skew s5 s6 s7]
  (完整扫描 + 出图见 sweep.py)
"""
import heapq
import math
import bisect
import random
import sys

# ---------- s27 时序图 ----------
NODES = ('IO', 'G5', 'G6', 'G7')          # 顶点顺序与工具输出中的 s[k] 编号一致
IDX = {nm: i for i, nm in enumerate(NODES)}
N = len(NODES)

DELAY = {                                  # 数据边，单位 ns；重复边取 max
    ('IO', 'G5'): 6.583830,
    ('IO', 'G6'): 5.886190,
    ('IO', 'G7'): 2.443820,
    ('G5', 'G5'): 3.586640,
    ('G5', 'G6'): 2.889000,
    ('G6', 'G5'): 5.758340,
    ('G6', 'G6'): 5.060700,
    ('G7', 'G5'): 4.844380,
    ('G7', 'G6'): 4.146740,
    ('G7', 'G7'): 2.613820,
}
TAPS = {('G5', 'IO'): 1.742520, ('G6', 'IO'): 3.914220, ('G7', 'IO'): 3.000260}

FANIN = [[] for _ in range(N)]
FANOUT = [[] for _ in range(N)]
for (a, b), d in DELAY.items():
    sa, sb = IDX[a], IDX[b]
    FANIN[sb].append((sa, d))
    FANOUT[sa].append((sb, d))
for k in range(N):
    FANIN[k].sort()
    FANOUT[k].sort()

# 工具侧参考值 (ns)
T_INITIAL = 6.583830          # 寄存器侧基线 = 最长单边 IO->G5
T_YTO_LP_ELL = 5.060700       # 冻结版二进制: YTO / LP_ELL；新版捕获: 全部方法
T_HOW_LP_MCR_FROZEN = 5.386210  # 冻结版二进制: Howard / LP_MCR (与新版捕获不一致)
T_ELL = 5.060760

# 工具输出的 skew 表 (来自 test_result_css/s27.blif.out.txt 捕获; 序号 0..3 = IO,G5,G6,G7)
SKEW_LP = [0.0, 0.32551, 0.0, 0.0]
SKEW_HOWARD = [0.0, 0.81650, 2.15822, 0.0]

T_GOLD = 30.0                 # 慢时钟参考周期

# 物理安全窗口上界: 必须严格小于"最短环路延迟"(G7 自环 2.61382 ns), 否则
# 一个完整时序环可以在同一个透明窗口内自环 -> 环内振荡/竞争(锁存器设计的经典禁忌)。
SAFE_W = 2.613800


def make_stim(ncyc, seed=2701):
    rng = random.Random(seed)
    return [rng.getrandbits(1) for _ in range(ncyc + 64)]


def run_sim(T, W, skew, cycles, stim):
    """事件驱动仿真。返回 {'cap': {k: [每周期捕获值]}, 'obs': {tap: [...]},
    'times', 'vals' (输出翻转时间线, 供画波形)}"""
    times = [[-1.0] for _ in range(N)]     # 时间线哨兵: t=-1 处值 0
    vals = [[0] for _ in range(N)]
    out = [0] * N
    opens = [False] * N
    cap = {k: [] for k in range(N)}
    obs = {tap: [] for tap in TAPS}

    def outval(k, t):
        # EPS: "恰在捕获时刻到达也算到达" (Tsu=0) 的浮点鲁棒化；远小于任何真实时序裕量
        i = bisect.bisect_right(times[k], t + 1e-6) - 1
        return vals[k][i]

    def eval_in(k, t):
        if k == 0:                          # IO: D 端 = 原始激励
            i = int(math.floor(t / T + 1e-9))
            return stim[i] if 0 <= i < len(stim) else 0
        v = 0
        for (src, d) in FANIN[k]:
            v ^= outval(src, t - d)
        return v

    heap = []
    tid = 0

    def push(t, prio, kind, k, extra=None):
        nonlocal tid
        tid += 1
        heapq.heappush(heap, (t, prio, tid, kind, k, extra))

    for c in range(cycles):
        for k in range(N):
            o = skew[k] + c * T
            push(o, 1, 'open', k)           # 同一时刻: 到达(0) < 开窗(1) < 关窗(2)
            push(o + W, 2, 'close', k)

    while heap:
        t, prio, _, kind, k, extra = heapq.heappop(heap)
        if kind == 'open':
            opens[k] = True
            v = eval_in(k, t)               # 开窗瞬间输入直通输出
            if v != out[k]:
                out[k] = v
                times[k].append(t)
                vals[k].append(v)
                for (dst, d) in FANOUT[k]:
                    push(t + d, 0, 'arrive', dst, k)
        elif kind == 'arrive':
            if opens[k]:                    # 关窗期间输入变化不直通, 只留待下次开窗采样
                v = eval_in(k, t)
                if v != out[k]:
                    out[k] = v
                    times[k].append(t)
                    vals[k].append(v)
                    for (dst, d) in FANOUT[k]:
                        push(t + d, 0, 'arrive', dst, k)
        else:                               # close
            opens[k] = False
            cap[k].append(eval_in(k, t))    # at-or-after 语义 (Tsu=0)
            if k == 0:
                for tap, d in TAPS.items():
                    obs[tap].append(outval(IDX[tap[0]], t - d))
    return {'cap': cap, 'obs': obs, 'times': times, 'vals': vals,
            'T': T, 'W': W, 'skew': list(skew)}


def variants(T):
    """(名称, W, skew) 列表。skew = [s_IO, s_G5, s_G6, s_G7]
    - ff: 寄存器(边沿); lat_Wsafe: 无竞争锁存(W = min(T/2, SAFE_W));
    - lat_Wmax: 工具模型名义上限 W=T/2 (>SAFE_W 时属于竞争区, 用于记录现象)"""
    Ws = min(T / 2, SAFE_W)
    return [
        ('ff',                0.0, list([0.0, 0.0, 0.0, 0.0])),
        ('ff_lp_skew',        0.0, list(SKEW_LP)),
        ('lat_Wsafe_s0',      Ws,  list([0.0, 0.0, 0.0, 0.0])),
        ('lat_Wsafe_lp',      Ws,  list(SKEW_LP)),
        ('lat_Wsafe_howard',  Ws,  list(SKEW_HOWARD)),
        ('lat_Wmax_lp',       T / 2, list(SKEW_LP)),
        ('lat_Wmax_howard',   T / 2, list(SKEW_HOWARD)),
    ]


def compare(fast, gold, c0, c1, max_off=24):
    """fast 与 gold 的状态捕获序列在恒定周期偏移下对照。
    判定只看 G5,G6,G7 三个状态锁存器的捕获序列 (每周期一个值):
      - 恒定偏移可对齐 = 唯一的流水线延迟差异, 功能/吞吐率正确;
      - 任何偏移都对不齐 = 捕获了错误的拍 (环路吞吐率破坏或功能被相位打乱)。
    输出抽头只在"窗口内瞬态"意义上有值, 不作为判定依据 (仅记录 frac 供参考)。
    返回 (pass, best_offset, worst_state_frac, tap_frac)"""
    st = [(fast['cap'][k], gold['cap'][k]) for k in (1, 2, 3)]
    taps = [(fast['obs'][t], gold['obs'][t]) for t in TAPS]

    def frac(fs, gs, off):
        ok = tot = 0
        for c in range(c0, c1):
            g = c + off
            if 0 <= g < len(gs):
                tot += 1
                if fs[c] == gs[g]:
                    ok += 1
        return ok / tot if tot else 0.0

    best = (False, None, 0.0, 0.0)
    for off in range(-4, max_off + 1):
        worst_state = min(frac(fs, gs, off) for fs, gs in st)
        tf = min(frac(fs, gs, off) for fs, gs in taps)
        if worst_state > best[2]:
            best = (worst_state >= 0.995, off, worst_state, tf)
        if worst_state >= 0.995:
            return (True, off, worst_state, tf)
    return best


def run_point(T, W, skew, cycles=170, c0=80, c1=160):
    """单点：快时钟 vs T=30 慢时钟参考。返回 dict"""
    stim = make_stim(cycles + 64)
    fast = run_sim(T, W, skew, cycles, stim)
    gold = run_sim(T_GOLD, W, skew, cycles + max(30, len(stim) // 4), stim)
    # 自检: IO 捕获序列必须等于激励本身
    io_ok = all(fast['cap'][0][c] == stim[c] for c in range(min(cycles, len(stim))))
    passed, off, frac, tfrac = compare(fast, gold, c0, c1)
    return {'T': T, 'W': W, 'skew': list(skew), 'pass': bool(passed and io_ok),
            'offset': off, 'match': frac, 'tap_match': tfrac, 'io_ok': io_ok,
            'fast': fast, 'gold': gold}


def _cli():
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        return
    T = float(args[0])
    mode = 'lat'
    W = None
    skew = [0.0, 0.0, 0.0, 0.0]
    diag = False
    i = 1
    while i < len(args):
        if args[i] == '--mode':
            mode = args[i + 1]; i += 2
        elif args[i] == '--W':
            W = float(args[i + 1]); i += 2
        elif args[i] == '--skew':
            skew = [0.0] + [float(x) for x in args[i + 1:i + 4]]; i += 4
        elif args[i] == '--diag':
            diag = True; i += 1
        else:
            raise SystemExit('unknown arg ' + args[i])
    if W is None:
        W = 0.0 if mode == 'ff' else min(T / 2, SAFE_W)
    r = run_point(T, W, skew)
    print('T=%.4f W=%.4f skew=%s -> pass=%s offset=%s state_match=%.4f tap_match=%.4f io_ok=%s'
          % (T, W, r['skew'], r['pass'], r['offset'], r['match'], r['tap_match'], r['io_ok']))
    if diag:
        d = _diagnose(r)
        print(d)


def _diagnose(r):
    """诊断: 在最佳偏移下, 逐节点匹配率 + 首次分歧处的序列片段"""
    import io
    buf = io.StringIO()
    fs, gs_all = r['fast'], r['gold']
    off = r['offset'] if r['offset'] is not None else 0
    for k in (1, 2, 3):
        f, g = fs['cap'][k], gs_all['cap'][k]
        c0, c1 = 80, 160
        ok = sum(1 for c in range(c0, c1) if 0 <= c + off < len(g) and f[c] == g[c + off])
        buf.write('  node %s: match@off=%d %.3f\n' % (NODES[k], off, ok / (c1 - c0)))
        bad = next((c for c in range(c0, c1) if 0 <= c + off < len(g) and f[c] != g[c + off]), None)
        if bad:
            buf.write('    first diff at cycle %d: fast%s vs gold%s\n'
                      % (bad, f[bad - 4:bad + 8], g[bad + off - 4:bad + off + 8]))
        else:
            buf.write('    sample: fast%s\n            gold%s\n' % (f[100:112], g[100 + off:112 + off]))
    return buf.getvalue()


if __name__ == '__main__':
    _cli()

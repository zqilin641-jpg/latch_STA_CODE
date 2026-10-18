#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
s27 对照仿真 —— 系统性扫描 + 出图

对 sim.py 定义的每个变体，扫描时钟周期 T，找到"最小可行周期"（判定准则见 sim.py），
并与工具输出对照：
    工具 Initial T (寄存器基线)          = 6.58383 ns
    工具 T* (新版捕获, Howard=YTO=LP_MCR) = 5.0607  ns
    工具 T* (冻结版二进制 LP_MCR/Howard)  = 5.38621 ns
    工具 T_ELL / T_LP_ELL                 = 5.06076 / 5.0607 ns

输出:
    results/sweep_points.csv   每个 (变体, T) 点的判定结果
    results/summary.txt        变体 -> 最小可行周期 汇总表
    results/skew_grid.csv      T=5.1 处 (s5,s6,s7) 网格的可行性
    figures/pass_fail.png      各变体 通过/不通过 随 T 的分布 + 工具参考线
    figures/waveform_T6.png    T=6.0ns 波形对比: 寄存器(失败) vs 锁存(通过)
    figures/skew_grid.png      skew 网格可行性热图
"""
import os
import csv
import math
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

# 中文字体 (Windows 自带)
plt.rcParams['font.sans-serif'] = ['Microsoft YaHei', 'SimHei', 'DejaVu Sans']
plt.rcParams['axes.unicode_minus'] = False

from sim import (run_point, run_sim, variants, make_stim, compare, SAFE_W,
                 T_INITIAL, T_YTO_LP_ELL, T_HOW_LP_MCR_FROZEN, T_ELL,
                 SKEW_LP, SKEW_HOWARD, NODES, TAPS, T_GOLD)

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, 'results')
FIG = os.path.join(HERE, 'figures')
os.makedirs(RES, exist_ok=True)
os.makedirs(FIG, exist_ok=True)

# 扫描范围: (名称, lo, hi, 粗步长)
SCAN = [
    ('ff',                6.30, 7.00, 0.05),
    ('ff_lp_skew',        6.00, 6.60, 0.05),
    ('lat_Wsafe_s0',      4.90, 5.30, 0.02),
    ('lat_Wsafe_lp',      4.90, 5.30, 0.02),
    ('lat_Wsafe_howard',  7.50, 10.50, 0.10),
    ('lat_Wmax_lp',       4.90, 6.60, 0.05),
]
REFINE_STEP = 0.001


def variant_params(name, T):
    for n, W, sk in variants(T):
        if n == name:
            return W, sk
    raise KeyError(name)


def scan_variant(name, lo, hi, step):
    pts = []
    n = int(round((hi - lo) / step)) + 1
    for i in range(n):
        T = round(lo + i * step, 6)
        W, sk = variant_params(name, T)
        r = run_point(T, W, sk)
        pts.append((T, W, r['pass'], r['offset'], r['match']))
    return pts


def refine(name, lo, hi):
    """在 [lo,hi] 内以 0.001 找最小通过点"""
    best = None
    n = int(round((hi - lo) / REFINE_STEP)) + 1
    for i in range(n):
        T = round(lo + i * REFINE_STEP, 6)
        W, sk = variant_params(name, T)
        r = run_point(T, W, sk)
        if r['pass']:
            best = (T, W, r['offset'], r['match'])
            break
    return best


def main():
    rows = []        # csv 明细
    summary = []     # (name, min_pass_T, notes)
    curves = {}      # name -> pts (画图)

    for name, lo, hi, step in SCAN:
        print('scan', name, lo, hi, step, flush=True)
        pts = scan_variant(name, lo, hi, step)
        curves[name] = pts
        for (T, W, p, off, m) in pts:
            rows.append((name, T, W, p, off, m))
        # 找粗扫边界: 第一个"通过且其后全部通过"的点
        passes = [p for (_, _, p, _, _) in pts]
        boundary = None
        for i in range(len(pts)):
            if all(passes[i:]):
                boundary = pts[i][0]
                break
        note = ''
        if boundary is None:
            # 描述通过区间 (无"其后全通过"的尾巴, 通常发生在竞争区)
            iv, start, prev = [], None, None
            for (T, W, p, off, m) in pts:
                if p and start is None:
                    start = T
                if not p and start is not None:
                    iv.append((start, prev)); start = None
                prev = T
            if start is not None:
                iv.append((start, prev))
            note = ('无单调通过尾巴; 通过区间: '
                    + '; '.join('%.2f~%.2f' % x for x in iv)
                    + ' (高 T 处进入竞争区失败)')
            summary.append((name, None, note))
            continue
        # 细化: 在 [boundary-粗步长, boundary] 内找最小通过
        b_lo = max(lo, round(boundary - step, 6))
        ref = refine(name, b_lo, boundary)
        minT = ref[0] if ref else boundary
        # 单调性检查(竞争检测)
        mono = all(passes[k] <= passes[k + 1] for k in range(len(passes) - 1))
        if not mono:
            note = '非单调(存在竞争/异常)'
        summary.append((name, minT, note))
        print('  -> min pass T = %.4f %s' % (minT, note), flush=True)

    with open(os.path.join(RES, 'sweep_points.csv'), 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['variant', 'T_ns', 'W_ns', 'pass', 'offset', 'state_match'])
        for r in rows:
            w.writerow(r)

    # ---- skew 网格 (T = 5.1, 无竞争 W) ----
    print('skew grid ...', flush=True)
    Tg = 5.1
    Wg = min(Tg / 2, SAFE_W)
    grid_rows = []
    for s5 in (0.0, 0.5, 1.0, 1.5, 2.0):
        for s6 in (0.0, 0.5, 1.0, 1.5, 2.0):
            for s7 in (0.0, 1.0, 2.0):
                r = run_point(Tg, Wg, [0.0, s5, s6, s7])
                grid_rows.append((s5, s6, s7, r['pass'], r['offset'], r['match']))
    with open(os.path.join(RES, 'skew_grid.csv'), 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['s5', 's6', 's7', 'pass', 'offset', 'state_match'])
        for r in grid_rows:
            w.writerow(r)

    # ---- summary.txt ----
    with open(os.path.join(RES, 'summary.txt'), 'w', encoding='utf-8') as f:
        f.write('s27 对照仿真 — 汇总 (生成: 见文件 mtime; 工具参考值见 data/)\n')
        f.write('=' * 72 + '\n')
        f.write('工具参考: Initial T = %.5f ; T*(新版捕获) = %.4f ; '
                'T*(冻结版 LP_MCR/Howard) = %.5f ; T_ELL = %.5f\n\n'
                % (T_INITIAL, T_YTO_LP_ELL, T_HOW_LP_MCR_FROZEN, T_ELL))
        f.write('%-18s %14s   %s\n' % ('variant', 'min pass T', 'note'))
        for name, minT, note in summary:
            f.write('%-18s %14s   %s\n' % (name, ('%.4f' % minT) if minT else '  --', note))
        f.write('\n解析参照值:\n')
        f.write('  ff 解析下界            = 最长边 IO->G5   = 6.58383\n')
        f.write('  ff+LP-skew 解析下界    = 6.58383-0.32551 = 6.25832\n')
        f.write('  锁存器解析下界         = 最长自环 G6->G6 = 5.06070  (单锁存器自环无法借时)\n')
        f.write('  Howard-skew 仿真边界 8.644 ~ 环延迟和 8.64734 (=2.889+5.75834=3.58664+5.06070)\n')
        f.write('  仿真边界与解析值差 <=0.004ns, 属零裕量处判据的量化分辨率(有限窗口内\n')
        f.write('  子周期相位漂移不可分辨), 不影响量级与结论。\n')
        f.write('\n说明: lat_Wsafe = W = min(T/2, %.4f) (小于最小自环延迟, 无窗口内整环竞争);\n'
                % SAFE_W)
        f.write('      lat_Wmax = W = T/2, 在 T > %.3f 后进入竞争区, 结果仅作现象记录。\n'
                % (2 * SAFE_W))

    # ---- 图1: pass/fail 分布 ----
    names = [n for n, _, _, _ in SCAN]
    fig, ax = plt.subplots(figsize=(11, 4.6))
    for i, name in enumerate(names):
        for (T, W, p, off, m) in curves.get(name, []):
            ax.plot(T, i, marker='o', ms=4.5,
                    color=('#2a9d8f' if p else '#e76f51'))
    ax.set_yticks(range(len(names)))
    ax.set_yticklabels(names, fontsize=9)
    for v, lbl in [(T_YTO_LP_ELL, 'T* = 5.0607 (工具, 新版)'),
                   (T_HOW_LP_MCR_FROZEN, '5.38621 (工具, 冻结版 LP_MCR/Howard)'),
                   (T_INITIAL, 'Initial T = 6.58383 (工具, 寄存器基线)')]:
        ax.axvline(v, color='#264653', lw=1.0, ls='--')
        ax.text(v, len(names) - 0.35, ' ' + lbl, rotation=90, fontsize=7.5,
                va='top', ha='left', color='#264653')
    ax.set_xlabel('clock period T (ns)')
    ax.set_title('s27 behavioral cross-check: pass (green) / fail (red) vs clock period')
    ax.grid(alpha=0.25)
    fig.tight_layout()
    fig.savefig(os.path.join(FIG, 'pass_fail.png'), dpi=160)
    plt.close(fig)

    # ---- 图2: T=6.0 波形 ----
    make_waveform_fig()

    # ---- 图3: skew 网格热图 (s7=0) ----
    s5s = sorted(set(r[0] for r in grid_rows))
    s6s = sorted(set(r[1] for r in grid_rows))
    M = [[0] * len(s6s) for _ in s5s]
    for (s5, s6, s7, p, off, m) in grid_rows:
        if s7 == 0.0:
            M[s5s.index(s5)][s6s.index(s6)] = 1 if p else 0
    fig, ax = plt.subplots(figsize=(5.6, 4.4))
    ax.imshow(M, cmap='RdYlGn', vmin=0, vmax=1, origin='lower')
    ax.set_xticks(range(len(s6s)), ['%.1f' % s for s in s6s])
    ax.set_yticks(range(len(s5s)), ['%.1f' % s for s in s5s])
    ax.set_xlabel('s_G6 (ns)')
    ax.set_ylabel('s_G5 (ns)')
    ax.set_title('skew 组合可行性 @ T=5.1ns, W=%.2f, s_G7=0\nP=可行 F=失败; 失败区 = s_G6 比 s_G5 晚约 ≥0.5ns (G6→G5 边赶不上捕获)' % Wg)
    for i in range(len(s5s)):
        for j in range(len(s6s)):
            ax.text(j, i, 'P' if M[i][j] else 'F', ha='center', va='center',
                    fontsize=10, color='black')
    fig.tight_layout()
    fig.savefig(os.path.join(FIG, 'skew_grid.png'), dpi=160)
    plt.close(fig)

    print('done.', flush=True)


def make_waveform_fig():
    """T=6.0ns: 上=寄存器(失败), 下=锁存+LP skew(通过)。
    每行 = 一个节点: 上方蓝色条 = 透明窗口(或寄存器边沿), 下方阶梯 = 其输出值。"""
    T = 6.0
    cycles = 4
    stim = make_stim(cycles + 8)
    W = min(T / 2, SAFE_W)
    ARR = 6.58383          # IO->G5 关键到达时刻 (从 0 时刻 IO 输出算起)

    ff = run_sim(T, 0.0, [0, 0, 0, 0], cycles, stim)
    lt = run_sim(T, W, list(SKEW_LP), cycles, stim)

    fig, axes = plt.subplots(2, 1, figsize=(12, 7.2), sharex=True,
                             gridspec_kw={'hspace': 0.42})
    tmax = (cycles - 1) * T
    bases = {0: 4.4, 1: 3.0, 2: 1.6, 3: 0.2}     # IO, G5, G6, G7 行基线

    def draw(ax, res, title, show_windows):
        for k, y in bases.items():
            sk = res['skew'][k]
            for c in range(cycles):               # 窗口(条) 或 边沿(短线)
                o = sk + c * T
                if o > tmax:
                    break
                if show_windows:
                    ax.add_patch(Rectangle((o, y + 0.5), min(W, tmax - o), 0.26,
                                           facecolor='#a8dadc', edgecolor='#457b9d', lw=0.5))
                else:
                    ax.plot([o, o], [y + 0.5, y + 0.76], color='#457b9d', lw=1.2)
            ts = res['times'][k][1:]              # 输出阶梯 (v=0 -> y, v=1 -> y+0.4)
            vs = res['vals'][k][1:]
            xs, ys = [0.0], [0]
            for t, v in zip(ts, vs):
                xs.append(t); ys.append(v)
            xs.append(tmax); ys.append(ys[-1])
            ax.step(xs, [y + 0.4 * v for v in ys], where='post',
                    color='#1d3557', lw=1.1)
            ax.text(-0.5, y + 0.2, NODES[k], fontsize=9, ha='right', va='center',
                    color='#1d3557')
        ax.axvline(ARR, color='#e76f51', lw=1.1, ls=':')
        ax.text(ARR + 0.06, 5.05, 'IO→G5 到达 %.5f ns' % ARR, fontsize=8.5, color='#e76f51')
        ax.set_yticks([])
        ax.set_ylim(-0.35, 5.55)
        ax.set_xlim(-1.6, tmax + 0.2)
        ax.set_title(title, fontsize=10, loc='left')
        ax.grid(axis='x', alpha=0.2)

    draw(axes[0], ff, '寄存器实现 @ T=6.0ns  (失败: 到达 %.5f 落在 G5 边沿(6.0/12.0)之外的第一整拍, '
         'G5 比 G6 晚看到输入 -> 状态机相位错乱)' % ARR, False)
    draw(axes[1], lt, '锁存器 + LP skew @ T=6.0ns  (通过: 蓝色条 = 透明窗口 [s_k+nT, +W], '
         'W=%.2fns; 迟到的到达落进窗口内被"借时"吸收)' % W, True)
    axes[1].set_xlabel('time (ns)')
    fig.savefig(os.path.join(FIG, 'waveform_T6.png'), dpi=160)
    plt.close(fig)


if __name__ == '__main__':
    main()

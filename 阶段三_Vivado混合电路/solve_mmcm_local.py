"""Stage III: fixed common-clock reduced timing graph for isolated latch stages.

STA has already propagated arrivals through each isolated latch. Eliminate these
arrival variables, retaining both G- and D-launch setup witnesses. No phase is a
decision variable. Not valid for latch chains, retiming, or a changed netlist.
"""
import json
import argparse
import math
import re
import subprocess
from pathlib import Path
from scipy.optimize import linprog
from pack_adjacent import audit, ROOT, NUMBER

SOLVER = Path('E:/大四上/曦源项目/现LatchSTA_Code/latch-STA/阶段二_PDS时钟调度/build_howard_app/pds_howard')
OUT = ROOT / 'stage3'


def wsl(p):
    s = p.resolve().as_posix()
    return '/mnt/' + s[0].lower() + s[2:]


def build(directory, expected_count=25):
    data = audit(directory, expected_count=expected_count)
    kinds = {n['name']: n['primitive'] for n in data['nodes']}
    edges, constants = [], []
    for p in data['paths']:
        src = p['adjacent_start'].rsplit('/', 1)[0]
        dst = p['end'].rsplit('/', 1)[0]
        if kinds.get(src) == kinds.get(dst) == 'LDCE':
            raise ValueError('Latch chains require a full transparent propagation graph')
        if p['status'] != 'OK':
            # Native hold uses G-launch for this isolated high-transparent latch.
            # Keep G min constraints; never invent a D min delay.
            if not (kinds.get(src) == 'LDCE' and p['query_start'] == src + '/D' and p['delay_type'] == 'min'):
                raise ValueError('Unexpected unavailable constraint')
            continue
        k = float(p['REQUIREMENT']) / 10
        margin = float(p['SLACK'])
        evidence = {'path_id': p['id'], 'report': p['report'], 'start': p['query_start'], 'end': p['end'], 'corner': p['corner'], 'check': p['delay_type']}
        if p['delay_type'] == 'min':
            k = -k
        elif kinds.get(dst) == 'LDCE':
            report = Path(p['report']).read_text()
            def value(label):
                m = re.search(re.escape(label) + r':\s*(' + NUMBER + ')', report, re.I)
                if not m:
                    raise ValueError('Missing latch borrowing evidence: ' + p['report'])
                return float(m[1])
            maximum = value('Computed max time borrow')
            borrowed = value('Time borrowed from endpoint')
            # Opening-edge slack is clamped by borrowing. Enforce closing limit.
            margin += maximum - borrowed
            k += .5
            evidence.update(max_borrow_ns=maximum, borrowed_ns=borrowed)
        d = k * 10 - margin
        record = dict(k=k, d_ns=d, evidence=evidence)
        if abs(k) < 1e-9:
            if margin < -.0031:
                raise ValueError('Period cannot repair constant hold failure')
            constants.append(record)
        else:
            if k < 0:
                raise ValueError('Unsupported upper period constraint')
            edges.append(record)
    summary = (directory / 'summary.rpt').read_text()
    row = next(l.split() for l in summary.split('WNS(ns)', 1)[1].splitlines() if re.match(r'^\s*-?\d+\.\d+\s', l))
    edges.append(dict(k=.5, d_ns=5-float(row[8]), evidence={'check': 'minimum_pulse_width', 'report': str(directory / 'summary.rpt')}))
    for i, e in enumerate(edges):
        e.update(id=str(i), u=0, v=0)
    return dict(model='fixed-route-single-clock-isolated-latch-reduced-graph', nodes=['common_clock'], t0_ns=10, edges=edges, constants=constants,
                scope='Only this fixed netlist/routing, 50% duty and existing edge association. STA propagated latch D-arrivals are retained; no independent phase allocation. Candidate needs native STA revalidation.')


def main():
    global ROOT, OUT
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument('--designs', nargs='+', default=['ff', 'mixed_stage1'])
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--out', type=Path, default=OUT)
    parser.add_argument('--expected-count', type=int, default=25)
    args = parser.parse_args()
    ROOT, OUT = args.root.resolve(), args.out.resolve()
    OUT.mkdir(exist_ok=True)
    results = []
    for name in args.designs:
        graph = build(ROOT / name / 'adjacent', expected_count=args.expected_count or None)
        run = OUT / name
        run.mkdir(exist_ok=True)
        (run / 'graph.json').write_text(json.dumps(graph, indent=2), encoding='utf-8')
        file = run / 'constraints.graph'
        file.write_text('\n'.join([f"PDS_GRAPH_V1 1 {len(graph['edges'])} 10"] +
            [f"0 0 {10*e['k']-e['d_ns']:.17g} {2*e['k']:.17g} {e['id']}" for e in graph['edges']]) + '\n')
        proc = subprocess.run(['wsl', '-d', 'Ubuntu', '--', wsl(SOLVER), wsl(file)], capture_output=True, timeout=60)
        (run / 'howard.stdout.json').write_bytes(proc.stdout)
        (run / 'howard.stderr.log').write_bytes(proc.stderr)
        if proc.returncode:
            raise RuntimeError(proc.stdout.decode(errors='replace') + proc.stderr.decode(errors='replace'))
        h = json.loads(proc.stdout)
        lp = linprog([1], A_ub=[[-e['k']] for e in graph['edges']], b_ub=[-e['d_ns'] for e in graph['edges']], bounds=[(0, None)])
        if not lp.success or abs(lp.fun - h['period_ns']) > 1e-6:
            raise ValueError('Howard/LP mismatch')
        result = dict(design=name, howard=h, lp_period_ns=lp.fun, frequency_mhz=1000/lp.fun,
                      critical_edges=[graph['edges'][int(i)] for i in h['cycle']],
                      phase_variables=0, native_validated=False)
        (run / 'result.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
        results.append(result)
    prior = json.loads((OUT / 'results.json').read_text()) if (OUT / 'results.json').exists() else []
    updated = {r['design']: r for r in prior}
    updated.update({r['design']: r for r in results})
    (OUT / 'results.json').write_text(json.dumps(list(updated.values()), indent=2), encoding='utf-8')
    # Existing checkpoint only: native STA above/below graph boundary, no reroute.
    lines = []
    for r in results:
        name = r['design']
        lines += [f'open_checkpoint {{{(ROOT / name / "routed.dcp").as_posix()}}}']
        for tag, delta in [('pass', .01), ('fail', -.01)]:
            period = r['lp_period_ns'] + delta
            report = (OUT / name / (tag + '.rpt')).as_posix()
            lines += [f'create_clock -name common_clock -period {period:.6f} -waveform {{0 {period/2:.6f}}} [get_ports clk_in]',
                      'set_clock_uncertainty 0.2 [get_clocks common_clock]',
                      f'report_timing_summary -delay_type min_max -report_unconstrained -file {{{report}}}']
        lines += ['close_design']
    (OUT / 'validate.tcl').write_text('\n'.join(lines + ['exit']) + '\n')
    print(json.dumps(results, indent=2))


if __name__ == '__main__':
    main()

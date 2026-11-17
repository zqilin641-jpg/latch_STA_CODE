"""Audit native adjacent-pair evidence; retain unsupported queries explicitly.

--log enables a readable audit log. JSON is always written for downstream tools.
This is not a timing graph solver or a proof of general latch transparency.
"""
import argparse
import csv
import json
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent
NUMBER = r"[-+]?\d+(?:\.\d+)?"


def read_tsv(path):
    with path.open(encoding="utf-8-sig", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def audit(directory, expected_count=25):
    nodes = read_tsv(directory / "nodes.tsv")
    rows = read_tsv(directory / "paths.tsv")
    if not nodes or (expected_count is not None and len(nodes) != expected_count) or len({n['clock_net'] for n in nodes}) != 1:
        raise ValueError("Unexpected storage count or multiple clock nets")
    groups = defaultdict(list)
    for row in rows:
        groups[(row['adjacent_start'], row['end'], row['query_start'])].append(row)
        if row['status'] != 'OK':
            continue
        report = directory / f"path_{row['id']}.rpt"
        content = report.read_text(encoding="utf-8", errors="replace")
        row['report'] = str(report)
        row['borrow_terms'] = {}
        for label in ('time borrowed from endpoint', 'time given to startpoint'):
            match = re.search(re.escape(label) + r"\s+(" + NUMBER + r")", content, re.I)
            row['borrow_terms'][label] = float(match[1]) if match else None
        row['library_checks'] = [
            {'arc': m[1], 'signed_increment_ns': float(m[2])}
            for m in re.finditer(r"\((Setup_\S+|Hold_\S+)\)\s+(" + NUMBER + r")", content)
        ]
        maxborrow = re.search(r"(?:computed )?max time borrow\s*:?\s*(" + NUMBER + r")", content, re.I)
        row['max_time_borrow_ns'] = float(maxborrow[1]) if maxborrow else None
        arrival, required, slack = (float(row[k]) for k in ('ARRIVAL_TIME', 'REQUIRED_TIME', 'SLACK'))
        calculated = required - arrival if row['delay_type'] == 'max' else arrival - required
        if abs(calculated - slack) > .0031:
            raise ValueError(f"Slack identity failed: {report}")
    expected = {(c, d) for c in ('Slow', 'Fast') for d in ('max', 'min')}
    for key, values in groups.items():
        if len(values) != 4 or {(v['corner'], v['delay_type']) for v in values} != expected:
            raise ValueError(f"Missing/duplicate corner query: {key}")
        if key[0] == key[2] and any(v['status'] != 'OK' for v in values):
            raise ValueError(f"Missing primary adjacent-pair timing: {key}")
    checks = (directory / 'check_timing.rpt').read_text()
    for label in ('no_clock', 'unconstrained_internal_endpoints', 'multiple_clock', 'loops', 'latch_loops'):
        if f'checking {label} (0)' not in checks:
            raise ValueError(f"Native timing coverage check failed: {label}")
    missing = [{k: r[k] for k in ('id', 'adjacent_start', 'end', 'query_start', 'corner', 'delay_type')}
               for r in rows if r['status'] != 'OK']
    return {
        'schema': 'vivado-adjacent-evidence/v1', 'period_ns': 20, 'duty': .5,
        'scope': 'Fixed routed checkpoint; native all_fanin sequential boundaries and output ports; reset excluded by XDC false path.',
        'primary_pair_count': sum(k[0] == k[2] for k in groups),
        'query_count': len(rows), 'timed_count': len(rows) - len(missing),
        'primary_pair_corner_coverage_complete': True,
        'unavailable_queries': missing,
        'howard_ready': False,
        'remaining': 'Transparent-latch propagation and library/hold semantics must be modeled; unavailable D-start min queries are not zero delays.',
        'nodes': nodes, 'paths': rows,
    }


def main():
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument('--log', action='store_true')
    parser.add_argument('--designs', nargs='+', default=['ff', 'mixed_stage1'])
    args = parser.parse_args()
    summaries = []
    for design in args.designs:
        directory = ROOT / design / 'adjacent'
        data = audit(directory)
        (directory / 'evidence.json').write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding='utf-8')
        summary = {k: data[k] for k in ('primary_pair_count', 'query_count', 'timed_count', 'primary_pair_corner_coverage_complete', 'howard_ready')}
        summary['design'] = design
        summaries.append(summary)
        if args.log:
            lines = [json.dumps(summary, ensure_ascii=False), data['scope'], data['remaining']]
            lines += ['UNAVAILABLE ' + json.dumps(r) for r in data['unavailable_queries']]
            (directory / 'audit.log').write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print(json.dumps(summaries, indent=2))


if __name__ == '__main__':
    main()

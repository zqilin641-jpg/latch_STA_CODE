"""One post-route-guided Pairl-style step on the operation-boundary benchmark.

Protect interface storage; prefer a legal backward move at the path end,
otherwise a forward move at the path head. This is not arbitrary-netlist retiming.
"""
import hashlib
import json
import re
import shutil
from pathlib import Path

BASE = Path(__file__).resolve().parent
SOURCE = BASE/'output_control/ff_output_iob'
ROOT = BASE/'pairl_iteration'
RAW = BASE/'pairl_iteration_raw'
ROOT.mkdir(exist_ok=True)
RAW.mkdir(exist_ok=True)
cuts = [3,6,9,12]
report = SOURCE/'setup.rpt'
selected = None
skipped = []
for block in report.read_text().split('Slack (')[1:]:
    sm = re.search(r'Source:\s*(\S+)',block)
    em = re.search(r'Destination:\s*(\S+)',block)
    if not sm or not em:
        continue
    src, end = sm[1],em[1]
    # Delay- and cycle-preserving word-level transforms only: no isolated-bit move.
    if not end.endswith('/D') or not src.startswith('ff_cut'):
        skipped.append(dict(start=src,end=end,reason='Protected interface/control or unsupported boundary'))
        continue
    dest_match = re.match(r'ff_cut(\d+)_\d+/D',end)
    source_match = re.match(r'ff_cut(\d+)_\d+/C',src)
    if dest_match:
        old = int(dest_match[1])
        pos = cuts.index(old)
        new = old-1
        if pos and cuts[pos-1] < new and old != 12:
            selected = dict(direction='backward',old_cut=old,new_cut=new,start=src,end=end)
    if selected is None and source_match:
        old = int(source_match[1])
        pos = cuts.index(old)
        new = old+1
        if pos+1 < len(cuts) and new < cuts[pos+1]:
            selected = dict(direction='forward',old_cut=old,new_cut=new,start=src,end=end)
    if selected:
        selected['slack_ns'] = float(re.search(r':\s*([-\d.]+)ns',block)[1])
        break
if selected is None:
    raise ValueError('No supported legal boundary move; no candidate emitted')
new_cuts = sorted(selected['new_cut'] if c == selected['old_cut'] else c for c in cuts)
variants = {'sta_retime_ff': {c:'FF' for c in new_cuts},
            'sta_retime_latch': {c:('LATCH' if c==selected['new_cut'] else 'FF') for c in new_cuts}}
(RAW/'variants.json').write_text(json.dumps(variants,indent=2))
for file in ['shared_pins.xdc','shared_pins.tsv']:
    shutil.copy2(BASE/'output_control'/file,RAW/file)
replaced = [f'ff_cut{selected["new_cut"]}_{b:02d}' for b in range(16)]
plan = dict(source_paper='E:/大四上/曦源项目/论文/Pairl-ZKX_FPT25投稿版.pdf',
            paper_rules='Section III-A: post-route critical path, backward-first/forward-fallback retiming, keep best-so-far. Section III-B: selective conversion at critical path boundaries.',
            source_report=str(report), source_sha256=hashlib.sha256(report.read_bytes()).hexdigest(),
            selected=selected, skipped_path_count=len(skipped), skipped_paths=skipped,
            original_cuts=cuts, new_cuts=new_cuts, variants=variants,
            replacement=dict(original_ff_cells_converted=replaced, original_ff_retained=69,
                             compensating_ff_inserted=16, final_ff=85, final_latch=16),
            limits=['Atomic operation-boundary moves in this feed-forward word datapath, not arbitrary LUT/netlist retiming.',
                    'Global IO paths protected; candidate selected from eligible internal paths, not claimed to repair protected IO.',
                    'One iteration, two candidates, retain prior best unless native STA improves.',
                    'Native FDCE/LDCE, not the paper custom VTR/HSPICE configurable hardware.',
                    'Common clock fixed; do not copy earliest-time inequality relaxation as a hold proof.'])
(ROOT/'candidate_plan.json').write_text(json.dumps(plan,indent=2,ensure_ascii=False),encoding='utf-8')
print(json.dumps(selected,indent=2))

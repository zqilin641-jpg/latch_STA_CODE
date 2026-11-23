"""Bounded automatic candidate enumeration; physical costs are measured later."""
import itertools
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent / 'controlled_search'
ROOT.mkdir(exist_ok=True)
def score(cuts):
    boundaries = (0,) + cuts + (12,)
    lengths = [b-a for a, b in zip(boundaries, boundaries[1:])]
    return max(lengths), sum(x*x for x in lengths), cuts

ranked = sorted(itertools.combinations(range(1,12),3), key=score)
variants = {}
for cuts in ranked[:2]:
    variants['ff_'+'_'.join(map(str,cuts))] = {k:'FF' for k in (*cuts,12)}
best = ranked[0]
for latch_cut in best:
    variants[f'latch_at_{latch_cut}'] = {k:('LATCH' if k == latch_cut else 'FF') for k in (*best,12)}
(ROOT/'variants.json').write_text(json.dumps(variants, indent=2))
(ROOT/'search_plan.json').write_text(json.dumps(dict(
    candidate_space_count=len(ranked), physically_selected_count=len(variants),
    rule='Rank FF cut triples by maximum operation count per stage, then sum of squared counts; choose two. Enumerate one latch at each internal cut of the best triple.',
    limitations='Heuristic preselection by operation counts, not physical optimum. Only five candidates. All latches common high-transparent clock. Compensating output FF retained.',
    variants=variants),indent=2))
print(json.dumps(variants, indent=2))

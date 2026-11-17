"""Generate only new isolated-stage candidates; never rebuild existing baselines."""
import json
from pathlib import Path

root = Path(__file__).resolve().parent
base = (root / 'ff/design.v').read_text()
template = (root / 'mixed_stage1/build.tcl').read_text()
manifest = []
for stage in (2, 3):
    name = f'mixed_stage{stage}'
    out = root / name
    out.mkdir(exist_ok=True)
    rtl = base
    for bit in range(5):
        i = 5 * stage + bit
        old = f"FDCE #(.INIT(0)) ff_{i:02}(.D(d{stage}[{bit}]),.Q(q{stage}[{bit}]),.C(clk),.CE(1'b1)"
        new = f"LDCE #(.INIT(0)) latch_{i:02}(.D(d{stage}[{bit}]),.Q(q{stage}[{bit}]),.G(clk),.GE(1'b1)"
        if rtl.count(old) != 1:
            raise ValueError('Unexpected baseline RTL')
        rtl = rtl.replace(old, new)
    (out / 'design.v').write_text(rtl)
    (out / 'timing.xdc').write_text((root / 'ff/timing.xdc').read_text())
    (out / 'build.tcl').write_text(template.replace((root / 'mixed_stage1').as_posix(), out.as_posix()))
    manifest.append(dict(design=name, replaced_stage=stage, ff=20, latch=5, clock_nets=1,
                         expected_latency_cycles=4, baseline_latency_cycles=5,
                         scope='Whole-stage selective replacement; not bitwise retiming or cycle-exact equivalence'))
(root / 'stage3/candidates.json').write_text(json.dumps(manifest, indent=2))
(root / 'stage3/build_candidates.tcl').write_text('\n'.join(
    f'source {{{(root / c["design"] / "build.tcl").as_posix()}}}' for c in manifest) + '\nexit\n')
print(json.dumps(manifest, indent=2))

"""Match final output registers without changing valid output cycles."""
import json
import argparse
import shutil
from pathlib import Path

BASE = Path(__file__).resolve().parent
SOURCE = BASE/'controlled_search'
ROOT = BASE/'output_control'
parser = argparse.ArgumentParser(__doc__)
parser.add_argument('--source', type=Path)
parser.add_argument('--out', type=Path)
args = parser.parse_args()
if args.source:
    SOURCE = args.source.resolve()
if args.out:
    ROOT = args.out.resolve()
ROOT.mkdir(exist_ok=True)
for file in ('shared_pins.xdc','shared_pins.tsv','tb.v'):
    shutil.copy2(SOURCE/file, ROOT/file)
configs = [('ff_output_iob','ff_3_6_9','ff_cut12','op12','q12'),
           ('latch6_output_iob','latch_at_6','alignment_ff','q12','aligned')]
manifest = []
source_manifest = {r['design']:r for r in json.loads((SOURCE/'manifest.json').read_text())}
if args.source:
    configs = [(name,name,'alignment_ff' if False else 'ff_cut12',
                'q12' if False else 'op12','aligned' if False else 'q12')
               for name,item in source_manifest.items()]
for name, original, cellprefix, old_d, old_q in configs:
    out = ROOT/name
    out.mkdir(exist_ok=True)
    rtl = (SOURCE/original/'design.v').read_text()
    # Previous result = v[4] ? final_Q : 0. Register v[3] ? final_D : 0 instead.
    # v[4](n+1)=v[3](n), so visible post-edge data/valid cycles are unchanged.
    marker = f'assign valid_out=v[4]; assign result=v[4]?{old_q}:16\'b0;'
    if rtl.count(marker) != 1:
        raise ValueError('Unexpected output logic')
    rtl = rtl.replace('wire clk;', 'wire [15:0] output_d;\nwire clk;', 1)
    rtl = rtl.replace(marker, f"assign output_d=v[3]?{old_d}:16'b0;\nassign valid_out=v[4]; assign result={old_q};")
    for b in range(16):
        old = f'{cellprefix}_{b:02d}(.D({old_d}[{b}])'
        new = f'output_ff_{b:02d}(.D(output_d[{b}])'
        if rtl.count(old) != 1:
            raise ValueError('Unexpected final storage cell')
        rtl = rtl.replace(old,new)
    (out/'design.v').write_text(rtl)
    xdc = (SOURCE/original/'timing.xdc').read_text()
    xdc += '\nset_property IOB TRUE [get_cells -filter {REF_NAME == FDCE} {output_ff_* valid_ff_04}]\n'
    (out/'timing.xdc').write_text(xdc)
    tcl = (SOURCE/original/'build.tcl').read_text().replace((SOURCE/original).as_posix(),out.as_posix())
    check = f'''set f [open {{{(out/'output_registers.tsv').as_posix()}}} w]
puts $f "cell\\tloc\\tbel\\tref_name\\tiob"
foreach c [lsort [get_cells -filter {{REF_NAME == FDCE}} {{output_ff_* valid_ff_04}}]] {{
    puts $f "$c\\t[get_property LOC $c]\\t[get_property BEL $c]\\t[get_property REF_NAME $c]\\t[get_property IOB $c]"
}}
close $f
'''
    tcl = tcl.replace('close_project',check+'close_project')
    (out/'build.tcl').write_text(tcl)
    item = dict(source_manifest[original],design=name,source_candidate=original,
                output_control='Mask moved before final FF using v[3]; same output sample cycle; request final data/valid registers in IOB')
    manifest.append(item)
(ROOT/'manifest.json').write_text(json.dumps(manifest,indent=2))
(ROOT/'build.tcl').write_text('\n'.join(f'source {{{(ROOT/name/"build.tcl").as_posix()}}}' for name,*_ in configs)+'\nexit\n')
(ROOT/'export.tcl').write_text(f'set export_root {{{ROOT.as_posix()}}}\nset argv {{{" ".join(c[0] for c in configs)}}}\nsource {{{(BASE/"export_adjacent.tcl").as_posix()}}}\n')
print(ROOT)

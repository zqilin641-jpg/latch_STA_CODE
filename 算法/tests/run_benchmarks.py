"""Run only Howard and LP; keep all failures in a CSV summary."""
import csv
import pathlib
import subprocess
import sys

root = pathlib.Path(__file__).resolve().parents[1]
binary = pathlib.Path(sys.argv[1]).resolve()
output = pathlib.Path(sys.argv[2]).resolve()
timeout = float(sys.argv[3]) if len(sys.argv) > 3 else 30.0
pattern = sys.argv[4] if len(sys.argv) > 4 else '*.out'
sources = sorted((root / 'benchmark').glob(pattern))
if not sources:
    raise SystemExit('No benchmark inputs matched')
failures = 0
with output.open('w', newline='', encoding='utf-8') as stream:
    writer = csv.writer(stream)
    writer.writerow(['input', 'mode', 'returncode', 'details'])
    for source in sources:
        for mode in ('baseline', 'duty', 'nonzero', 'override'):
            try:
                proc = subprocess.run([str(binary), str(source), mode],
                                      capture_output=True, text=True, timeout=timeout)
                code, details = proc.returncode, proc.stdout.strip() + proc.stderr.strip()
            except subprocess.TimeoutExpired:
                code, details = 124, f'TIMEOUT ({timeout:g} seconds)'
            failures += code != 0
            writer.writerow([source.name, mode, code, details])
            stream.flush()
            print(source.name, mode, code, details, flush=True)
raise SystemExit(1 if failures else 0)

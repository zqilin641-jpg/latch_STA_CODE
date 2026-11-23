"""Analytic interchange tests, independent of the PDS adapter."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile

binary = sys.argv[1]
with tempfile.TemporaryDirectory() as folder:
    path = Path(folder)/"test.graph"
    def run(text):
        path.write_text(text)
        return subprocess.run([binary,str(path)],capture_output=True,text=True,timeout=20)
    # At T0=10: x1-x0 >= 3; x0-x1 >= 2-T, so T >= 5.
    result = run("PDS_GRAPH_V1 2 2 10\n0 1 -3 0 0\n1 0 8 2 1\n")
    assert result.returncode == 0, result.stdout+result.stderr
    data = json.loads(result.stdout)
    assert abs(data['period_ns']-5) < 1e-9
    assert set(data['cycle']) == {'0','1'}
    assert data['max_violation'] <= 1e-9
    for bad in ("wrong", "PDS_GRAPH_V1 2 1 10\n2 0 1 2 0\n",
                "PDS_GRAPH_V1 2 2 10\n0 1 -3 0 0\n",
                "PDS_GRAPH_V1 1 1 10\n0 0 8 2 bad\n"):
        assert run(bad).returncode == 1
    unsupported = run("PDS_GRAPH_V1 1 1 10\n0 0 1 0 0\n")
    assert unsupported.returncode == 2
    assert json.loads(unsupported.stdout)['period_ns'] is None
print('PDS graph CLI: analytic cycle, invalid input, unsupported-cycle reporting PASS')

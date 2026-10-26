"""Smoke-test reports and exit codes without executing YTO/ELL."""
import pathlib
import subprocess
import sys
import tempfile

root = pathlib.Path(__file__).resolve().parents[1]
binary = pathlib.Path(sys.argv[1]).resolve()
with tempfile.TemporaryDirectory(prefix='howard-cli-') as temp:
    report = pathlib.Path(temp) / 'report.csv'
    def run(source, params):
        return subprocess.run([str(binary), str(source), '2', '100', *params,
                               '--report', str(report)],
                              capture_output=True, text=True, timeout=30)
    success = run(root / 'benchmark/s27.blif.out', ['0.1'] * 4 + ['0.4'])
    assert success.returncode == 0, success.stdout + success.stderr
    assert 'Howard/LP validation: PASS' in success.stdout
    assert 'Howard certificate: max violation=' in success.stdout
    assert 'cyclic SCCs: 1' in success.stdout
    assert report.is_file() and report.stat().st_size > 0
    saved = report.read_bytes()
    for setup, hold in [('-0.012', '0.1'), ('0.1', '-0.014'), ('-0.012', '-0.014')]:
        signed = run(root / 'benchmark/s27.blif.out', [setup, hold, '0.1', '0.1', '0.4'])
        assert signed.returncode == 0, signed.stdout + signed.stderr
        assert 'Howard/LP validation: PASS' in signed.stdout
    node_file = pathlib.Path(temp) / 'nodes.txt'
    node_file.write_text('A -0.012 -0.014 0.1 0.1\n')
    signed = run(root / 'tests/fixtures/self.out', ['0'] * 4 + ['0.4', str(node_file)])
    assert signed.returncode == 0, signed.stdout + signed.stderr
    saved = report.read_bytes()
    for values in [('nan', '0', '0', '0'), ('inf', '0', '0', '0'),
                   ('oops', '0', '0', '0'), ('0', '0', '-0.1', '0'),
                   ('0', '0', '0', '-0.1')]:
        invalid = run(root / 'tests/fixtures/self.out', [*values, '0.4'])
        assert invalid.returncode == 1, invalid.stdout + invalid.stderr
        assert report.read_bytes() == saved
        node_file.write_text('A ' + ' '.join(values) + '\n')
        invalid = run(root / 'tests/fixtures/self.out', ['0'] * 4 + ['0.4', str(node_file)])
        assert invalid.returncode == 1, invalid.stdout + invalid.stderr
        assert report.read_bytes() == saved
    failed = run(root / 'tests/fixtures/empty.out', ['0'] * 4 + ['0.4'])
    assert failed.returncode == 2, failed.stdout + failed.stderr
    assert 'Howard=NoCycle' in failed.stderr and 'LP=InputError' in failed.stderr
    assert 'Howard diagnostics:' in failed.stderr
    assert 'SUMMARY' not in failed.stdout
    assert report.read_bytes() == saved, 'Failed run overwrote the previous report'
    report.unlink()
    failed = run(root / 'tests/fixtures/empty.out', ['0'] * 4 + ['0.4'])
    assert failed.returncode == 2 and not report.exists()
    zero = run(root / 'tests/fixtures/zero.out', ['0'] * 4 + ['0.4'])
    assert zero.returncode == 0, zero.stdout + zero.stderr
print('CLI PASS: signed setup/hold, node overrides, invalid parameters, report preservation, zero-delay boundary')

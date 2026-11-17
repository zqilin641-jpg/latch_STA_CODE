import shutil
import tempfile
import unittest
from pathlib import Path
from pack_adjacent import ROOT, audit


class CoverageTests(unittest.TestCase):
    def test_native_evidence(self):
        ff = audit(ROOT / 'ff/adjacent')
        mixed = audit(ROOT / 'mixed_stage1/adjacent')
        self.assertEqual(ff['primary_pair_count'], 50)
        self.assertEqual(mixed['primary_pair_count'], 50)
        self.assertEqual(len(mixed['unavailable_queries']), 10)
        self.assertTrue(any(p.get('borrow_terms', {}).get('time given to startpoint')
                            for p in mixed['paths']))
        self.assertFalse(mixed['howard_ready'])

    def test_missing_primary_query_rejected(self):
        with tempfile.TemporaryDirectory() as temp:
            target = Path(temp) / 'adjacent'
            shutil.copytree(ROOT / 'ff/adjacent', target)
            path = target / 'paths.tsv'
            lines = path.read_text().splitlines()
            path.write_text('\n'.join(lines[:1] + lines[2:]) + '\n')
            with self.assertRaisesRegex(ValueError, 'Missing/duplicate'):
                audit(target)

    def test_corrupted_slack_rejected(self):
        with tempfile.TemporaryDirectory() as temp:
            target = Path(temp) / 'adjacent'
            shutil.copytree(ROOT / 'ff/adjacent', target)
            path = target / 'paths.tsv'
            lines = path.read_text().splitlines()
            fields = lines[0].split('\t')
            row = lines[1].split('\t')
            row[fields.index('SLACK')] = '-999'
            lines[1] = '\t'.join(row)
            path.write_text('\n'.join(lines) + '\n')
            with self.assertRaisesRegex(ValueError, 'Slack identity'):
                audit(target)


if __name__ == '__main__':
    unittest.main()

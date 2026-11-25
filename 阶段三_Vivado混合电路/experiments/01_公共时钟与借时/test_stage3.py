import unittest
from stage3_solve import build, ROOT


class MixedGraphTests(unittest.TestCase):
    def test_borrowing_is_not_zero_setup_margin(self):
        g = build(ROOT / 'mixed_stage1/adjacent')
        latch_setup = [e for e in g['edges'] if 'borrowed_ns' in e['evidence']]
        self.assertTrue(latch_setup)
        self.assertTrue(all(e['k'] == .5 for e in latch_setup))
        self.assertTrue(all(20 * e['k'] - e['d_ns'] > 0 for e in latch_setup))

    def test_hold_is_not_optimized_as_a_free_phase(self):
        g = build(ROOT / 'mixed_stage1/adjacent')
        self.assertEqual(g['nodes'], ['common_clock'])
        hold = [e for e in g['constants'] if e['evidence']['check'] == 'min']
        self.assertTrue(hold)
        self.assertTrue(all(e['d_ns'] <= 0 for e in hold))

    def test_latch_late_data_witness_retained(self):
        g = build(ROOT / 'mixed_stage1/adjacent')
        self.assertTrue(any(e['evidence'].get('start', '').startswith('latch_')
                            and e['evidence']['start'].endswith('/D') for e in g['edges']))


if __name__ == '__main__':
    unittest.main()

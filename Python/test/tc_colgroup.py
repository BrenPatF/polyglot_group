import unittest
import os
from col_group import *
#
# assert fail stops subsequent asserts in same test_ method
# unittest does not support data-driven (parameterized) tests
#
INPUT_FILE = '../../Input/ut_group.csv'
global lines, exp_asis, expK, expVdelim, col
delim = [',', ';;']
col = [2, 0]
lines = ["0,1,Cc,3\n00,1,A,9\n000,1,B,27\n0000,1,A,81\n",
	      "X;;1;;A\nX;;1;;A\n"]
exp_asis = [3, 2]
expK = [("A",2),("Bx",1),("Cc",1)], [("X",2)]
expV = [("B",1),("Cc",1),("A",2)], [("X",2)]

def _setup_each(i):
    with open(INPUT_FILE, 'w') as the_file:
        the_file.write(lines[i])
    global grp
    grp = ColGroup(INPUT_FILE, delim[i], col[i])

class TestColGroup(unittest.TestCase):
 
    def tearDown(self):
        os.remove(INPUT_FILE)

    def _do_test_asis(self, i):
        _setup_each(i)
        self.assertEqual(exp_asis[i], len(grp.list_as_is()), 'Count rows')
    def _do_test_by_key(self, i):
        _setup_each(i)
        self.assertEqual(expK[i], grp.sort_by_key(), 'Compare tuple-lists for key-sorting')
    def _do_test_by_value_IG(self, i):
        _setup_each(i)
        self.assertEqual(expV[i], grp.sort_by_value_IG(), 'Compare tuple-lists for value_IG-sorting')
    def _do_test_by_value_lambda(self, i):
        _setup_each(i)
        self.assertEqual(expV[i], grp.sort_by_value_lambda(), 'Compare tuple-lists for value_lambda-sorting')

    def test_asis_0(self):
        self._do_test_asis(0)
    def test_asis_1(self):
        self._do_test_asis(1)
    def test_by_key_0(self):
        self._do_test_by_key(0)
    def test_by_key_1(self):
        self._do_test_by_key(1)
    def test_by_value_IG_0(self):
        self._do_test_by_value_IG(0)
    def test_by_value_IG_1(self):
        self._do_test_by_value_IG(1)
    def test_by_value_lambda_0(self):
        self._do_test_by_value_lambda(0)
    def test_by_value_lambda_1(self):
        self._do_test_by_value_lambda(1)

if __name__ == '__main__':
    unittest.main()

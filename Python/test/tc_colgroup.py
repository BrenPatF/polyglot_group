import unittest
import os
from colgroup import *
'''*************************************************************************************************
Name: tc_colgroup.py                   Author: Brendan Furey                       Date: 22-Oct-2016

Python component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    |  Col Group  |  Utils      |
| *Tester* |             |  Timer Set  |
========================================

Unit test program.

Notes:
- assert fail stops subsequent asserts in same test_ method
- unittest does not support data-driven (parameterized) tests
- get as close as possible by putting test data into arrays, then have driving tests pass an array
index to a private testing method per method to be tested
- two scenarios: (1) 1-char delimiter, column 2 counted
                 (2) 2-char delimiter, column 0 counted
- use scenario-indexed arrays for test data and expected values
- 4 methods x 2 scenarios = 8 tests
- 2 tests fail deliberately by incorrect expected values for illustration purposes

*************************************************************************************************'''
INPUT_FILE = '../../Input/ut_group.csv'
global lines, exp_asis, expK, col

# setup data indexed by scenario
delim = [',', ';;']
col = [2, 0]
lines = ["0,1,Cc,3\n00,1,A,9\n000,1,B,27\n0000,1,A,81\n",
          "X;;1;;A\nX;;1;;A\n"]

# expected values for as is list just counts, with arrays of 2-tuples for sorted lists
exp_asis = [3, 2] # 2 is deliberately wrong, 1 is the correct value
expK = [("A",2),("Bx",1),("Cc",1)], [("X",2)] # Bx is deliberately wrong, B is the correct value
expV = [("B",1),("Cc",1),("A",2)], [("X",2)]

'''*************************************************************************************************

_setup_each: Per scenario, writes the test data to the file and constructs the ColGroup instance

*************************************************************************************************'''
def _setup_each(i): # scenario index
    with open(INPUT_FILE, 'w') as the_file:
        the_file.write(lines[i])
    return ColGroup(INPUT_FILE, delim[i], col[i])

'''*************************************************************************************************

TestColGroup: Test class, unittest package calls all methods starting with "test"

*************************************************************************************************'''
class TestColGroup(unittest.TestCase):

    '''************************************************************************************************

    tearDown: Removes test input file, called by unittest package

    ************************************************************************************************'''
    def tearDown(self):
        os.remove(INPUT_FILE)

    '''************************************************************************************************

    _do_test_*: Per scenario, calls private setup method and asserts actual against expected for method
                tested

    ************************************************************************************************'''
    def _do_test_asis(self, i): # scenario index
        self.assertEqual(exp_asis[i], len(_setup_each(i).list_as_is()), 'Count rows')
    def _do_test_by_key(self, i): # scenario index
        self.assertEqual(expK[i], _setup_each(i).sort_by_key(), 'Compare tuple-lists for key-sorting')
    def _do_test_by_value_IG(self, i): # scenario index
        self.assertEqual(expV[i], _setup_each(i).sort_by_value_IG(), 'Compare tuple-lists for value_IG-sorting')
    def _do_test_by_value_lambda(self, i): # scenario index
        self.assertEqual(expV[i], _setup_each(i).sort_by_value_lambda(), 'Compare tuple-lists for value_lambda-sorting')

    '''************************************************************************************************

    test_*: Test driver methods, called by unittest; separate method per scenario and per method
            tested - ensures failure does not abort the testing; private _do_test* is called passing
            scenario index

    ************************************************************************************************'''
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

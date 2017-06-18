require "colgroup"
#require "active_support/test_case"
require "test/unit"
require "fileutils"
'''*************************************************************************************************
Name: tc_colgroup.rb                   Author: Brendan Furey                       Date: 22-Oct-2016

Ruby component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: "Oracle and JUnit Data Driven Testing: An Example" on the Oracle and Java components,
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
- test/unit does not support data-driven (parameterized) tests
- get as close as possible by putting test data into arrays, then have driving tests
pass an array index to a private testing method per method to be tested
- two scenarios: (1) 1-char delimiter, column 2 counted
                 (2) 2-char delimiter, column 0 counted
- use scenario-indexed arrays for test data and expected values
- 3 methods x 2 scenarios = 6 tests
- 2 tests fail deliberately by incorrect expected values for illustration purposes

- space before ( fails
- $ = global, @ instance variables

*************************************************************************************************'''
INPUT_FILE = '../../Input/ut_group.csv'

# setup data indexed by scenario
$delim = [',', ';;']
$col = [2, 0]
$lines = ["0,1,Cc,3\n00,1,A,9\n000,1,B,27\n0000,1,A,81\n",
          "X;;1;;A\nX;;1;;A\n"]

# expected values for as is list just counts, with arrays of 2-tuples for sorted lists
$exp_asis = [3, 2] # 2 is deliberately wrong, 1 is the correct value
$expK = [["A",2],["Bx",1],["Cc",1]], [["X",2]] # Bx is deliberately wrong, B is the correct value
$expV = [["B",1],["Cc",1],["A",2]], [["X",2]]

class TestColGroup < Test::Unit::TestCase
  '''*************************************************************************************************

  setup_each: Per scenario, writes the test data to the file and constructs the ColGroup instance

  *************************************************************************************************'''
  def setup_each(i) # scenario index

    open(INPUT_FILE, 'w') { |f| f << $lines[i] }
    return ColGroup.new(INPUT_FILE, $delim[i], $col[i])

  end
  '''************************************************************************************************

  tearDown: Removes test input file, called by test/unit package

  ************************************************************************************************'''
  def teardown

    File.delete INPUT_FILE

  end
  '''************************************************************************************************

  do_test_*: Per scenario, calls private setup method and asserts actual against expected for method
             tested

  ************************************************************************************************'''
  def do_test_asis(i) # scenario index

    assert_equal($exp_asis[i], setup_each(i).list_as_is.size, 'Count rows')

  end
  def do_test_by_key(i) # scenario index

    assert_equal($expK[i], setup_each(i).sort_by_key, 'Compare tuple-lists for key-sorting')

  end
  def do_test_by_value(i) # scenario index

    assert_equal($expV[i], setup_each(i).sort_by_value, 'Compare tuple-lists for value-sorting')

  end

  '''************************************************************************************************

  test_*: Test driver methods, called by unittest; separate method per scenario and per method
          tested - ensures failure does not abort the testing; private _do_test* is called passing
          scenario index

  ************************************************************************************************'''
  def test_asis_0; do_test_asis(0) end
  def test_asis_1; do_test_asis(1) end
  def test_bykey_0; do_test_by_key(0) end
  def test_bykey_1; do_test_by_key(1) end
  def test_byvalue_0; do_test_by_value(0) end
  def test_byvalue_1; do_test_by_value(1) end

end

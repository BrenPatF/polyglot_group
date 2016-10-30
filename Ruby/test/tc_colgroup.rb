require "colgroup"
#require "active_support/test_case"
require "test/unit"
require "fileutils"
#
# sp before ( fails
# assert fail stops subsequent asserts in same test_ method
# $ = global, @ instance variables
# test/unit does not support data-driven (parameterized) tests
#
INPUT_FILE = '../../Input/ut_group.csv'
$delim = [',', ';;']
$col = [2, 0]
$lines = ["0,1,Cc,3\n00,1,A,9\n000,1,B,27\n0000,1,A,81\n",
	      "X;;1;;A\nX;;1;;A\n"]
$exp_asis = [3, 2]
$expK = [["A",2],["Bx",1],["Cc",1]], [["X",2]]
$expV = [["B",1],["Cc",1],["A",2]], [["X",2]]

class TestColGroup < Test::Unit::TestCase

  def setup_each(i)

    open(INPUT_FILE, 'w') { |f| f << $lines[i] }
    @grp = ColGroup.new(INPUT_FILE, $delim[i], $col[i])

  end
  def teardown

	File.delete INPUT_FILE

  end

  def do_test_asis(i)

	setup_each(i)
    assert_equal($exp_asis[i], @grp.list_as_is.size, 'Count rows')

  end

  def do_test_by_key(i)

	setup_each(i)
    assert_equal($expK[i], @grp.sort_by_key, 'Compare tuple-lists for key-sorting')

  end

  def do_test_by_value(i)

	setup_each(i)
    assert_equal($expV[i], @grp.sort_by_value, 'Compare tuple-lists for value-sorting')

  end

  def test_asis_0; do_test_asis(0) end
  def test_asis_1; do_test_asis(1) end
  def test_bykey_0; do_test_by_key(0) end
  def test_bykey_1; do_test_by_key(1) end
  def test_byvalue_0; do_test_by_value(0) end
  def test_byvalue_1; do_test_by_value(1) end

end

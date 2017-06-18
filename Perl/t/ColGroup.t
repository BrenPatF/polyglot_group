use strict; use warnings;
use ColGroup;
use Test::More 'no_plan';
####################################################################################################
# Name: ColGroup.t                     Author: Brendan Furey                       Date: 22-Oct-2016
#
# Perl component of polyglot project: a simple file-reading and group-counting module, with main
# program, unit testing program, code timing and general utility packages, implemented in multiple
# languages for learning purposes: https://github.com/BrenPatF/polyglot_group
#
# See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
# http://aprogrammerwrites.eu/?p=1860
#
# ========================================
# |  Driver  |  Class/API  |  Utility    |
# ===========|=============|==============
# |  Main    |  Col Group  |  Utils      |
# | *Tester* |             |  Timer Set  |
# ========================================
#
# Unit test program.
#
####################################################################################################
my $INPUT_FILE = '../../Input/ut_group.csv';

# setup data indexed by scenario
my @delim = (',', ';;');
my @col = (2, 0);
my @lines = ("0,1,Cc,3\n00,1,A,9\n000,1,B,27\n0000,1,A,81", "X;;1;;A\nX;;1;;A\n");

# expected values for as is list just counts, with arrays of 2-tuples for sorted lists
my @expA = (3, 2);
my @expK = ([["A",2],["Bx",1],["Cc",1]], [["X",2]]);
my @expV = ([["B",1],["Cc",1],["A",2]], [["X",2]]);

####################################################################################################
#
# setup: Per scenario, writes the test data to the file and constructs the ColGroup instance
#
####################################################################################################
sub setup { # scenario index
  my $test_num = shift;
  print ("Setup\n");
  open(my $fh, '>', $INPUT_FILE) or die "Could not open file '$INPUT_FILE' $!";
  print $fh $lines[$test_num];
  close $fh;
  return new ColGroup ($INPUT_FILE, $delim[$test_num], $col[$test_num]);
}
####################################################################################################
#
# test_one: Per scenario, asserts actual against expected for each method tested
#
####################################################################################################
sub test_one { # scenario index, group object
  my $test_num = shift;
  my $grp = shift;

  is (@{$grp->listAsIs()}, $expA[$test_num], "listAsIs");
  is_deeply ($grp->sortByKey(), $expK[$test_num], "sortByKey");
  is_deeply ($grp->sortByValue(), $expV[$test_num], "sortByValue");
}
####################################################################################################
#
# main section: Per scenario, calls setup and test_one to do testing of all methods
#
####################################################################################################
for my $i (0 .. $#lines) {
  print "Test number ".$i."\n";
  test_one ($i, setup ($i));
}
unlink ($INPUT_FILE) or die "Could not unlink $INPUT_FILE, $!";

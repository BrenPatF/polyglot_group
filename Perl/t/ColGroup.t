use strict; use warnings;
use ColGroup;
use Test::More 'no_plan';

my $INPUT_FILE = '../../Input/ut_group.csv';
my @delim = (',', ';;');
my @col = (2, 0);
my @lines = ("0,1,Cc,3\n00,1,A,9\n000,1,B,27\n0000,1,A,81", "X;;1;;A\nX;;1;;A\n");
my @expK = ([["A",2],["Bx",1],["Cc",1]], [["X",2]]);
my @expV = ([["B",1],["Cc",1],["A",2]], [["X",2]]);
my @expA = (3, 2);

sub setup {
  my $test_num = shift;
  print ("Setup\n");
  open(my $fh, '>', $INPUT_FILE) or die "Could not open file '$INPUT_FILE' $!";
  print $fh $lines[$test_num];
  close $fh;
  return new ColGroup ($INPUT_FILE, $delim[$test_num], $col[$test_num]);
}
sub test_one {
  my $test_num = shift;
  my $grp = shift;

  is (@{$grp->listAsIs()}, $expA[$test_num], "listAsIs");
  is_deeply ($grp->sortByKey(), $expK[$test_num], "sortByKey");
  is_deeply ($grp->sortByValue(), $expV[$test_num], "sortByValue");
}
for my $i (0 .. $#lines) {
  print "Test number ".$i."\n";
  my $grp = setup ($i);
  test_one ($i, $grp);
}
unlink ($INPUT_FILE) or die "Could not unlink $INPUT_FILE, $!";

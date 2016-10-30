use strict; use warnings;
use Utils;

heading "My heading";

my @heads;
#$heads[0]=["col 1", -6];
#$heads[1]=["c2", 4];
@heads=(["col 1", -6],["c2", 4]);
for my $i (0..$#heads) {
    printf ("%s\t%d\n", $heads[$i]->[0], $heads[$i]->[1]);
}
colHeaders (\@heads);
totLines;

package ColGroup; require Exporter; @ISA = qw(Exporter); @EXPORT = qw(new writeGroups); 
####################################################################################################
# Name: ColGroup.pm                      Author: Brendan Furey                       Date: 22-Oct-2016
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
# |  Main    | *Col Group* |  Utils      |
# |  Tester  |             |  Timer Set  |
# ========================================
# 
# Object reads delimited lines from file, and counts values in a given column, with methods to return
# or print the counts in various orderings.
#
####################################################################################################
use strict; use warnings;
use Utils;

my $max_len;
my ($num_rows, @cells, @master_indexes);
####################################################################################################
#
# new: Constructor sets the key-value map of (string, count), via _readList
#
####################################################################################################
sub new { # input file, field delimiter, 0-based column index
    my $class = shift;
    my ($file, $delim, $col) = @_;
    return bless {&_readList ($file, $delim, $col)};
}
####################################################################################################
#
# _readList: Private function returns the key-value map of (string, count)
#
####################################################################################################
sub _readList { # input file, field delimiter, 0-based column index
    my ($file, $delim, $col) = @_;
    my %counter;
    print "Opening file $file\n";
    open (DAT, $file) || die "Could not open file $!";
    foreach (<DAT>) {
        my $val = (split (/$delim/, $_))[$col];
        $counter{$val}++;
    }
    close (DAT);
    $max_len = maxList (keys %counter);
    return %counter;
}
####################################################################################################
#
# prList: Prints the key-value list of (string, count) tuples, with sort method in heading
#
####################################################################################################
sub prList { # sort by label, key-value list of (string, count)
    my ($this, $sort_by, $ref) = @_;
    heading ('Sorting by '.$sort_by);
    colHeaders([['Team',-$max_len], ['#apps',5]]);
    my @grp_list = @{$ref};
    foreach my $f (@grp_list) {
        printf(sprintf("%-".$max_len."s  %5s\n", $f->[0], $f->[1]));
    }
}
####################################################################################################
#
# listAsIs: Returns the key-value list of (string, count) tuples unsorted
#
####################################################################################################
sub listAsIs {
    my $this = shift;
    return [map { ([$_, ${$this}{$_}]) } keys %{$this}];
}
####################################################################################################
#
# sortByKey, sortByValue: Returns the key-value list of (string, count) sorted by key or value
#
####################################################################################################
sub sortByKey {
    my $this = shift;
    return [map { ([$_, ${$this}{$_}]) } sort keys %{$this}];
}
sub sortByValue {
    my $this = shift;
    return [map { ([$_, ${$this}{$_}]) } sort { ${$this}{$a} <=> ${$this}{$b} || $a cmp $b } keys %{$this}];
}
1;

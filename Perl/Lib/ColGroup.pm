package ColGroup; require Exporter; @ISA = qw(Exporter); @EXPORT = qw(new writeGroups); 
use strict; use warnings;
use Utils;

my $max_len;
my ($num_rows, @cells, @master_indexes);
sub new {
    my $class = shift;
    my ($file, $delim, $col) = @_;
    return bless {&_readList ($file, $delim, $col)};
}

sub _readList {
    my ($file, $delim, $col, $offset) = @_;
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
sub prList {
	my ($this, $sort_by, $ref) = @_;
    heading ('Sorting by '.$sort_by);
    colHeaders([['Team',-$max_len], ['#apps',5]]);
	my @grp_list = @{$ref};
	foreach my $f (@grp_list) {
		printf(sprintf("%-".$max_len."s  %5s\n", $f->[0], $f->[1]));
	}
}
sub listAsIs {
    my $this = shift;
	return [map { ([$_, ${$this}{$_}]) } keys %{$this}];
}
sub sortByKey {
    my $this = shift;
	return [map { ([$_, ${$this}{$_}]) } sort keys %{$this}];
}
sub sortByValue {
    my $this = shift;
	return [map { ([$_, ${$this}{$_}]) } sort { ${$this}{$a} <=> ${$this}{$b} || $a cmp $b } keys %{$this}];
}
1;

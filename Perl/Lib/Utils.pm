package Utils; require Exporter; @ISA = qw(Exporter); @EXPORT = qw(formInt indent heading shortTime maxList now colHeaders totLines prListAsLine); 

use List::Util (max);
use strict; use warnings;
our $INDENT = 2;
my $spaces = '                                                            ';
my @lines;

sub formInt {
    my $int = shift;
    my $str = sprintf ("%d", $int);
    $str =~ s/(\d{1,3}?)(?=(\d{3})+$)/$1,/g;
#   print "str2 = $str\n";
    return $str;
}
sub indent {
    my ($str, $level, $maxlen) = @_;
    return sprintf ("%-$maxlen".'s', substr ($spaces, 0, $level * $INDENT).$str);
}
sub heading {
    my @str = @_;
    print "\n";
    printf "%s\n", join ('   ', @str);
    my $equals = join '|||', @str;
    $equals =~ s/[^|]/=/g;
    $equals =~ s/[|]/ /g;
    print "$equals\n";
}
sub maxList {
    return max (map { length } @_);
}

sub shortTime {
    my $t = shift;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
    if (defined $t) {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime ($t);
    } else {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
    }
    return sprintf "%02s/%02s/%02s %02s:%02s:%02s", $mday, ($mon+1), ($year-100), $hour, $min, $sec;
}
sub now {
    my $tm = localtime;
    return $tm;
}
sub prListAsLine {
	printf("%s\n", join "  ", @_);
}
sub totLines {
	prListAsLine (@lines);
}
sub colHeaders {
	my $x = shift;
	my @hdrs = @{$x};
    for my $i (0..$#hdrs) {
		$lines[$i] = sprintf "%".$hdrs[$i]->[1]."s", $hdrs[$i]->[0]
    }
	prListAsLine (@lines);
	for my $i (0..$#lines) {
		$lines[$i] =~ s/./-/g;
	}
	prListAsLine (@lines);
}
1;

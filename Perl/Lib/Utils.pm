package Utils; require Exporter; @ISA = qw(Exporter); @EXPORT = qw(formInt indent heading shortTime maxList now colHeaders totLines prListAsLine); 
####################################################################################################
# Name: Utils.pm                       Author: Brendan Furey                       Date: 22-Oct-2016
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
# |  Main    |  Col Group  |  *Utils*    |
# |  Tester  |             |  Timer Set  |
# ========================================
# 
# Class for general utility methods.
#
####################################################################################################
use List::Util (max);
use strict; use warnings;
our $INDENT = 2;
my $spaces = '                                                            ';
my @lines;

####################################################################################################
#
# formInt: Formats an integer
#
####################################################################################################
sub formInt { # integer
    my $int = shift;
    my $str = sprintf ("%d", $int);
    $str =~ s/(\d{1,3}?)(?=(\d{3})+$)/$1,/g;
    return $str;
}
####################################################################################################
#
# indent: Indents a string with spaces to a given length
#
####################################################################################################
sub indent { # string, indent level, length to allocate
    my ($str, $level, $maxlen) = @_;
    return sprintf ("%-$maxlen".'s', substr ($spaces, 0, $level * $INDENT).$str);
}
####################################################################################################
#
# heading: Prints a title with "=" underlining to its length, preceded by a blank line. Perl version
#          can take array of heading strings and separate by spaces
#
####################################################################################################
sub heading { # array of heading strings
    my @str = @_;
    print "\n";
    printf "%s\n", join ('   ', @str);
    my $equals = join '|||', @str;
    $equals =~ s/[^|]/=/g;
    $equals =~ s/[|]/ /g;
    print "$equals\n";
}
####################################################################################################
#
# maxList: Returns maximum length of string in a list of strings
#
####################################################################################################
sub maxList { # array of stings
    return max (map { length } @_);
}

####################################################################################################
#
# shortTime: Returns formatted datetime; uses passed value if any, else current datetime
#
####################################################################################################
sub shortTime { # datetime
    my $t = shift;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
    if (defined $t) {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime ($t);
    } else {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
    }
    return sprintf "%02s/%02s/%02s %02s:%02s:%02s", $mday, ($mon+1), ($year-100), $hour, $min, $sec;
}
####################################################################################################
#
# now: Returns current time
#
####################################################################################################
sub now {
    my $tm = localtime;
    return $tm;
}
####################################################################################################
#
# prListAsLine: Prints an array of strings as one line, separating fields by a 2-space delimiter
#
####################################################################################################
sub prListAsLine { # array of strings
	printf("%s\n", join "  ", @_);
}
####################################################################################################
#
# totLines: Reprints the line of underlines for a set of columns last printed, used for before/after
#           summary line
#
####################################################################################################
sub totLines {
	prListAsLine (@lines);
}
####################################################################################################
#
# col_headers: Prints a set of column headers, input as array of value, length/justification tuples
#
####################################################################################################
sub colHeaders { # array of value, length/justification tuples
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

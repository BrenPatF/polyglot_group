use strict; use warnings;
use ColGroup;
use TimerSet;
use Utils;
####################################################################################################
# Name: MainGroup.pl                   Author: Brendan Furey                       Date: 22-Oct-2016
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
# | *Main*   |  Col Group  |  Utils      |
# |  Tester  |             |  Timer Set  |
# ========================================
#
# Main program calling the ColGroup class to read delimited lines from file, count values in a given
# column, and print the counts in various orderings. TimerSet times the method calls and prints the
# timings at the end.
#
####################################################################################################
my $timer = new TimerSet("Group Counter");

my $input_file='../../Input/fantasy_premier_league_player_stats.csv';

my $grp = new ColGroup($input_file, ',', 6);
$timer->incrementTime ("Open");

$grp->prList("(as is)", $grp->listAsIs());
$timer->incrementTime ("listAsIs");

$grp->prList("key", $grp->sortByKey());
$timer->incrementTime ("sortByKey");

$grp->prList("value", $grp->sortByValue());
$timer->incrementTime ("sortByValue");

$timer->writeTimes;



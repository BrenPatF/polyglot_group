use strict; use warnings;
use ColGroup;
use TimerSet;
use Utils;
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



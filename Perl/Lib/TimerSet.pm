package TimerSet; require Exporter; @ISA = qw(Exporter); @EXPORT = qw(today); # this allows today to be called without package prefix, TimerSet::
my ($maxName, $selfEla, $selfUsr, $selfSys, $selfCalls);
my ($CALLS_WIDTH, $TIME_WIDTH, $TIME_DP, $TIME_RATIO_DP, $TOT_TIMER, $OTH_TIMER, $SELF_RANGE) = (10, 8, 2, 5, 'Total', '(Other)', 10000);

use strict; use warnings;
use Time::HiRes qw( gettimeofday );
use List::Util qw( min max );
use Utils;

my @timeList;

sub new {
    my $setname = $_[1];
    my $this = [];
    bless $this;
    &_getTimes;
    $this->[0] = {};                     # Row 0 stores the hash of indexes for the timer names
    $this->[1] = [@timeList, @timeList, $setname]; # Row 1, first 3 are prior times; second 3 are start times; last is set name
    return $this;
}
sub initTime {

    my $this = shift;
    &_getTimes;
    for (my $i = 0; $i < 3; $i++) {
        $this->[1]->[$i] = $timeList[$i];
    }
}
sub incrementTime {

    my ($this, $key) = @_;
    &_getTimes;
    my $ind;
    if (exists $this->[0]->{$key}){
        $ind = $this->[0]->{$key};
    } else {
        $ind = $#{$this} + 1;
        $this->[0]->{$key} = $ind;
        $this->[$ind]->[0] = $key;
        $this->[$ind]->[4] = 0;
    }
    for (my $i = 0; $i < 3; $i++) {
        $this->[$ind]->[$i+1] += $timeList[$i] - $this->[1]->[$i];
        $this->[1]->[$i] = $timeList[$i];
    }
    $this->[$ind]->[4] += 1;
}
sub getTimer {

    my ($this, $key) = @_;
    my $ind;
    if (exists $this->[0]->{$key}){
        $ind = $this->[0]->{$key};
		return ($this->[$ind]->[1], $this->[$ind]->[2], $this->[$ind]->[3], $this->[$ind]->[4]);
    } else {
		return (0, 0, 0, 0);
    }
}
sub _getTimes {
    my ($user, $system, $cuser, $csystem) = times;
    @timeList = (scalar gettimeofday, $user + $cuser, $system + $csystem);
}
sub curStats {
    my $this = shift;
    return ($this->[2]->[1], $this->[2]->[2], $this->[2]->[3], $this->[2]->[4]);
}
sub _formTime {
    my ($t, $dp)  = @_;
    my $width = 8 + $dp;
    my $dpfm = '%'.$width.".$dp".'f';
#   return sprintf "   %11.3f", shift;
    return sprintf "$dpfm", $t;
}
sub _formTimeTrim {
    my $trim = _formTime (@_);
    $trim =~ s/ //g;
    return $trim;
}
sub _formCalls {
    my $calls = shift;
    return sprintf "%10s", formInt($calls);
}
sub _formName {
    my ($name, $maxlen) = @_;
    return sprintf "%-$maxlen".'s', $name;
}
sub _writeTimeLine {
    my ($timer, $ela, $usr, $sys, $calls) = @_;
    prListAsLine ((   &_formName ($timer, $maxName),
            &_formTime ($ela, 2),
            &_formTime ($usr + $sys, 2), 
            &_formTime ($usr, 2), 
            &_formTime ($sys, 2),
            &_formCalls ($calls),
            &_formTime ($ela/$calls, 5),
            &_formTime (($usr + $sys)/$calls, 5)));
    if ($timer ne "***" && ($usr + $sys)/$calls < 10 * ($selfUsr + $selfSys) && ($usr + $sys) > 0.1) {
        _writeTimeLine ("***", $ela - $calls*$selfEla, $usr - $calls*$selfUsr, $sys - $calls*$selfSys, $calls);
    }
}
sub writeTimes {

    my $this = shift;
    &_getTimes;

	my @totTim;
    for (my $i=0; $i < 3; $i++) {
        $totTim[$i] = $timeList[$i] - $this->[1]->[$i+3];
    }
    $maxName = max (7, maxList (keys %{$this->[0]}));
    my $setName = "Timer Set: $this->[1]->[6]";

    my $selfTimer = new TimerSet ('self');
    for (my $i=0; $i < 10000; $i++) {
        $selfTimer->incrementTime ('x');
    }
    ($selfEla, $selfUsr, $selfSys, $selfCalls) = $selfTimer->getTimer('x');
    heading ("$setName, constructed at ".shortTime ($this->[1]->[3]).", written at ".substr (shortTime, 9));
    print '[Timer timed: Elapsed (per call): ' . _formTimeTrim ($selfEla, 2) . ' (' . _formTimeTrim ($selfEla/$selfCalls, 6) . 
    '), CPU (per call): ' . _formTimeTrim ($selfUsr + $selfSys, 2) . ' (' . _formTimeTrim(($selfUsr + $selfSys)/$selfCalls, 6) . '), calls: ' . $selfCalls . ", '***' denotes corrected line below]";
    $selfEla /= $selfCalls; $selfUsr /= $selfCalls; $selfSys /= $selfCalls;
    print "\n\n";
	colHeaders ([(["Timer", -$maxName],
			["Elapsed", $TIME_WIDTH+$TIME_DP],
			["CPU", $TIME_WIDTH+$TIME_DP],
			["= User", $TIME_WIDTH+$TIME_DP],
			["+ System", $TIME_WIDTH+$TIME_DP],
			["Calls", $CALLS_WIDTH],
			["Ela/Call", $TIME_WIDTH+$TIME_RATIO_DP],
			["CPU/Call", $TIME_WIDTH+$TIME_RATIO_DP])]);

    my @sumTime = (0, 0, 0, 0);
    for (my $i=2; $i < @$this; $i++) {
        my @curTime = ($this->[$i]->[1], $this->[$i]->[2], $this->[$i]->[3], $this->[$i]->[4]);
        for (my $j = 0; $j < 4; $j++) {
            $sumTime[$j] += $curTime[$j];
        }
        _writeTimeLine ($this->[$i]->[0], $curTime[0], $curTime[1], $curTime[2], $curTime[3]);
    }
    _writeTimeLine ('(Other)', $totTim[0] - $sumTime[0], $totTim[1] - $sumTime[1], $totTim[2] - $sumTime[2], 1);
    totLines;
    _writeTimeLine ('Total', $totTim[0], $totTim[1], $totTim[2], $sumTime[3] + 1);
    totLines;
}
sub today {
    printf "Today it's %s\n", now;
}
1;


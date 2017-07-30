"use strict";
/***************************************************************************************************
Name: TimerSet.js                      Author: Brendan Furey                       Date: 30-Jul-2017

Javascript (Nodejs) component of polyglot project: a simple file-reading and group-counting module,
 with main program, unit testing program, code timing and general utility packages, implemented in
 multiple languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    |  Col Group  |  Utils      |
|  Tester  |             | *Timer Set* |
========================================

TimerSet class to facilitate code timing.

***************************************************************************************************/
const os = require ('os');
const Utils = require ('./Utils.js');
const [CALLS_WIDTH, TIME_WIDTH, TIME_DP, TIME_RATIO_DP, TOT_TIMER, OTH_TIMER, SELF_RANGE, TIME_FACTOR] = [10, 8, 2, 5, 'Total', '(Other)', 10000, 1000];
var timerTimes;

/***************************************************************************************************

_getTimes: Gets CPU and elapsed times using system calls and return in object

***************************************************************************************************/
function _getTimes () {
    let usr = 0, sys = 0;
    const ela = +new Date();
	const cpus = os.cpus();

    for (var cpu of cpus) {
        usr += cpu.times.user;
        sys += cpu.times.sys;
    }
    return {ela : ela, usr : usr / cpus.length, sys : sys / cpus.length};
}
/***************************************************************************************************

_form*: Formatting methods that return formatted times and other values as strings

***************************************************************************************************/
function _formTime (t, dp) { // time, decimal places to print
    return Utils.rJust ((t / TIME_FACTOR).toFixed (dp), TIME_WIDTH + dp);
};
function _formTimeTrim (t, dp) { // time, decimal places to print
    return _formTime (t, dp).trim();
};
function _formName (name, maxName) { // timer name, maximum timer name length
    return Utils.lJust (name, maxName);
};
function _formCalls (calls) { // timer name, maximum timer name length
    return Utils.rJust (calls.toString(), CALLS_WIDTH);
};
/***************************************************************************************************

writeTimeLine: Writes a formatted timing line
  Parameters: timer name, maximum timer name length, elapsed, cpu times, number of calls to timer

***************************************************************************************************/
function _writeTimeLine (timer, maxName, ela, usr, sys, calls) {
    Utils.prListAsLine ([_formName(timer,     maxName),			
                         _formTime(ela,       TIME_DP),
                         _formTime(usr,       TIME_DP),
                         _formTime(sys,       TIME_DP),
                         _formCalls(calls),
                         _formTime(ela/calls, TIME_RATIO_DP),
                         _formTime(usr/calls, TIME_RATIO_DP),
                         _formTime(sys/calls, TIME_RATIO_DP)]);
	const cpu = usr + sys;
	if (timer != "***" && cpu/calls < 10 * (timerTimes.usr + timerTimes.sys) && cpu > 0.1) {
		_writeTimeLine ("***", maxName, ela - calls*timerTimes.ela, usr - calls*timerTimes.usr , sys - calls*timerTimes.sys, calls);
	};
};

class TimerSet {

	/***************************************************************************************************

	TimerSet: Constructor sets the timer set name and initialises the instance timing arrays

	***************************************************************************************************/
    constructor (timerSetName) { // timer set name
        this.timerSetName = timerSetName;
        this.timBeg = _getTimes();
        this.timPri = this.timBeg;
        this.timerHash = new Map();
        this.stime = Date().substring(0,24);
    }

	/***************************************************************************************************

	initTime: Initialises (or resets) the instance timing array

	***************************************************************************************************/
    initTime() {
        this.timPri = _getTimes();
    };

	/***************************************************************************************************

	incrementTime: Increments the timing accumulators for a timer set and timer

	***************************************************************************************************/
    incrementTime (timerName) { // timer name

        const initHashVal = {ela : 0, usr : 0, sys : 0, calls : 0};
        const curTim = _getTimes();
        const curHashVal = this.timerHash.get (timerName) || initHashVal;
        this.timerHash.set(timerName, { ela:   curHashVal.ela + curTim.ela - this.timPri.ela,
                                        usr:   curHashVal.usr + curTim.usr - this.timPri.usr,
                                        sys:   curHashVal.sys + curTim.sys - this.timPri.sys,
                                        calls: curHashVal.calls + 1
                                      });
        this.initTime();
    };

	/***************************************************************************************************

	writeTimes: Writes a report of the timings for the timer set

	***************************************************************************************************/
    writeTimes() {
        const tim = _getTimes();
        const totTim = {ela : tim.ela - this.timBeg.ela, usr : tim.usr - this.timBeg.usr, sys : tim.sys - this.timBeg.sys};

		const timerTimer = new TimerSet ('timer');
		for (let i = 0; i < SELF_RANGE; i++) { timerTimer.incrementTime('x'); };
		timerTimes = timerTimer.timerHash.get('x');

		const maxName = Utils.maxLen (this.timerHash);
        Utils.heading ("Timer set: " + this.timerSetName + ", constructed at " + this.stime + ", written at " + Date().substring(0,24));

		console.log ('[Timer timed: Elapsed (per call): ' + _formTimeTrim(timerTimes.ela, TIME_DP) + ' (' + _formTimeTrim(timerTimes.ela/timerTimes.calls, TIME_RATIO_DP) +
        '), USR (per call): ' + _formTimeTrim(timerTimes.usr, TIME_DP) + ' (' + _formTimeTrim(timerTimes.usr/timerTimes.calls, TIME_RATIO_DP) +
        '), SYS (per call): ' + _formTimeTrim(timerTimes.sys, TIME_DP) + ' (' + _formTimeTrim(timerTimes.sys/timerTimes.calls, TIME_RATIO_DP) +
        '), calls: ' + timerTimes.calls + ', "***" denotes corrected line below]', "\n");
		timerTimes.ela /= timerTimes.calls;
		timerTimes.usr /= timerTimes.calls;
		timerTimes.sys /= timerTimes.calls;

        const unders = Utils.colHeaders ( [{name: 'Timer',    len: -maxName},
                                           {name: 'Elapsed',  len: TIME_WIDTH+TIME_DP},
                                           {name: 'USR',      len: TIME_WIDTH+TIME_DP},
                                           {name: 'SYS',      len: TIME_WIDTH+TIME_DP},
                                           {name: 'Calls',    len: CALLS_WIDTH},
                                           {name: 'Ela/Call', len: TIME_WIDTH+TIME_RATIO_DP},
                                           {name: 'USR/Call', len: TIME_WIDTH+TIME_RATIO_DP},
                                           {name: 'SYS/Call', len: TIME_WIDTH+TIME_RATIO_DP}]);

        const sumTim = Array.from (this.timerHash.values()).reduce (function (t, s) { return {ela : t.ela + s.ela, usr : t.usr + s.usr, sys : t.sys + s.sys, calls : t.calls + s.calls}; });

        for (let e of this.timerHash.entries()) {
            _writeTimeLine (e[0], maxName, e[1].ela, e[1].usr, e[1].sys, e[1].calls);
        };
        _writeTimeLine (OTH_TIMER, maxName, totTim.ela - sumTim.ela, totTim.usr - sumTim.usr, totTim.sys - sumTim.sys, 1);
        console.log(unders);
        _writeTimeLine (TOT_TIMER, maxName, totTim.ela, totTim.usr, totTim.sys, sumTim.calls + 1);
        console.log(unders);
    };
};

module.exports = TimerSet;
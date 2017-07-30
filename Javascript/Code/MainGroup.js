"use strict";
/***************************************************************************************************
Name: MainGroup.js                     Author: Brendan Furey                       Date: 30-Jul-2017

Javascript (Nodejs) component of polyglot project: a simple file-reading and group-counting module,
with mainprogram, unit testing program, code timing and general utility packages, implemented in 
multiple languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
| *Main*   |  Col Group  |  Utils      |
|  Tester  |             |  Timer Set  |
========================================

Main program calling the ColGroup class to read delimited lines from file, count values in a given
column, and print the counts in various orderings. TimerSet times the method calls and prints the
timings at the end.

***************************************************************************************************/
const Utils = require ('../Lib/Utils.js');
const ColGroup = require ('../Lib/ColGroup.js');
const TimerSet = require ('../Lib/TimerSet.js');
const INPUT_FILE = '../../Input/fantasy_premier_league_player_stats.csv', DELIM =',', COL = 6;
Utils.heading ('input file is ' + INPUT_FILE);

let x = new TimerSet ('Timer_x');
let grp = new ColGroup (INPUT_FILE, DELIM, COL);
x.incrementTime ('ColGroup');

grp.prList('(as is)', grp.listAsIs());
x.incrementTime ('listAsIs');

grp.prList('key', grp.sortByKey());
x.incrementTime ('sortByKey');

grp.prList('value', grp.sortByValue());
x.incrementTime ('sortByValue');
x.writeTimes();
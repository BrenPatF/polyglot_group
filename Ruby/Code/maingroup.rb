require "colgroup"
require "timerset"
require "utils"
'''*************************************************************************************************
Name: maingroup.rb                     Author: Brendan Furey                       Date: 22-Oct-2016

Ruby component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: "Oracle and JUnit Data Driven Testing: An Example" on the Oracle and Java components,
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

*************************************************************************************************'''

x = Timerset.new('Timer_x')
(INPUT_FILE, DELIM, COL) = '../../Input/fantasy_premier_league_player_stats.csv', ',', 6
grp = ColGroup.new(INPUT_FILE, DELIM, COL)
x.increment_time ('ColGroup')

grp.pr_list('(as is)', grp.list_as_is)
x.increment_time ('list_as_is')

grp.pr_list('key', grp.sort_by_key)
x.increment_time ('sort_by_key')

grp.pr_list('value', grp.sort_by_value)
x.increment_time ('sort_by_value')
x.write_times

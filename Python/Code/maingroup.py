from colgroup import *
from timerset import *
from utils import *
'''*************************************************************************************************
Name: maingroup.py                     Author: Brendan Furey                       Date: 22-Oct-2016

Python component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

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

*************************************************************************************************'''
x = TimerSet('Timer_x')

(input_file, delim, col) = '../../Input/fantasy_premier_league_player_stats.csv', ',', 6

grp = ColGroup(input_file, delim, col)
x.increment_time ('ColGroup')

grp.pr_list('(as is)', grp.list_as_is())
x.increment_time ('list_as_is')

grp.pr_list('key', grp.sort_by_key())
x.increment_time ('sort_by_key')

grp.pr_list('value (item_getter)', grp.sort_by_value_IG())
x.increment_time ('sort_by_valueIG')

grp.pr_list('value (lambda)', grp.sort_by_value_lambda())
x.increment_time ('sort_by_value_lambda')

x.write_times()

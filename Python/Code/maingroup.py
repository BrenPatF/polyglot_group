from col_group import *
from timer_set import *
from utils import *
x = TimerSet('Timer_x')

(input_file, delim, col) = '../../Input/fantasy_premier_league_player_stats.csv', ',', 6

grp = ColGroup(input_file, delim, col)
x.increment_time ('ColGroup')

grp.pr_list('(as is)', grp.list_as_is())
x.increment_time ('list_as_is')

grp.pr_list('(as is)', grp.sort_by_key())
x.increment_time ('sort_by_key')

grp.pr_list('(as is)', grp.sort_by_value_IG())
x.increment_time ('sort_by_valueIG')

grp.pr_list('(as is)', grp.sort_by_value_lambda())
x.increment_time ('sort_by_value_lambda')

x.write_times()

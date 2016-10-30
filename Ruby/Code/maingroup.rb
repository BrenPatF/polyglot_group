require "colgroup"
require "timerset"
require "utils"

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

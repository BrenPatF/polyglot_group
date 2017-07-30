require "utils"
'''*************************************************************************************************
Name: timerset.rb                      Author: Brendan Furey                       Date: 22-Oct-2016

Ruby component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: "Oracle and JUnit Data Driven Testing: An Example"on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    |  Col Group  |  Utils      |
|  Tester  |             | *Timer Set* |
========================================

TimerSet class to facilitate code timing.

*************************************************************************************************'''
# Constants are display lengths, decimal places and labels, plus number of times to call self-timer
CALLS_WIDTH, TIME_WIDTH, TIME_DP, TIME_RATIO_DP, TOT_TIMER, OTH_TIMER, SELF_RANGE = 10, 8, 2, 5, 'Total', '(Other)', 10000
timer_times =[]

'''*************************************************************************************************

_getTimes: Gets CPU and elapsed times using system calls and returns as tuple

*************************************************************************************************'''
def _get_times
  return Time.now, Process.times.utime+Process.times.cutime, Process.times.stime+Process.times.cstime
end

'''*************************************************************************************************

_form*: Formatting methods that return formatted times and other values as strings

*************************************************************************************************'''
def _form_name(name, max_name) # timer name, maximum timer name length
  sprintf("%#{-max_name}s", name)
end
def _form_time(t, dp) # time, decimal places to print
  sprintf("%#{TIME_WIDTH + dp}.#{dp}f", t)
end
def _form_time_trim(t, dp) # time, decimal places to print
  _form_time(t, dp).lstrip()
end
def _form_calls(calls) # number of calls to timer
  sprintf("%#{CALLS_WIDTH}d", calls)
end

'''*************************************************************************************************

_write_time_line: Writes a formatted timing line
  Parameters: timer name, maximum timer name length, elapsed, cpu times, number of calls to timer

*************************************************************************************************'''
def _write_time_line(timer, max_name, ela, usr, sys, calls)
  Utils.pr_list_as_line (  [_form_name(timer, max_name),
                      _form_time(ela, TIME_DP),
                      _form_time(usr, TIME_DP),
                      _form_time(sys, TIME_DP),
                      _form_calls(calls),
                      _form_time(ela/calls, TIME_RATIO_DP),
                      _form_time(usr/calls, TIME_RATIO_DP),
                      _form_time(sys/calls, TIME_RATIO_DP)])
  cpu = usr + sys
  if timer != "***" && cpu/calls < 10 * ($timer_times[1] + $timer_times[2]) && cpu > 0.1
    _write_time_line("***", max_name, ela - calls*$timer_times[0], usr - calls*$timer_times[1] , sys - calls*$timer_times[2], calls)
  end
end

class Timerset

  attr_reader :timer_hash
  '''************************************************************************************************

  initialize: Constructor function, which sets the timer set name and initialises the instance timing
              variables

  ************************************************************************************************'''
  def initialize(timer_set_name) # timer set name
    @timer_set_name = timer_set_name
    @n_times = -1
    @timer_hash = Hash.new([0,0,0,0])
    @ela_time_start, @usr_time_start, @sys_time_start = _get_times
    @ela_time_prior, @usr_time_prior, @sys_time_prior = @ela_time_start, @usr_time_start, @sys_time_start
    @stime = Time.now()
  end

  '''************************************************************************************************

  init_time: Initialises (or resets) the instance timing array

  ************************************************************************************************'''
  def init_time
    @ela_time_prior, @usr_time_prior, @sys_time_prior = _get_times()
  end

  '''************************************************************************************************

  increment_time: Increments the timing accumulators for a timer

  ************************************************************************************************'''
  def increment_time(timer_name) # timer name

    ela_dif, usr_dif, sys_dif = _get_times()
    ela_dif -= @ela_time_prior
    usr_dif -= @usr_time_prior
    sys_dif -= @sys_time_prior

    cur_hash = @timer_hash[timer_name]
    @timer_hash[timer_name] = [cur_hash[0] + ela_dif, cur_hash[1] + usr_dif, cur_hash[2] + sys_dif, cur_hash[3] + 1]
    init_time()
  end

  '''************************************************************************************************

  write_times: Writes a report of the timings for the timer set

  ************************************************************************************************'''
  def write_times
    ela_dif, usr_dif, sys_dif = _get_times()
    tot_tim = [ela_dif - @ela_time_start, usr_dif - @usr_time_start, sys_dif - @sys_time_start]
    timer_timer = Timerset.new('timer')
    SELF_RANGE.times {
        timer_timer.increment_time('x')
    }
    $timer_times = timer_timer.timer_hash['x']
    max_name = [(@timer_hash.keys.max_by(&:length)).length, OTH_TIMER.length].max
    Utils.heading ("Timer set: " + @timer_set_name + ", constructed at "+@stime.to_s+
                                   ", written at "+Time.now().to_s)
    print('[Timer timed: Elapsed (per call): ' + _form_time_trim($timer_times[0], TIME_DP) + ' (' + _form_time_trim($timer_times[0]/$timer_times[3], TIME_RATIO_DP) +
        '), USR (per call): ' + _form_time_trim($timer_times[1], TIME_DP) + ' (' + _form_time_trim($timer_times[1]/$timer_times[3], TIME_RATIO_DP) +
        '), SYS (per call): ' + _form_time_trim($timer_times[2], TIME_DP) + ' (' + _form_time_trim($timer_times[2]/$timer_times[3], TIME_RATIO_DP) +
        '), calls: ' + ($timer_times[3]).to_s + ', "***" denotes corrected line below]', "\n\n")
    $timer_times[0] /= $timer_times[3]
    $timer_times[1] /= $timer_times[3]
    $timer_times[2] /= $timer_times[3]
    print('')
    Utils.col_headers ([['Timer',    -max_name],
                        ['Elapsed',  TIME_WIDTH+TIME_DP],
                        ['USR',      TIME_WIDTH+TIME_DP],
                        ['SYS',      TIME_WIDTH+TIME_DP],
                        ['Calls',    CALLS_WIDTH],
                        ['Ela/Call', TIME_WIDTH+TIME_RATIO_DP],
                        ['USR/Call', TIME_WIDTH+TIME_RATIO_DP],
                        ['SYS/Call', TIME_WIDTH+TIME_RATIO_DP]])

    sum_tim = @timer_hash.values.reduce ([0,0,0,0]) { |s, t|
      [s[0]+t[0], s[1]+t[1], s[2]+t[2], s[3]+t[3]]
    }
    @timer_hash.each { |k, v|
      _write_time_line(k, max_name, v[0], v[1], v[2], v[3])
    }
    _write_time_line(OTH_TIMER, max_name, tot_tim[0] - sum_tim[0], tot_tim[1] - sum_tim[1], tot_tim[2] - sum_tim[2], 1)
    Utils.tot_lines
    _write_time_line(TOT_TIMER, max_name, tot_tim[0], tot_tim[1], tot_tim[2], sum_tim[3]+1)
    Utils.tot_lines

  end
end


from time import process_time, perf_counter
from functools import reduce
from utils import *
import datetime
import collections
'''*************************************************************************************************
Name: timerset.py                      Author: Brendan Furey                       Date: 22-Oct-2016

Python component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
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
def _get_times():
    return process_time(), perf_counter()

'''*************************************************************************************************

_form*: Formatting methods that return formatted times and other values as strings

*************************************************************************************************'''
def _form_name (name, max_name): # timer name, column length as maximum timer name length
    return ('{0:'+str(max_name)+'s}').format(name)
def _form_time (t, dp): # time, decimal places to print
    return ('{0:'+str(TIME_WIDTH + dp)+'.'+ str(dp)+'f}').format(t)
def _form_time_trim (t, dp): # time, decimal places to print
    return _form_time(t, dp).lstrip()
def _form_calls (calls): # number of calls to timer
    return ('{0:'+str(CALLS_WIDTH)+'d}').format(calls)

'''*************************************************************************************************

_write_time_line: Writes a formatted timing line
  Parameters: timer name, maximum timer name length, elapsed, cpu times, number of calls to timer

*************************************************************************************************'''
def _write_time_line(timer, max_name, ela, cpu, calls):
    global timer_times
    pr_list_as_line (  [_form_name (timer, max_name),
                        _form_time (ela, TIME_DP),
                        _form_time (cpu, TIME_DP),
                        _form_calls (calls),
                        _form_time (ela/calls, TIME_RATIO_DP),
                        _form_time (cpu/calls, TIME_RATIO_DP)])
    if timer != "***" and cpu/calls < 10 * timer_times[2] and cpu > 0.1:
        _writeTimeLine ("***", max_name, ela - calls*timer_times[1], cpu - calls*timer_times[2], calls)

class TimerSet:

    '''************************************************************************************************

    __init__: Constructor function, which sets the timer set name and initialises the instance timing
              variables

    ************************************************************************************************'''
    def __init__(self, timer_set_name): # timer set name
        self.timer_set_name = timer_set_name
        self.n_times = -1
        self.timer_hash = collections.OrderedDict()
        self.ela_time_start, self.cpu_time_start = _get_times()
        self.ela_time_prior, self.cpu_time_prior = self.ela_time_start, self.cpu_time_start
        self.stime = datetime.datetime.now()

    '''************************************************************************************************

    init_time: Initialises (or resets) the instance timing array

    ************************************************************************************************'''
    def init_time (self):
        self.ela_time_prior, self.cpu_time_prior = _get_times()

    '''************************************************************************************************

    increment_time: Increments the timing accumulators for a timer

    ************************************************************************************************'''
    def increment_time (self, timer_name): # timer name

        ela_dif, cpu_dif = _get_times()
        ela_dif -= self.ela_time_prior
        cpu_dif -= self.cpu_time_prior

        cur_hash = self.timer_hash.get(timer_name, [0, 0, 0])
        self.timer_hash[timer_name] = [cur_hash[0] + ela_dif, cur_hash[1] + cpu_dif, cur_hash[2] + 1]
        self.init_time()

    '''************************************************************************************************

    write_times: Writes a report of the timings for the timer set

    ************************************************************************************************'''
    def write_times(self):
        ela_dif, cpu_dif = _get_times()
        tot_tim = [ela_dif - self.ela_time_start, cpu_dif - self.cpu_time_start]

        global timer_times
        timer_timer = TimerSet('timer')
        for i in range(0, SELF_RANGE):
            timer_timer.increment_time ('x')
        timer_times = timer_timer.timer_hash['x']

        max_name = max (len(max(self.timer_hash.keys(),key=len)), len(OTH_TIMER))
        heading ("Timer set: " + self.timer_set_name + ", constructed at "+datetime.datetime.strftime(self.stime, '%Y-%m-%d %H:%M:%S')+
                                       ", written at "+datetime.datetime.strftime(datetime.datetime.now(), '%Y-%m-%d %H:%M:%S'))
        print ('[Timer timed: Elapsed (per call): ' + _form_time_trim (timer_times[0], TIME_DP) + ' (' + _form_time_trim (timer_times[0]/timer_times[2], TIME_RATIO_DP) +
            '), CPU (per call): ' + _form_time_trim (timer_times[1], TIME_DP) + ' (' + _form_time_trim(timer_times[1]/timer_times[2], TIME_RATIO_DP) +
            '), calls: ' + str(timer_times[2]) + ', "***" denotes corrected line below]')
        timer_times[0] /= timer_times[2]
        timer_times[1] /= timer_times[2]
        print ('')
        col_headers ([['Timer',    -max_name],
                      ['Elapsed',  TIME_WIDTH+TIME_DP],
                      ['CPU',      TIME_WIDTH+TIME_DP],
                      ['Calls',    CALLS_WIDTH],
                      ['Ela/Call', TIME_WIDTH+TIME_RATIO_DP],
                      ['CPU/Call', TIME_WIDTH+TIME_RATIO_DP]])

        sum_tim = reduce((lambda s, t: [s[0]+t[0],s[1]+t[1],s[2]+t[2]]), self.timer_hash.values())
        for k, v in self.timer_hash.items():
            _write_time_line (k, max_name, v[0], v[1], v[2])
        _write_time_line(OTH_TIMER, max_name, tot_tim[0] - sum_tim[0], tot_tim[1] - sum_tim[1], 1)
        tot_lines ()
        _write_time_line(TOT_TIMER, max_name, tot_tim[0], tot_tim[1], sum_tim[2]+1)
        tot_lines ()

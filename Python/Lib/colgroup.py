from operator import itemgetter
from utils import *
'''*************************************************************************************************
Name: colgroup.py                      Author: Brendan Furey                       Date: 22-Oct-2016

Python component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    | *Col Group* |  Utils      |
|  Tester  |             |  Timer Set  |
========================================

Object reads delimited lines from file, and counts values in a given column, with methods to return
or print the counts in various orderings.

****************************************************************************************************

_readList: Private function returns the key-value map of (string, count)

*************************************************************************************************'''
def _readList(input_file, delim, col): # input file, field delimiter, 0-based column index
    counter = {}
    print("Opening file "+input_file)
    with open(input_file) as f:
        for line in f:
            val = line.split (delim)[col]
            counter[val] = counter.get(val, 0) + 1 # +=1 doesn't work
    return counter

class ColGroup:

    '''************************************************************************************************

    __init__: Constructor sets the key-value map of (string, count), via _readList, and the maximum key
              length

    ************************************************************************************************'''
    def __init__(self, input_file, delim, col): # input file, field delimiter, 0-based column index
        self.counter = _readList (input_file, delim, col)
        global max_len
        max_len = len(max(self.counter.keys(), key=len))

    '''************************************************************************************************

    pr_list: Prints the key-value list of (string, count) tuples, with sort method in heading

    ************************************************************************************************'''
    def pr_list(self, sort_by, key_values): # sort method, key-value list of (string, count)
        heading ('Counts sorted by '+sort_by)
        col_headers([['Team',-max_len], ['#apps',5]])
        for k, v in key_values:
            print(('{0:<'+str(max_len)+'s}  {1:5d}').format(k, v))

    '''************************************************************************************************

    list_as_is: Returns the key-value list of (string, count) tuples unsorted

    ************************************************************************************************'''
    def list_as_is(self):
        return [(k, v) for k, v in self.counter.items()]

    '''************************************************************************************************

    sort_by_key: Returns the key-value list of (string, count) tuples sorted by key

    ************************************************************************************************'''
    def sort_by_key(self):
        return [(k, v) for k, v in sorted(self.counter.items())]

    '''************************************************************************************************

    sort_by_value_*: Returns the key-value list of (string, count) tuples sorted by value, by lambda
                     and itemgetter methods

    ************************************************************************************************'''
    def sort_by_value_lambda(self):
        return [(k, v) for k, v in sorted(self.counter.items(), key=lambda item : (item[1],item[0]))]

    def sort_by_value_IG(self):
        return [(k, v) for k, v in sorted(self.counter.items(), key=itemgetter(1,0))]


'''*************************************************************************************************
Name: utils.py                         Author: Brendan Furey                       Date: 22-Oct-2016

Python component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    |  Col Group  |  *Utils*    |
|  Tester  |             |  Timer Set  |
========================================

Class for general utility methods.

*************************************************************************************************'''
names_list = []
'''*************************************************************************************************

heading: Prints a title with "=" underlining to its length, preceded by a blank line

*************************************************************************************************'''
def heading (title): # heading string
    print ("")
    print (title)
    print ("="*len(title))

'''*************************************************************************************************

pr_list_as_line: Prints an array of strings as one line, separating fields by a 2-space delimiter

*************************************************************************************************'''
def pr_list_as_line (pr_list): # array of strings to print as line
    print ('  '.join (pr_list))

'''*************************************************************************************************

col_headers: Prints a set of column headers, input as array of value, length/justification tuples

*************************************************************************************************'''
def col_headers (col_names): # array of value, length/justification tuples
    global names_list
    del names_list[:]
    for c in col_names:
        fmt = '>' + str(c[1])
        if c[1] < 0:
            fmt = '<' + str(-c[1])
        names_list.append (('{0:'+fmt+'}').format(c[0]))
    pr_list_as_line (names_list)
    del names_list[:]
    for c in col_names:
        names_list.append ("-"*abs(c[1]))
    pr_list_as_line (names_list)

'''*************************************************************************************************

tot_lines: Reprints the line of underlines for a set of columns last printed, used for before/after
           summary line

*************************************************************************************************'''
def tot_lines ():
    pr_list_as_line (names_list)


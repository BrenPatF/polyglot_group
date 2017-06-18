module Utils
'''*************************************************************************************************
Name: utils.rb                         Author: Brendan Furey                       Date: 22-Oct-2016

Ruby component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: "Oracle and JUnit Data Driven Testing: An Example" on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    |  Col Group  |  *Utils*    |
|  Tester  |             |  Timer Set  |
========================================

Class for general utility methods.

*************************************************************************************************'''

  $names_list = []
  '''*************************************************************************************************

  heading: Prints a title with "=" underlining to its length, preceded by a blank line

  *************************************************************************************************'''
  def Utils.heading(title) # heading string
    puts("")
    puts(title)
    puts("="*title.length)
  end

  '''*************************************************************************************************

  pr_list_as_line: Prints an array of strings as one line, separating fields by a 2-space delimiter

  *************************************************************************************************'''
  def Utils.pr_list_as_line(pr_list) # array of strings to print as line
    print(pr_list.join('  '), "\n")
  end

  '''*************************************************************************************************

  col_headers: Prints a set of column headers, input as array of value, length/justification tuples

  *************************************************************************************************'''
  def Utils.col_headers(col_names) # array of value, length/justification tuples

    $names_list.clear
    col_names.each {|c|
      $names_list.push(sprintf("%#{c[1]}s", c[0]))
    }
    pr_list_as_line($names_list)
    $names_list.clear
    col_names.each {|c|
      $names_list.push("-"*(c[1]).abs)
    }
    pr_list_as_line($names_list)
  end

  '''*************************************************************************************************

  tot_lines: Reprints the line of underlines for a set of columns last printed, used for before/after
             summary line

  *************************************************************************************************'''
  def Utils.tot_lines
    pr_list_as_line($names_list)
  end

  '''*************************************************************************************************

  max_len: Returns maximum length of string in a list of strings

  *************************************************************************************************'''
  def Utils.max_len(stringlist) # list of strings
    stringlist.max_by(&:length).length
  end

end


require "utils"
'''*************************************************************************************************
Name: colgroup.rb                      Author: Brendan Furey                       Date: 22-Oct-2016

Ruby component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: "Oracle and JUnit Data Driven Testing: An Example" on the Oracle and Java components,
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
def _readList(input_file, delim, col) # input file, field delimiter, 0-based column index
  counter = Hash.new(0)
  Utils.heading(input_file)
  x = File.open(input_file, "r") { |file|
    file.each {|line|
      val = line.split(delim)[col]
      counter[val] += 1
    }
  }
  return counter
end

class ColGroup
  '''************************************************************************************************

  initialize: Constructor sets the key-value map of (string, count), via _readList, and the maximum
              key length

  ************************************************************************************************'''
  def initialize(input_file, delim, col) # input file, field delimiter, 0-based column index
    @counter = _readList(input_file, delim, col)
    @max_len=Utils.max_len(@counter.keys)
  end
  '''************************************************************************************************
  pr_list: Prints the key-value list of (string, count) tuples, with sort method in heading

  ************************************************************************************************'''
  def pr_list(sort_by, key_values) # sort by label, key-value list of (string, count)
    
    Utils.heading ('Counts sorted by '+sort_by)
    Utils.col_headers([['Team',-@max_len], ['#apps',5]])
    key_values.each {|k,v|
      puts(sprintf("%-"+@max_len.to_s+"s  %5s", k, v.to_s))
    }

  end
  '''************************************************************************************************

  list_as_is: Returns the key-value list of (string, count) tuples unsorted

  ************************************************************************************************'''
  def list_as_is
    return @counter.map {|k,v|
      [k,v]
    }
  end
  '''************************************************************************************************

  sort_by_key, sort_by_value: Returns the key-value list of (string, count) sorted by key or value

  ************************************************************************************************'''
  def sort_by_key
    return @counter.sort
  end
  def sort_by_value
    return @counter.sort_by {|k, v| [v, k]}
  end
end


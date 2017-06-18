package colgroup
/***************************************************************************************************
Name: ColGroup.scala                   Author: Brendan Furey                       Date: 22-Oct-2016

Scala component of polyglot project: a simple file-reading and group-counting module, with main
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

***************************************************************************************************/
import utils.Utils
import scala.io.Source

/***************************************************************************************************

ColGroup: Implicit constructor sets the key-value list of (string, count), and the maximum key length

***************************************************************************************************/
class ColGroup (input_file:     String, // file name, including path
                delim:          String, // field delimiter
                col:            Int) {  // column number of values to be counted
  val source = Source.fromFile(input_file)
  val counts = (for (line <- source.getLines()) yield line.split(delim)(col)).toList.groupBy((x) => x).mapValues(_.size).toList
  source.close()
  val maxName = counts.map(_._1.length).max
  val maxNameFmt = "%-"+(maxName)+"s"
  def prList (sortBy : String, keyValues : List[(String, Int)]) {
    print(Utils.heading ("Sorting by "+sortBy))
    Utils.colHeaders(List(
                  ("Team",  -maxName),
                  ("#Apps",  5)))
    keyValues.foreach((x) => (println (maxNameFmt.format(x._1) + "  " + ("%5d").format(x._2))))
  }
  /***************************************************************************************************

  listAsIs: Returns the key-value list of (string, count) unsorted

  ***************************************************************************************************/
  def listAsIs = {
    counts
  }
  /***************************************************************************************************

  sortByKey, sortByValue: Returns the key-value list of (string, count) sorted by key or value

  ***************************************************************************************************/
  def sortByKey = {
    counts.toSeq.sortBy(_._1).toList
  }
  def sortByValue = {
    counts.toSeq.sortBy(r => (r._2, r._1)).toList
  }
}


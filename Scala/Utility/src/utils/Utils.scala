package utils
/***************************************************************************************************
Name: Utils.scala                      Author: Brendan Furey                       Date: 22-Oct-2016

Scala component of polyglot project: a simple file-reading and group-counting module, with main
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

***************************************************************************************************/
import scala.math.abs

object Utils {
  /***************************************************************************************************

  heading: Prints a title with "=" underlining to its length, preceded by a blank line

  ***************************************************************************************************/
  def heading (title : String): String = { // heading string
    "\n"+title+"\n"+"="*(title.length)+"\n";
  }
  /***************************************************************************************************

  prListAsLine: Prints an array of strings as one line, separating fields by a 2-space delimiter

  ***************************************************************************************************/
  def prListAsLine (prList : List[String]) { // list of strings to print as line
    println (prList.mkString("  "))
  }
  /***************************************************************************************************

  colHeaders: Prints a set of column headers, input as a list of values and length/justification tuples

  ***************************************************************************************************/
  def colHeaders(colNames : List[(String, Int)]) = { // list of values and length/justification tuples
    val strings = colNames.map((x) => ("%"+x._2.toString+"s").format(x._1))
    prListAsLine(strings)
    val unders = colNames.map((x) => ("%"+x._2.toString+"s").format("-"*abs(x._2)))
    prListAsLine(unders)
    unders
  }
}
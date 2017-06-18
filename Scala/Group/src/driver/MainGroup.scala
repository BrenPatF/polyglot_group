package driver
/***************************************************************************************************
Name: MainGroup.scala                  Author: Brendan Furey                       Date: 22-Oct-2016

Scala component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
| *Main*   |  Col Group  |  Utils      |
|  Tester  |             |  Timer Set  |
========================================

Main program calling the ColGroup class to read delimited lines from file, count values in a given
column, and print the counts in various orderings. TimerSet times the method calls and prints the
timings at the end.

***************************************************************************************************/
import colgroup.ColGroup
import timerset.TimerSet
import java.io.FileNotFoundException
/***************************************************************************************************

MainGroup: Object constructs TimerSet, then ColGroup objects, then prints lists of counts in various orderings,
           with timings for each call printed at the end.

***************************************************************************************************/
object MainGroup extends App {

  val (input_file, delim, col) = ("../../Input/fantasy_premier_league_player_stats.csv", ",", 6)
  val grpTimer = new TimerSet("Group")
  try {

    val counts = new ColGroup(input_file, delim, col)
    grpTimer.incrementTime("ColGroup")

    counts.prList ("(as is)", counts.listAsIs)
    grpTimer.incrementTime("listAsIs")

    counts.prList ("key", counts.sortByKey)
    grpTimer.incrementTime("sortByKey")

    counts.prList ("value", counts.sortByValue)
    grpTimer.incrementTime("sortByValue")

    grpTimer.writeTimes

  } catch {
      case ex: FileNotFoundException => {
        println ("Missing file exception: "+input_file)
      }
  }
}


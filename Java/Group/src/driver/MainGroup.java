package driver;
/***************************************************************************************************
Name: MainGroup.java                   Author: Brendan Furey                       Date: 22-Oct-2016

Java component of polyglot project: a simple file-reading and group-counting module, with main
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
import java.io.IOException;
import java.util.List;
import java.util.Map;

import colgroup.ColGroup;
import timerset.TimerSet;

public class MainGroup {

  /***************************************************************************************************

  main: Constructs TimerSet, then ColGroup objects, then prints lists of counts in various orderings,
        with timings for each call printed at the end.

  ***************************************************************************************************/
  public static void main(String[] args) {
    TimerSet grpTimer = new TimerSet("Group");
    try {
      ColGroup colGroup = new ColGroup ("../../Input/fantasy_premier_league_player_stats.csv", ",", 6);
      grpTimer.incrementTime("ColGroup");

      List<Map.Entry<String,Long>> sortedList = colGroup.listAsIs();
      colGroup.prList("(as is)", sortedList);
      grpTimer.incrementTime("listAsIs");

      sortedList = colGroup.sortByKey();
      colGroup.prList("key", sortedList);
      grpTimer.incrementTime("sortByKey");

      sortedList = colGroup.sortByValue();
      colGroup.prList("value", sortedList);
      grpTimer.incrementTime("sortByValue");

      grpTimer.writeTimes();
    } catch (IOException e) {
      System.out.println ("IO exception "+e.getMessage());
    }
  }
}
package colgroup;
/***************************************************************************************************
Name:        ColGroup.java
Name: ColGroup.java                    Author: Brendan Furey                       Date: 22-Oct-2016

Java component of polyglot project: a simple file-reading and group-counting module, with main
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
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import utils.Utils;

public class ColGroup {
  static Map<String, Long> counts = new HashMap<String, Long>();// HashMap, TreeMap implement Map
  static int maxName;
  /***************************************************************************************************

  ColGroup: Constructor sets the key-value map of (string, count), and the maximum key length

  ***************************************************************************************************/
  public ColGroup(String		input_file, // file name, including path
				  String		delim,      // field delimiter
				  int			col)        // column number of values to be counted
				  throws IOException {
    try (Stream<String> stream = Files.lines(Paths.get(input_file)).map(x -> x.split(delim)[col]) ) {
         counts = stream.collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));
    }
    maxName = counts.entrySet().stream().map(Map.Entry::getKey).max((x,y)->Integer.compare(x.length(), y.length())).get().length();
  }
  /***************************************************************************************************

  prList: Prints the key-value list of (string, count) sorted as specified

  ***************************************************************************************************/
  public void prList (String						sortBy,		  // sort by label
					  List<Map.Entry<String,Long>>	keysSorted) { // sorted list of key-value tuples
    Utils.heading ("Sorting by "+sortBy);
    Utils.colHeaders(new String[]{"Team", "#Apps"}, new int[]{-maxName, 5});
    for (Map.Entry<String,Long> k: keysSorted) {
	  System.out.println(String.format("%-"+maxName+"s  %5d", k.getKey(), k.getValue()));
    }
  }
  /***************************************************************************************************

  listAsIs: Returns the key-value list of (string, count) unsorted

  ***************************************************************************************************/
  public List<Map.Entry<String,Long>> listAsIs() { // key-value list of (string, count) unsorted
    return counts.entrySet().stream().collect(Collectors.toList());
  }
  /***************************************************************************************************

  sortByKey, sortByValue: Returns the key-value list of (string, count) sorted by key or value

  ***************************************************************************************************/
  public List<Map.Entry<String,Long>> sortByKey() { // key-value list of (string, count) sorted by key
    return counts.entrySet().stream()
    .sorted(Map.Entry.<String, Long>comparingByKey()).collect(Collectors.toList());
  }
  public List<Map.Entry<String,Long>> sortByValue() { // key-value list of (string, count) sorted by value
    return counts.entrySet().stream()
    .sorted(Map.Entry.<String, Long>comparingByValue().thenComparing(Map.Entry.comparingByKey())).collect(Collectors.toList());
  }
}


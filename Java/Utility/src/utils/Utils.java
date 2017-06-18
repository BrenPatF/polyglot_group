package utils;
/***************************************************************************************************
Name: Utils.java                       Author: Brendan Furey                       Date: 22-Oct-2016

Java component of polyglot project: a simple file-reading and group-counting module, with main
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

public class Utils {
  private static String[] fmtCols;
  /***************************************************************************************************

  heading: Prints a title with "=" underlining to its length, preceded by a blank line

  ***************************************************************************************************/
  public static void heading (String title) { // heading string
    System.out.println ("");
    System.out.println (title);
    System.out.println (String.format("%0"+title.length()+"d", 0).replace("0", "="));
  }
  /***************************************************************************************************

  prListAsLine: Prints an array of strings as one line, separating fields by a 2-space delimiter

  ***************************************************************************************************/
  public static void prListAsLine (String[] prList) { // array of strings to print as line
    System.out.println (String.join("  ", prList));
  }
  /***************************************************************************************************

  colHeaders: Prints a set of column headers, input as arrays of values and length/justification's

  ***************************************************************************************************/
  public static void colHeaders (String[]   colNames,  // array of column headers
                                 int[]      colLens) { // array of length/justification's
    fmtCols = new String[colNames.length];
    for (int i=0; i < colNames.length; i++) {
      fmtCols[i] = String.format("%"+colLens[i]+"s", colNames[i]);
    }
    prListAsLine(fmtCols);
    for (int i=0; i < colNames.length; i++) {
      fmtCols[i]=fmtCols[i].replaceAll(".", "-");
    }
    prListAsLine(fmtCols);
  }
  /***************************************************************************************************

  totLines: Reprints the line of underlines for a set of columns last printed, used for before/after
            summary line

  ***************************************************************************************************/
  public static void totLines() {
    prListAsLine(fmtCols);
  }
}



package timerset;
/***************************************************************************************************
Name: TimerSet.java                    Author: Brendan Furey                       Date: 22-Oct-2016

Java component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    |  Col Group  |  Utils      |
|  Tester  |             | *Timer Set* |
========================================

TimerSet class to facilitate code timing.

***************************************************************************************************/
import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;

import java.text.DecimalFormat;
import java.text.NumberFormat;

import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap; // Linked form retains order of insertion within the hash
import utils.Utils;

public class TimerSet {

  private static final int CALLSWIDTH = 10;
  private static final int TIMEWIDTH = 8;
  private static final int TIMEDP = 2;
  private static final int TIMERATIODP = 5;
  private static final int STIMERATIODP = 8;
  private static final String TOTTIMER = "Total";
  private static final String OTHTIMER = "(Other)";
  private static final int SELFRANGE = 100000;
  private static final int TIMETOSECONDS = 1000000000;

  private long[] startTime = new long[3], priorTime = new long[3];
  private String setName;
  HashMap<String, long[]> timerHash = new LinkedHashMap<String, long[]>();
  private static NumberFormat formatter = new DecimalFormat("###,###,###");
  private Date ctime = new Date();

  /***************************************************************************************************

  TimerSet: Constructor sets the timer set name and initialises the instance timing arrays

  ***************************************************************************************************/
  public TimerSet(String setName) { // timer set name
    this.setName = "Timer Set: "+setName;
    initTime();
    for (int i = 0; i < 3; i++) {
      startTime[i] = priorTime[i];
    }
  }
  /***************************************************************************************************

  incrementTime: Increments the timing accumulators for a timer set and timer

  ***************************************************************************************************/
  public void incrementTime(String timerName) { // timer name
    long[] curTime = new long[4];
    curTime = getTimes();
    long[] oldVal=timerHash.getOrDefault(timerName, new long[]{0,0,0,0});
    long[] newVal = new long[4];
    for (int i=0; i<3; i++) {
      newVal[i] = oldVal[i] + curTime[i] - priorTime[i];
      priorTime[i] = curTime[i];
    }
    newVal[3] = oldVal[3] + 1;
    timerHash.put(timerName,newVal);
  }
  /***************************************************************************************************

  initTime: Initialises (or resets) the instance timing array

  ***************************************************************************************************/
  public void initTime() {
    long[] curTime = new long[4];
    curTime = getTimes();
    for (int i = 0; i < 3; i++) {
        priorTime[i] = curTime[i];
    }
  }
  /***************************************************************************************************

  getTimes: Gets CPU and elapsed times using system calls and return in array

  ***************************************************************************************************/
  private long[] getTimes() { // return value is array of times (elapsed, user CPU, system CPU)
    long[] curTime = new long[4];
    curTime[0] = System.nanoTime();
    ThreadMXBean bean = ManagementFactory.getThreadMXBean();
    curTime[1] = bean.getCurrentThreadUserTime();
    curTime[2] = bean.getCurrentThreadCpuTime() - curTime[1];
    return curTime;
  }
  /***************************************************************************************************

  form*: Formatting methods that return formatted times and other values as strings

  ***************************************************************************************************/
  private static String formTime (long time) { // time
    String dpfm = String.format( "%s.%sf", TIMEWIDTH + TIMEDP, TIMEDP);
    return String.format( "%"+dpfm, (float) time / TIMETOSECONDS);
  }
  private static String formTimeRatio (long time) { // time per iteration ratio
    String dpfm = String.format( "%s.%sf", TIMEWIDTH + TIMERATIODP, TIMERATIODP);
    return String.format( "%"+dpfm, (float) time / TIMETOSECONDS);
  }
  private static String formTimeTrim (long time, int dp) { // time, decimal places to print
    String dpfm = String.format( "%s.%sf", TIMEWIDTH + dp, dp);
    return String.format( "%"+dpfm, (float) time / TIMETOSECONDS).replace (" ", "");
  }
  private static String formName (String    name,      // timer name
                                  int       maxName) { // column length as maximum timer name length
    return String.format( "%-"+maxName+"s", name);
  }
  private static String formCalls (long nCalls) { // number of calls to a timer
    return String.format("%1$10s", formatter.format (nCalls)) ;
  }
  /***************************************************************************************************

  writeTimeLine: Writes a formatted timing line

  ***************************************************************************************************/
  private static void writeTimeLine (String     timer,     // timer name
                                     long       ela,       // elapsed time
                                     long       usr,       // user CPU time
                                     long       sys,       // system CPU time
                                     long       nCalls,    // number of calls to timer
                                     int        maxName) { // maximum timer name length
    Utils.prListAsLine (new String[] {
                        formName (timer, maxName),
                        formTime (ela),
                        formTime (usr + sys),
                        formTime (usr),
                        formTime (sys),
                        formCalls (nCalls),
                        formTimeRatio (ela/nCalls),
                        formTimeRatio ((usr + sys)/nCalls)}
    );
  }
  /***************************************************************************************************

  writeTimes: Writes a report of the timings for the timer set

  ***************************************************************************************************/
  public void writeTimes() {
    long selfEla, selfUsr, selfSys;
    long[] curTime = new long[4];
    int maxName;
    curTime = getTimes();
    long totTime[] = new long[3];
    Date wtime = new Date();

    for (int i = 0; i < 3; i++) {
      totTime[i] = curTime[i] - startTime[i];
    }
    TimerSet selfTimer = new TimerSet("self");

    for (int i=0; i < SELFRANGE; i++) {
        selfTimer.incrementTime ("x");
    }
    curTime = selfTimer.timerHash.get ("x");
    selfEla = curTime[0];
    selfUsr = curTime[1];
    selfSys = curTime[2];
    maxName = Math.max(OTHTIMER.length(), timerHash.keySet().stream().reduce((s1,s2) -> (s1.length() > s2.length() ? s1 : s2)).get().length());
//    maxName = Math.max(OTHTIMER.length(), timerHash.keySet().stream().map(s->s.length()).mapToInt(Integer::intValue).max().getAsInt()); //reduce((s1,s2) -> (s1.length() > s2.length() ? s1 : s2)).get().length());
    long[] sumTime = timerHash.values().stream().
            reduce(new long[] {0, 0, 0, 0}, (s1,s2) -> (new long[] {s1[0]+s2[0],s1[1]+s2[1],s1[2]+s2[2],s1[3]+s2[3]}));
    Utils.heading (setName+", constructed at "+ctime.toString()+", written at "+wtime.toString().substring(11, 19));
    System.out.println ( "[Timer timed: Elapsed (per call): " + formTimeTrim (selfEla, TIMEDP) + " (" + formTimeTrim (selfEla/curTime[3], STIMERATIODP) +
    "), CPU (per call): " + formTimeTrim ((selfUsr + selfSys), TIMEDP) + " (" + formTimeTrim((selfUsr + selfSys)/curTime[3], STIMERATIODP) + "), calls: " + curTime[3] + "\n");
    Utils.colHeaders (new String[] {"Timer", "Elapsed", "CPU", "= User", "+ System", "Calls", "Ela/Call", "CPU/Call"},
                      new int[]   {-maxName,
                                   TIMEWIDTH+TIMEDP,
                                   TIMEWIDTH+TIMEDP,
                                   TIMEWIDTH+TIMEDP,
                                   TIMEWIDTH+TIMEDP,
                                   CALLSWIDTH,
                                   TIMEWIDTH+TIMERATIODP,
                                   TIMEWIDTH+TIMERATIODP}
                    );

    timerHash.forEach((k, v) -> writeTimeLine (k, v[0], v[1], v[2], v[3], maxName));
    writeTimeLine (OTHTIMER, totTime[0] - sumTime[0], totTime[1] - sumTime[1], totTime[2] - sumTime[2], 1, maxName);
    Utils.totLines();
    writeTimeLine (TOTTIMER, totTime[0], totTime[1], totTime[2], sumTime[3] + 1, maxName);
    Utils.totLines();
  }
}




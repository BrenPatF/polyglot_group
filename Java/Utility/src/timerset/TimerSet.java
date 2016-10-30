package timerset;

import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;

import java.text.DecimalFormat;
import java.text.NumberFormat;

import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
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

  public TimerSet(String setName) {
    this.setName = "Timer Set: "+setName;;
    initTime();
    for (int i = 0; i < 3; i++) {
      startTime[i] = priorTime[i];
    }
  }

  public void incrementTime(String timerName) {
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
  public void initTime() {
	long[] curTime = new long[4];
	curTime = getTimes();
    for (int i = 0; i < 3; i++) {
        priorTime[i] = curTime[i];
    }
  }
  private long[] getTimes() {
	long[] curTime = new long[4];
    curTime[0] = System.nanoTime();
    ThreadMXBean bean = ManagementFactory.getThreadMXBean();
    curTime[1] = bean.getCurrentThreadUserTime();
    curTime[2] = bean.getCurrentThreadCpuTime() - curTime[1];
    return curTime;
  }
  private static String formTime (long time) {
    String dpfm = String.format( "%s.%sf", TIMEWIDTH + TIMEDP, TIMEDP);
    return String.format( "%"+dpfm, (float) time / TIMETOSECONDS);
  }
  private static String formTimeRatio (long time) {
    String dpfm = String.format( "%s.%sf", TIMEWIDTH + TIMERATIODP, TIMERATIODP);
    return String.format( "%"+dpfm, (float) time / TIMETOSECONDS);
  }
  private static String formTimeTrim (long time, int dp) {
    String dpfm = String.format( "%s.%sf", TIMEWIDTH + dp, dp);
    return String.format( "%"+dpfm, (float) time / TIMETOSECONDS).replace (" ", "");
  }
  private static String formName (String name, int maxName) {
    return String.format( "%-"+maxName+"s", name);
  }
  private static String formCalls (long nCalls) {
    return String.format("%1$10s", formatter.format (nCalls)) ;
  }
  private static void writeTimeLine (String timer, long ela, long usr, long sys, long nCalls, int maxName) {
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




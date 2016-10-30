package timerset
import utils.Utils
import scala.collection.mutable.LinkedHashMap
import java.lang.management.ManagementFactory
import java.lang.management.ThreadMXBean
import java.util.Date

class TimerSet (timerSetName : String) {

  val (callsWidth, timeWidth, timeDp, timeRatioDp, totTimer, othTimer, selfRange) = (10, 8, 2, 5, "Total", "(Other)", 100000) //Initcap does not work!
  val (elaTimBeg, usrTimBeg, sysTimBeg) = getTimes
  var (elaTimPri, usrTimPri, sysTimPri) = (elaTimBeg, usrTimBeg, sysTimBeg) // These initializations use pattern-matching
  val ctime = new Date
  var timerHash  = LinkedHashMap.empty[String, (Long, Long, Long, Long)].withDefaultValue((0, 0, 0,0))

  def getTimes = {
    val ela = System.nanoTime()
    val bean = ManagementFactory.getThreadMXBean()
    val usr = bean.getCurrentThreadUserTime()
    val sys = bean.getCurrentThreadCpuTime() - usr
    (ela, usr, sys)
  }
  
  def initTime {
    elaTimPri = getTimes._1 // looks clunky but assigning to tuple unsupported
    usrTimPri = getTimes._2
    sysTimPri = getTimes._3
  }

  def incrementTime (timerName : String) {

    val curTim = getTimes
    val curHsh = timerHash(timerName)
    timerHash.update(timerName, (curHsh._1 + curTim._1 - elaTimPri, 
                                 curHsh._2 + curTim._2 - usrTimPri, 
                                 curHsh._3 + curTim._3 - sysTimPri, 
                                 curHsh._4 + 1)
                    )
    initTime
  }
  private def formName(name : String, maxName : Int) = {
    ("%-"+maxName.toString+"s").format(name)
  }
  private def formTime(t : Float, dp : Int) = {
    ("%"+(timeWidth + dp).toString+"."+dp.toString+"f").format(t / 1000000000)
  }
  private def trimTime(t : Float, dp : Int) = {
    formTime(t, dp).trim
  }
  private def formCalls(calls : Long) = {
    ("%"+callsWidth.toString+"d").format(calls)
  }
  private def writeTimeLine(timer : String, maxName : Int, ela : Long, usr : Long, sys : Long, calls : Long) {
    val (elaF, usrF, sysF) = (ela.toFloat, usr.toFloat, sys.toFloat)
    Utils.prListAsLine (List(
                      formName(timer,      maxName),
                      formTime(elaF,       timeDp),
                      formTime(usrF,       timeDp),
                      formTime(sysF,       timeDp),
                      formCalls(calls),
                      formTime(elaF/calls, timeRatioDp),
                      formTime(usrF/calls, timeRatioDp),
                      formTime(sysF/calls, timeRatioDp)))
  }

  def writeTimes {
        
    val curTim = getTimes
    val totTim = (curTim._1 - elaTimBeg, curTim._2 - usrTimBeg, curTim._3 - sysTimBeg)
    val lZero = 0.toLong
    val sumTim = timerHash.valuesIterator.reduce((s, t) => (s._1 + t._1, s._2 + t._2, s._3 + t._3, s._4 + t._4))

    print(Utils.heading ("Timer set: " + timerSetName + ", constructed at "+ctime.toString()+
                                   ", written at "+(new Date).toString()))

    val timerTimer = new TimerSet("timer")
    1 to selfRange foreach (_ => timerTimer.incrementTime("x"))
    val timerTimes = timerTimer.timerHash("x")
    println("[Timer timed: Elapsed (per call): " + trimTime(timerTimes._1, timeDp) + " (" + trimTime(timerTimes._1/timerTimes._4, timeRatioDp+3) +
        "), USR (per call): " + trimTime(timerTimes._2, timeDp) + " (" + trimTime(timerTimes._2/timerTimes._4, timeRatioDp+3) + 
        "), SYS (per call): " + trimTime(timerTimes._3, timeDp) + " (" + trimTime(timerTimes._3/timerTimes._4, timeRatioDp+3) + 
        "), calls: " + (timerTimes._4).toString + "]\n")

    val maxName = timerHash.keysIterator.map(_.length).max
    val unders = Utils.colHeaders(List(
                  ("Timer",     -maxName), 
                  ("Elapsed",   timeWidth+timeDp), 
                  ("USR",       timeWidth+timeDp), 
                  ("SYS",       timeWidth+timeDp), 
                  ("Calls",     callsWidth), 
                  ("Ela/Call",  timeWidth+timeRatioDp), 
                  ("USR/Call",  timeWidth+timeRatioDp),
                  ("SYS/Call",  timeWidth+timeRatioDp)))

    timerHash.foreach((t) => writeTimeLine(t._1, maxName, t._2._1, t._2._2, t._2._3, t._2._4))
    writeTimeLine(othTimer, maxName, totTim._1 - sumTim._1, totTim._2 - sumTim._2, totTim._3 - sumTim._3, 1)
    Utils.prListAsLine (unders)
    writeTimeLine(totTimer, maxName, totTim._1, totTim._2, totTim._3, sumTim._4 + 1)
    Utils.prListAsLine (unders)
  }
}

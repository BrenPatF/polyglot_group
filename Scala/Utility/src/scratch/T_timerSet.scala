package scratch
import timerset.TimerSet

object T_timerSet extends App {
  val x = new TimerSet ("Brendan")
  x.incrementTime("Timer xone")
  x.incrementTime("Timer two")
  x.writeTimes
}
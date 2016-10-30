package driver
import colgroup.ColGroup
import timerset.TimerSet
import  java.io.FileNotFoundException
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


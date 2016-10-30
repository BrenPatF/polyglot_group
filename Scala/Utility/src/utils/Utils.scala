package utils
import scala.math.abs

object Utils {
  def heading (title : String): String = {
    "\n"+title+"\n"+"="*(title.length)+"\n";
  }
  def prListAsLine (prList : List[String]) {
    println (prList.mkString("  "))
  }
  def colHeaders(colNames : List[(String, Int)]) = {
    val strings = colNames.map((x) => ("%"+x._2.toString+"s").format(x._1))
    prListAsLine(strings)
    val unders = colNames.map((x) => ("%"+x._2.toString+"s").format("-"*abs(x._2)))
    prListAsLine(unders)
    unders
  }
}
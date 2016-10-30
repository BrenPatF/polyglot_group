package colgroup
import utils.Utils
import scala.io.Source

class ColGroup (input_file: String, delim: String, col: Int) {
  val source = Source.fromFile(input_file)
  val counts = (for (line <- source.getLines()) yield line.split(delim)(col)).toList.groupBy((x) => x).mapValues(_.size).toList
  source.close()
  val maxName = counts.map(_._1.length).max
  val maxNameFmt = "%-"+(maxName)+"s"
  def prList (sortBy : String, keyValues : List[(String, Int)]) {
    print(Utils.heading ("Sorting by "+sortBy))
    Utils.colHeaders(List(
                  ("Team",  -maxName), 
                  ("#Apps",  5)))
    keyValues.foreach((x) => (println (maxNameFmt.format(x._1) + "  " + ("%5d").format(x._2))))
  }
  def listAsIs = {
    counts
  }
  def sortByKey = {
    counts.toSeq.sortBy(_._1).toList
  }
  def sortByValue = {
    counts.toSeq.sortBy(r => (r._2, r._1)).toList
  }
}


package colgroup

import org.scalatest._
import java.io.FileNotFoundException
import java.nio.file.{Paths, Files}
import java.nio.charset.StandardCharsets
import scala.collection.JavaConverters._

class TestColGroup extends FunSuite {
  val testFile = "../../Input/ut_group.csv"
  val lines = List(List("0,1,Cc,3", "00,1,A,9", "000,1,B,27", "0000,1,A,81"), List("X;;1;;A", "X;;1;;A"))
  val input_file = testFile
  val delim = List(",", ";;")
  val col = List(2, 0)
  val expAsIsSize = List(3, 2)
  val expK = List(List(("A", 2),("Bx", 1),("Cc", 1)), List(("X", 2)))
  val expV = List(List(("B", 1),("Cc", 1),("A", 2)), List(("X", 2)))
  var counts : ColGroup = null
  def setup(datasetNum : Int) {
    Files.write (Paths.get (testFile), lines(datasetNum).asJava, StandardCharsets.UTF_8 )
    counts = new ColGroup (input_file, delim(datasetNum), col(datasetNum))
  }
  def teardown() {
    Files.delete(Paths.get (testFile))
  }
  for (i <- 0 to lines.size-1) {
    test ("listAsIs should return the correct number of groups in any order "+i) {
      setup(i)
      assert(counts.listAsIs.size === expAsIsSize(i))
      teardown
    }
  }
  for (i <- 0 to lines.size-1) {
    test ("sortByKey should return the list in key order "+i) {
      setup(i)
      assert(counts.sortByKey === expK(i))
      teardown
    }
  }
  for (i <- 0 to lines.size-1) {
    test ("sortByValue should return the list in value order "+i) {
      setup(i)
      assert(counts.sortByValue === expV(i))
      teardown
    }
  }
}

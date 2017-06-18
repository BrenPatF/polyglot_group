package colgroup
/***************************************************************************************************
Name: TestColGroup.scala               Author: Brendan Furey                       Date: 22-Oct-2016

Scala component of polyglot project: a simple file-reading and group-counting module, with main
program, unit testing program, code timing and general utility packages, implemented in multiple
languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    |  Col Group  |  Utils      |
| *Tester* |             |  Timer Set  |
========================================

Unit test program.

Description: Demo Scala package for polyglot project. Testing class for ColGroup class. Uses
             Parameterized.class to data-drive

Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
B. Furey             22-Oct-2016 1.0   Created

***************************************************************************************************/
import org.scalatest._
import java.io.FileNotFoundException
import java.nio.file.{Paths, Files}
import java.nio.charset.StandardCharsets
import scala.collection.JavaConverters._

class TestColGroup extends FunSuite {
/***************************************************************************************************

Private instance constants: 2 scenarios, input, and expected records declared here, in 2-level lists

***************************************************************************************************/
  val testFile = "../../Input/ut_group.csv"

// setup data indexed by scenario
  val lines = List(List("0,1,Cc,3", "00,1,A,9", "000,1,B,27", "0000,1,A,81"), List("X;;1;;A", "X;;1;;A"))
  val delim = List(",", ";;")
  val col = List(2, 0)

// expected values for as is list just counts, with lists of 2-tuples for sorted lists
  val expAsIsSize = List(3, 2) // 2 is deliberately wrong, 1 is the correct value
  val expK = List(List(("A", 2),("Bx", 1),("Cc", 1)), List(("X", 2))) // Bx is deliberately wrong, B is the correct value
  val expV = List(List(("B", 1),("Cc", 1),("A", 2)), List(("X", 2)))

  /***************************************************************************************************

  setup: Writes the test file and instantiates base object

  ***************************************************************************************************/
  def setup(datasetNum : Int) : ColGroup = { // scenario index
    Files.write (Paths.get (testFile), lines(datasetNum).asJava, StandardCharsets.UTF_8 )
    return new ColGroup (testFile, delim(datasetNum), col(datasetNum))
  }
  /***************************************************************************************************

  teardown: Removes test input file, called by test/unit package

  ***************************************************************************************************/
  def teardown() {
    Files.delete(Paths.get (testFile))
  }
  /***************************************************************************************************

  main section: Per tested method, and scenario, calls test to assert method return, and tears down

  ***************************************************************************************************/
  for (i <- 0 to lines.size-1) {
    test ("listAsIs should return the correct number of groups in any order "+i) {
      assert(setup(i).listAsIs.size === expAsIsSize(i))
      teardown
    }
  }
  for (i <- 0 to lines.size-1) {
    test ("sortByKey should return the list in key order "+i) {
      assert(setup(i).sortByKey === expK(i))
      teardown
    }
  }
  for (i <- 0 to lines.size-1) {
    test ("sortByValue should return the list in value order "+i) {
      assert(setup(i).sortByValue === expV(i))
      teardown
    }
  }
}

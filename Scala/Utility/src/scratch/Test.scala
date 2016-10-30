package scratch
import scala.collection.mutable.LinkedHashMap

object Test extends App {
  val timerHash  = LinkedHashMap(("a", (1, 2)), ("b", (3,4)))
  timerHash.foreach(println _)
  val x = timerHash.map((t) => (t._2._1, t._2._2)).toList.foldLeft((0,0)){case ((accA, accB), (a,b)) => (accA + a, accB + b)}
 //Note: Tuples cannot be directly destructured in method or function parameters. Either create a single parameter accepting the Tuple2, 
 // or consider a pattern matching anonymous function: `{ case (accA, accB) ⇒ ... }
  println (x._1 + ", " + x._2)
  
}
package driver;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import colgroup.ColGroup;
import timerset.TimerSet;

public class MainGroup {

  public static void main(String[] args) {
    TimerSet grpTimer = new TimerSet("Group");
    try {
      ColGroup colGroup = new ColGroup ("../../Input/fantasy_premier_league_player_stats.csv", ",", 6);
      grpTimer.incrementTime("ColGroup");
      
      List<Map.Entry<String,Long>> sortedList = colGroup.listAsIs();
      colGroup.prList("(as is)", sortedList);
      grpTimer.incrementTime("listAsIs");
      
      sortedList = colGroup.sortByKey();
      colGroup.prList("key", sortedList);
      grpTimer.incrementTime("sortByKey");
      
      sortedList = colGroup.sortByValue();
      colGroup.prList("value", sortedList);
      grpTimer.incrementTime("sortByValue");
      
      grpTimer.writeTimes();
    } catch (IOException e) {
      System.out.println ("IO exception "+e.getMessage());
    }
  }
}


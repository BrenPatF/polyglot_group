package colgroup;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import utils.Utils;

public class ColGroup {
    static Map<String, Long> counts = new HashMap<String, Long>();// HashMap, TreeMap
    static int maxName;
	public ColGroup(String input_file, String delim, int col) throws IOException {
	    try (Stream<String> stream = Files.lines(Paths.get(input_file)).map(x -> x.split(delim)[col]) ) {
	         counts = stream.collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));
	    }
	    maxName = counts.entrySet().stream().map(Map.Entry::getKey).max((x,y)->Integer.compare(x.length(), y.length())).get().length();
	}
	public void prList (String sortBy, List<Map.Entry<String,Long>> keysSorted) {
	  Utils.heading ("Sorting by "+sortBy);
	  Utils.colHeaders(new String[]{"Team", "#Apps"}, new int[]{-maxName, 5});
	  for (Map.Entry<String,Long> k: keysSorted) {
		  System.out.println(String.format("%-"+maxName+"s  %5d", k.getKey(), k.getValue()));
	  }
    }
    public List<Map.Entry<String,Long>> listAsIs() {
      return counts.entrySet().stream().collect(Collectors.toList());
  }
    public List<Map.Entry<String,Long>> sortByKey() {
      return counts.entrySet().stream()
      .sorted(Map.Entry.<String, Long>comparingByKey()).collect(Collectors.toList());
  }
    public List<Map.Entry<String,Long>> sortByValue() {
      return counts.entrySet().stream()
      .sorted(Map.Entry.<String, Long>comparingByValue().thenComparing(Map.Entry.comparingByKey())).collect(Collectors.toList());
  }
}


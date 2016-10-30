package utils;

public class Utils {
  private static String[] fmtCols;
  public static void heading (String title) {
    System.out.println ("");
    System.out.println (title);
    System.out.println (String.format("%0"+title.length()+"d", 0).replace("0", "="));
  }
  public static void prListAsLine (String[] prList) {
    System.out.println (String.join("  ", prList));
  }
  public static void colHeaders (String[] colNames, int[] colLens) {
	fmtCols = new String[colNames.length];
    for (int i=0; i < colNames.length; i++) {
      fmtCols[i] = String.format("%"+colLens[i]+"s", colNames[i]);
	}
    prListAsLine(fmtCols);
    for (int i=0; i < colNames.length; i++) {
      fmtCols[i]=fmtCols[i].replaceAll(".", "-");
	}
    prListAsLine(fmtCols);
  }
  public static void totLines() {
    prListAsLine(fmtCols);
  }
}



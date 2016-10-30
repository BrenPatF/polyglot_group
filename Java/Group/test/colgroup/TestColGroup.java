package colgroup;
/***************************************************************************************************
Name:        TestColGroup.java

Description: Junit testing class for Col_Group class. Uses Parameterized.class to data-drive
                                                                               
Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
B. Furey             22-Oct-2016 1.0   Created                       

***************************************************************************************************/
import static org.junit.Assert.*;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized.Parameters;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public class TestColGroup {
/***************************************************************************************************

Private instance variables: 2 scenarios, input, and expected records declared here, initially in 
2-level generic arrays, but expected records transferred to List for assertion

***************************************************************************************************/
  private ColGroup colGroup = null;
  private String testFile = "../../Input/ut_group.csv";
  private String[][] testLines = new String[][] { 
      {"0,1,Cc,3", "00,1,A,9", "000,1,B,27", "0000,1,A,81"}, 
      {"X;;1;;A", "X;;1;;A"}
  };
  private String[] testDelim = new String[] {",", ";;"};
  private int[] testColnum = new int[] {2, 0};
  private List<String> lines;
  private String delim;
  private int colnum;

  private String[][] keysK = new String[][] { 
      {"A", "Bx", "Cc"}, 
      {"X"}
  };
  private int[][] valuesK = new int[][] { 
      {2, 1, 1}, 
      {2}
  };
  private String[][] keysV = new String[][] { 
      {"B", "Cc", "A"},
      {"X"}
  };
  private int[][] valuesV = new int[][] { 
      {1, 1, 2}, 
      {2}
  };
  private int expAsIs;
  private List<Map.Entry<String,Long>> expListK = null;
  private List<Map.Entry<String,Long>> expListV = null;

  private void addMap (int i, String strValK, int lonValK, String strValV, int lonValV) {
    expListK.add (i, new AbstractMap.SimpleEntry<String, Long> (strValK, (long) lonValK));
    expListV.add (i, new AbstractMap.SimpleEntry<String, Long> (strValV, (long) lonValV));
  }

  private int testNum;

  /***************************************************************************************************

  TestColGroup: Constructor function, which sets the instance variables for given scenario (testNum), and
                is called before each test with parameters passed via test_data (see end)

  ***************************************************************************************************/
  public TestColGroup (int   testNum,   // test scenario number
                  int   nGroups) { // number of groups

    System.out.println("Doing constructor before test "+testNum+"...");
    this.lines = Arrays.asList (testLines[testNum]);
    this.delim = testDelim[testNum];
    this.colnum = testColnum[testNum];
    this.expAsIs = nGroups;
    this.testNum = testNum;
    int i = 0;
    expListK = new ArrayList<Map.Entry<String,Long>>(keysK[testNum].length);
    expListV = new ArrayList<Map.Entry<String,Long>>(keysV[testNum].length);
    for (String k : keysK[testNum]) {
      addMap (i, k, valuesK[testNum][i], keysV[testNum][i], valuesV[testNum][i]);
      i++;
    }
  }
  /***************************************************************************************************

  getGroup: Before each test method to write the test file and instantiate base object, using instance
            variables set for the scenario in TestCG3

  ***************************************************************************************************/
  @Before
  public void getGroup() {
    try {
      System.out.println("Doing setup before test "+this.testNum+"...");
      Files.write (Paths.get (testFile), lines, StandardCharsets.UTF_8);
      colGroup = new ColGroup (testFile, delim, colnum);
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
  /***************************************************************************************************

  delFile: After each test method to delete the test file

  ***************************************************************************************************/
  @After
  public void delFile() {
    try {
      System.out.println("Doing teardown after test "+this.testNum+"...");
      Files.delete(Paths.get (testFile));
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
  /***************************************************************************************************

  test*: Test method for each base method; each one is run once for each record defined in test_data
         in @Parameters

  ***************************************************************************************************/
  @Test
  public void testAsIs() {

    List<Map.Entry<String,Long>> actList = colGroup.listAsIs();
    assertEquals ("(as is)", expAsIs, actList.size());
    colGroup.prList("(as is)", actList);
  }
  @Test
  public void testKey() {

    List<Map.Entry<String,Long>> actList = colGroup.sortByKey();
    assertEquals ("keys", expListK, actList);
    colGroup.prList("keys", actList);
  }
  @Test
  public void testValue() {
    List<Map.Entry<String,Long>> actList = colGroup.sortByValue();
    assertEquals ("values", expListV, actList);
    colGroup.prList("values", actList);
  }
  /***************************************************************************************************

  test_data: @Parameters section allows passing of data into tests per scenario; neater to pass in a
             pointer to the instance arrays for most of the data

  ***************************************************************************************************/
  @Parameters
  public static Collection<Object[]> test_data() {
    Object[][] data = new Object[][] { {0, 3}, {1, 2} }; // 2 records, columns = scenario #, # groups
    return Arrays.asList(data);
  }
}


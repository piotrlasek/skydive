package skydive.d2i;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by Piotr Lasek on 7/7/2015.
 */
public class DataObjectReader {

    ArrayList<DataObject> dataObjects;

    public DataObjectReader() throws IOException {

        String fileName = "C:\\Users\\Piotr\\Dropbox\\PROJECTS\\DATAVIS\\PAPERS\\BIG_DATA\\work";
        File file = new File(fileName);

        Pattern p = Pattern.compile("(.*),(.*): ((.*),(.*),(.*))  #");
        Matcher m;
        try(BufferedReader br = new BufferedReader(new FileReader(file))) {
            for(String line; (line = br.readLine()) != null; ) {
                 m = p.matcher(line);
                if (m.find()) {
                    String x = m.group(0);
                    String y = m.group(1);
                    String r = m.group(2);
                    String g = m.group(3);
                    String b = m.group(4);

                    System.out.println(x + ", " + y + ": " + g);
                }
            }
        }
    }
}

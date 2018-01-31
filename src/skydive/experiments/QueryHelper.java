package skydive.experiments;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Created by Piotr Lasek on 19.09.2017.
 */
public class QueryHelper {

    private static final Logger log = LogManager.getLogger(QueryHelper.class);

    /**
     *
     * @param lev
     * @return
     */
    public String getMinZooQuery(int lev) {
       String query = "" +
               "select min(zoo) from pyramid where lev = " + lev;
       return query;
    }

    /**
     *
     * @param lev
     * @return
     */
    public String getMaxZooQuery(int lev) {
        String query = "" +
                "select max(zoo) from pyramid where lev = " + lev;
        return query;
    }
    /**
     *
     * @param woi
     * @return
     */
    public String generate(WindowOfInterest woi) {

        String query = "\n" +
            "with tuples as ( \n" +
            "   select point as z, zoo, \n" +
            "          morton_dec_x(zoo) as x, \n" +
            "          morton_dec_y(zoo) as y, \n" +
            "          zooatlevel(cast(2 as smallint), cast(31 as smallint), lev, zoo) as zal, \n" +
            "          zooatlevel(cast(2 as smallint), cast(31 as smallint), cast(lev+1 as smallint), zoo) as zalp1, \n" +
            "          morton_dec_x( zooatlevel(cast(2 as smallint), cast(31 as smallint), lev, zoo)) as xal, \n" +
            "          morton_dec_y( zooatlevel(cast(2 as smallint), cast(31 as smallint), lev, zoo)) as yal \n" +
            "   from   pyramid_5mln_ \n" +
            "   where  lev = " + woi.getLevel() + " and \n" +
            "          zoo >= " + woi.getZooA() + " and \n" +
            "          zoo <= " + woi.getZooB() + " \n" +
            ") \n" +
            "select \n" +
            "   zoo, zal, zalp1, \n" +
            "   ((cast(z as float) ) - cast((select min(z) from tuples) as float) ) as z, \n" +
            "   xal, yal, xal as x, yal as y \n" +
            "from  tuples \n" +
            "order by x, y \n";
               // "where x >= " + woi.getMinX() + " and x <= " + woi.getMaxX() + " and " +
               // "      y >= " + woi.getMinY() + " and y <= " + woi.getMaxY() + " ";

        log.info(query);

        return query;
   }
}

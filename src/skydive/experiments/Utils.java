package skydive.experiments;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Created by Piotr Lasek on 04.10.2017.
 */
public class Utils {

    private static final Logger log = LogManager.getLogger(Utils.class);

    /**
     *
     * @param zoo
     * @param currentLevel
     * @param targetLevel
     * @return
     */
    public static long zooAtLevel(long zoo, int currentLevel, int targetLevel) {
        long res;
        int dim = 2;
        if (currentLevel > targetLevel) {
            //log.info("<");
            int bitstoshift = dim * (currentLevel - targetLevel);
            res = zoo >> bitstoshift;
        } else {
            //log.info(">");
            int bitstoshift = dim * (targetLevel - currentLevel);
            res = zoo << bitstoshift;
        }
        return res;
    }

    public static void main(String[] args) {
        long z = 1893914239757380243L;
        int levA = 31;
        int levB = 1;
        int width = 8;
        int dim = 2;

        long zA = 0;
        zA = Utils.zooAtLevel(6527123019460067L, levA, levB);
        log.info("a : " + zA);
        zA = Utils.zooAtLevel(zA, levB, levA);
        log.info("a_: " + zA);
        zA = Utils.zooAtLevel(1155220747762665019L, levA, levB);
        log.info("b: " + zA);
        zA = Utils.zooAtLevel(2309068667516787075L, levA, levB);
        log.info("c: " + zA);
        zA = Utils.zooAtLevel(3458980956378682771L, levA, levB);
        log.info("d : " + zA);
        zA = Utils.zooAtLevel(zA, levB, levA);
        log.info("d_: " + zA);

        zA = Utils.zooAtLevel(3458980956378682771L, levA, levB);
        log.info("d : " + zA);
        zA = Utils.zooAtLevel(zA, levB, levA);
        log.info("d_: " + zA);
        zA = Utils.zooAtLevel(z, levA, levB);
        log.info(zA);

        long cells = (long) Math.pow(Math.pow(2, width), dim);
        long zB = zA + cells;
        log.info(zB);

        long znA = Utils.zooAtLevel(zA, levB, levA);
        log.info(znA);
        long znB = Utils.zooAtLevel(zB, levB, levA);
        log.info(znB);
    }
}

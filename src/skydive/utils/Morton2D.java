<<<<<<< HEAD
package skydive.utils;

/**
 * Created by Piotr Lasek on 01.08.2017.
 */
public class Morton2D {


    public static long morton2d(long x, long y) {
        long d;

        x = (x | (x << 16)) & 0x0000FFFF0000FFFFL;
        x = (x | (x << 8)) & 0x00FF00FF00FF00FFL;
        x = (x | (x << 4)) & 0x0F0F0F0F0F0F0F0FL;
        x = (x | (x << 2)) & 0x3333333333333333L;
        x = (x | (x << 1)) & 0x5555555555555555L;

        y = (y | (y << 16)) & 0x0000FFFF0000FFFFL;
        y = (y | (y << 8)) & 0x00FF00FF00FF00FFL;
        y = (y | (y << 4)) & 0x0F0F0F0F0F0F0F0FL;
        y = (y | (y << 2)) & 0x3333333333333333L;
        y = (y | (y << 1)) & 0x5555555555555555L;

        d = x | (y << 1);

        return d;
    }

    /**
     *
     * @param morton2d
     * @return
     */
    public static long[] decodeMorton2d(long morton2d) {
        long[] d = new long[2];

        d[0] = DecodeMorton2X(morton2d);
        d[1] = DecodeMorton2Y(morton2d);

        return d;
    }

    /**
     *
     * @param x
     * @return
     */
    static long Compact1By1(long x) {
        x &= 0x55555555;                  // x = -f-e -d-c -b-a -9-8 -7-6 -5-4 -3-2 -1-0
        x = (x ^ (x >>  1)) & 0x33333333; // x = --fe --dc --ba --98 --76 --54 --32 --10
        x = (x ^ (x >>  2)) & 0x0f0f0f0f; // x = ---- fedc ---- ba98 ---- 7654 ---- 3210
        x = (x ^ (x >>  4)) & 0x00ff00ff; // x = ---- ---- fedc ba98 ---- ---- 7654 3210
        x = (x ^ (x >>  8)) & 0x0000ffff; // x = ---- ---- ---- ---- fedc ba98 7654 3210
        return x;
    }

    /**
     *
     * @param code
     * @return
     */
    public static long DecodeMorton2X(long code) {
        return Compact1By1(code >> 0);
    }

    /**
     *
     * @param code
     * @return
     */
    public static long DecodeMorton2Y(long code) {
        return Compact1By1(code >> 1);
    }



    public static void main(String[] args) {
        long zoo;

        zoo = Morton2D.morton2d(0,0);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(1,0);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(0,1);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(1,1);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(15,15);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(8,9);
        Morton2D.log.info(zoo);


        zoo = Morton2D.morton2d(2146941188, 2147097832);
        Morton2D.log.info(zoo);

    }
}
=======
package skydive.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Created by Piotr Lasek on 01.08.2017.
 */
public class Morton2D {

    private static final Logger log = LogManager.getLogger(Morton2D.class);

    public static long morton2d(long x, long y) {
        long d;

        x = (x | (x << 16)) & 0x0000FFFF0000FFFFL;
        x = (x | (x << 8)) & 0x00FF00FF00FF00FFL;
        x = (x | (x << 4)) & 0x0F0F0F0F0F0F0F0FL;
        x = (x | (x << 2)) & 0x3333333333333333L;
        x = (x | (x << 1)) & 0x5555555555555555L;

        y = (y | (y << 16)) & 0x0000FFFF0000FFFFL;
        y = (y | (y << 8)) & 0x00FF00FF00FF00FFL;
        y = (y | (y << 4)) & 0x0F0F0F0F0F0F0F0FL;
        y = (y | (y << 2)) & 0x3333333333333333L;
        y = (y | (y << 1)) & 0x5555555555555555L;

        d = x | (y << 1);

        return d;
    }

    /**
     *
     * @param morton2d
     * @return
     */
    public static long[] decodeMorton2d(long morton2d) {
        long[] d = new long[2];

        d[0] = DecodeMorton2X(morton2d);
        d[1] = DecodeMorton2Y(morton2d);

        return d;
    }

    /**
     *
     * @param x
     * @return
     */
    static long Compact1By1(long x) {
        x &= 0x55555555;                  // x = -f-e -d-c -b-a -9-8 -7-6 -5-4 -3-2 -1-0
        x = (x ^ (x >>  1)) & 0x33333333; // x = --fe --dc --ba --98 --76 --54 --32 --10
        x = (x ^ (x >>  2)) & 0x0f0f0f0f; // x = ---- fedc ---- ba98 ---- 7654 ---- 3210
        x = (x ^ (x >>  4)) & 0x00ff00ff; // x = ---- ---- fedc ba98 ---- ---- 7654 3210
        x = (x ^ (x >>  8)) & 0x0000ffff; // x = ---- ---- ---- ---- fedc ba98 7654 3210
        return x;
    }

    /**
     *
     * @param code
     * @return
     */
    public static long DecodeMorton2X(long code) {
        return Compact1By1(code >> 0);
    }

    /**
     *
     * @param code
     * @return
     */
    public static long DecodeMorton2Y(long code) {
        return Compact1By1(code >> 1);
    }

    /**
     *
     * @param dim
     * @param deepest
     * @param level
     * @param zoo
     * @return
     */
    public static double zooAtLevelA(int dim, int deepest, int level, long zoo) {
        // return floor(zoo / power(power(CAST((2) as bigint), dim), abs(deepest - level)));
        double b = Math.abs(deepest - level);
        double a = Math.pow(2, dim);
        double p = Math.pow(a, b);
        double zal = zoo / p;
        //Morton2D.log.info("a: " + a + ", b: " + b + ", p: " + p + ", zal: " + Math.floor(zal));
        //Morton2D.log.info("" + zoo + " / Math.pow(" + "Math.pow(2, " + dim + "), Math.abs(" + deepest + " - " + level + "))");

        return Math.floor(zal);
    }
    /**
     *
     * @param dim
     * @param deepest
     * @param level
     * @param zoo
     * @return
     */
    public static long zooAtLevelB(int dim, int deepest, int level, long zoo) {

        long tzoo1 = zoo;
        long tzoo2 = zoo;
        long tzoo3 = zoo;

        int div = (int) Math.pow(4, deepest-level);
        tzoo3 = tzoo3 / div;

        System.out.println("------------");
        for (int i = 0; i < deepest - level; i++) {
           tzoo1 = (tzoo1 / 4);
           tzoo2 = (long) Math.floor(tzoo2 /4);
        }

        System.out.println(">" + tzoo1);
        System.out.println(">" + tzoo2);
        System.out.println(">" + tzoo3);

        return (long) Math.floor(tzoo2);
    }

    /**
     *
     * @param dim
     * @param deepest
     * @param zooA
     * @param zooB
     * @return
     */
    public static double adjAtLevel2 (int dim, int deepest, long zooA, long zooB) {
        double dm = dim * Math.log(2);
        long axb = zooA ^ zooB;
        double laxb = Math.log(axb);
        double laxbdm = laxb / dm;
        return deepest - Math.floor(laxbdm);
    }


    public static void main(String[] args) {
        /*(long zoo;
        zoo = Morton2D.morton2d(0,0);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(1,0);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(0,1);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(1,1);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(15,15);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(8,9);
        Morton2D.log.info(zoo);
        zoo = Morton2D.morton2d(2146941188, 2147097832);
        Morton2D.log.info(zoo);
        */
        Morton2D.log.info("---------------------");
        //Morton2D.log.info(Morton2D.zooAtLevelA(2, 31, 18, 1072178917556894766L));
        Morton2D.log.info(Morton2D.zooAtLevelB(2, 31, 18, 1072178917556894766L));
        Morton2D.log.info("---------------------");
        //Morton2D.log.info(Morton2D.zooAtLevelA(2, 31, 18, 1072178917613240256L));
        Morton2D.log.info(Morton2D.zooAtLevelB(2, 31, 18, 1072178917613240256L));
        Morton2D.log.info("---------------------");

        /*Morton2D.log.info(Morton2D.adjAtLevel2(2, 31, 1072178917556894766L, 1072178917613240256L));
        Morton2D.log.info(Morton2D.adjAtLevel2(2, 31, 31, 32));
        Morton2D.log.info(Morton2D.adjAtLevel2(2, 31, 127, 128));
        Morton2D.log.info(Morton2D.adjAtLevel2(2, 31, 126, 132));*/
        /*Morton2D.log.info(Morton2D.adjAtLevel2(2, 31, 67108800, 10763310));
        Morton2D.log.info(Morton2D.zooAtLevelA(2, 31, 18, 67108800));
        Morton2D.log.info(Morton2D.zooAtLevelB(2, 31, 18, 67108800));
        Morton2D.log.info(Morton2D.zooAtLevelA(2, 31, 18, 10763310));
        Morton2D.log.info(Morton2D.zooAtLevelB(2, 31, 18, 10763310));*/
        //Morton2D.log.info(Morton2D.adjAtLevel2(2, 31, 0, 3));
    }
}
>>>>>>> 7bb2f3bc1ce16ec2328878a08d193592b6fbeb10

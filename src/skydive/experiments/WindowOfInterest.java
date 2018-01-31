package skydive.experiments;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import skydive.utils.Morton2D;

/**
 * Created by Piotr Lasek on 19.09.2017.
 */
public class WindowOfInterest {

    private static final Logger log = LogManager.getLogger(WindowOfInterest.class);

    private int x;
    private int y;
    private int width;
    private int level;
    private long zooA;
    private long zooB;
    int deepest = 31;
    int dim = 2;

    public WindowOfInterest(int level, int width, int x, int y) {
        this.level = level;
        this.width = width;
        this.x = x;
        this.y = y;
        this.zooA = Morton2D.morton2d(x, y);
        this.zooB = Morton2D.morton2d(x + width, y + width);
    }

    public WindowOfInterest(int level, int width, long zoo) {
        this.level = level;
        this.width = width;

        long cells = (long) Math.pow(Math.pow(2, width), dim);

        long zA = Utils.zooAtLevel(zoo, deepest, level);
        long zB = zA + cells;

        long znA = Utils.zooAtLevel(zA-1, level, deepest);
        long znB = Utils.zooAtLevel(zA+width, level, deepest);

        zooA = znA;
        zooB = znB;
        log.info("zoo mid: " + zoo);
    }

    public int getWidth() {
        return width;
    }

    public void setWidth(int width) {
        this.width = width;
    }

    public int getMinX() {
        return x;
    }

    public int getMinY() {
        return y;
    }

    public int getMaxX() {
        return x + width;
    }

    public int getMaxY() {
        return y + width;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public long getZooA() {
        return zooA;
    }

    public long getZooB() {
        return zooB;
    }


}

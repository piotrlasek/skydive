package skydive.db;

/**
 * Created by bozon92 on 8/8/2016.
 */
public class TimeTuple implements Tuple {
    public long time;
    public int count;

    public TimeTuple(long time, int count) {
        this.time = time;
        this.count = count;
    }

    //can't set time because String is immutable, so can't modify time, only read it in from the resultset

    public long getX() { return 0; }
    public long getY() { return 0; }
    public long getZ() { return 0; }

    public int getCount() { return count; }

    public int getTime() { return (int) time; }
}

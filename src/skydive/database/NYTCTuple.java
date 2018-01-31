package skydive.database;

/**
 * Created by Piotr Lasek on 02.08.2017.
 */
public class NYTCTuple implements Tuple {

    private long x;
    private long y;
    private float z;
    private long zoo;
    private long zalp1;
    private long zal;
    private long xal;
    private long yal;

    public NYTCTuple() {

    }

    public NYTCTuple(long x, long y, long z) {
        this.setX(x);
        this.setY(y);
        this.setZ(z);
    }

    @Override
    public long getX() {
        return x;
    }

    @Override
    public long getY() {
        return y;
    }

    @Override
    public float getZ() {
        return z;
    }

    @Override
    public int getTime() {
        return -1;
    }

    public void setX(long x) {
        this.x = x;
    }

    public void setY(long y) {
        this.y = y;
    }

    public void setZ(long z) {
        this.z = z;
    }

    public long getZoo() {
        return zoo;
    }

    public void setZoo(long zoo) {
        this.zoo = zoo;
    }

    public void setZalp1(long zalp1) {
        this.zalp1 = zalp1;
    }

    public void setZal(long zal) {
        this.zal = zal;
    }

    public long getZal() {
        return zal;
    }

    public long getZalp1() {
        return zalp1;
    }

    public void setXal(long xal) {
        this.xal = xal;
    }


    public void setYal(long yal) {
        this.yal = yal;
    }

    public long getYal() {
        return yal;
    }

    public long getXal() {
        return xal;
    }
}

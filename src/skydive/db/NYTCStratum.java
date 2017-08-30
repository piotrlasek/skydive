package skydive.db;

import javafx.geometry.Point3D;

import java.util.ArrayList;
import java.util.Collection;

public class NYTCStratum {

    Collection<NYTCTuple> tuples;
    int[] stratumCoordinates;
    long[] sumValues;
    private float maxZ;

    /**
     *
     * @param stratumCoordinates
     */
    public NYTCStratum(int[] stratumCoordinates) {
        sumValues = new long[3];

        this.stratumCoordinates = stratumCoordinates;
        tuples = new ArrayList<>();
    }

    public void clear() {
        tuples.clear();
    }

    /**
     *
     * @param tuple
     */
    public void addTuple(NYTCTuple tuple) {
        long x = tuple.getX();
        long y = tuple.getY();
        float z = tuple.getZ();
        sumValues[0] += x;
        sumValues[1] += y;
        sumValues[2] += z;

        if (z > maxZ)
            maxZ = z;

        tuples.add(tuple);
    }

    /**
     *
     * @return
     */
    public float getMaxZ() {
        return maxZ;
    }

    /**
     *
     * @return
     */
    public Collection<NYTCTuple> getTuples() {
        return tuples;
    }

    /**
     * Sets threeDStratum's coordinates
     * @param stratumCoordinates    threeDStratum's coordinates
     */
    public void setStratumCoordinates(int... stratumCoordinates) {
        this.stratumCoordinates = stratumCoordinates;
    }

    /**
     *
     * @return
     */
    public int[] getStratumCoordinates() {
        return stratumCoordinates;
    }

    /**
     *
     * @return
     */
    public int getTimeStratumNumber() {
        return stratumCoordinates[0];
    }

    public Point3D getMid() {
        int size = tuples.size();
        return new Point3D(sumValues[0] / size, sumValues[1] / size, 0);
    }
}

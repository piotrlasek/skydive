/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

import java.util.ArrayList;
import java.util.Collection;
import javafx.geometry.Point3D;

/**
 *
 * @author Piotr Lasek
 */
public class Stratum {
    
    Collection<Tuple> tuples;
    int[] stratumCoordinates;
    Point3D min;
    Point3D max;

    Integer minTime;
    Integer maxTime;

    /**
     * 
     * @param stratumCoordinates
     */
    public Stratum(int... stratumCoordinates) {
        this.stratumCoordinates = stratumCoordinates;
        tuples = new ArrayList<Tuple>();
    }
    
    public void clear() {
        tuples.clear();
        max = null;
        min = null;
    }
    
    public Point3D getMax() {
        return max;
    }
    
    public Point3D getMin() {
        return min;
    }
    
    public Point3D getMid() {
        return max.midpoint(min);
    }
    
    /**
     * 
     * @param tuple
     */
    public void addTuple(Tuple tuple) {
        
        if (tuples.size() == 0) {
            min = new Point3D(tuple.getX(), tuple.getY(), tuple.getZ());
            max = new Point3D(tuple.getX(), tuple.getY(), tuple.getZ());
        } else {
            if (tuple.getX() > max.getX()) max = new Point3D(tuple.getX(), max.getY(), max.getZ());
            if (tuple.getX() < min.getX()) min = new Point3D(tuple.getX(), min.getY(), min.getZ());
            if (tuple.getY() > max.getY()) max = new Point3D(max.getX(), tuple.getY(), max.getZ());
            if (tuple.getY() < min.getY()) min = new Point3D(min.getX(), tuple.getY(), min.getZ());
            if (tuple.getZ() > max.getZ()) max = new Point3D(max.getX(), max.getY(), tuple.getZ());
            if (tuple.getZ() < min.getZ()) min = new Point3D(min.getX(), min.getY(), tuple.getZ());
        }

        updateMinTime(tuple);
        updateMaxTime(tuple);

        tuples.add(tuple);
    }

    /**
     *
     * @param tuple
     */
    private void updateMaxTime(Tuple tuple) {
        if (maxTime == null) {
            maxTime = tuple.getTime();
        } else {
            if (tuple.getTime() > minTime) {
                maxTime = tuple.getTime();
            }
        }
    }

    /**
     *
     * @param tuple
     */
    private void updateMinTime(Tuple tuple) {
        if (minTime == null) {
            minTime = tuple.getTime();
        } else {
            if (tuple.getTime() < minTime) {
                minTime = tuple.getTime();
            }
        }
    }

    /**
     * 
     * @return 
     */
    public Collection<Tuple> getTuples() {
        return tuples;
    }

    /**
     * Sets stratum's coordinates
     * @param stratumCoordinates    stratum's coordinates
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
    public int getSpaceStratumNumber() {
        return stratumCoordinates[0];
    }

}

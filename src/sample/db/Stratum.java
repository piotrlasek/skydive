/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sample.db;

import java.util.ArrayList;
import java.util.Collection;
import javafx.geometry.Point3D;

/**
 *
 * @author Piotr Lasek
 */
public class Stratum {
    
    Collection<Tuple> tuples;
    int stratumNumber;
    Point3D min;
    Point3D max;
    private float baseTileSize = 1;
    
    /**
     * 
     * @param stratumNumber 
     */
    public Stratum(int stratumNumber) {
        this.stratumNumber = stratumNumber;
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
        
        tuples.add(tuple);
    }
    
    /**
     * 
     * @return 
     */
    public Collection<Tuple> getTuples() {
        return tuples;
    }

    /**
     * 
     * @return 
     */
    public int getStratumNumber() {
        return stratumNumber;
    }

    /**
     * 
     * @param stratumNumber 
     */
    public void setStratumNumber(int stratumNumber) {
        this.stratumNumber = stratumNumber;
    }

    public float getBaseTileSize() {
        return baseTileSize;
    }

    public void setBaseTileSize(float baseTileSize) {
        this.baseTileSize = baseTileSize;
    }
}

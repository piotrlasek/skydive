/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

import javafx.scene.paint.Color;

/**
 *
 * @author Piotr Lasek
 */
public class BaseTuple implements Tuple {
    
    public long x;
    
    public long y;
    
    public long value;

    public ValueObject valueObject;

    public int time;

    /**
     *
     * @param x
     * @param y
     * @param v
     */
    public BaseTuple(long x, long y, long v) {
        this.x = x;
        this.y = y;
        this.value = v;
    }

    /**
     *
     * @param x
     * @param y
     * @param vo
     */
    public BaseTuple(long x, long y, ValueObject vo) {
        this.valueObject = vo;
    }

    /**
     *
     * @parame time
     */
    public void setTime(int time) {
        this.time = time;
    }

    /**
     *
     * @return
     */
    public Color getColor() {
        // TODO: Hardcoded for days of weeks.
        String maxKey = valueObject.getMaxKey();
        Integer hue = 0;
        if (maxKey.equals("mon")) {hue = 0;} else
        if (maxKey.equals("tue")) {hue = 40;} else
        if (maxKey.equals("wed")) {hue = 80;} else
        if (maxKey.equals("thu")) {hue = 120;} else
        if (maxKey.equals("fri")) {hue = 160;} else
        if (maxKey.equals("sat")) {hue = 200;} else
        if (maxKey.equals("sun")) {hue = 240;}

        Color color = Color.hsb(hue, 1.0, 1.0, 1.0);
        return color;
    }

    /**
     *
     * @return
     */
    public long getX() {
        return x;
    }

    /**
     *
     * @return
     */
    public long getY() {
        return y;
    }

    /**
     *
     * @return
     */
    public long getZ() {
        return value;
    }

    /**
     *
     * @param z
     */
    public void setZ(long z) {this.value = z; }

    /**
     *
     * @return
     */
    public Integer getTime() {
        return time;
    }
    
}

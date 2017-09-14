/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

/**
 *
 * @author Piotr Lasek
 */
public interface Tuple {

    /**
     * TODO !!!
     */

    public long getX();
    public long getY();
    public float getZ();

    //both 3D and Time have "time" measure, but only 3D has X and Y, so the generic tuple should
    //have only "getTime", not getX and getY

    public int getTime();
}

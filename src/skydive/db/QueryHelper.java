/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Piotr Lasek
 */
public class QueryHelper {
    
    /**
     * 
     * @param layerNumber
     * @param attributes
     * @return 
     */
    public static String getStratum(int layerNumber, Object[] attributes) {
        
        StringBuilder sb = new StringBuilder();
        
        sb.append("SELECT ");
        
        int attributesCounter = 0;
        for(Object a : attributes) {
            sb.append( a + " ");
            if (attributesCounter+1 < attributes.length) {
                sb.append(", ");
            }
            attributesCounter++;
        }
        
        sb.append("FROM PYRAMID WHERE LAYER = " + layerNumber + " ");
        sb.append("ORDER BY " + attributes[0] + ", " + attributes[1] + " ASC ");
        
        System.out.println(sb.toString());
        
        return sb.toString();
    }
    
    /**
     * 
     * @param rs
     * @return 
     */
    public static Tuple toTuple(ResultSet rs, String[] measures,
            String attributes[]) throws SQLException {
        
        int x = rs.getInt(measures[0]);
        int y = rs.getInt(measures[1]);
        long v = (long) rs.getDouble(attributes[0]);

        BaseTuple bt;

        bt = new BaseTuple(x, y, v);

        if (attributes.length > 1) {
            ValueObject vo = new ValueObject();
            for (int i = 1; i < attributes.length; i++) {
                vo.put(attributes[i], rs.getInt(attributes[i]));
            }
            bt.valueObject = vo;
        } /*else {
            bt = new BaseTuple(x, y, v);
        }*/

        return bt;
    }
    
    /**
     * 
     */
    public static void createPyramid() {
        
    }
    
}

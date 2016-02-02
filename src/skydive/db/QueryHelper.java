/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Piotr Lasek
 */
public class QueryHelper {

    private static final Logger log = LogManager.getLogger(QueryHelper.class);

    /**
     * 
     * @param stratumCoordinates
     * @param measures
     * @param attributes
     * @return 
     */
    public static String getStratum(String tableName, String[] pyramidCoordinates,
                                    String[] measures, String[] attributes,
                                    int... stratumCoordinates)
        throws Exception {

        if (stratumCoordinates.length != measures.length) {
            throw new Exception("Number of stratum's coordinates should be equal to measures size.");
        }

        StringBuilder sb = new StringBuilder();
        int attributesCounter = 0;

        // SELECT
        // ------
        sb.append("SELECT ");

        for (Object m : measures) {
            sb.append( m + " ");
            if (attributesCounter + 1 < measures.length) {
                sb.append(", ");
            }
            attributesCounter++;
        }

        for (Object a : attributes) {
            sb.append(", " + a);
            attributesCounter++;
        }

        // FROM
        // ----
        sb.append("FROM " + tableName + " WHERE ");

        // WHERE
        int coordinateIndex = 0;
        for (String coordinate : pyramidCoordinates) {
            if (coordinateIndex > 0) {
                sb.append(" AND ");
            }
            sb.append(coordinate + " = " + stratumCoordinates[coordinateIndex]);
        }

        // ORDER BY
        // --------
        sb.append("ORDER BY ");

        for (Object m : measures) {
            sb.append(m);
            if (attributesCounter + 1 < measures.length) {

            }
        }

        // SORT
        // ----
        sb.append(" ASC ");

        log.info(sb.toString());
        
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
        // TODO: Pyramid creation should be managed by SKYDIVE. For now, it is created manually.
    }
    
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import skydive.gui.Filter;

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
    public static String getTuplesQuery(String uiLayout, String tableName, String[] pyramidCoordinates,
                                        String[] measures, String[] attributes,
                                        int[] stratumCoordinates,
                                        Filter filter)
        throws Exception {
        if (uiLayout.equals("3dview.fxml")) {
            if (stratumCoordinates.length != measures.length - 1) {
                throw new Exception("Number of stratum's coordinates should be one less than measures size.");
            }
        } else if (uiLayout.equals("timeview.fxml")) {
            if (stratumCoordinates.length != measures.length) {
                throw new Exception("Number of stratum's coordinates should be equal to measures size.");
            }
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
            if (uiLayout.equals("timeview.fxml")) {//need to take sum of count for timeview
                sb.append(", SUM(" + a + ") AS " + a);
            } else {
                sb.append(", " + a);
            }
            attributesCounter++;
        }

        // FROM
        // ----
        sb.append(" FROM " + tableName + " WHERE ");

        // WHERE
        int coordinateIndex = 0;
        for (String coordinate : pyramidCoordinates) {
            if (coordinateIndex > 0) {
                sb.append(" AND ");
            }
            sb.append(coordinate + " = " + stratumCoordinates[coordinateIndex]);
            coordinateIndex++;
        }

        // FILTER
        // ------
        if (filter != null && !filter.isEmpty()) {
            sb.append(" AND ");
            sb.append(filter.toSQL());
        }

        // GROUP BY (only for time, which groups by layer)
        if (uiLayout.equals("timeview.fxml")) {
            sb.append(" GROUP BY " + measures[0]);
            //first element because measures for time is an array of size 1
        }

        // ORDER BY
        // --------
        sb.append(" ORDER BY ");

        int measuresCounter = 0;
        for (Object m : measures) {
            if (measuresCounter > 0) {
                sb.append(", ");
            }
            sb.append(m);
            measuresCounter++;
        }

        // SORT
        // ----
        sb.append(" ASC");

        return sb.toString();
    }

    /**
     * 
     * @param rs
     * @return 
     */
    public static ThreeDTuple toThreeDTuple(ResultSet rs, String[] measures,
                                            String attributes[]) throws SQLException {
        
        int x = rs.getInt(measures[0]);
        int y = rs.getInt(measures[1]);
        int t = rs.getInt(measures[2]);
        long v = (long) rs.getDouble(attributes[0]);

        ThreeDTuple bt;

        bt = new ThreeDTuple(x, y, v);
        bt.setTime(t);

        if (attributes.length > 1) {
            ValueObject vo = new ValueObject();
            for (int i = 1; i < attributes.length; i++) {
                vo.put(attributes[i], rs.getInt(attributes[i]));
            }
            bt.valueObject = vo;
        } /*else {
            bt = new ThreeDTuple(x, y, v);
        }*/

        return bt;
    }

    public static TimeTuple toTimeTuple(ResultSet rs, String[] measures,
                                        String attributes[]) throws SQLException {
        long time = rs.getLong(measures[0]); //take this as a string so the axes can be created properly
        int count = rs.getInt(attributes[0]);

        TimeTuple tt;

        tt = new TimeTuple(time, count);
        return tt;
    }

    /**
     *
     */
    public static void createPyramid() {
        // TODO: Pyramid creation should be managed by SKYDIVE. For now, it is created manually.
    }
    
}

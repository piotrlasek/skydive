/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sample.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Piotr Lasek
 */
public class StratumLoader {
 
    /**
     * 
     * @param stratumNumber 
     */
    public static Stratum loadStratum(DatasetConfig ds, int stratumNumber) {
        
        Stratum stratum = new Stratum(stratumNumber);
        
        String driver = ds.getDriver();
        String wholeConnectionString = ds.getConnectionString();
        String[] connectionStringTab = wholeConnectionString.split(";");
        String connectionString = connectionStringTab[0];
        String userName = connectionStringTab[1];
        String password = connectionStringTab[2];
        String attributesList = ds.getAttributes();
        String[] attributes = attributesList.split(";");
        String measuresList = ds.getMeasures();
        String[] measures = measuresList.split(";");
        
        try {
            Class.forName(driver);
        } catch (ClassNotFoundException ex) {

        }
        
        try {
            Connection connection = DriverManager.getConnection(
                    connectionString, userName, password);

            Statement s = connection.createStatement();

            ArrayList<String> allAttributes = new ArrayList<String>();
            allAttributes.add("layer");
            for(String m:measures) allAttributes.add(m);
            for(String a:attributes) allAttributes.add(a);

            ResultSet rs = s.executeQuery(QueryHelper.getStratum(
                    stratum.getStratumNumber(), allAttributes.toArray()));
                    //new String[]{"layer", measures[0], measures[1], attributes[0]}));
           
            while(rs.next()) {
                Tuple tuple = QueryHelper.toTuple(rs, measures, attributes);
                stratum.addTuple(tuple);
            }
            
        } catch (Exception ex) {
           ex.printStackTrace();
        }
        
        return stratum;
    }
}

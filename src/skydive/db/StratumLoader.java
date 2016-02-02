/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.sql.*;
import java.util.ArrayList;

/**
 *
 * @author Piotr Lasek
 */
public class StratumLoader {

    private static final Logger log = LogManager.getLogger(StratumLoader.class);
    private DatasetConfig datasetConfig;
    private Connection connection;
    private String[] attributes;
    private String[] measures;

    /**
     *
     * @param datasetConfig
     */
    public StratumLoader(DatasetConfig datasetConfig) throws SQLException, ClassNotFoundException {
        this.datasetConfig = datasetConfig;

        String driver = this.datasetConfig.getDriver();
        String wholeConnectionString = this.datasetConfig.getConnectionString();
        String[] connectionStringTab = wholeConnectionString.split(";");
        String connectionString = connectionStringTab[0];
        String userName = connectionStringTab[1];
        String password = connectionStringTab[2];
        String attributesList = this.datasetConfig.getAttributes();
        String measuresList = this.datasetConfig.getMeasures();

        Class.forName(driver);
        connection = DriverManager.getConnection(connectionString, userName, password);
        attributes = attributesList.split(";");
        measures = measuresList.split(";");

        log.info("StratumLoader created.");
    }

    /*
     * 
     * @param stratumNumber
     */
    public Stratum loadStratum(int... stratumCoordinates) throws SQLException {
        Stratum stratum = new Stratum(stratumCoordinates);
        Statement statement = connection.createStatement();
        ArrayList<String> allAttributes = new ArrayList<String>();

        allAttributes.add("layer");

        for(String m:measures) allAttributes.add(m);
        for(String a:attributes) allAttributes.add(a);

        ResultSet rs = statement.executeQuery(
                QueryHelper.getStratum(measures, attributes, stratumCoordinates)
            );

        while(rs.next()) {
            Tuple tuple = QueryHelper.toTuple(rs, measures, attributes);
            stratum.addTuple(tuple);
        }

        log.info("Tuples added: " + stratum.getTuples().size());
            
        return stratum;
    }
}

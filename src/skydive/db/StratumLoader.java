/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import skydive.gui.Filter;

import java.sql.*;

/**
 * A class responsible for loading a stratum into memory.
 *
 * @author Piotr Lasek
 */
public class StratumLoader {

    private static final Logger log = LogManager.getLogger(StratumLoader.class);

    //private DatasetConfig datasetConfig;
    private DatabaseManager databaseManager;
    //private Connection connection;
    private String[] attributes;
    private String[] measures;
    String pyramidTableName;
    String[] pyramidCoordinates;

    /**
     * A constructor.
     *
     * @param datasetConfig a dataset configuration object
     * @throws SQLException
     * @throws ClassNotFoundException
     */
    public StratumLoader(DatabaseManager databaseManager, DatasetConfig datasetConfig) throws SQLException, ClassNotFoundException {
        this.databaseManager = databaseManager;

        attributes = datasetConfig.getAttributes().split(";");
        measures = datasetConfig.getMeasures().split(";");
        pyramidTableName = datasetConfig.getPyramidTableName();
        pyramidCoordinates = datasetConfig.getPyramidCoordinates();

        log.info("StratumLoader created.");
    }

    /**
     * Loads stratum identified by stratumCoordinates.
     *
     * @param stratumCoordinates coordinates of a stratum to be loaded
     */
    public Stratum loadStratum(int[] stratumCoordinates, Filter filter) throws SQLException {
        Stratum stratum = new Stratum(stratumCoordinates);
        Connection connection = databaseManager.getConnection();
        Statement statement = connection.createStatement();



        try {
            String query = QueryHelper.getTuplesQuery(pyramidTableName, pyramidCoordinates,
                measures, attributes, stratumCoordinates, filter);

            log.info("EXECUTING QUERY: ");

            ResultSet rs = statement.executeQuery(query);

            while(rs.next()) {
                Tuple tuple = QueryHelper.toTuple(rs, measures, attributes);
                stratum.addTuple(tuple);
            }

            log.info("DONE");
            log.info("Number or records read: " + stratum.getTuples().size());
        } catch (Exception e) {
            log.error(e);
        }

        return stratum;
    }
}

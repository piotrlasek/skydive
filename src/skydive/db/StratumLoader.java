/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import skydive.gui.Filter;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * A class responsible for loading a threeDStratum into memory.
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
    int maxNumberOfTimeIntervals;
    String uiLayout;

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
        uiLayout = datasetConfig.getUILayout();

        log.info("StratumLoader created.");
    }

    /**
     * Loads threeDStratum identified by stratumCoordinates.
     *
     * @param stratumCoordinates coordinates of a threeDStratum to be loaded
     */
    public ThreeDStratum loadThreeDStratum(int[] stratumCoordinates, Filter filter) throws SQLException {
        ThreeDStratum threeDStratum = new ThreeDStratum(stratumCoordinates);
        Connection connection = databaseManager.getConnection();
        Statement statement = connection.createStatement();

        try {
            String query = QueryHelper.getTuplesQuery(uiLayout, pyramidTableName, pyramidCoordinates,
                measures, attributes, stratumCoordinates, filter);

            log.info("EXECUTING QUERY: ");
            log.info(query);

            ResultSet rs = statement.executeQuery(query);

            while(rs.next()) {
                ThreeDTuple tuple = QueryHelper.toThreeDTuple(rs, measures, attributes);
                threeDStratum.addTuple(tuple);
            }

            log.info("DONE");
            log.info("Number of records read: " + threeDStratum.getTuples().size());
        } catch (Exception e) {
            log.error(e);
            e.printStackTrace();
        }

        return threeDStratum;
    }

    public TimeStratum loadTimeStratum(int[] stratumCoordinates, Filter filter) throws SQLException {
        TimeStratum timeStratum = new TimeStratum(stratumCoordinates);
        Connection connection = databaseManager.getConnection();
        Statement statement = connection.createStatement();

        try {
            String query = QueryHelper.getTuplesQuery(uiLayout, pyramidTableName, pyramidCoordinates,
                    measures, attributes, stratumCoordinates, filter);

            log.info("EXECUTING QUERY: ");
            log.info(query);

            ResultSet rs = statement.executeQuery(query);

            while(rs.next()) {
                TimeTuple tuple = QueryHelper.toTimeTuple(rs, measures, attributes);
                timeStratum.addTuple(tuple);
            }

            log.info("DONE");
            log.info("Number of records read: " + timeStratum.getTuples().size());
        } catch (Exception e) {
            log.error(e);
            e.printStackTrace();
        }
        return timeStratum;
    }
}

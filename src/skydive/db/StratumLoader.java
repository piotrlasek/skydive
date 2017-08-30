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
import java.util.ArrayList;

/**
 * A class responsible for loading a threeDStratum into memory.
 *
 * @author Piotr Lasek
 */
public class StratumLoader {

    private static final Logger log = LogManager.getLogger(StratumLoader.class);

    private DatabaseManager databaseManager;
    private String[] attributes;
    private String[] measures;
    String pyramidTableName;
    String[] pyramidCoordinates;
    String uiLayout;

    /**
     * A constructor.
     *
     * @param datasetConfig a dataset configuration object
     * @throws SQLException
     * @throws ClassNotFoundException
     */
    public StratumLoader(DatabaseManager databaseManager, DatasetConfig datasetConfig)
        throws SQLException, ClassNotFoundException {

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

    /**
     *
     * @param stratumCoordinates
     * @param filter
     * @return
     * @throws SQLException
     */
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

    /**
     *
     * @return
     */
    public NYTCStratum queryZoo(int level) throws SQLException {
        Connection connection = databaseManager.getConnection();
        Statement statement = connection.createStatement();
        NYTCStratum stratum = new NYTCStratum(null);

        ArrayList<Tuple> tuples = new ArrayList();
        Tuple t = new NYTCTuple();

        String q = "with tuples as ( " +
            "       select point as z, zoo, " +
            "              morton_dec_x(zoo) as x, " +
            "              morton_dec_y(zoo) as x, " +
            "              zooatlevel(cast(2 as smallint), cast(31 as smallint), lev, zoo) as zal, " +
            "              zooatlevel(cast(2 as smallint), cast(31 as smallint), cast(lev+1 as smallint), zoo) as zalp1, " +
            "              morton_dec_x( zooatlevel(cast(2 as smallint), cast(31 as smallint), lev, zoo)) as xal, " +
            "              morton_dec_y( zooatlevel(cast(2 as smallint), cast(31 as smallint), lev, zoo)) as yal " +
            "       from   pyramid " +
            "       where  lev = " + level + ")" +
            "select zoo, " +
            " zal, zalp1, ((cast(z as float) ) - cast((select min(z) from tuples) as float) ) as z, " +
            "       xal, yal, x, y " +
            "from  tuples";

        log.info(q);

        ResultSet rs = statement.executeQuery(q);

        while(rs.next()) {
            NYTCTuple tuple = QueryHelper.toNYTCTuple(rs);
            stratum.addTuple(tuple);
        }

        statement.close();

        return stratum;
    }
}

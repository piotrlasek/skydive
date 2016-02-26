/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.*;
import java.util.HashMap;
import java.util.Properties;

/**
 *
 * @author Piotr Lasek
 */
public class DatabaseManager {

    private static final Logger log = LogManager.getLogger(DatabaseManager.class);

    Connection connection;
    DatasetConfig datasetConfig;
    HashMap<String, DatasetConfig> datasets;

    public DatabaseManager(DatasetConfig datasetConfig) throws ClassNotFoundException {
        this.datasetConfig = datasetConfig;
        String driver = datasetConfig.getDriver();
        Class.forName(driver);
    }

    /**
     *
     * @return
     */
    public Connection getConnection() {
        if (connection == null) {
            String wholeConnectionString = datasetConfig.getConnectionString();
            String[] connectionStringTab = wholeConnectionString.split(";");
            String connectionString = connectionStringTab[0];
            String userName = connectionStringTab[1];
            String password = connectionStringTab[2];
            try {
                connection = DriverManager.getConnection(connectionString, userName, password);
            } catch (SQLException e) {
                log.error(e);
                e.printStackTrace();
            }
        }

        return connection;
    }


    /**
     *
     * @param query
     * @return
     */
    public Integer getInt(String query) {
        Integer result = null;

        try {
            Statement statement = getConnection().createStatement();
            statement.execute(query);
            ResultSet resultSet = statement.getResultSet();
            resultSet.next();
            result = resultSet.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
            log.error(e);
        }

        return result;
    }

    /**
     *
     */
    public DatabaseManager() {
        datasets = new HashMap<String, DatasetConfig>();
    }

    /**
     *
     * @param dc
     */
    public void addDataset(DatasetConfig dc) {
        datasets.put(dc.getName(), dc);
    }

    /**
     *
     * @param name
     * @param connectionString
     * @param measures
     * @param attributes
     * @param databaseType
     * @param driver
     * @param pyramidType
     * @param pyramidTableType
     * @param pyramidCoordinates
     * @param isNew
     * @return
     */
    public DatasetConfig createNew(String name, String connectionString,
            String measures, String attributes, String databaseType,
            String driver, String pyramidType, String pyramidTableType, String pyramidCoordinates,
            boolean isNew) {
        
        DatasetConfig dc = new DatasetConfig(name, connectionString,
        measures, attributes, databaseType, driver, pyramidType, pyramidTableType, pyramidCoordinates, isNew);
        
        return dc;
    }

    /**
     *
     * @param ds
     */
    /*public void save(DatasetConfig ds) {
        ds.save();
        if (ds.isIsNew()) {
            updateDatasetManagerFile(ds.getName());
        }
    }*/

    /**
     *
     * @param datasetName
     */
    private void updateDatasetManagerFile(String datasetName) {

        // update databases.proprerties file
        String databasesList = null;

        Properties propDatabaseList = new Properties();
        InputStream inputDatabaseList = null;

        // laod existing list od datasets
        try {
            inputDatabaseList = new FileInputStream("databases.properties");
            propDatabaseList.load(inputDatabaseList);
            databasesList = propDatabaseList.getProperty("list");            
        } catch (IOException ex) {
                ex.printStackTrace();
        } finally {
            if (inputDatabaseList != null) {
                try {
                    inputDatabaseList.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        Properties propDatabases = new Properties();
        OutputStream outputDatabases = null;

        // save updated list of data sets
        try {
            outputDatabases = new FileOutputStream("databases.properties");

            if (databasesList == null) {
                databasesList = datasetName;
            } else {
                databasesList = databasesList + "," + datasetName;
            }

            propDatabases.setProperty("list", databasesList);
            propDatabases.store(outputDatabases, null);
        } catch (IOException io) {
            io.printStackTrace();
        } finally {
            if (outputDatabases != null) {
                try {
                    outputDatabases.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

}

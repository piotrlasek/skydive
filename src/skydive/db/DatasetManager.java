/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.db;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Properties;

/**
 *
 * @author piotr
 */
public class DatasetManager {
    
    HashMap<String, DatasetConfig> datasets;
    
    public DatasetManager() {
        datasets = new HashMap<String, DatasetConfig>();
    }
    
    public void addDataset(DatasetConfig dc) {
        datasets.put(dc.getName(), dc);
    }
    
    public DatasetConfig createNew(String name, String connectionString,
            String measures, String attributes, String databaseType,
            String driver, String pyramidType, boolean isNew) {
        
        DatasetConfig dc = new DatasetConfig(name, connectionString,
        measures, attributes, databaseType, driver, pyramidType, isNew);
        
        return dc;
    }
    
    public void save(DatasetConfig ds) {
        ds.save();
        if (ds.isIsNew()) {
            updateDatasetManagerFile(ds.getName());
        }
    } 
    
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

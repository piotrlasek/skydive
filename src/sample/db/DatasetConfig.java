/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sample.db;

import java.io.*;
import java.util.Properties;

/**
 *
 * @author piotr
 */
public class DatasetConfig {
    
    private String name;
    private String measures;
    private String attributes;
    private String connectionString;
    private String databaseType;
    private boolean isNew;
    private String driver;
    private String fileName;

    public DatasetConfig() {
        
    }
    
    public DatasetConfig(String name, String connectionString,
            String measures, String attributes, String databaseType,
            String driver, boolean isNew) {
        this.name = name;
        this.measures = measures;
        this.attributes = attributes;
        this.connectionString = connectionString;
        this.databaseType = databaseType;
        this.driver = driver;
        this.isNew = isNew;
    }

    /**
     * 
     */
    public void save() {
        
        Properties prop = new Properties();
        OutputStream output = null;
        
        String fileName = getName();
        fileName = fileName.replace(" ", "_");
        
        try {
            output = new FileOutputStream(fileName);
            prop.setProperty("databaseName", getName());
            prop.setProperty("connectionString", getConnectionString());
            prop.setProperty("measures", getMeasures());
            prop.setProperty("attributes", getAttributes());
            prop.setProperty("databaseType", getDatabaseType());
            prop.setProperty("driver", getDriver());
            prop.store(output, null);
	} catch (IOException io) {
            io.printStackTrace();
	} finally {
            if (output != null) {
                try {
                        output.close();
                } catch (IOException e) {
                        e.printStackTrace();
                }
            }
	}
    }

    public void load(File f) {
        setFileName(f.getPath());

        InputStream input = null;

        Properties prop = new Properties();

        try {

            input = new FileInputStream(getFileName());

            prop.load(input);

            setName(prop.getProperty("databaseName"));
            setConnectionString(prop.getProperty("connectionString"));
            setMeasures(prop.getProperty("measures"));
            setAttributes(prop.getProperty("attributes"));
            setDriver(prop.getProperty("driver"));
            setDatabaseType(prop.getProperty("databaseType"));

        } catch (IOException ex) {
            ex.printStackTrace();
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public void load(String datasetName) {
        String fileName = datasetName.replace(" ", "_");

        File f = new File(fileName);

        load(f);

    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the measures
     */
    public String getMeasures() {
        return measures;
    }

    /**
     * @param measures the measures to set
     */
    public void setMeasures(String measures) {
        this.measures = measures;
    }

    /**
     * @return the attributes
     */
    public String getAttributes() {
        return attributes;
    }

    /**
     * @param attributes the attributes to set
     */
    public void setAttributes(String attributes) {
        this.attributes = attributes;
    }

    /**
     * @return the connectionString
     */
    public String getConnectionString() {
        return connectionString;
    }

    /**
     * @param connectionString the connectionString to set
     */
    public void setConnectionString(String connectionString) {
        this.connectionString = connectionString;
    }

    /**
     * @return the databaseType
     */
    public String getDatabaseType() {
        return databaseType;
    }

    /**
     * @param databaseType the databaseType to set
     */
    public void setDatabaseType(String databaseType) {
        this.databaseType = databaseType;
    }

    /**
     * @return the isNew
     */
    public boolean isIsNew() {
        return isNew;
    }

    /**
     * @param isNew the isNew to set
     */
    public void setIsNew(boolean isNew) {
        this.isNew = isNew;
    }

    /**
     * @return the driver
     */
    public String getDriver() {
        return driver;
    }

    /**
     * @param driver the driver to set
     */
    public void setDriver(String driver) {
        this.driver = driver;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
}

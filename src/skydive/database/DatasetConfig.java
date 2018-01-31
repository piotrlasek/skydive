/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package skydive.database;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 *
 * @author Piotr Lasek
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
    private String pyramidType;
    private String pyramidTableName;
    private String pyramidCoordinates;
    private String uiLayout;

    /**
     *
     * @param name
     * @param connectionString
     * @param measures
     * @param attributes
     * @param databaseType
     * @param driver
     * @param isNew
     */
    public DatasetConfig(String name, String connectionString,
                         String measures, String attributes, String databaseType,
                         String driver, String pyramidType, String pyramidTableName,
                         String pyramidCoordinates, String uiLayout, boolean isNew) {
        this.name = name;
        this.measures = measures;
        this.attributes = attributes;
        this.connectionString = connectionString;
        this.databaseType = databaseType;
        this.driver = driver;
        this.isNew = isNew;
        this.pyramidType = pyramidType;
        this.setPyramidTableName(pyramidTableName);
        this.setPyramidCoordinates(pyramidCoordinates);
        this.setUILayout(uiLayout);
    }

    /**
     *
     */
    public DatasetConfig() {

    }

    /**
     * 
     */
    /*public void save() {
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
            prop.setProperty("driver", getDriver());
            prop.setProperty("databaseType", getDatabaseType());
            prop.setProperty("pyramidType", getPyramidType());
            prop.setProperty("pyramidTableName", getPyramidTableName());
            prop.setProperty("pyramidCoordinates", getPyramidCoordinates());
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
    }*/

    /**
     *
     * @param fileName
     */
    public void load(File fileName) {
        setFileName(fileName.getPath());

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
            setPyramidType(prop.getProperty("pyramidType"));
            setPyramidCoordinates(prop.getProperty("pyramidCoordinates"));
            setPyramidTableName(prop.getProperty("pyramidTableName"));
            setUILayout(prop.getProperty("uiLayout"));
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


    /**
     *
     * @param datasetName
     */
    public void load(String datasetName) {
        String fileName = datasetName.replace(" ", "_");
        File f = new File(fileName);
        load(f);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMeasures() {
        return measures;
    }

    public void setMeasures(String measures) {
        this.measures = measures;
    }

    public String getAttributes() {
        return attributes;
    }

    public void setAttributes(String attributes) {
        this.attributes = attributes;
    }

    public String getConnectionString() {
        return connectionString;
    }

    public void setConnectionString(String connectionString) {
        this.connectionString = connectionString;
    }

    public String getDatabaseType() {
        return databaseType;
    }

    public void setDatabaseType(String databaseType) {
        this.databaseType = databaseType;
    }

    public boolean isIsNew() {
        return isNew;
    }

    public void setIsNew(boolean isNew) {
        this.isNew = isNew;
    }

    public String getDriver() {
        return driver;
    }

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getPyramidType() {
        return pyramidType;
    }

    public void setPyramidType(String pyramidType) {
        this.pyramidType = pyramidType;
    }

    public String getPyramidTableName() {
        return pyramidTableName;
    }

    public void setPyramidTableName(String pyramidTableName) {
        this.pyramidTableName = pyramidTableName;
    }

    public String[] getPyramidCoordinates() {
        return pyramidCoordinates.split(";");
    }

    public void setPyramidCoordinates(String pyramidCoordinates) {
        this.pyramidCoordinates = pyramidCoordinates;
    }

    public String getUILayout() { return uiLayout; }

    public void setUILayout(String uiLayout) { this.uiLayout = uiLayout; }
}

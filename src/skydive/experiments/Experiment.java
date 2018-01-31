package skydive.experiments;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import skydive.database.DatabaseManager;
import skydive.database.DatasetConfig;

import java.io.File;
import java.sql.*;

/**
 * Created by Piotr Lasek on 18.09.2017.
 */
public class Experiment {

    private static final Logger log = LogManager.getLogger(Experiment.class);
    DatabaseManager dm;
    Connection conn;

    /**
     *
     */
    public Experiment() {
        DatasetConfig datasetConfig = new DatasetConfig();
        datasetConfig.load(new File("C:\\Users\\Piotr\\GitHubProjects\\skydive\\conf\\NYTC[Postgresql].conf"));
        try {
            dm = new DatabaseManager(datasetConfig);
            conn = dm.getConnection();
        } catch (ClassNotFoundException e) {
            log.error(e);
        }
    }

    /**
     *
     * @throws SQLException
     */
    public void run() throws SQLException {
        Timer t = new Timer();
        QueryHelper qh = new QueryHelper();

        int lev = 29;
        int width = (int) Math.pow(2, lev+1);

        long zooMin = dm.getLong(qh.getMinZooQuery(lev));

        long zooMax = dm.getLong(qh.getMaxZooQuery(lev));
        long zooMid = (zooMin + zooMax) / 2;

        WindowOfInterest woi = new WindowOfInterest(lev, width, zooMin);
        String q = qh.generate(woi);

        Statement st;
        st = conn.createStatement();
        t.start("execute");
        st.execute(q);

        ResultSet rs = st.getResultSet();
        ResultSetMetaData rsmd = rs.getMetaData();
        String row = "";
        int cnt = 0;
        while(rs.next()) {
            /*row = "";
            for (int c = 1; c <= rsmd.getColumnCount(); c++) {
                row += rs.getObject(c) + "\t";
            }*/
            cnt++;
            //log.info(row);
        }
        t.stop("execute");

        log.info("level: " + lev);
        log.info("width: " + width);
        log.info("count: " + cnt);
        log.info("execute: " + t.getTime("execute"));
    }

    /**
     *
     * @param args
     */
    public static void main(String[] args) throws SQLException {
        log.info("Start experiment.");
        Experiment ex = new Experiment();
        ex.run();
        log.info("Experiment ended.");
    }
}

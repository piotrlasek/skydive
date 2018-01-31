package skydive;

import javafx.fxml.FXML;
import javafx.scene.chart.BarChart;
import javafx.scene.chart.CategoryAxis;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Slider;
import javafx.scene.control.TextField;
import javafx.scene.layout.Background;
import javafx.scene.layout.BorderPane;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import skydive.database.*;
import skydive.viewer.DataSetEditFrame;
import skydive.viewer.Filter;
import skydive.viewer.FilterAttribute;
import skydive.viewer.FilterInterval;

import java.io.File;
import java.sql.SQLException;

public class TimeController implements SkydiveController {
    private static final Logger log = LogManager.getLogger(TimeController.class);

    @FXML BorderPane chartPane;
    @FXML Slider sliderGranularity;
    @FXML Slider sliderTimeStart;
    @FXML TextField textFieldDatasetName;

    DatasetConfig datasetConfig;
    DatabaseManager databaseManager;
    TimeStratum timeStratum;
    int granularityNumber = 7;
    int timeStart = 0;
    int timeEnd = 0;
    int previousTimeStart = -1;

    private static final int BASE_INTERVAL_SIZE = 2048;

    private Filter filter;
    private Integer minTimeInStratum;
    private Integer maxTimeInStratum;

    @FXML public void initialize() {
        log.info("Initialize Time View");
        filter = new Filter();
    }

    public void prepareView(File file) {
        datasetConfig = new DatasetConfig();
        datasetConfig.load(file);
        try {
            databaseManager = new DatabaseManager(datasetConfig);
        } catch (ClassNotFoundException e) {
            log.error(e);
        }
        textFieldDatasetName.setText(datasetConfig.getName());
        initFX();
        updateView();
    }

    @FXML public void sliderGranularityMouseReleased() {
        log.info("sliderGranularityMouseReleased " + sliderGranularity.getValue());
        granularityNumber = (int) sliderGranularity.getValue();

        updateTimeSlider();
        updateView();
    }

    @FXML public void sliderTimeStartMouseDragged() {
        log.info("sliderTimeStartMouseDragged");
        timeStart = (int) sliderTimeStart.getValue();

        boolean exit = true;
        if (previousTimeStart != timeStart) {
            exit = false;
        }

        previousTimeStart = timeStart;

        if (exit == false) {
            // timeStart value has changed, updateView
            updateView();
        }
    }

    @FXML public void buttonDetailsMouseClicked() {
        log.info("buttonDetailsMouseClicked");
        DataSetEditFrame dsef = new DataSetEditFrame(datasetConfig);
        dsef.setVisible(true);
    }

    @FXML
    public void initFX() {
        log.info("initFX Time - START");
        sliderGranularity.setValue(7);
        sliderTimeStart.setValue(0);
        updateTimeSlider();
        updateView();
        log.info("initFX Time - END");
    }

    @FXML
    public void updateTimeSlider() {
        log.info("updateTimeSlider START");
        minTimeInStratum = databaseManager.getInt("SELECT min(time) from time_pyramid " +
                "where layer = " + granularityNumber);
        maxTimeInStratum = databaseManager.getInt("SELECT max(time) from time_pyramid " +
                "where layer = " + granularityNumber);
        sliderTimeStart.setMin(minTimeInStratum);
        sliderTimeStart.setMax(maxTimeInStratum);
        log.info("updateTimeSlider END");
    }

    @FXML
    public void updateFilter() {
        log.info("updateFilter START");
        filter.clear();

        //set timeEnd to adhere to a fixed interval size, determined by the layer number
        timeEnd = timeStart + (int) (BASE_INTERVAL_SIZE / (Math.pow(2, granularityNumber - 1)));
        FilterAttribute filterAttribute = new FilterAttribute();
        filterAttribute.setName("time");
        FilterInterval filterInterval = new FilterInterval();
        filterInterval.setMin("" + timeStart);
        filterInterval.setMax("" + timeEnd);

        filter.add(filterAttribute, filterInterval);
        log.info("updateFilter END");
    }

    @FXML
    private BarChart<String, Number> createChart(TimeStratum timeStratum) {
        final CategoryAxis xAxis = new CategoryAxis();
        final NumberAxis yAxis = new NumberAxis();
        final BarChart<String, Number> chart = new BarChart<>(xAxis, yAxis);
        chart.setBarGap(0);
        chart.setCategoryGap(0);
        chart.setLegendVisible(false);
        xAxis.setLabel("Time");
        xAxis.setTickLabelsVisible(true);
        xAxis.setTickMarkVisible(true);

        yAxis.setLabel("Count");
        XYChart.Series data = new XYChart.Series();
        data.setName("Time Data"); //will not show because legendVisible is set to false

        for (TimeTuple tuple : timeStratum.getTuples()) {
            data.getData().add(new XYChart.Data(Integer.toString(tuple.getTime()), tuple.getCount()));
        }

        chart.getData().addAll(data);
        chart.setBackground(Background.EMPTY);
        return chart;
    }

    @FXML
    public void updateView() {
        log.info("updateView START");

        granularityNumber = (int) sliderGranularity.getValue();
        timeStart = (int) sliderTimeStart.getValue();

        updateFilter();

        try {
            StratumLoader stratumLoader = new StratumLoader(databaseManager, datasetConfig);

            int[] stratumCoordinates = new int[datasetConfig.getPyramidCoordinates().length];
            for (int i = 0; i < stratumCoordinates.length; i++) {
                if (i == 0) stratumCoordinates[0] = granularityNumber;
            }
            log.info("t1");
            timeStratum = stratumLoader.loadTimeStratum(stratumCoordinates, filter);
            BarChart chart = createChart(timeStratum);
            chartPane.setCenter(chart);
        } catch (SQLException e) {
            log.error(e);
        } catch (ClassNotFoundException e) {
            log.error(e);
        }
        log.info("updateView END");
    }


}

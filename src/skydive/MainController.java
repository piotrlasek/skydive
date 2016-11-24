package skydive;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.embed.swing.SwingFXUtils;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Point3D;
import javafx.scene.*;
import javafx.scene.control.*;
import javafx.scene.image.WritableImage;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.RotateEvent;
import javafx.scene.input.ScrollEvent;
import javafx.scene.layout.Background;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import javafx.scene.paint.Color;
import javafx.scene.paint.PhongMaterial;
import javafx.scene.shape.*;
import javafx.scene.transform.Rotate;
import javafx.scene.transform.Scale;
import javafx.scene.transform.Translate;
import javafx.stage.FileChooser;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import skydive.db.*;
import skydive.gui.*;

import javax.imageio.ImageIO;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;

/**
 * Created by piotr on 15-03-01.
 */
public class MainController {
    private static final Logger log = LogManager.getLogger(MainController.class);

    @FXML StackPane stackPane;
    @FXML
    BorderPane borderPane;

    DatasetConfig datasetConfig;
    DatabaseManager databaseManager;

    IPlotController currentController;

    @FXML public void initialize() {
        log.info("INITIALIZE");

    }

    @FXML public void fileOpen() {
        FileChooser fileChooser = new FileChooser();
        fileChooser.setInitialDirectory(new File("."));
        fileChooser.setTitle("Open Resource File");
        File f = fileChooser.showOpenDialog(null);

        datasetConfig = new DatasetConfig();
        datasetConfig.load(f);


       SplitPane splitPane = null;

        FXMLLoader fxmlLoader = new FXMLLoader();
        try {
            String layoutFileName = datasetConfig.getViewLayoutFileName();
            log.info("Loading fxml file: " + layoutFileName);
            splitPane = (SplitPane) fxmlLoader.load(getClass().getResource(layoutFileName));
            //splitPane = (SplitPane) fxmlLoader.load(getClass().getResource(layoutFileName).openStream());
        } catch (IOException e) {
            e.printStackTrace();
        }

        CubeCheckinsController checkinsController = (CubeCheckinsController) fxmlLoader.getController();

        try {
            databaseManager = new DatabaseManager(datasetConfig);
            // textFieldDatasetName.setText(datasetConfig.getName());

            borderPane.setCenter(splitPane);

            currentController = checkinsController;

            currentController.initFX();
            currentController.updateStratum();
        } catch (ClassNotFoundException e) {
            log.error(e);
            /*Alert alert = new Alert(Alert.AlertType.INFORMATION);
            alert.setTitle("Error");
            alert.setHeaderText("Error loading configuration file: " +
                    datasetConfig.getFileName());
            alert.setContentText(e.getMessage());
            alert.showAndWait();*/
        }

        currentController.initFX();
        currentController.updateStratum();
    }



}

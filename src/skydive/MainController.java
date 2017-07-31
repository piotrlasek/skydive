package skydive;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.layout.BorderPane;
import javafx.stage.FileChooser;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import skydive.db.DatasetConfig;

import java.io.File;
import java.io.IOException;

/**
 * Created by piotr on 15-03-01.
 */
public class MainController {
    private static final Logger log = LogManager.getLogger(MainController.class);

    @FXML
    BorderPane borderPane;

    DatasetConfig datasetConfig;

    private String uiLayout;

    @FXML
    public void fileOpen() {
        FileChooser fileChooser = new FileChooser();
        fileChooser.setInitialDirectory(new File("."));
        fileChooser.setTitle("Open Resource File");
        File f = fileChooser.showOpenDialog(null);
        datasetConfig = new DatasetConfig();
        datasetConfig.load(f);
        uiLayout = datasetConfig.getUILayout();

        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource(uiLayout));
            BorderPane bp = loader.load();
            Object controller = loader.getController();
            SkydiveController skydiveController = (SkydiveController) controller;
            skydiveController.prepareView(f);
            borderPane.setCenter(bp);
        } catch (IOException e) {
            e.printStackTrace();
            log.error(e);
        }

        /*if (uiLayout.equals("nytc-view.fxml")) {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("3dview.fxml"));
                BorderPane view = loader.load();
                NYTCController controller = loader.getController();
                controller.prepareView(f);//set up everything you need to use initfx and updatestratum in 3dctrl
                borderPane.setCenter(view);
            } catch (Exception e) {
                log.error(e);
            }
        } else if (uiLayout.equals("3dview.fxml")) {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("3dview.fxml"));
                BorderPane view3D = loader.load();
                ThreeDController threedCtrl = loader.getController();
                threedCtrl.prepareView(f);//set up everything you need to use initfx and updatestratum in 3dctrl
                borderPane.setCenter(view3D);
            } catch (Exception e) {
                log.error(e);
            }
        } else if (uiLayout.equals("timeview.fxml")) {
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("timeview.fxml"));
                BorderPane viewTime = loader.load();
                TimeController timeCtrl = loader.getController();
                timeCtrl.prepareView(f);
                borderPane.setCenter(viewTime);
            } catch (Exception e) {
                log.error(e);
            }
        }*/
    }

    @FXML
    public void initialize() {
        log.info("Initialize Main Window");
    }

}

package skydive;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.embed.swing.SwingFXUtils;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.geometry.Point3D;
import javafx.scene.*;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.control.TextField;
import javafx.scene.image.WritableImage;
import javafx.scene.input.*;
import javafx.scene.layout.Background;
import javafx.scene.layout.StackPane;
import javafx.scene.paint.Color;
import javafx.scene.paint.PhongMaterial;
import javafx.scene.shape.Box;
import javafx.scene.shape.MeshView;
import javafx.scene.transform.Rotate;
import javafx.scene.transform.Scale;
import javafx.scene.transform.Translate;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import skydive.db.*;
import skydive.gui.*;

import javax.imageio.ImageIO;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;

public class NYTCController implements SkydiveController {
    private static final Logger log = LogManager.getLogger(NYTCController.class);

    @FXML StackPane stackPane;
    @FXML Slider sliderSpaceStratum;
    @FXML Slider sliderTimeStratum;
    @FXML TextField textFieldDatasetName;
    @FXML Slider sliderHueShift;
    @FXML Slider sliderScaleZ;
    @FXML Slider sliderBaseTile;
    @FXML CheckBox checkBoxAxes;
    @FXML CheckBox checkBoxWire;
    @FXML CheckBox checkBoxPerspective;
    @FXML Slider timeFilterSlider;

    SubScene scene;
    MeshView meshView;
    ViewConfig viewConfig = new ViewConfig();
    DatasetConfig datasetConfig;
    DatabaseManager databaseManager;
    NYTCStratum nytcStratum;
    Group rectangleGroup;
    Group axes = new Group();
    int level = 9;
    int timeStratumNumber = 9;

    /*private double mouseYold;
    private double cameraYlimit;
    private double mouseXold;
    private double rotateModifier;*/

    private Filter filter;
    private int previousTimeStratumNumber = -1;
    private int previousSpaceStratum = -1;
    private Integer minTimeInStratum;
    private Integer maxTimeInStratum;

    @FXML public void initialize() {
        log.info("Initialize 3D View");
        filter = new Filter();
        FilterAttribute filterAttribute = new FilterAttribute();
        filterAttribute.setName("time");
        FilterInterval filterInterval = new FilterInterval();
        filterInterval.setMin("1");
        filterInterval.setMax("2");

        timeFilterSlider.valueProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {

                log.info("timeFilterSlider.changed START");
                int value = (int) timeFilterSlider.getValue();

                //int filterMax = (int) (((float) value / (float) 100) * (maxTimeInStratum - minTimeInStratum) + minTimeInStratum);
                //int filterMax = 1;
                int filterMax = value;

                FilterAttribute filterAttribute = new FilterAttribute();
                filterAttribute.setName("time");
                FilterInterval filterInterval = new FilterInterval();
                filterInterval.setMin("" + (filterMax - 1));
                filterInterval.setMax("" + filterMax);

                // Filter values for time
                filter.add(filterAttribute, filterInterval);

                updateStratum();

                log.info(minTimeInStratum + ", " + maxTimeInStratum + " " + value + ", filterMax: " + filterMax);
                log.info("timeFilterSlider.changed END");
            }
        });
    }

    //Configure the view while opening the dataset file before showing it
    public void prepareView(File file) {
        datasetConfig = new DatasetConfig();
        datasetConfig.load(file);
        try {
            databaseManager = new DatabaseManager(datasetConfig);
        } catch (ClassNotFoundException e) {
            log.error(e);
        }
        textFieldDatasetName.setText(datasetConfig.getName());
        viewConfig.setPlotType(ViewConfig.PlotType.BOXES);
        initFX();
        updateStratum();
    }

    @FXML public void checkBoxPerspectiveClicked() {
        if (checkBoxPerspective.isSelected()) {
            log.info("Camera type: perspective.");
            viewConfig.setCameraType("perspective");
        } else {
            log.info("Camera type: parallel.");
            viewConfig.setCameraType("parallel");
        }
        updateStratum();
    }

    @FXML public void loadTest() {
        File f = new File("/Users/piotr/NetBeansProjects/JavaFXApplication1/Checkins_[MonetDB]");

        datasetConfig = new DatasetConfig();
        datasetConfig.load(f);
    }

    @FXML public void buttonResetAnglesClicked() {
        log.info("buttonResetAnglesClicked");
        viewConfig.resetAngles();
    }

    @FXML public void buttonResetScaleClicked() {
        log.info("buttonResetScaleClicked");
        viewConfig.resetScale();
    }

    @FXML public void buttonSaveChangesClicked() {
        log.info("buttonSaveChangesClicked");
    }

    @FXML public void sliderBaseTileSizeMouseReleased() {
        log.info("sliderBaseTileSizeMouseReleased");
        viewConfig.setBaseTileSize((float) sliderBaseTile.getValue() / 100);
        updateStratum();
    }

    @FXML public void sliderTimeStratumMouseDragged() {
        log.info("sliderTimeStratumMouseDragged");

        /*minTimeInStratum = databaseManager.getInt("SELECT min(time) from cubed_pyramid " +
                "where space_layer = " + level + " and  " +
                "time_layer = " + timeStratumNumber);

        maxTimeInStratum = databaseManager.getInt("SELECT max(time) from cubed_pyramid " +
                "where space_layer = " + level + " and  " +
                "time_layer = " + timeStratumNumber);

        timeFilterSlider.setMax(maxTimeInStratum);

        level = (int) sliderSpaceStratum.getValue();
        timeStratumNumber = (int) sliderTimeStratum.getValue();

        boolean exit = true;

        if (previousTimeStratumNumber != timeStratumNumber ||
                previousSpaceStratum != level) {
            exit = false;
        }

        previousSpaceStratum = level;
        previousTimeStratumNumber = timeStratumNumber;

        if (exit == false) {
            // time nytcStratum changed.
            // determining minimum time interval...

            //updateTimeSlider();

            // updating nytcStratum
            updateStratum();
        }*/
    }

    @FXML public void onTimeFilterSliderDragged() {
    }

    @FXML public void sliderHueShiftMouseReleased() {
        log.info("sliderHueShiftMouseReleased");
        viewConfig.setHueShift(sliderHueShift.getValue());
        updateStratum();
    }

    @FXML public void sliderScaleZMouseReleased() {
        log.info("sliderScaleZMouseReleased");
        float sz = (float) sliderScaleZ.getValue() / 100;
        viewConfig.setScaleZ(sz);
        updateStratum();
    }

    @FXML public void checkBoxAxesClicked() {
        log.info("checkBoxAxesClicked");

        if (!checkBoxAxes.isSelected()) {
            axes.setVisible(false);
        } else {
            axes.setVisible(true);
        }
    }

    @FXML public void buttonDetailsMouseClicked() {
        log.info("buttonDetailsMouseClicked");
        DataSetEditFrame dsef = new DataSetEditFrame(datasetConfig);
        dsef.setVisible(true);
    }

    @FXML public void radioButtonMeshClicked() {
        viewConfig.setPlotType(ViewConfig.PlotType.MESH);
        updateStratum();
    }

    @FXML public void radioButtonBoxesClicked() {
        viewConfig.setPlotType(ViewConfig.PlotType.BOXES);
        // Remove mesh...
        if (meshView != null)
            axes.getChildren().remove(meshView);

        updateStratum();
    }

    @FXML public void radioButtonTilesClicked() {
        viewConfig.setPlotType(ViewConfig.PlotType.TILES);

        if (meshView != null)
            axes.getChildren().remove(meshView);

        updateStratum();
    }

    @FXML public void sliderSpaceStratumMouseReleased() {
        log.info("sliderSpaceStratumMouseReleased " + sliderSpaceStratum.getValue());
        level = (int) sliderSpaceStratum.getValue();
        updateStratum();
    }

    @FXML public void sliderTimeStratumMouseReleased() {
        log.info("sliderTimeStratumMouseReleased " + sliderTimeStratum.getValue());
        timeStratumNumber = (int) sliderTimeStratum.getValue();
        updateStratum();
    }

    @FXML public void checkBoxWireClicked() {
        if (checkBoxWire.isSelected()) {
            viewConfig.setWireMesh(true);
        } else {
            viewConfig.setWireMesh(false);
        }
        updateStratum();
    }

    @FXML public void buttonSnapshotClicked() {
        WritableImage wi = new WritableImage(800,800);
        SnapshotParameters param = new SnapshotParameters();
        //param.setCamera(ParallelCameraBuilder.create().fieldOfView(45).build());
        param.setDepthBuffer(true);
        //param.setFill(Color.CORNSILK);

        WritableImage snapshot = rectangleGroup.snapshot(param, wi);

        File output = new File("snapshot" + new Date().getTime() + ".png");
        try {
            ImageIO.write(SwingFXUtils.fromFXImage(snapshot, null), "png", output);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     *
     */
    @FXML
    public void initFX() {
        log.info("initFX 3D - START");
        StackPane root = new StackPane();
        root.setBackground(Background.EMPTY);
        scene = new SubScene(root, 800, 600, true, SceneAntialiasing.BALANCED);
        scene.heightProperty().bind(stackPane.heightProperty());
        scene.widthProperty().bind(stackPane.widthProperty());

        scene.setFill(Color.WHITE);
        rectangleGroup = new Group();
        rectangleGroup.getChildren().add(viewConfig.getBase());

        root.getChildren().add(rectangleGroup);

        createAxes(rectangleGroup);

        //Camera camera = viewConfig.getCamera();
        //scene.setCamera(camera);

        rectangleGroup.getTransforms().add(viewConfig.getRx());
        rectangleGroup.getTransforms().add(viewConfig.getRy());
        rectangleGroup.getTransforms().add(viewConfig.getRz());

        scene.getRoot().getTransforms().add(viewConfig.getScale());

        scene.setOnScroll(new EventHandler<ScrollEvent>() {
            @Override
            public void handle(ScrollEvent event) {
                double dy = event.getDeltaY();
                Scale scale = viewConfig.getScale();
                if (dy > 0) {
                    double sx = scale.getX();
                    scale.setX(sx + 0.1);
                    scale.setY(sx + 0.1);
                    scale.setZ(sx + 0.1);
                } else if (dy < 0) {
                    double sx = scale.getX();
                    scale.setX(sx - 0.1);
                    scale.setY(sx - 0.1);
                    scale.setZ(sx - 0.1);
                }
            }
        });

        scene.setOnRotate(new EventHandler<RotateEvent>() {
            @Override
            public void handle(RotateEvent event) {
            }
        });

        scene.setOnMouseClicked(new EventHandler<MouseEvent>() {
            @Override
            public void handle(MouseEvent event) {
                //log.info("scene.mouseClicked: " + x + ", " + y + " SOURCE: " + event.getSource().toString());
                PickResult pr = event.getPickResult();
                //log.info(pr.getIntersectedNode().getId());
                //log.info(pr.toString());

                String idTab[] = pr.getIntersectedNode().getId().split(",");
                long zoo = new Long(idTab[0]);
                long zal = new Long(idTab[1]);
                long zalp1 = new Long(idTab[2]);
                long x = new Long(idTab[3]);
                long y = new Long(idTab[4]);
                long xal = new Long(idTab[5]);
                long yal = new Long(idTab[6]);

                log.info("x: " + x + ", y: " + y + ", zoo: " + zoo + ", zal: " + zal + ", zalp1: " + zalp1);
            }
        });

        scene.setOnMouseDragged(new EventHandler<MouseEvent>() {

            @Override
            public void handle(MouseEvent event) {

                MouseButton button = event.getButton();

                double otx = viewConfig.getOtx();
                double oty = viewConfig.getOty();
                double tx = viewConfig.getTx();
                double ty = viewConfig.getTy();
                double tz = viewConfig.getTz();
                Rotate rx = viewConfig.getRx();
                Rotate rz = viewConfig.getRz();
                Rotate ry = viewConfig.getRy();

                if (button.equals(MouseButton.PRIMARY)) {

                    if (event.isShiftDown()) {
                        if (otx == 0d) otx = event.getSceneX();
                        double dx = otx - event.getSceneX();

                        otx = event.getSceneX();
                        oty = event.getSceneY();
                        tz += dx;
                        rz.setAngle(tz);
                    } else {
                        if (otx == 0d) {
                            otx = event.getSceneX();
                        }

                        double dx = otx - event.getSceneX();
                        //if (dx > 0) tx += 1; else tx -= 1;

                        if (oty == 0) oty = event.getSceneY();
                        double dy = oty - event.getSceneY();
                        //if (dy > 0) ty += 1; else ty -= 1;

                        otx = event.getSceneX();
                        oty = event.getSceneY();

                        tx += -dy;
                        ty += dx;

                        rx.setAngle(tx);
                        ry.setAngle(ty);
                    }
                }

                viewConfig.setOtx(otx);
                viewConfig.setOty(oty);
                viewConfig.setTx(tx);
                viewConfig.setTy(ty);
                viewConfig.setTz(tz);
                viewConfig.setRx(rx);
                viewConfig.setRy(ry);
                viewConfig.setRz(rz);
            }
        });

        stackPane.getChildren().add(scene);

        log.info("initFX 3D - END");
    }

    /**
     *
     * @param rectangleGroup
     */
    private void drawTuples(Group rectangleGroup) {

        // assumes that the nytcStratum is loaded
        double tileSize = 2; // viewConfig.getBaseTileSize() * Math.pow(2, nytcStratum.getSpaceStratumNumber());

        Box b1 = new Box(50, 50, 30);
        b1.translateXProperty().set(0);
        b1.translateYProperty().set(0);
        b1.setOnMouseClicked(new EventHandler<MouseEvent>() {
            @Override
            public void handle(MouseEvent event){
                log.info("b1");
            }
        });
        b1.setId("BOX 1");

        Box b = new Box(50, 50, 50);
        b.translateXProperty().set(60);
        b.translateYProperty().set(60);

        b.setOnMouseClicked(new EventHandler<MouseEvent>() {
            @Override
            public void handle(MouseEvent event) {
                log.info("b2");
            }
        });
        b.setId("BOX 2");


        //nytcStratum = StratumLoader.loadStratum(datasetConfig, stratumNumber);
        Point3D midTmp = nytcStratum.getMid();
        Point3D midData = midTmp.multiply(tileSize);

        Group plot = new Group();

        plot.setOnMouseClicked(new EventHandler<MouseEvent>() {
            @Override
            public void handle(MouseEvent event) {
                log.info("group");
            }
        });


        plot.setOnMouseClicked(new EventHandler<MouseEvent>() {
            @Override
            public void handle(MouseEvent event) {
                log.info("plot");
            }
        });

        // Show TILES or BOXES
        for (NYTCTuple bt : nytcStratum.getTuples()) {
            //double z = (bt.value / nytcStratum.getMax().getZ()) * 200;
            double z = viewConfig.getScaleZ() * 100f * bt.getZ() / nytcStratum.getMaxZ();
            double i = (bt.getX() * tileSize - midData.getX());
            double j = (bt.getY() * tileSize - midData.getY());

            Node node = null;

            double zTranslate = z - midTmp.getZ();

            Box box = new Box(tileSize, tileSize, 0);

            Color c;
            double colorZ = bt.getZ() / nytcStratum.getMaxZ();
            double saturation = 1;
            c = Color.hsb(240 + 360 * colorZ + viewConfig.getHueShift(), saturation, 1.0, 1);

            PhongMaterial pm = new PhongMaterial();
            pm.setDiffuseColor(c);
            pm.setSpecularColor(c);
            box.setMaterial(pm);
            box.setId("" + bt.getZoo() + "," + bt.getZal() + "," + bt.getZalp1() + "," + bt.getX() + "," + bt.getY() + "," +
                    bt.getXal() + "," + bt.getYal() + "," + bt.getZ());

            node = box;
            node.translateYProperty().set(j);
            node.translateXProperty().set(i);

            plot.getChildren().add(node);
        }

        // add plot
        rectangleGroup.getChildren().add(plot);

    }

    /**
     * Never called because viewConfig.setHueShift is always used instead
     * @param hueShift
     */
    public void setHueShift(int hueShift) {
        viewConfig.setHueShift(hueShift);
    }

    /**
     *
     * @param rectangleGroup
     */
    public void createAxes(Group rectangleGroup) {
        log.info("createAxes");

        double axisLength = 600d;

        Box axisX = this.createAxis(Rotate.X_AXIS, axisLength);
        Box axisY = this.createAxis(Rotate.Y_AXIS, axisLength);
        Box axisZ = this.createAxis(Rotate.Z_AXIS, axisLength);

        axes.getChildren().add(axisX);
        axes.getChildren().add(axisY);
        axes.getChildren().add(axisZ);

        Label lx = new Label();
        Translate tlx = new Translate(0.9*axisLength/2, 0);
        lx.setText("x");
        lx.getTransforms().add(tlx);
        axes.getChildren().add(lx);

        Label ly = new Label();
        Translate tly = new Translate(0, 0.9*axisLength/2);
        ly.setText("y");
        ly.getTransforms().add(tly);
        axes.getChildren().add(ly);

        Label lz = new Label();
        Translate tlz = new Translate(0, 0, 0.9*axisLength/2);
        lz.setText("z");
        lz.getTransforms().add(tlz);
        axes.getChildren().add(lz);

        // TODO: FIX IT!
        //rectangleGroup.getChildren().add(axes);
    }

    /**
     *
     * @param ax
     * @param width
     * @return
     */
    public Box createAxis(Point3D ax, double width) {
        // apply transformations
        double size = .5;
        Box axis = null;

        if (ax.equals(Rotate.X_AXIS)) {
            Translate t = new Translate();
            //t.deltaTransform(width/2, 0, 0);
            axis = new Box(width, size, size);
            //axis.getTransforms().add(t);
            //axis.setTranslateX(-width/2);
        } else if (ax.equals(Rotate.Y_AXIS)) {
            axis = new Box(size, width, size);
        } else if (ax.equals(Rotate.Z_AXIS)) {
            axis = new Box(size, size, width);
        }

        return axis;
    }

    /**
     *
     */
    public void updateStratum() {
        log.info("updateStratum START");

        level = (int) sliderSpaceStratum.getValue();
        timeStratumNumber = (int) sliderTimeStratum.getValue();

        try {
            StratumLoader stratumLoader = new StratumLoader(databaseManager, datasetConfig);

            // TODO: The below section is hardcoded for pyramids and cubed pyramids with time.
            int[] stratumCoordinates = new int[datasetConfig.getPyramidCoordinates().length];
            for (int i = 0; i < stratumCoordinates.length; i++) {
                if (i == 0) stratumCoordinates[i] = level;
                if (i == 1) stratumCoordinates[i] = timeStratumNumber;
            }

            log.info("t1");

            nytcStratum = stratumLoader.queryZoo(level);

            log.info("t2");
            rectangleGroup.getChildren().clear();
            log.info("t3");
            //scene.setCamera(viewConfig.getCamera());
            drawTuples(rectangleGroup);
            log.info("t4");
            createAxes(rectangleGroup);
            log.info("t5");
        } catch (SQLException e) {
            log.error(e);
        } catch (ClassNotFoundException e) {
            log.error(e);
        }
        log.info("updateStratum END");
    }
}

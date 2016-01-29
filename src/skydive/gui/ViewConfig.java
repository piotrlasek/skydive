package skydive.gui;

import javafx.scene.Camera;
import javafx.scene.ParallelCamera;
import javafx.scene.PerspectiveCamera;
import javafx.scene.paint.Color;
import javafx.scene.paint.PhongMaterial;
import javafx.scene.shape.Rectangle;
import javafx.scene.transform.Rotate;
import javafx.scene.transform.Scale;
import javafx.scene.transform.Translate;

/**
 * Created by Piotr Lasek on 15-03-02.
 */
public class ViewConfig {

    public ViewConfig() {
        base.setFill(Color.TRANSPARENT);
        perspectiveCamera = new PerspectiveCamera();
        parallelCamera = new ParallelCamera();
    }

    private PhongMaterial material = new PhongMaterial(Color.WHITE);

    private Rectangle base = new Rectangle(-1000, -1000, 2000, 2000);

    private PerspectiveCamera perspectiveCamera;

    private ParallelCamera parallelCamera;

    private String cameraType = "perspective";

    private Rotate rx = new Rotate(0d, Rotate.X_AXIS);

    private Rotate ry = new Rotate(0d, Rotate.Y_AXIS);

    private Rotate rz = new Rotate(0d, Rotate.Z_AXIS);

    private Translate transXY = new Translate(0d, 0d, 0d);

    private Scale scale = new Scale(1,1);

    private double tx = 0d;

    private double ty = 0d;

    private double tz = 0d;

    private double otx = 0d;

    private double oty = 0d;

    private int windowWidth = 700;

    private int windowHeight = 600;

    private int stratumNumber = 9;

    private double hueShift;

    private float baseTileSize = 1;

    private double scaleZ = 1d;

    private PlotType plotType;

    private boolean wireMesh = false;

    /**
     *
     */
    public void resetAngles() {

        getRx().setAngle(0d);
        getRy().setAngle(0d);
        getRz().setAngle(0d);
        setOtx(0d);
        setOty(0d);
        setTz(0d);
        setTy(0d);
        setTz(0d);
    }

    /**
     *
     */
    public void resetScale() {
        getScale().setX(1d);
        getScale().setY(1d);
        getScale().setZ(1d);
    }

    public PhongMaterial getMaterial() {
        return material;
    }

    public void setMaterial(PhongMaterial material) {
        this.material = material;
    }

    public Rectangle getBase() {
        return base;
    }

    public void setBase(Rectangle base) {
        this.base = base;
    }

    public Rotate getRx() {
        return rx;
    }

    public void setRx(Rotate rx) {
        this.rx = rx;
    }

    public Rotate getRy() {
        return ry;
    }

    public void setRy(Rotate ry) {
        this.ry = ry;
    }

    public Rotate getRz() {
        return rz;
    }

    public void setRz(Rotate rz) {
        this.rz = rz;
    }

    public Translate getTransXY() {
        return transXY;
    }

    public void setTransXY(Translate transXY) {
        this.transXY = transXY;
    }

    public Scale getScale() {
        return scale;
    }

    public void setScale(Scale scale) {
        this.scale = scale;
    }

    public double getTx() {
        return tx;
    }

    public void setTx(double tx) {
        this.tx = tx;
    }

    public double getTy() {
        return ty;
    }

    public void setTy(double ty) {
        this.ty = ty;
    }

    public double getTz() {
        return tz;
    }

    public void setTz(double tz) {
        this.tz = tz;
    }

    public double getOtx() {
        return otx;
    }

    public void setOtx(double otx) {
        this.otx = otx;
    }

    public double getOty() {
        return oty;
    }

    public void setOty(double oty) {
        this.oty = oty;
    }

    public int getWindowWidth() {
        return windowWidth;
    }

    public void setWindowWidth(int windowWidth) {
        this.windowWidth = windowWidth;
    }

    public int getWindowHeight() {
        return windowHeight;
    }

    public void setWindowHeight(int windowHeight) {
        this.windowHeight = windowHeight;
    }

    public int getStratumNumber() {
        return stratumNumber;
    }

    public void setStratumNumber(int stratumNumber) {
        this.stratumNumber = stratumNumber;
    }

    public double getHueShift() {
        return hueShift;
    }

    public void setHueShift(double hueShift) {
        this.hueShift = hueShift;
    }

    public float getBaseTileSize() {
        return baseTileSize;
    }

    public void setBaseTileSize(float baseTileSize) {
        this.baseTileSize = baseTileSize;
    }

    public double getScaleZ() {
        return scaleZ;
    }

    public void setScaleZ(double scaleZ) {
        this.scaleZ = scaleZ;
    }

    public PlotType getPlotType() {
        return plotType;
    }

    public void setPlotType(PlotType plotType) {
        this.plotType = plotType;
    }

    public boolean isWireMesh() {
        return wireMesh;
    }

    public void setWireMesh(boolean wireMesh) {
        this.wireMesh = wireMesh;
    }


    public void setCameraType(String cameraType) {
        this.cameraType = cameraType;
    }

    public Camera getCamera() {
        if (cameraType.equals("perspective")) {
            return perspectiveCamera;
        } else {
            return parallelCamera;
        }
    }

    public enum PlotType {TILES, BOXES, MESH};

}

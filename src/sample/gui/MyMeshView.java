package sample.gui;

import javafx.scene.image.Image;
import javafx.scene.paint.Color;
import javafx.scene.paint.PhongMaterial;
import javafx.scene.shape.DrawMode;
import javafx.scene.shape.MeshView;
import javafx.scene.transform.Rotate;

/**
 * Created by Piotr Lasek on 15-03-05.
 */
public class MyMeshView extends MeshView {

    private PhongMaterial phongMaterial;
    private MyMesh mesh;
    private ViewConfig viewConfig;
    private Triangulator triangulator;
    //private EnhancedTriangulator triantulator;

    /**
     *
     * @param vc
     * @param t
     */
    public MyMeshView(ViewConfig vc, Triangulator t) {
        super();
        this.viewConfig = vc;
        this.triangulator = t;

        mesh = new MyMesh(triangulator, viewConfig);

        this.setMesh(mesh);

        phongMaterial = viewConfig.getMaterial();

        String texturePath =
                //"file:/Users/piotr/IdeaProjects/DataTV/snapshota-blur.png";
                //"file:/Users/piotr/IdeaProjects/DataTV/snapshotd.png";
                "file:/Users/piotr/IdeaProjects/DataTV/snapshot-checkins-days.png";
                //"file:/Users/piotr/IdeaProjects/DataTV/snapshot-calls-density.png";
        Image image = new Image(texturePath);

        phongMaterial = new PhongMaterial(Color.WHITE, image, null, null, null);
        viewConfig.setMaterial(phongMaterial);

        //phongMaterial.setBumpMap(image);
        //phongMaterial.setSpecularMap(image);
        //phongMaterial.setDiffuseColor(Color.WHITE);
        //phongMaterial.setSpecularColor(Color.WHITE);

        if (viewConfig.isWireMesh()) {
            setDrawMode(DrawMode.LINE);
        } else {
            setDrawMode(DrawMode.FILL);
            this.setMaterial(phongMaterial);
        }

        getTransforms().add(new Rotate(270));
    }
}

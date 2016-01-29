package skydive.gui;

import javafx.scene.shape.TriangleMesh;


public class MyMesh extends TriangleMesh {

        Triangulator triangulator;
        ViewConfig viewConfig;

        float[] points;
        float[] texCoords;
        int[] faces;

        public MyMesh(Triangulator t, ViewConfig vc) {
            triangulator = t;
            viewConfig = vc;

            this.getPoints().addAll(triangulator.getPoints());
            this.getTexCoords().setAll(triangulator.getTexture());
            this.getFaces().setAll(triangulator.getFaces());

            //init(100, 100);

        }
    }
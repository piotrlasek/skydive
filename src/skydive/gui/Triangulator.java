package skydive.gui;

import javafx.geometry.Point3D;
import skydive.db.BaseTuple;
import skydive.db.Stratum;
import skydive.db.Tuple;

import java.util.Arrays;
import java.util.Collection;

/**
 * Created by Piotr Lasek on 15-02-27.
 * Triangulator transforms tuples to be displayed into a set of triangles.
 */
public class Triangulator {

    protected final Stratum stratum;
    protected Tuple[][] matrix;
    protected int width;
    protected int height;
    protected float[] points;
    protected int[] faces;
    protected ViewConfig viewConfig;
    protected float[] texture;

    /**
     *
     * @param stratum
     */
    public Triangulator(Stratum stratum, ViewConfig vc) {
        this.stratum = stratum;
        viewConfig = vc;
        width = (int) stratum.getMax().getX() + 1;
        height = (int) stratum.getMax().getY()  + 1;

        System.out.println("Triangulator, width: " + width + " height: " + height);

        matrix = new Tuple[width][height];

        fillMatrix();

        triangulate();

        printStratum();
        System.out.println();
        printMatrix();
    }

    /**
     *
     */
    public void printStratum() {
        Collection<Tuple> tuples = stratum.getTuples();

        System.out.println("Tuples:");

        for(Tuple t:tuples) {
            System.out.println(t.getX() + ", " + t.getY() + ", " + t.getZ());
        }

    }

    /**
     *
     */
    public void printMatrix() {

        System.out.println("Matrix:");

        for(int j = 0; j < height; j++) {
            for (int i = 0; i < width; i++) {
                Tuple t = matrix[i][j];
                System.out.println(i + ", " + j + ", " + ", " + t.getZ());
            }
        }

        System.out.println("POINTS : " + Arrays.toString(getPoints()));
        System.out.println("TEXTURE: " + Arrays.toString(getTexture()));
        System.out.println("FACES  : " + Arrays.toString(getFaces()));
    }

    /**
     *
     */
    private void triangulate() {
        for(int x = 0; x < width; x++) {
            for(int y = 0; y < height; y++) {
                Tuple t = matrix[x][y];
                if (t != null) {
                    BaseTuple bt = (BaseTuple) t;
                    bt.setZ(bt.getZ() + 5);
                } else if (t == null) {
                    long z = 0;
                    t = new BaseTuple(x, y, z);
                    matrix[x][y] = t;
                }
            }
        }
    }

    /**
     *
     */
    private void fillMatrix() {

        Collection<Tuple> tuples = stratum.getTuples();

        for(Tuple t : tuples) {
            int x = (int) t.getX();
            int y = (int) t.getY();

            try {
                matrix[x][y] = t;
            } catch (Exception e) {
                System.out.println("--- " + x + ", " + y);
            }
        }
    }

    /**
     *
     * @return
     */
    public float[] getPoints() {

        double tileSize = getTileSize();

        Point3D midTmp = stratum.getMid();
        Point3D midData = midTmp.multiply(tileSize);

        if (points == null) {
            points = new float[3 * width * height];
            int i = 0;
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    double z = viewConfig.getScaleZ() * matrix[x][y].getZ() + midData.getZ();
                    double ii = (x * tileSize - midData.getX()) ;
                    double jj = (y * tileSize - midData.getY()) ;

                    points[i++] = -(float) ii;
                    points[i++] = (float) jj;
                    points[i++] = (float) z;
                }
            }
        }
        return points;
    }


    /**
     * Return size of a tile based on a stratum's "space" layer number.
     *
     * @return  tile size
     */
    public double getTileSize() {
        int spaceStratumNumber = stratum.getStratumCoordinates()[0];
        double tileSize = viewConfig.getBaseTileSize() * Math.pow(2, spaceStratumNumber);
        return tileSize;
    }

    /**
     *
     * @return
     */
    public int[] getFaces() {

        System.out.println("width: " + width);
        System.out.println("height: " + height);

        if (faces ==  null) {
            faces = new int[(width - 1) * (height - 1) * 12];
            int i = 0;

            for (int y = 0; y < height - 1; y++) {
                for (int x = 0; x < width - 1; x++) {

                    faces[i++] = y * width + x;
                    faces[i++] = y * width + x;

                    faces[i++] = (y+1) * width + x;
                    faces[i++] = (y+1) * width + x;

                    faces[i++] = (y+1) * width + x + 1;
                    faces[i++] = (y+1) * width + x + 1;

                    // ---

                    faces[i++] = (y+1) * width + x + 1;
                    faces[i++] = (y+1) * width + x + 1;

                    faces[i++] = (y) * width + x + 1;
                    faces[i++] = (y) * width + x + 1;

                    faces[i++] = y * width + x ;
                    faces[i++] = y * width + x ;
                }
            }
        }

        return faces;
    }

    /**
     *
     * @return
     */
    public float[] getTexture() {

        if (texture == null) {
            texture = new float[2 * width * height];

            int i = 0;
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    texture[i++] = (float) x / width + 0.5f / width;
                    texture[i++] = (float) y / height + 0.5f / height;
                }
            }
        }
        return texture;
    }
}

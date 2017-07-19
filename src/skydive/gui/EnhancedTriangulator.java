package skydive.gui;

import javafx.geometry.Point3D;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import skydive.db.ThreeDStratum;

/**
 * Created by Piotr Lasek on 15-03-10.
 *
 * EnhancedTriangulator generates the mesh so that it add additional point in the middle
 * of each tile computed as an average value of 4 corners of the tile.
 */
public class EnhancedTriangulator extends Triangulator {

    private static final Logger log = LogManager.getLogger(EnhancedTriangulator.class);
    public EnhancedTriangulator(ThreeDStratum threeDStratum, ViewConfig vc) {
        super(threeDStratum, vc);
    }

    /**
     * Generates "faces" for a mesh.
     *
     * @return  an array representing faces of the mesh
     */
    public int[] getFaces() {
        log.info("width: " + width);
        log.info("height: " + height);

        int i = 0;

        if (faces ==  null) {
            faces = new int[width * height * 24];

            for (int y = 0; y < 2 * height - 2; y += 2) {
                for (int x = 0; x < width - 1; x++) {
                    faces[i++] = y * width + x;
                    faces[i++] = y * width + x;
                    faces[i++] = (y+2) * width + x;
                    faces[i++] = (y+2) * width + x;
                    faces[i++] = (y+1) * width + x ;
                    faces[i++] = (y+1) * width + x ;

                    faces[i++] = (y+1) * width + x ;
                    faces[i++] = (y+1) * width + x ;
                    faces[i++] = (y+2) * width + x + 1;
                    faces[i++] = (y+2) * width + x + 1;
                    faces[i++] = (y) * width + x + 1;
                    faces[i++] = (y) * width + x + 1;

                    faces[i++] = (y+2) * width + x;
                    faces[i++] = (y+2) * width + x;
                    faces[i++] = (y+2) * width + x + 1;
                    faces[i++] = (y+2) * width + x + 1;
                    faces[i++] = (y+1) * width + x ;
                    faces[i++] = (y+1) * width + x ;

                    faces[i++] = y * width + x;
                    faces[i++] = y * width + x;
                    faces[i++] = (y+1) * width + x ;
                    faces[i++] = (y+1) * width + x ;
                    faces[i++] = (y) * width + x + 1;
                    faces[i++] = (y) * width + x + 1;
                }
            }
        }
        log.info("Number of faces: " + i + " (expected: " + faces.length + ")");

        return faces;
    }

    /**
     * Returns an array of coordinates of points representing a mesh to be displayed.
     * Three consecutive elements of the array denote x, y and z coordinates. E.g.
     * point with coorinates (1, 2, 5) will be represetned in an array as: points[0] = 1,
     * points[1] = 2 and points[2] = 5.
     *
     * @return  coordinates of points representing a mesh to be displayed
     */
    public float[] getPoints() {
        double tileSize = getTileSize();
        Point3D midTmp = threeDStratum.getMid();
        Point3D midData = midTmp.multiply(tileSize);

        if (points == null) {
            points = new float[3 * width * height + 3 * width  * height];
            int i = 0;
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    float z = (float) viewConfig.getScaleZ() * matrix[x][y].getZ() +
                        (float) midData.getZ();
                    double ii = x * tileSize - midData.getX();
                    double jj = y * tileSize - midData.getY();

                    points[i++] = -(float) ii;
                    points[i++] = (float) jj;
                    points[i++] = z;
                }

                for (int x = 0; x < width; x++) {
                    float ii = ((float) x * (float) tileSize) + (float) tileSize/2 -
                        (float) midData.getX();
                    float jj = ((float) y * (float) tileSize + (float) tileSize/2 -
                        (float) midData.getY());
                    float z = (float) viewConfig.getScaleZ() * getAvarage(x, y) +
                        (float) midData.getZ();

                    points[i++] = -ii;
                    points[i++] = jj;
                    points[i++] = z;
                }
            }

            log.info("Number of points: " + i + " (expected: " + points.length + ")");
        }
        return points;
    }

    /**
     * Returns and generates (if necessary) an array required for adding a texture.
     *
     * @return an array of texture coordinates
     */
    public float[] getTexture() {

        int i = 0;

        if (texture == null) {
            texture = new float[2 * width * height + 2 * height * width];

            for (int y = 0; y < height; y++) {

                for (int x = 0; x < width; x++) {
                    texture[i++] = (float) x / width + 0.5f / width;
                    texture[i++] = (float) y / height + 0.5f / height;
                }

                for (int x = 0; x < width ; x++) {
                    texture[i++] = (float) x / width + 0.75f / width;
                    texture[i++] = (float) y / height + 0.75f / height;
                }
            }
        }

        log.info("Number of faces: " + i + " (expected: " + texture.length + ")");

        return texture;
    }

    /**
     *
     * @param x
     * @param y
     * @return
     */
    public float getAvarage(int x, int y) {
        int x1 = x;
        int y1 = y;

        if (x1 > width - 1) x1 = x;
        if (y1 > height -1) y1 = y;

        double a = matrix[x][y].getZ();
        double b = matrix[x1][y].getZ();
        double c = matrix[x1][y1].getZ();
        double d = matrix[x][y1].getZ();

        return (float) (a + b + c  + d) / 4.0f;
    }
}

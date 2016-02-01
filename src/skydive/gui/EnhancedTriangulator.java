package skydive.gui;

import javafx.geometry.Point3D;
import skydive.db.Stratum;

/**
 * Created by Piotr Lasek on 15-03-10.
 *
 * EnhancedTrangulator generates the mesh so that it add additional point in the middle
 * of each tile computed as an average value of 4 corners of the tile.
 */
public class EnhancedTriangulator extends Triangulator {

    public EnhancedTriangulator(Stratum stratum, ViewConfig vc) {
        super(stratum, vc);
    }

    /**
     *
     * @return
     */
    public int[] getFaces() {
        System.out.println("width: " + width);
        System.out.println("height: " + height);

        int i = 0;

        if (faces ==  null) {
            faces = new int[width * height * 24];

            for (int y = 0; y < 2*height - 2; y+=2) {
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
        System.out.println("Number of faces: " + i + " (expected: " + faces.length + ")");

        return faces;
    }

    /**
     *
     * @return
     */
    public float[] getPoints() {

        double tileSize = viewConfig.getBaseTileSize() * Math.pow(2, stratum.getStratumNumber());
        Point3D midTmp = stratum.getMid();
        Point3D midData = midTmp.multiply(tileSize);

        if (points == null) {
            points = new float[3 * width * height + 3 * width  * height];
            int i = 0;
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    float z = (float) viewConfig.getScaleZ() * matrix[x][y].getZ() + (float) midData.getZ();
                    double ii = x * tileSize - midData.getX();
                    double jj = y * tileSize - midData.getY();

                    points[i++] = -(float) ii;
                    points[i++] = (float) jj;
                    points[i++] = z;
                }

                for (int x = 0; x < width; x++) {
                    float ii = ((float) x * (float) tileSize) + (float) tileSize/2 - (float) midData.getX();
                    float jj = ((float) y * (float) tileSize + (float) tileSize/2 - (float) midData.getY());
                    float z = (float) viewConfig.getScaleZ() * getAvarage(x, y) + (float) midData.getZ();

                    points[i++] = -ii;
                    points[i++] = jj;
                    points[i++] = z;
                }
            }

            System.out.println("Number of points: " + i + " (expected: " + points.length + ")");
        }
        return points;
    }

    /**
     *
     * @return
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

        System.out.println("Number of faces: " + i + " (expected: " + texture.length + ")");

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

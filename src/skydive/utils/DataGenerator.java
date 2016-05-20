package skydive.utils;

import java.math.BigInteger;
import java.util.ArrayList;

/**
 * Created by Piotr Lasek on 12.04.2016.
 */
public class DataGenerator {

    public static class IntegerObj {
        int value;

        public IntegerObj(int val) {
            this.value = val;
        }

        public void increment() {
           value++;
        }

        public int getValue() {
            return value;
        }

        public void setValue(int v) {
            value = v;
        }

        public String toString() {
            return "" + value;
        }
    }

    /**
     * Generates n-dimensional data cube.
     * @param n
     * @return
     */
    ArrayList<Object> generate(int n) {
        ArrayList<Object> result = new ArrayList();
        return result;
    }

    /**
     *
     * @param n
     */
    public ArrayList<int[]> cube(int n) {
        ArrayList<int[]> coordinates = new ArrayList<>();

        int size = (int) Math.pow(2, n);

        for(int i = 0; i < size; i++) {
            int[] coord= new int[n];
            for(int d = 0; d < n; d++) {
                if (BigInteger.valueOf(i).testBit(d)) {
                    coord[d] = 1;
                }
            }
            coordinates.add(coord);
            /*for(int x = 0; x < n; x++) {
                System.out.print(coord[x] + " ");
            }
            System.out.println();*/
        }

        return coordinates;
    }

    /**
     *
     * @param numberOfElements
     * @return
     */
    public ArrayList<Object> initiate(int numberOfElements) {
        ArrayList<Object> arrayList = new ArrayList<>();
        for(int i = 0; i < numberOfElements; i++) {
            arrayList.add(i, new ArrayList<Object>());
        }
        return arrayList;
    }

    /**
     *
     * @param dimensions A number of dimensions
     * @param width Width of a multidimensional cube
     * @param count A number of objects to be generated
     * @return
     */
    public ArrayList<Object> generate(int dimensions, int width, int count) {
        ArrayList<Object> result = initiate(width);
        ArrayList<Object> root = result;
        ArrayList currentCoord = null;
        int objectsCount = 0;
        int mc = (int) Math.pow(width, dimensions);
        int maxCount = count < mc ? count : mc;
        //
        // for (int i = 0; i < count; i++) {
        while(objectsCount < maxCount) {
            for (int j = 0; j < dimensions; j++) {
                int coord = (int) (Math.random() * (float) width);
                try {
                    if (j == 0) {
                        currentCoord = (ArrayList) root.get(coord);
                        result = root;
                    } else {
                        currentCoord = (ArrayList) result.get(coord);
                    }
                } catch (Exception e) {
                    // blah...
                }

                // create coordinates for a current dimension...
                if (currentCoord.size() == 0) {
                    currentCoord = initiate(width);
                }

                // update
                if (j < dimensions - 1) {
                    result.remove(coord);
                    result.add(coord, currentCoord);
                    result = currentCoord;
                } else if (j == dimensions - 1) {
                    result.remove(coord);
                    result.add(coord, "X");
                    objectsCount++;
                }
            }
        }

        return root;
    }

    /**
     *
     * @param data
     * @param coordinates
     * @return
     */
    public Object getAggregate(ArrayList<Object> data, ArrayList<int[]> coordinates) {
       Object result = null;
        int aggregatesCount = 0;
       for(int[] coordinate : coordinates) {
           ArrayList<Object> currentObject = data;
           for(int dimensionIndex : coordinate) {
               if (currentObject.size() != 0) {
                   Object o = currentObject.get(dimensionIndex);
                   if (o instanceof java.lang.String) {
                       aggregatesCount++;
                       if (aggregatesCount > 3) {
                           result = "" + aggregatesCount;
                       }
                       break;
                   }
                   currentObject = (ArrayList<Object>) o;
               } else {
                   break;
               }
           }
           if (result != null)
               break;
       }

        if (aggregatesCount > 0)
            result = "" + aggregatesCount;

       return result;
    }

    /**
     *
     * @param root
     * @param coordinates
     */
    public void addAggregate(ArrayList<Object> root, int width, int[] coordinates, Object o) {
        ArrayList<Object> tmp = root;
        for (int c = 0; c < coordinates.length - 1; c++) {
            ArrayList<Object> tmpPrev = (ArrayList<Object>) tmp.get(coordinates[c]);
            if (tmpPrev.size() == 0) {
                tmpPrev = initiate(width);
            }
            tmp.remove(coordinates[c]);
            tmp.add(coordinates[c], tmpPrev);
            tmp = tmpPrev;
        }
        int index = coordinates[coordinates.length - 1];
        tmp.remove(index);
        tmp.add(index, o);
    }

    /**
     *
     * @param layer
     * @param dimensions
     * @param width
     * @return
     */
    public ArrayList<Object> aggregateLayer(ArrayList<Object> layer, int dimensions, int width, IntegerObj aggregationCount) {
        aggregationCount.setValue(0);
        ArrayList<Object> higherLayer = initiate(width / 2);

        ArrayList<int[]> coordinates = new ArrayList<>();
        generateCoordinates(coordinates, width, 0, new int[dimensions], dimensions);


        for (int[] coordinate : coordinates) {

            ArrayList<int[]> cube = cube(dimensions);

            for(int[] pebble : cube) {
                for (int i = 0; i < dimensions; i++) {
                    pebble[i] += coordinate[i];
                }
            }

            Object o = getAggregate(layer, cube);

            if (o != null) {
                //System.out.println(o);
                int[] newLayerCoordinate = newLayerCoordinate(coordinate);
                int newWidth = width / 2;
                addAggregate(higherLayer, newWidth, newLayerCoordinate, o);
                if (o.equals("2") || o.equals("3") || o.equals("4")) {
                   aggregationCount.increment();
                }

            }
            // new coordinates should be divided by 2
        }
        // ...

        return higherLayer;
    }

    /**
     *
     * @param coordinate
     * @return
     */
    private int[] newLayerCoordinate(int[] coordinate) {
        int[] nlc = new int[coordinate.length];
        for(int i = 0; i < coordinate.length; i++) {
            nlc[i] = coordinate[i] / 2;
        }
        return  nlc;
    }

    /**
     *
     * @param coordinates
     * @param w
     * @param n
     * @param vector
     * @param maxN
     */
    public void generateCoordinates(ArrayList<int[]> coordinates, int w, int n, int[] vector, int maxN) {
        if (n == maxN) {
            // for (int i = )
            return;
        }

        for (int i = 0; i < w; i+=2) {
            vector[n] = i;

            if (n == maxN - 1) {
                coordinates.add(vector.clone());
            }

            generateCoordinates(coordinates, w, n + 1, vector, maxN);
        }
    }

    /**
     *
     * @param vector
     */
    public void printVector(int[] vector) {
        for(int v : vector) {
            System.out.print(v + " ");
        }
        System.out.println();
    }

    /**
     *
     * @param layer
     */
    public void printLayer2D(ArrayList<Object> layer) {
        for(int i = 0; i < layer.size(); i++) {
            for (int j = 0; j < layer.size(); j++) {
                ArrayList<Object> x = (ArrayList<Object>) layer.get(i);
                if (x.size() != 0) {
                    Object y = x.get(j);
                    if (y instanceof String) {
                        System.out.print(y);
                    } else {
                        System.out.print(" ");
                    }
                }
            }
            System.out.println();
        }
        System.out.println("---------------------------------");
    }

    /**
     *
     * @param args
     */
    public static void main(String[] args) {
        DataGenerator dg = new DataGenerator();
        int dimensions = 2;
        int count = 10000000;
        int width = 4096;

        int[] iv = new int[dimensions];

        ArrayList<int[]> coordinates = new ArrayList<>();
        dg.generateCoordinates(coordinates, width, 0, iv, dimensions);

        IntegerObj aggregationCount = new IntegerObj(0);

        ArrayList<Object> data = dg.generate(dimensions, width, count);

        //dg.printLayer2D(data);

        ArrayList<Object> layer1 = data;

        for (int i = 0; i < 10; i++) {
            layer1 = dg.aggregateLayer(layer1, dimensions, width, aggregationCount);
            width = width / 2;
            System.out.println(i + ";" + aggregationCount);
            //dg.printLayer2D(layer1);
        }


        System.out.println("End.");
        // ArrayList<int[]> cube = dg.cube(n);
    }
}

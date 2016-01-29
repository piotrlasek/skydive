package skydive.d2i;

import java.util.ArrayList;

/**
 * Created by Piotr Lasek on 7/6/2015.
 */
public class Aggregate {

    ArrayList<Integer> values;
    ArrayList<Integer> categories;

    // The aggregate's location in the stratum.
    int x;
    int y;

    /**
     * @param x
     * @param y
     */
    public Aggregate(int x, int y) {
        this.x = x;
        this.y = y;

        values = new ArrayList<Integer>();
        categories = new ArrayList<Integer>();
    }

    /**
     * @param value
     */
    public void addValue(int value, int category) {
        values.add(value);
        categories.add(category);
    }

    public ArrayList<Integer> getCategories() {
        return categories;
    }

    public ArrayList<Integer> getValues() {
        return values;
    }
}

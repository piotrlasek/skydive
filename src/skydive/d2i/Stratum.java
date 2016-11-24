package skydive.d2i;

import java.util.ArrayList;

/**
 * Created by Piotr Lasek on 7/6/2015.
 */
public class Stratum {

    private int size;

    private ArrayList<ArrayList<Aggregate>> data;

    /**
     *
     * @param size
     */
    public Stratum(int size) {
        this.size = size;
        setData(new ArrayList<ArrayList<Aggregate>>());
        for (int x = 0; x < getSize(); x++) {
            ArrayList<Aggregate> row = new ArrayList<Aggregate>();
            for (int y = 0; y < getSize(); y++) {
                Aggregate a;
                a = new Aggregate(x, y);

                // TODO: What is this?
                a.addValue((int)(Math.random()*10), (int) (Math.random() * 3));
                a.addValue((int)(Math.random()*10), (int) (Math.random() * 3));
                a.addValue((int)(Math.random()*10), (int) (Math.random() * 3));

                row.add(a);
            }
            getData().add(row);
        }
    }

    /**
     *
     * @return
     */
    public Stratum createNext() {

        int newSize = size / 2;

        Stratum newStratum = new Stratum(newSize);

        for (int x = 0; x < newSize; x++) {
            for (int y = 0; y < newSize; y++) {

            }
        }
        return newStratum;
    }


    /**
     *
     * @param x
     * @param y
     * @return
     */
    public Aggregate getAggregate(int x, int y) {
        ArrayList<Aggregate> row = getData().get(x);
        Aggregate a = row.get(y);
        return a;
    }

    /**
     *
     * @return
     */
    public Aggregate[] getFourAggregates() {
        return null;
    }

    /**
     *
     */
    public void plot() {

        StratumVis sv = new StratumVis(this);

        sv.setVisible(true);

    }

    /**
     *
     * @param args
     */
    public static void main (String[] args) {
        Stratum s = new Stratum(32);
        s.plot();
    }

    /**
     *
     * @return
     */
    public int getSize() {
        return size;
    }

    /**
     *
     * @param size
     */
    public void setSize(int size) {
        this.size = size;
    }

    /**
     *
     * @return
     */
    public ArrayList<ArrayList<Aggregate>> getData() {
        return data;
    }

    /**
     *
     * @param data
     */
    public void setData(ArrayList<ArrayList<Aggregate>> data) {
        this.data = data;
    }
}

package skydive.database;

import java.util.ArrayList;
import java.util.Collection;

public class TimeStratum {

    Collection<TimeTuple> tuples;
    int[] stratumCoordinates;

    /**
     *
     * @param stratumCoordinates
     */
    public TimeStratum(int[] stratumCoordinates) {
        this.stratumCoordinates = stratumCoordinates;
        tuples = new ArrayList<>();
    }

    public void clear() {
        tuples.clear();
    }

    /**
     *
     * @param tuple
     */
    public void addTuple(TimeTuple tuple) {

        tuples.add(tuple);
    }

    /**
     *
     * @return
     */
    public Collection<TimeTuple> getTuples() {
        return tuples;
    }

    /**
     * Sets threeDStratum's coordinates
     * @param stratumCoordinates    threeDStratum's coordinates
     */
    public void setStratumCoordinates(int... stratumCoordinates) {
        this.stratumCoordinates = stratumCoordinates;
    }

    /**
     *
     * @return
     */
    public int[] getStratumCoordinates() {
        return stratumCoordinates;
    }

    /**
     *
     * @return
     */
    public int getTimeStratumNumber() {
        return stratumCoordinates[0];
    }

}

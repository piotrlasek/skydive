package skydive.experiments;

import java.util.HashMap;

/**
 * Created by Piotr Lasek on 19.09.2017.
 */
public class Timer {

    HashMap<String, Long> times;

    /**
     *
     */
    public Timer() {
        times = new HashMap<>();
    }

    /**
     *
     * @param name
     */
    public void start(String name) {
        if (!times.containsKey(name)) {
            times.put(name, new Long(System.currentTimeMillis()));
        }
    }

    /**
     *
     * @param name
     */
    public void stop(String name) {
        Long startTime = times.get(name);
        Long endTime = System.currentTimeMillis();
        times.put(name, endTime - startTime);
    }

    /**
     *
     * @param name
     * @return
     */
    public Long getTime(String name) {
        return times.get(name);
    }
}

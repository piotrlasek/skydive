package skydive.gui;

import java.util.HashMap;
import java.util.Set;

/**
 * The Filter supports pyramid filtering.
 * Created by Piotr Lasek on 09.02.2016.
 */
public class Filter {

    /**
     *
     */
    HashMap<FilterAttribute, FilterInterval> filter;

    /**
     *
     */
    public Filter() {
        filter = new HashMap();
    }

    /**
     *
     */
    public void clear() {
        filter.clear();
    }

    /**
     *
     * @param fa
     * @param fi
     */
    public void add(FilterAttribute fa, FilterInterval fi) {
        if (!filter.containsKey(fa)) {
            filter.put(fa, fi);
        }
    }

    /**
     *
      * @param fa
     * @return
     */
    public String getMin(FilterAttribute fa) {
        String result = null;
        FilterInterval fi = filter.get(fa);
        if (fi != null) {
            result = fi.getMin();
        }
        return result;
    }

    /**
     *
     * @param fa
     * @return
     */
    public String getMax(FilterAttribute fa) {
        String result = null;
        FilterInterval fi = filter.get(fa);
        if (fi != null) {
            result = fi.getMax();
        }
        return result;
    }

    /**
     *
     * @return
     */
    public String toSQL() {
        StringBuilder query = new StringBuilder();

        Set<FilterAttribute> attributes = filter.keySet();

        int attributeCounter = 0;

        for (FilterAttribute attribute : attributes) {
            FilterInterval interval = filter.get(attribute);

            if (attributeCounter++ > 0) {
                query.append(" AND ");
            }

            query.append(
                attribute.getName() + " > " + interval.getMin() + " AND " +
                attribute.getName() + " <= " + interval.getMax()
            );
        }

        return query.toString();
    }
}

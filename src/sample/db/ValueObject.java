package sample.db;

import java.util.HashMap;
import java.util.Set;

/**
 * Created by piotr on 15-03-25.
 */
public class ValueObject {

    HashMap<String, Object> keyMap = new HashMap<String, Object>();

    public void put(String k, Object v) {
        keyMap.put(k, v);
    }

    public Object get(String k) {
        return keyMap.get(k);
    }

    public String getMaxKey() {
        Set<String> keys = keyMap.keySet();
        Integer maxValue = 0;
        String maxKey = null;
        for(String k:keys) {
            Integer i = (Integer) keyMap.get(k);
            if (i > maxValue) {
                maxValue = i;
                maxKey = k;
            }
        }

        return maxKey;
    }
}

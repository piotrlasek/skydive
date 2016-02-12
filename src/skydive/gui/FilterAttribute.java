package skydive.gui;

/**
 * Created by Piotr on 09.02.2016.
 */
public class FilterAttribute {

    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object obj) {
        FilterAttribute fa = (FilterAttribute) obj;
        return name.equals(fa.getName());
    }

    @Override
    public int hashCode() {
        return name.hashCode();
    }
}

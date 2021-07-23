package ua.zori;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import androidx.annotation.NonNull;

/**
 * Created by artur.menchenko@globallogic.com on 12/04/21.
 */
public class Test1 {

    @Test
    public void sort_az() {

        List<Box> list = new ArrayList<>();

        for (int i = 0; i < 100; i++) {
            Box b = new Box();
            b.index = i + 1;
            list.add(b);
        }

        for (int i = 2; i <= 100; i++) {
            for (Box b:list) {
                if (b.index % i == 0) {
                    b.open = !b.open;
                }
            }
        }

        for (Box b:list) {
            System.out.println(b.toString());
        }
    }

    private class Box {
        boolean open = true;
        int index = 0;

        @NonNull
        @Override
        public String toString() {
            return "" + index + " " + open;
        }
    }

}

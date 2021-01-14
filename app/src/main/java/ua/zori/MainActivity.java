package ua.zori;

import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Bundle;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.palette.graphics.Palette;

/**
 * Created by Artur Menchenko on 1/4/2021, 5:42 PM.
 * Zori App
 */
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);
        final ViewGroup background = findViewById(R.id.rootview);
        Palette.from(BitmapFactory.decodeResource(getResources(), R.drawable.logo2z))
                .generate(new Palette.PaletteAsyncListener() {
            @Override
            public void onGenerated(@Nullable Palette palette) {
                if (palette == null) {
                    return;
                }
                background.setBackgroundColor(palette.getDarkVibrantColor(Color.RED));
            }
        });
    }
}

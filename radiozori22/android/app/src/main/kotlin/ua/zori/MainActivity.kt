package ua.zori

import io.flutter.embedding.android.FlutterFragmentActivity
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine
import com.google.android.gms.cast.framework.CastContext
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        CastContext.getSharedInstance(applicationContext)
    }
}

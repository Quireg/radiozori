package ua.zori;

import android.content.Context;
import com.google.android.gms.cast.framework.CastOptions;
import com.google.android.gms.cast.framework.OptionsProvider;
import com.google.android.gms.cast.framework.SessionProvider;
import java.util.ArrayList;
import java.util.List;

public class CastOptionsProvider implements OptionsProvider {
    private String app_id="CC1AD845";
    public static final String CUSTOM_NAMESPACE = "urn:x-cast:radio_fm_am";

    @Override
    public CastOptions getCastOptions(Context context) {
        List<String> supportedNamespaces = new ArrayList<>();
        supportedNamespaces.add(CUSTOM_NAMESPACE);
        CastOptions castOptions = new CastOptions.Builder()
                .setReceiverApplicationId(app_id)

                //.setSupportedNamespaces(supportedNamespaces)
                .build();
        return castOptions;
    }
    @Override
    public List<SessionProvider> getAdditionalSessionProviders(Context context) {
        return null;
    }
}

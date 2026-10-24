package uz.carhelper.passenger.boot;

import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.Context;
import android.provider.Settings;
import android.util.Log;

/**
 * Keeps LP Companion's notification access in place. The listener (the now-playing card needs it to read other apps'
 * media sessions) was called WheelListener until 2.34 and is MediaListener now. Android checks the grant by class name
 * (MediaSessionService reads Settings.Secure enabled_notification_listeners), so after the rename the new class has to be
 * listed there. ensure() does that without adb: it appends MediaListener to the setting (needs WRITE_SECURE_SETTINGS, which
 * the app already holds) and leaves every other entry alone. The system keeps the old WheelListener entry in its own list
 * and puts it back whenever it is removed from the setting; it points at a class that no longer exists and does nothing.
 * Without the permission ensure() returns false and the adb route in Heal does the same job (cmd notification
 * allow_listener).
 */
public final class ListenerGrant {
    private static final String TAG = "LPBoot";
    private static final String SETTING = "enabled_notification_listeners";
    private static final String PKG = "uz.carhelper.passenger";
    private static final String CLS = PKG + ".MediaListener";

    private ListenerGrant() {
    }

    /** true = MediaListener is listed (already, or just put there); false = the setting could not be written */
    public static boolean ensure(Context context) {
        try {
            ContentResolver cr = context.getContentResolver();
            String current = Settings.Secure.getString(cr, SETTING);
            if (current != null) {
                for (String part : current.split(":")) {
                    ComponentName cn = ComponentName.unflattenFromString(part);
                    if (cn != null && PKG.equals(cn.getPackageName()) && CLS.equals(cn.getClassName())) {
                        return true;
                    }
                }
            }
            String add = new ComponentName(PKG, CLS).flattenToString();
            String value = current == null || current.isEmpty() ? add : current + ":" + add;
            Settings.Secure.putString(cr, SETTING, value);
            Log.i(TAG, "notification access: MediaListener added to " + SETTING);
            return true;
        } catch (Throwable t) {
            Log.w(TAG, "cannot list MediaListener in " + SETTING + ": " + t);
            return false;
        }
    }
}

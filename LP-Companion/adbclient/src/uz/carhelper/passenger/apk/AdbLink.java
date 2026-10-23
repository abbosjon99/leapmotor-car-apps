package uz.carhelper.passenger.apk;

import android.content.ContentResolver;
import android.content.Context;
import android.content.pm.PackageManager;
import android.provider.Settings;
import android.util.Log;

import uz.carhelper.passenger.adb.AdbRunner;

/**
 * Checks that the car's own adbd is listening before the app talks to it and, when it is not, switches adb on again
 * (Settings.Global adb_enabled) if the app holds WRITE_SECURE_SETTINGS. Nothing else is touched and adb is never
 * switched off or restarted.
 */
public final class AdbLink {
    private AdbLink() {
    }

    public static final String HOST = "127.0.0.1";
    public static final int PORT = 5555;
    private static final String TAG = "LPCompanion";

    /** True when adbd answers at host:port, after switching adb on again when `revive` is set and it was off. */
    public static boolean ensure(Context c, String host, int port, boolean revive) {
        if (AdbRunner.listening(host, port, 600)) {
            return true;
        }
        if (!revive) {
            return false;
        }
        try {
            if (c.checkSelfPermission("android.permission.WRITE_SECURE_SETTINGS") != PackageManager.PERMISSION_GRANTED) {
                Log.i(TAG, "adb is not listening on " + host + ":" + port + " and WRITE_SECURE_SETTINGS is not granted");
                return false;
            }
            ContentResolver cr = c.getContentResolver();
            if (Settings.Global.getInt(cr, Settings.Global.ADB_ENABLED, 0) == 0) {
                Settings.Global.putInt(cr, Settings.Global.ADB_ENABLED, 1);
                Log.i(TAG, "adb_enabled was off: switched on");
            } else {
                Log.i(TAG, "adb_enabled is on but nothing listens on " + host + ":" + port);
            }
            if (waitListening(host, port, 8000)) {
                return true;
            }
            if (Settings.Global.getInt(cr, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0) == 0) {
                Settings.Global.putInt(cr, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 1);
                Log.i(TAG, "development_settings_enabled was off: switched on");
                return waitListening(host, port, 6000);
            }
        } catch (Throwable t) {
            Log.i(TAG, "could not switch adb on: " + t);
        }
        return false;
    }

    private static boolean waitListening(String host, int port, int ms) {
        long end = System.currentTimeMillis() + ms;
        while (System.currentTimeMillis() < end) {
            if (AdbRunner.listening(host, port, 400)) {
                return true;
            }
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                return false;
            }
        }
        return false;
    }
}

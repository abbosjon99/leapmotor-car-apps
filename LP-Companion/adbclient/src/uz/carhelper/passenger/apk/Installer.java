package uz.carhelper.passenger.apk;

import android.app.Activity;
import android.content.Context;
import android.os.Environment;

import java.io.File;

import uz.carhelper.passenger.adb.AdbProgress;
import uz.carhelper.passenger.adb.AdbRunner;

/** Runs installs, uninstalls and the all-files grant through the car's own adb on a background thread. */
final class Installer {
    private Installer() {
    }

    static final String HOST = "127.0.0.1";
    static final int PORT = 5555;
    /** how long to wait for "Allow USB debugging?" on the car the first time */
    static final int APPROVE_SECONDS = 90;

    interface Done {
        /** Called on the UI thread. message is what to show (already in the user's language). */
        void done(boolean ok, String message, String raw);
    }

    static String keyPath(Context c) {
        return new File(c.getFilesDir(), "adbkey").getPath();
    }

    /** Before each job: make sure adbd is up (switching adb on again when the app may, and the setting allows it). */
    private static void link(Context c) {
        AdbLink.ensure(c, HOST, PORT, c.getSharedPreferences("apps", 0).getBoolean("healAdb", true));
    }

    static int userId() {
        return android.os.Process.myUid() / 100000;
    }

    /** True when the app may read all files (the "All files access" setting). */
    static boolean allFiles() {
        try {
            return Environment.isExternalStorageManager();
        } catch (Throwable t) {
            return false;
        }
    }

    /** Result text of AdbRunner -> sentence for the user. `what` is the sentence for a plain failure. */
    static String explain(String result, String what) {
        int bar = result.indexOf('|');
        String code = bar < 0 ? "FAIL" : result.substring(0, bar);
        String detail = bar < 0 ? result : result.substring(bar + 1);
        if (code.equals("NOCONN")) {
            return Cards.T("Could not reach the car's ADB (port 5555)");
        }
        if (code.equals("AUTH")) {
            return Cards.T("Allow the connection on the car's screen (Always allow), then try again");
        }
        if (code.equals("TLS")) {
            return Cards.T("The car's ADB is in wireless-debugging mode (TLS). Classic network ADB on port 5555 is needed.");
        }
        String known = reason(detail);
        if (known != null) {
            return known;
        }
        return what;
    }

    /** The common installer / uninstaller refusals, in words. */
    private static String reason(String detail) {
        if (detail.contains("INSTALL_FAILED_VERSION_DOWNGRADE")) {
            return Cards.T("A newer version is already installed. Downgrading is not allowed.");
        }
        if (detail.contains("INSTALL_FAILED_UPDATE_INCOMPATIBLE") || detail.contains("INSTALL_FAILED_SHARED_USER_INCOMPATIBLE")) {
            return Cards.T("The installed copy was signed with a different key. Uninstall it first (its data is lost).");
        }
        if (detail.contains("INSTALL_FAILED_INSUFFICIENT_STORAGE")) {
            return Cards.T("Not enough free storage on the car.");
        }
        if (detail.contains("INSTALL_FAILED_NO_MATCHING_ABIS")) {
            return Cards.T("The app is built for a different processor type.");
        }
        if (detail.contains("INSTALL_FAILED_OLDER_SDK")) {
            return Cards.T("The app needs a newer Android version than this car has.");
        }
        if (detail.contains("INSTALL_PARSE_FAILED") || detail.contains("INSTALL_FAILED_INVALID_APK")) {
            return Cards.T("The file is not a valid app.");
        }
        if (detail.contains("INSTALL_FAILED_USER_RESTRICTED") || detail.contains("INSTALL_FAILED_VERIFICATION_FAILURE")) {
            return Cards.T("The car refused this install.");
        }
        if (detail.contains("DELETE_FAILED_DEVICE_POLICY_MANAGER")) {
            return Cards.T("The car does not allow removing this app.");
        }
        return null;
    }

    /** Streams one APK into the installer. */
    static void install(final Activity a, final File apk, final boolean grantAll, final AdbProgress progress, final Done done) {
        Thread t = new Thread(new Runnable() {
            public void run() {
                link(a);
                final String r = AdbRunner.installApk(keyPath(a), HOST, PORT, apk, grantAll, APPROVE_SECONDS, progress);
                a.runOnUiThread(new Runnable() {
                    public void run() {
                        done.done(r.startsWith("OK|"), r.startsWith("OK|") ? Cards.T("Installed") :
                                explain(r, Cards.T("Could not install the app")), r);
                    }
                });
            }
        });
        t.start();
    }

    /** Removes one package (the caller has checked it is in the record). */
    static void uninstall(final Activity a, final String pkg, final Done done) {
        Thread t = new Thread(new Runnable() {
            public void run() {
                link(a);
                final String r = AdbRunner.uninstallPackage(keyPath(a), HOST, PORT, pkg, APPROVE_SECONDS);
                a.runOnUiThread(new Runnable() {
                    public void run() {
                        done.done(r.startsWith("OK|"), r.startsWith("OK|") ? Cards.T("Uninstalled") :
                                explain(r, Cards.T("Could not uninstall the app")), r);
                    }
                });
            }
        });
        t.start();
    }

    /** Gives this app "All files access" through the car's adb (needed to read APK files from storage and USB). */
    static void grantAllFiles(final Activity a, final Done done) {
        Thread t = new Thread(new Runnable() {
            public void run() {
                link(a);
                String cmd = "appops set --user " + userId() + " " + a.getPackageName() + " MANAGE_EXTERNAL_STORAGE allow";
                final String r = AdbRunner.run(keyPath(a), HOST, PORT, new String[]{cmd}, APPROVE_SECONDS);
                a.runOnUiThread(new Runnable() {
                    public void run() {
                        done.done(r.startsWith("OK|"), r.startsWith("OK|") ? Cards.T("Permissions granted through the car's ADB") :
                                explain(r, Cards.T("Could not grant the permissions")), r);
                    }
                });
            }
        });
        t.start();
    }
}

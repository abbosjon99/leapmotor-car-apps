package uz.carhelper.passenger.apk;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import uz.carhelper.passenger.adb.AdbRunner;

import static uz.carhelper.passenger.apk.Cards.T;

/**
 * Settings: everything that needs the car's own adb is greyed out while adb cannot be reached: the Vehicle rows "Install
 * apps from storage" and "Uninstall apps" (title gets "needs ADB") and the Status button "Fix permissions now" (its label
 * says to turn ADB on by hand in the car's settings). Their tag becomes "#adboff" and a tap explains why (Settings shows the
 * explanation).
 *
 * The first check runs in the background when Settings opens and tries to switch adb on again first when the "Fix
 * permissions" switch is on and the app may do it. After that the page looks again every 3 s while it is open, so it
 * unlocks by itself the moment adb is switched on in the car's settings, and greys out again if it goes off.
 */
public final class AdbGate {
    private AdbGate() {
    }

    private static final String[] TAGS = {"#files", "#uninstall"};
    private static final String HEAL = "#heal";
    private static final long POLL_MS = 3000L;

    public static void apply(final Activity a, View root) {
        final View[] rows = new View[TAGS.length];
        final String[] titles = new String[TAGS.length];
        boolean any = false;
        for (int i = 0; i < TAGS.length; i++) {
            rows[i] = root.findViewWithTag(TAGS[i]);
            TextView t = titleOf(rows[i]);
            if (t != null) {
                titles[i] = t.getText().toString();
                any = true;
                rows[i].setAlpha(0.5f);
                rows[i].setTag("#adboff");
            }
        }
        final View heal = root.findViewWithTag(HEAL);
        final String healTitle;
        if (heal instanceof TextView) {
            healTitle = ((TextView) heal).getText().toString();
            heal.setAlpha(0.5f);
            heal.setTag("#adboff");
            any = true;
        } else {
            healTitle = null;
        }
        if (!any) {
            return;
        }
        final boolean revive = a.getSharedPreferences("apps", 0).getBoolean("healAdb", true);
        Thread t = new Thread(new Runnable() {
            public void run() {
                boolean up = AdbLink.ensure(a, AdbLink.HOST, AdbLink.PORT, revive);
                while (true) {
                    show(a, rows, titles, heal, healTitle, up);
                    boolean now = up;
                    while (now == up) {
                        try {
                            Thread.sleep(POLL_MS);
                        } catch (InterruptedException e) {
                            return;
                        }
                        if (a.isFinishing() || a.isDestroyed()) {
                            return;
                        }
                        now = AdbRunner.listening(AdbLink.HOST, AdbLink.PORT, 600);
                    }
                    up = now;
                }
            }
        });
        t.setDaemon(true);
        t.start();
    }

    private static void show(final Activity a, final View[] rows, final String[] titles, final View heal,
                             final String healTitle, final boolean up) {
        a.runOnUiThread(new Runnable() {
            public void run() {
                if (a.isFinishing() || a.isDestroyed()) {
                    return;
                }
                for (int i = 0; i < rows.length; i++) {
                    TextView title = titleOf(rows[i]);
                    if (title == null) {
                        continue;
                    }
                    rows[i].setTag(up ? TAGS[i] : "#adboff");
                    rows[i].setAlpha(up ? 1f : 0.4f);
                    title.setText(up ? titles[i] : titles[i] + "  ·  " + T("needs ADB"));
                }
                if (heal instanceof TextView) {
                    heal.setTag(up ? HEAL : "#adboff");
                    heal.setAlpha(up ? 1f : 0.4f);
                    ((TextView) heal).setText(up ? healTitle
                            : healTitle + "  ·  " + T("turn ADB on in the car's settings"));
                }
            }
        });
    }

    private static TextView titleOf(View row) {
        if (row instanceof ViewGroup && ((ViewGroup) row).getChildCount() > 0
                && ((ViewGroup) row).getChildAt(0) instanceof TextView) {
            return (TextView) ((ViewGroup) row).getChildAt(0);
        }
        return null;
    }
}

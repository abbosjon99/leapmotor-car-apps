package uz.carhelper.passenger.apk;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import static uz.carhelper.passenger.apk.Cards.T;

/**
 * Settings > Vehicle: "Install apps from storage" and "Uninstall apps" both need the car's own adb. While adb cannot be
 * reached the two rows are greyed out and tapping them explains why (their tag becomes "#adboff"; Settings shows the
 * explanation). The check runs in the background each time Settings opens or Re-check status is tapped, and tries to
 * switch adb on again first when the "Fix permissions" switch is on and the app may do it.
 */
public final class AdbGate {
    private AdbGate() {
    }

    private static final String[] TAGS = {"#files", "#uninstall"};

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
        if (!any) {
            return;
        }
        final boolean revive = a.getSharedPreferences("apps", 0).getBoolean("healAdb", true);
        Thread t = new Thread(new Runnable() {
            public void run() {
                final boolean up = AdbLink.ensure(a, AdbLink.HOST, AdbLink.PORT, revive);
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
                    }
                });
            }
        });
        t.start();
    }

    private static TextView titleOf(View row) {
        if (row instanceof ViewGroup && ((ViewGroup) row).getChildCount() > 0
                && ((ViewGroup) row).getChildAt(0) instanceof TextView) {
            return (TextView) ((ViewGroup) row).getChildAt(0);
        }
        return null;
    }
}

package uz.carhelper.passenger.apk;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.List;

import uz.carhelper.passenger.Ui;

import static uz.carhelper.passenger.apk.Cards.T;

/**
 * "Uninstall apps": a card like Close apps that lists only the apps this app installed (the private record in ApkStore).
 * Tapping one asks again, with the button locked for 10 seconds, then removes it through the car's own adb.
 */
public final class UninstallDialog {
    private UninstallDialog() {
    }

    public static void show(final Activity a) {
        final Cards.Card c = new Cards.Card(a, Cards.width(a, 900));
        c.title(T("Uninstall apps"));
        c.line(T("Only apps installed from LP Companion are listed."), Ui.TEXT3, 18f, 0);
        final LinearLayout list = new LinearLayout(a);
        list.setOrientation(LinearLayout.VERTICAL);
        ScrollView sv = new ScrollView(a);
        sv.setVerticalScrollBarEnabled(false);
        sv.addView(list);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.topMargin = 14;
        c.box.addView(sv, lp);
        Cards.capHeight(sv, 330);
        c.box.addView(Cards.buttons(a, Cards.grey(a, T("Close"), new View.OnClickListener() {
            public void onClick(View v) {
                c.dismiss();
            }
        }), new View(a)));
        fill(a, list);
        c.show();
    }

    /** (Re)builds the rows; entries whose app is no longer installed are dropped from the record. */
    private static void fill(final Activity a, final LinearLayout list) {
        list.removeAllViews();
        PackageManager pm = a.getPackageManager();
        List<ApkStore.Entry> all = ApkStore.all(a);
        int shown = 0;
        for (int i = all.size() - 1; i >= 0; i--) {
            final ApkStore.Entry e = all.get(i);
            if (e.pkg.equals(a.getPackageName())) {
                continue;
            }
            Drawable icon;
            try {
                icon = pm.getApplicationIcon(e.pkg);
            } catch (PackageManager.NameNotFoundException gone) {
                ApkStore.remove(a, e.pkg);
                continue;
            }
            shown++;
            LinearLayout row = new LinearLayout(a);
            row.setGravity(Gravity.CENTER_VERTICAL);
            row.setPadding(18, 14, 18, 14);
            row.setBackground(Ui.btn(0, 0x22ffffff, 0, 24f));
            ImageView iv = new ImageView(a);
            iv.setImageDrawable(icon);
            row.addView(iv, new LinearLayout.LayoutParams(56, 56));
            LinearLayout names = new LinearLayout(a);
            names.setOrientation(LinearLayout.VERTICAL);
            names.setPadding(20, 0, 20, 0);
            TextView n = Ui.text(a, e.label, 26f, 0xffffffff, false);
            n.setSingleLine(true);
            n.setEllipsize(TextUtils.TruncateAt.END);
            names.addView(n);
            names.addView(Ui.text(a, e.pkg + (e.version.length() > 0 ? "   " + e.version : ""), 16f, Ui.TEXT3, false));
            row.addView(names, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
            row.addView(Ui.text(a, T("Uninstall"), 20f, Ui.BAD, true));
            row.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    confirm(a, e, list);
                }
            });
            list.addView(row);
        }
        if (shown == 0) {
            TextView t = Ui.text(a, T("Nothing installed from here yet."), 22f, Ui.TEXT2, false);
            t.setPadding(6, 16, 6, 16);
            list.addView(t);
        }
    }

    private static void confirm(final Activity a, final ApkStore.Entry e, final LinearLayout list) {
        final Cards.Card c = new Cards.Card(a, Cards.width(a, 860));
        c.title(T("Uninstall this app?"));
        c.line(e.label, 0xffffffff, 24f, 0);
        c.line(e.pkg, Ui.TEXT3, 16f, 2);
        c.line(T("The app and its data are deleted. This cannot be undone."), Ui.BAD, 20f, 12);
        TextView no = Cards.grey(a, T("Cancel"), new View.OnClickListener() {
            public void onClick(View v) {
                c.dismiss();
            }
        });
        final TextView yes = Cards.red(a, T("Uninstall"), new View.OnClickListener() {
            public void onClick(View v) {
                c.dismiss();
                Toast.makeText(a.getApplicationContext(), T("Uninstalling…"), Toast.LENGTH_SHORT).show();
                Installer.uninstall(a, e.pkg, new Installer.Done() {
                    public void done(boolean ok, String message, String raw) {
                        if (ok) {
                            ApkStore.remove(a, e.pkg);
                        }
                        Toast.makeText(a.getApplicationContext(), e.label + ": " + message, Toast.LENGTH_LONG).show();
                        if (!a.isFinishing()) {
                            fill(a, list);
                        }
                    }
                });
            }
        });
        c.box.addView(Cards.buttons(a, no, yes));
        c.show();
        Cards.lock(c.dialog, yes, T("Uninstall"), 10);
    }
}

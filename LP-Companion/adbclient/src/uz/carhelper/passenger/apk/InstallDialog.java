package uz.carhelper.passenger.apk;

import android.app.Activity;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;

import uz.carhelper.passenger.Ui;
import uz.carhelper.passenger.adb.AdbProgress;

import static uz.carhelper.passenger.apk.Cards.T;

/**
 * The warning shown when an APK is tapped: what it is, what it asks for, the risks, the "grant all permissions" switch
 * and an Install button that stays locked for 10 seconds. Installing streams the file through the car's own adb.
 */
final class InstallDialog {
    private InstallDialog() {
    }

    static void show(final Activity a, final File apk) {
        final ApkInfo info = ApkInfo.read(a, apk);
        if (info == null) {
            final Cards.Card c = new Cards.Card(a, Cards.width(a, 760));
            c.title(T("This is not an app"));
            c.line(T("The file could not be read as an Android app."), Ui.TEXT2, 22f, 0);
            c.box.addView(Cards.buttons(a, new View(a), Cards.accent(a, T("OK"), new View.OnClickListener() {
                public void onClick(View v) {
                    c.dismiss();
                }
            })));
            c.show();
            return;
        }
        final Cards.Card c = new Cards.Card(a, Cards.width(a, 980));

        // who: icon, name, package
        LinearLayout head = new LinearLayout(a);
        head.setGravity(Gravity.CENTER_VERTICAL);
        ImageView icon = new ImageView(a);
        if (info.icon != null) {
            icon.setImageDrawable(info.icon);
        }
        head.addView(icon, new LinearLayout.LayoutParams(84, 84));
        LinearLayout names = new LinearLayout(a);
        names.setOrientation(LinearLayout.VERTICAL);
        names.setPadding(24, 0, 0, 0);
        TextView name = Ui.text(a, info.label, 30f, 0xffffffff, true);
        name.setSingleLine(true);
        name.setEllipsize(android.text.TextUtils.TruncateAt.END);
        names.addView(name);
        names.addView(Ui.text(a, info.pkg, 18f, Ui.TEXT3, false));
        head.addView(names, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        c.box.addView(head);

        // what: scrolls when it is long, so the buttons stay on screen on the 720 px passenger display
        final ScrollView scroll = new ScrollView(a);
        scroll.setVerticalScrollBarEnabled(false);
        LinearLayout body = new LinearLayout(a);
        body.setOrientation(LinearLayout.VERTICAL);
        scroll.addView(body);
        c.box.addView(scroll, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        Cards.capHeight(scroll, 300);

        String state;
        int stateColor = 0xffffffff;
        if (!info.installed) {
            state = T("New app") + "  ·  " + info.versionName;
        } else if (info.versionCode > info.installedVersionCode) {
            state = T("Update") + ":  " + info.installedVersionName + "  →  " + info.versionName;
        } else if (info.versionCode == info.installedVersionCode) {
            state = T("Same version as the installed one") + "  ·  " + info.versionName;
        } else {
            state = T("Older than the installed version. The install will fail.") + "  (" + info.versionName + ")";
            stateColor = 0xffffc857;
        }
        body.addView(line(a, state, stateColor, 22f, 14));
        String sizeLine = T("Size") + ": " + Cards.size(info.size) + "   ·   " + T("Permissions asked") + ": " + info.permissionCount;
        body.addView(line(a, sizeLine, Ui.TEXT2, 20f, 6));
        if (info.sensitive.size() > 0) {
            StringBuilder s = new StringBuilder(T("Sensitive permissions") + ": ");
            for (int i = 0; i < info.sensitive.size(); i++) {
                if (i > 0) {
                    s.append(", ");
                }
                s.append(T(info.sensitive.get(i)));
            }
            body.addView(line(a, s.toString(), 0xffffc857, 20f, 6));
        }
        body.addView(line(a, T("Install only apps you trust. This install skips the car's app whitelist and uses the car's ADB rights."), Ui.BAD, 20f, 14));
        if (info.installed && !info.sameSigner) {
            body.addView(line(a, T("This app is signed with a different key than the installed copy. The install will fail unless you uninstall the old one first (its data is lost)."), Ui.BAD, 20f, 10));
        }
        if (info.self) {
            body.addView(line(a, T("This replaces LP Companion itself. The app will restart and you will not see the result."), Ui.BAD, 20f, 10));
        }

        // the -g switch, above the Install button
        final boolean[] grant = {false};
        final boolean[] quiet = {false};
        LinearLayout gRow = new LinearLayout(a);
        gRow.setGravity(Gravity.CENTER_VERTICAL);
        gRow.setPadding(0, 18, 0, 0);
        LinearLayout gText = new LinearLayout(a);
        gText.setOrientation(LinearLayout.VERTICAL);
        gText.addView(Ui.text(a, T("Grant all permissions (-g)"), 22f, 0xffffffff, false));
        gText.addView(Ui.text(a, T("Off: the app asks for them itself. Only for experts."), 17f, Ui.TEXT3, false));
        gRow.addView(gText, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        final Switch sw = new Switch(a);
        Ui.tintSwitch(sw);
        gRow.addView(sw);
        c.box.addView(gRow);
        sw.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton b, boolean on) {
                if (quiet[0]) {
                    return;
                }
                if (!on) {
                    grant[0] = false;
                    return;
                }
                // turning it on needs a second, deliberate yes
                quiet[0] = true;
                b.setChecked(false);
                quiet[0] = false;
                confirmGrant(a, new Runnable() {
                    public void run() {
                        quiet[0] = true;
                        sw.setChecked(true);
                        quiet[0] = false;
                        grant[0] = true;
                    }
                });
            }
        });

        TextView cancel = Cards.grey(a, T("Cancel"), new View.OnClickListener() {
            public void onClick(View v) {
                c.dismiss();
            }
        });
        final TextView install = Cards.accent(a, T("Install"), new View.OnClickListener() {
            public void onClick(View v) {
                c.dismiss();
                run(a, apk, info, grant[0]);
            }
        });
        c.box.addView(Cards.buttons(a, cancel, install));
        c.show();
        Cards.lock(c.dialog, install, T("Install"), 10);
    }

    private static TextView line(Activity a, String text, int color, float sp, int top) {
        TextView t = Ui.text(a, text, sp, color, false);
        t.setPadding(0, top, 0, 0);
        return t;
    }

    /** "This can break the system": the switch only turns on after this. */
    private static void confirmGrant(final Activity a, final Runnable yes) {
        final Cards.Card c = new Cards.Card(a, Cards.width(a, 820));
        c.title(T("Grant all permissions?"));
        c.line(T("Every permission the app asks for is granted without asking you. This can break the system. Only turn it on if you know what you are doing."), Ui.BAD, 22f, 0);
        TextView no = Cards.grey(a, T("Keep it off"), new View.OnClickListener() {
            public void onClick(View v) {
                c.dismiss();
            }
        });
        TextView ok = Cards.red(a, T("I know what I am doing"), new View.OnClickListener() {
            public void onClick(View v) {
                c.dismiss();
                yes.run();
            }
        });
        c.box.addView(Cards.buttons(a, no, ok));
        c.show();
    }

    /** The install itself: a progress card, then the result. */
    private static void run(final Activity a, final File apk, final ApkInfo info, boolean grantAll) {
        final Cards.Card c = new Cards.Card(a, Cards.width(a, 760));
        c.dialog.setCancelable(false);
        c.dialog.setCanceledOnTouchOutside(false);
        c.title(T("Installing…"));
        c.line(info.label, Ui.TEXT2, 22f, 0);
        final ProgressBar bar = new ProgressBar(a, null, android.R.attr.progressBarStyleHorizontal);
        bar.setMax(1000);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 24);
        lp.topMargin = 22;
        c.box.addView(bar, lp);
        final TextView pct = c.line("0%", Ui.TEXT3, 18f, 8);
        c.show();
        AdbProgress progress = new AdbProgress() {
            public void onProgress(final long done, final long total) {
                a.runOnUiThread(new Runnable() {
                    public void run() {
                        int p = total <= 0 ? 0 : (int) (done * 1000 / total);
                        bar.setProgress(p);
                        pct.setText((p / 10) + "%");
                    }
                });
            }
        };
        Installer.install(a, apk, grantAll, progress, new Installer.Done() {
            public void done(boolean ok, String message, String raw) {
                c.dismiss();
                if (ok && !info.self) {
                    ApkStore.add(a, info.pkg, info.label, info.versionName);
                }
                if (a.isFinishing()) {
                    Toast.makeText(a.getApplicationContext(), message, Toast.LENGTH_LONG).show();
                    return;
                }
                result(a, ok, info.label, message, raw);
            }
        });
    }

    static void result(final Activity a, boolean ok, String label, String message, String raw) {
        final Cards.Card r = new Cards.Card(a, Cards.width(a, 820));
        r.title(ok ? T("Installed") : T("Could not install the app"));
        r.line(label, 0xffffffff, 22f, 0);
        r.line(message, ok ? Ui.OK : Ui.BAD, 22f, 10);
        if (!ok && raw != null && raw.length() > 0) {
            String t = raw.replace('\n', ' ');
            r.line(t.length() > 260 ? t.substring(0, 260) : t, Ui.TEXT3, 16f, 12);
        }
        r.box.addView(Cards.buttons(a, new View(a), Cards.accent(a, T("OK"), new View.OnClickListener() {
            public void onClick(View v) {
                r.dismiss();
            }
        })));
        r.show();
    }
}

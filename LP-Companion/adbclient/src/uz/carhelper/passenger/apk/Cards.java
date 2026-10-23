package uz.carhelper.passenger.apk;

import android.app.Activity;
import android.app.Dialog;
import android.graphics.drawable.ColorDrawable;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.LinearLayout;
import android.widget.TextView;

import uz.carhelper.passenger.Lang;
import uz.carhelper.passenger.Ui;

/** The look shared by the file manager's cards: a dark rounded card in its own window (like the Close apps popup). */
final class Cards {
    private Cards() {
    }

    /** The text in the language in use. */
    static String T(String english) {
        return Lang.t(english);
    }

    /** One card: a dialog whose only content is a vertical box with rounded dark background. */
    static final class Card {
        final Activity act;
        final Dialog dialog;
        final LinearLayout box;

        Card(Activity act, int width) {
            this.act = act;
            this.dialog = new Dialog(act);
            this.dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            this.box = new LinearLayout(act);
            this.box.setOrientation(LinearLayout.VERTICAL);
            this.box.setBackground(Ui.rect(0xf0141c2a, Ui.STROKE, 36f));
            this.box.setPadding(36, 30, 36, 28);
            this.dialog.setContentView(box);
            this.dialog.setCanceledOnTouchOutside(true);
            Window w = dialog.getWindow();
            w.setBackgroundDrawable(new ColorDrawable(0));
            w.setLayout(width, ViewGroup.LayoutParams.WRAP_CONTENT);
        }

        TextView title(String text) {
            TextView t = Ui.text(act, text, 30f, 0xffffffff, true);
            t.setPadding(0, 0, 0, 10);
            box.addView(t);
            return t;
        }

        TextView line(String text, int color, float sp, int top) {
            TextView t = Ui.text(act, text, sp, color, false);
            t.setPadding(0, top, 0, 0);
            box.addView(t);
            return t;
        }

        void show() {
            dialog.show();
        }

        void dismiss() {
            dialog.dismiss();
        }
    }

    static int width(Activity a, int wanted) {
        int screen = a.getResources().getDisplayMetrics().widthPixels;
        return Math.min(wanted, screen - 80);
    }

    static TextView button(Activity a, String label, int fill, int pressed, int stroke, View.OnClickListener l) {
        TextView b = Ui.pill(a, label, fill, pressed, stroke);
        b.setOnClickListener(l);
        return b;
    }

    static TextView grey(Activity a, String label, View.OnClickListener l) {
        return button(a, label, 0x2effffff, 0x44ffffff, Ui.STROKE, l);
    }

    static TextView accent(Activity a, String label, View.OnClickListener l) {
        return button(a, label, Ui.ACCENT, Ui.ACCENT_PRESSED, 0, l);
    }

    static TextView red(Activity a, String label, View.OnClickListener l) {
        return button(a, label, 0xffe5484d, 0xffc93a3f, 0, l);
    }

    /** A row with `left` at the start and `right` at the end. */
    static LinearLayout buttons(Activity a, View left, View right) {
        LinearLayout row = new LinearLayout(a);
        row.setGravity(android.view.Gravity.CENTER_VERTICAL);
        row.setPadding(0, 22, 0, 0);
        row.addView(left);
        View spacer = new View(a);
        row.addView(spacer, new LinearLayout.LayoutParams(1, 1, 1f));
        row.addView(right);
        return row;
    }

    /**
     * Locks a button for `seconds`, showing the countdown in its label ("Install (10)"). Stops by itself when the
     * dialog goes away.
     */
    static void lock(final Dialog d, final TextView b, final String label, final int seconds) {
        final Handler h = new Handler(Looper.getMainLooper());
        b.setEnabled(false);
        b.setAlpha(0.45f);
        b.setText(label + " (" + seconds + ")");
        h.postDelayed(new Runnable() {
            int left = seconds;

            public void run() {
                if (!d.isShowing()) {
                    return;
                }
                left--;
                if (left <= 0) {
                    b.setEnabled(true);
                    b.setAlpha(1f);
                    b.setText(label);
                } else {
                    b.setText(label + " (" + left + ")");
                    h.postDelayed(this, 1000);
                }
            }
        }, 1000);
    }

    /** Caps a scroll view at `max` px high (it grows with its content until then). */
    static void capHeight(final android.widget.ScrollView sv, final int max) {
        sv.getViewTreeObserver().addOnGlobalLayoutListener(new android.view.ViewTreeObserver.OnGlobalLayoutListener() {
            public void onGlobalLayout() {
                if (sv.getHeight() > max) {
                    ViewGroup.LayoutParams lp = sv.getLayoutParams();
                    lp.height = max;
                    sv.setLayoutParams(lp);
                }
            }
        });
    }

    static String size(long bytes) {
        if (bytes < 1024) {
            return bytes + " B";
        }
        double v = bytes / 1024.0;
        String[] unit = {"KB", "MB", "GB"};
        int i = 0;
        while (v >= 1024 && i < unit.length - 1) {
            v /= 1024;
            i++;
        }
        return String.format(java.util.Locale.US, v >= 100 ? "%.0f %s" : "%.1f %s", v, unit[i]);
    }
}

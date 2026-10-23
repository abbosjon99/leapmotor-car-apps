package uz.carhelper.passenger.apk;

import android.app.Activity;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.util.List;

import uz.carhelper.passenger.Lang;
import uz.carhelper.passenger.Ui;

import static uz.carhelper.passenger.apk.Cards.T;

/**
 * "Install apps from storage": a read-only file browser for the car's storage and USB drives that shows only folders
 * and .apk files. Tapping an APK opens the warning card (InstallDialog); the small Delete button removes the file after
 * a warning (DeleteDialog). Nothing outside the allowed places (see Roots) is ever listed or touched.
 */
public class ApkManagerActivity extends Activity {
    private List<Roots.Root> roots;
    private int rootIndex = 0;
    private File dir;
    private LinearLayout column;
    private boolean firstShow = true;

    @Override
    protected void onCreate(Bundle b) {
        super.onCreate(b);
        Lang.init(this);
        ScrollView scroll = new ScrollView(this);
        scroll.setBackground(Ui.pageBg());
        scroll.setVerticalScrollBarEnabled(false);
        column = new LinearLayout(this);
        column.setOrientation(LinearLayout.VERTICAL);
        column.setPadding(48, 40, 48, 72);
        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(1200, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER_HORIZONTAL;
        scroll.addView(column, lp);
        setContentView(scroll);
    }

    @Override
    protected void onResume() {
        super.onResume();
        Lang.init(this);
        roots = Roots.list(this);
        if (firstShow) {
            firstShow = false;
            rootIndex = 0;
            dir = roots.get(0).dir;
        } else if (rootIndex >= roots.size()) {
            rootIndex = 0;
            dir = roots.get(0).dir;
        }
        refresh();
    }

    /** Back goes up a folder first, then leaves. */
    @Override
    public void onBackPressed() {
        if (roots != null && dir != null && !dir.equals(roots.get(rootIndex).dir) && dir.getParentFile() != null) {
            dir = dir.getParentFile();
            refresh();
        } else {
            finish();
        }
    }

    private TextView pill(String text, boolean selected, View.OnClickListener l) {
        return selected ? Cards.accent(this, text, l) : Cards.grey(this, text, l);
    }

    private void refresh() {
        column.removeAllViews();
        final Roots.Root root = roots.get(rootIndex);

        // header
        LinearLayout head = new LinearLayout(this);
        head.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout titles = new LinearLayout(this);
        titles.setOrientation(LinearLayout.VERTICAL);
        titles.addView(Ui.text(this, T("Install apps from storage"), 34f, 0xffffffff, true));
        titles.addView(Ui.text(this, T("Tap an app to install it. Only plain .apk files are installed."), 18f, Ui.TEXT3, false));
        head.addView(titles, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        head.addView(Cards.grey(this, T("Close"), new View.OnClickListener() {
            public void onClick(View v) {
                finish();
            }
        }));
        column.addView(head);

        // without "All files access" there is nothing to list
        if (!Installer.allFiles()) {
            LinearLayout box = new LinearLayout(this);
            box.setOrientation(LinearLayout.VERTICAL);
            box.setBackground(Ui.rect(Ui.CARD, Ui.STROKE, 36f));
            box.setPadding(36, 30, 36, 30);
            box.addView(Ui.text(this, T("To see the files, this app needs All files access. The car's ADB can grant it."), 22f, 0xffffffff, false));
            TextView grant = Cards.accent(this, T("Grant access"), new View.OnClickListener() {
                public void onClick(View v) {
                    Toast.makeText(getApplicationContext(), T("Trying to grant the permissions…"), Toast.LENGTH_SHORT).show();
                    Installer.grantAllFiles(ApkManagerActivity.this, new Installer.Done() {
                        public void done(boolean ok, String message, String raw) {
                            Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
                            refresh();
                        }
                    });
                }
            });
            LinearLayout.LayoutParams glp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            glp.topMargin = 22;
            box.addView(grant, glp);
            LinearLayout.LayoutParams blp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            blp.topMargin = 28;
            column.addView(box, blp);
            return;
        }

        // where: Downloads, Device storage, USB drives
        LinearLayout chips = new LinearLayout(this);
        chips.setGravity(Gravity.CENTER_VERTICAL);
        chips.setPadding(0, 28, 0, 0);
        for (int i = 0; i < roots.size(); i++) {
            final int idx = i;
            TextView chip = pill(roots.get(i).label, i == rootIndex, new View.OnClickListener() {
                public void onClick(View v) {
                    rootIndex = idx;
                    dir = roots.get(idx).dir;
                    refresh();
                }
            });
            LinearLayout.LayoutParams clp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            clp.rightMargin = 14;
            chips.addView(chip, clp);
        }
        View spacer = new View(this);
        chips.addView(spacer, new LinearLayout.LayoutParams(1, 1, 1f));
        chips.addView(Cards.grey(this, T("Refresh"), new View.OnClickListener() {
            public void onClick(View v) {
                roots = Roots.list(ApkManagerActivity.this);
                if (rootIndex >= roots.size()) {
                    rootIndex = 0;
                    dir = roots.get(0).dir;
                }
                refresh();
            }
        }));
        column.addView(chips);

        // the folder, with a way up
        LinearLayout path = new LinearLayout(this);
        path.setGravity(Gravity.CENTER_VERTICAL);
        path.setPadding(0, 22, 0, 12);
        String rel = "/";
        try {
            String r = root.dir.getCanonicalPath();
            String p = dir.getCanonicalPath();
            rel = p.length() > r.length() ? p.substring(r.length()) : "/";
        } catch (Exception ignored) {
        }
        TextView where = Ui.text(this, root.label + "  " + rel, 20f, Ui.TEXT2, false);
        where.setSingleLine(true);
        where.setEllipsize(TextUtils.TruncateAt.MIDDLE);
        path.addView(where, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        if (!dir.equals(root.dir) && dir.getParentFile() != null) {
            path.addView(Cards.grey(this, T("Up"), new View.OnClickListener() {
                public void onClick(View v) {
                    dir = dir.getParentFile();
                    refresh();
                }
            }));
        }
        column.addView(path);

        // the list
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackground(Ui.rect(Ui.CARD, Ui.STROKE, 36f));
        card.setPadding(10, 10, 10, 10);
        List<Roots.Entry> entries = Roots.children(root, dir);
        if (entries.isEmpty()) {
            TextView none = Ui.text(this, T("No folders or .apk files here."), 22f, Ui.TEXT2, false);
            none.setPadding(26, 24, 26, 24);
            card.addView(none);
        }
        for (int i = 0; i < entries.size(); i++) {
            card.addView(row(root, entries.get(i)));
        }
        column.addView(card);
    }

    private View row(final Roots.Root root, final Roots.Entry e) {
        LinearLayout row = new LinearLayout(this);
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(24, 18, 18, 18);
        row.setBackground(Ui.btn(0, 0x22ffffff, 0, 24f));
        String name = e.file.getName();
        TextView t = Ui.text(this, e.dir ? name + "/" : name, 24f, e.dir ? 0xffffffff : (e.bundle ? Ui.TEXT3 : 0xffcfe3ff), e.dir);
        t.setSingleLine(true);
        t.setEllipsize(TextUtils.TruncateAt.MIDDLE);
        row.addView(t, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        if (!e.dir) {
            TextView size = Ui.text(this, Cards.size(e.file.length()), 18f, Ui.TEXT3, false);
            size.setPadding(16, 0, 16, 0);
            row.addView(size);
            TextView del = Ui.text(this, T("Delete"), 18f, Ui.BAD, true);
            del.setPadding(22, 10, 22, 10);
            del.setBackground(Ui.btn(0x33e5484d, 0x66e5484d, 0, 100f));
            del.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    DeleteDialog.show(ApkManagerActivity.this, root, e.file, new Runnable() {
                        public void run() {
                            refresh();
                        }
                    });
                }
            });
            row.addView(del);
        }
        row.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                if (e.dir) {
                    dir = e.file;
                    refresh();
                } else if (e.apk) {
                    if (Roots.allowed(root, e.file)) {
                        InstallDialog.show(ApkManagerActivity.this, e.file);
                    }
                } else {
                    Toast.makeText(getApplicationContext(), T("Bundles (.xapk, .apks, .apkm) are not supported. Only plain .apk files can be installed."), Toast.LENGTH_LONG).show();
                }
            }
        });
        return row;
    }
}

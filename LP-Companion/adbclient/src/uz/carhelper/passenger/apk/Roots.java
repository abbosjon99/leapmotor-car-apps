package uz.carhelper.passenger.apk;

import android.content.Context;
import android.os.Environment;
import android.os.storage.StorageManager;
import android.os.storage.StorageVolume;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * Where the file manager may look: the device storage of the car's user and any mounted USB drive. Everything is
 * checked on the real (canonical) path, so a shortcut cannot lead out of these places, and the dangerous or private
 * places inside them (Android, hidden dot-folders, system folders of USB drives) are never shown.
 */
final class Roots {
    private Roots() {
    }

    static final class Root {
        String label;
        File dir;
        /** a mounted USB / SD volume (not the device storage) */
        boolean removable;
    }

    static final class Entry {
        File file;
        boolean dir;
        /** a plain .apk, which can be installed */
        boolean apk;
        /** .xapk / .apks / .apkm: shown, but not installable */
        boolean bundle;
    }

    private static final int MAX_ENTRIES = 500;

    /** The top places: device storage, its Download folder, and each mounted USB drive. */
    static List<Root> list(Context c) {
        List<Root> out = new ArrayList<Root>();
        File base = Environment.getExternalStorageDirectory();
        File dl = new File(base, "Download");
        if (dl.isDirectory()) {
            Root r = new Root();
            r.label = Cards.T("Downloads");
            r.dir = dl;
            out.add(r);
        }
        Root dev = new Root();
        dev.label = Cards.T("Device storage");
        dev.dir = base;
        out.add(dev);
        try {
            StorageManager sm = (StorageManager) c.getSystemService(Context.STORAGE_SERVICE);
            for (StorageVolume v : sm.getStorageVolumes()) {
                if (v.isPrimary()) {
                    continue;
                }
                File d = v.getDirectory();
                if (d == null || !Environment.MEDIA_MOUNTED.equals(v.getState())) {
                    continue;
                }
                Root r = new Root();
                String name = v.getDescription(c);
                r.label = (name == null || name.length() == 0) ? Cards.T("USB drive") : name;
                r.dir = d;
                r.removable = true;
                out.add(r);
            }
        } catch (Throwable ignored) {
        }
        return out;
    }

    /** The device storage root itself (the first non-removable root that is not Download). */
    private static boolean isDeviceRoot(Root r) {
        return !r.removable && !r.dir.getName().equals("Download");
    }

    private static final List<String> NEVER = Arrays.asList(
            "android", "system volume information", "$recycle.bin", "lost.dir", ".trash", "lost+found");

    /** True when `f` is inside the root and no folder on the way is hidden or dangerous. */
    static boolean allowed(Root r, File f) {
        try {
            String root = r.dir.getCanonicalPath();
            String p = f.getCanonicalPath();
            if (!(p.equals(root) || p.startsWith(root + "/"))) {
                return false;
            }
            String rel = p.substring(root.length());
            if (rel.startsWith("/")) {
                rel = rel.substring(1);
            }
            if (rel.length() == 0) {
                return true;
            }
            String[] parts = rel.split("/");
            for (int i = 0; i < parts.length; i++) {
                String n = parts[i];
                if (n.startsWith(".") || NEVER.contains(n.toLowerCase())) {
                    return false;
                }
            }
            return true;
        } catch (Throwable t) {
            return false;
        }
    }

    /** Folders and APK files directly inside `dir`, folders first, only the allowed ones. */
    static List<Entry> children(Root r, File dir) {
        List<Entry> out = new ArrayList<Entry>();
        File[] files = null;
        try {
            files = dir.listFiles();
        } catch (Throwable ignored) {
        }
        if (files == null) {
            return out;
        }
        for (File f : files) {
            if (out.size() >= MAX_ENTRIES) {
                break;
            }
            String n = f.getName();
            if (n.startsWith(".") || !allowed(r, f)) {
                continue;
            }
            Entry e = new Entry();
            e.file = f;
            if (f.isDirectory()) {
                e.dir = true;
                out.add(e);
            } else if (f.isFile()) {
                String l = n.toLowerCase();
                if (l.endsWith(".apk")) {
                    e.apk = true;
                    out.add(e);
                } else if (l.endsWith(".xapk") || l.endsWith(".apks") || l.endsWith(".apkm")) {
                    e.bundle = true;
                    out.add(e);
                }
            }
        }
        Collections.sort(out, new Comparator<Entry>() {
            public int compare(Entry a, Entry b) {
                if (a.dir != b.dir) {
                    return a.dir ? -1 : 1;
                }
                return a.file.getName().compareToIgnoreCase(b.file.getName());
            }
        });
        return out;
    }

    /** Folders the device-storage root hides at its top level, besides dot-folders. */
    static boolean hiddenAtTop(Root r, File f) {
        return isDeviceRoot(r) && f.getParentFile() != null && f.getParentFile().equals(r.dir)
                && f.getName().equalsIgnoreCase("Android");
    }
}

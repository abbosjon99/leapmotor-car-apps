package uz.carhelper.passenger.apk;

import android.content.Context;
import android.content.SharedPreferences;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import uz.carhelper.passenger.Backup;

/**
 * The record of apps this app installed. Kept in the app's own private settings (key "installed" in the "apps" prefs),
 * which no other app can read or change, and included in the settings backup so it survives a reset. Only packages in
 * this record can ever be uninstalled from the app.
 */
final class ApkStore {
    private ApkStore() {
    }

    static final class Entry {
        String pkg;
        String label;
        String version;
        long time;
    }

    private static SharedPreferences prefs(Context c) {
        return c.getSharedPreferences("apps", 0);
    }

    static List<Entry> all(Context c) {
        List<Entry> out = new ArrayList<Entry>();
        try {
            JSONArray a = new JSONArray(prefs(c).getString("installed", "[]"));
            for (int i = 0; i < a.length(); i++) {
                JSONObject o = a.getJSONObject(i);
                Entry e = new Entry();
                e.pkg = o.getString("p");
                e.label = o.optString("l", e.pkg);
                e.version = o.optString("v", "");
                e.time = o.optLong("t", 0);
                out.add(e);
            }
        } catch (Exception ignored) {
        }
        return out;
    }

    private static void save(Context c, List<Entry> list) {
        try {
            JSONArray a = new JSONArray();
            for (Entry e : list) {
                JSONObject o = new JSONObject();
                o.put("p", e.pkg);
                o.put("l", e.label);
                o.put("v", e.version);
                o.put("t", e.time);
                a.put(o);
            }
            prefs(c).edit().putString("installed", a.toString()).commit();
            Backup.save(c);
        } catch (Throwable ignored) {
        }
    }

    static void add(Context c, String pkg, String label, String version) {
        List<Entry> list = all(c);
        for (int i = list.size() - 1; i >= 0; i--) {
            if (list.get(i).pkg.equals(pkg)) {
                list.remove(i);
            }
        }
        Entry e = new Entry();
        e.pkg = pkg;
        e.label = label;
        e.version = version == null ? "" : version;
        e.time = System.currentTimeMillis();
        list.add(e);
        save(c, list);
    }

    static void remove(Context c, String pkg) {
        List<Entry> list = all(c);
        for (int i = list.size() - 1; i >= 0; i--) {
            if (list.get(i).pkg.equals(pkg)) {
                list.remove(i);
            }
        }
        save(c, list);
    }
}

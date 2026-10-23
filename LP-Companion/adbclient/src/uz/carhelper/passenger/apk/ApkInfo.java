package uz.carhelper.passenger.apk;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.content.pm.SigningInfo;
import android.graphics.drawable.Drawable;

import java.io.File;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/** What the app can tell about an APK before it is installed (read from the file, nothing is run). */
final class ApkInfo {
    String pkg;
    String label;
    String versionName = "";
    long versionCode;
    long size;
    Drawable icon;
    int permissionCount;
    /** Short names of the sensitive permissions it asks for, e.g. "Camera". */
    List<String> sensitive = new ArrayList<String>();
    boolean installed;
    String installedVersionName = "";
    long installedVersionCode;
    /** false when a copy is installed that was signed with a different key (the install would fail). */
    boolean sameSigner = true;
    boolean self;

    /** (permission, name shown) pairs: the ones a person would want to be told about. */
    private static final String[][] SENSITIVE = {
            {"android.permission.CAMERA", "Camera"},
            {"android.permission.RECORD_AUDIO", "Microphone"},
            {"android.permission.ACCESS_FINE_LOCATION", "Location"},
            {"android.permission.ACCESS_COARSE_LOCATION", "Location"},
            {"android.permission.ACCESS_BACKGROUND_LOCATION", "Location in the background"},
            {"android.permission.READ_CONTACTS", "Contacts"},
            {"android.permission.WRITE_CONTACTS", "Contacts"},
            {"android.permission.READ_SMS", "SMS"},
            {"android.permission.SEND_SMS", "SMS"},
            {"android.permission.RECEIVE_SMS", "SMS"},
            {"android.permission.READ_CALL_LOG", "Call log"},
            {"android.permission.CALL_PHONE", "Phone calls"},
            {"android.permission.READ_PHONE_STATE", "Phone state"},
            {"android.permission.READ_EXTERNAL_STORAGE", "Files"},
            {"android.permission.WRITE_EXTERNAL_STORAGE", "Files"},
            {"android.permission.MANAGE_EXTERNAL_STORAGE", "All files"},
            {"android.permission.SYSTEM_ALERT_WINDOW", "Draw over other apps"},
            {"android.permission.REQUEST_INSTALL_PACKAGES", "Install other apps"},
            {"android.permission.BIND_ACCESSIBILITY_SERVICE", "Accessibility"},
            {"android.permission.BIND_DEVICE_ADMIN", "Device admin"},
            {"android.permission.QUERY_ALL_PACKAGES", "See all installed apps"},
            {"android.permission.WRITE_SETTINGS", "Change system settings"},
            {"android.permission.BODY_SENSORS", "Body sensors"},
            {"android.permission.READ_CALENDAR", "Calendar"},
    };

    /** Reads the APK, or returns null when it is not a readable APK. */
    static ApkInfo read(Context c, File apk) {
        try {
            PackageManager pm = c.getPackageManager();
            String path = apk.getAbsolutePath();
            PackageInfo pi = pm.getPackageArchiveInfo(path,
                    PackageManager.GET_PERMISSIONS | PackageManager.GET_SIGNING_CERTIFICATES);
            if (pi == null || pi.packageName == null) {
                return null;
            }
            ApkInfo r = new ApkInfo();
            r.pkg = pi.packageName;
            r.size = apk.length();
            r.versionName = pi.versionName == null ? "" : pi.versionName;
            r.versionCode = pi.getLongVersionCode();
            ApplicationInfo ai = pi.applicationInfo;
            if (ai != null) {
                ai.sourceDir = path;
                ai.publicSourceDir = path;
                CharSequence l = ai.loadLabel(pm);
                r.label = l == null ? r.pkg : l.toString();
                r.icon = ai.loadIcon(pm);
            } else {
                r.label = r.pkg;
            }
            if (pi.requestedPermissions != null) {
                r.permissionCount = pi.requestedPermissions.length;
                Set<String> seen = new HashSet<String>();
                for (String p : pi.requestedPermissions) {
                    for (String[] s : SENSITIVE) {
                        if (s[0].equals(p) && seen.add(s[1])) {
                            r.sensitive.add(s[1]);
                        }
                    }
                }
            }
            r.self = r.pkg.equals(c.getPackageName());
            try {
                PackageInfo cur = pm.getPackageInfo(r.pkg, PackageManager.GET_SIGNING_CERTIFICATES);
                r.installed = true;
                r.installedVersionName = cur.versionName == null ? "" : cur.versionName;
                r.installedVersionCode = cur.getLongVersionCode();
                Set<String> a = signers(pi.signingInfo);
                Set<String> b = signers(cur.signingInfo);
                if (a != null && b != null && !a.equals(b)) {
                    r.sameSigner = false;
                }
            } catch (PackageManager.NameNotFoundException e) {
                r.installed = false;
            }
            return r;
        } catch (Throwable t) {
            return null;
        }
    }

    /** SHA-256 of each signing certificate, or null when unknown. */
    private static Set<String> signers(SigningInfo si) {
        if (si == null) {
            return null;
        }
        try {
            Signature[] sigs = si.getApkContentsSigners();
            if (sigs == null || sigs.length == 0) {
                return null;
            }
            Set<String> out = new HashSet<String>();
            for (Signature s : sigs) {
                byte[] d = MessageDigest.getInstance("SHA-256").digest(s.toByteArray());
                StringBuilder hex = new StringBuilder();
                for (byte x : d) {
                    hex.append(String.format("%02x", x));
                }
                out.add(hex.toString());
            }
            return out;
        } catch (Exception e) {
            return null;
        }
    }
}

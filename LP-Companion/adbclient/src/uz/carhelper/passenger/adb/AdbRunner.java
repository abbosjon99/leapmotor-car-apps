package uz.carhelper.passenger.adb;

import java.io.File;

/**
 * The one entry point the app calls: connect to the car's own adbd and run a short list of grant commands.
 * Only three kinds of command are accepted (pm grant, appops set, cmd notification allow_listener); anything else is
 * refused before a connection is even made.
 */
public final class AdbRunner {
    private AdbRunner() {
    }

    /** True when something accepts a TCP connection at host:port (no adb is spoken: the socket is closed again at once). */
    public static boolean listening(String host, int port, int ms) {
        java.net.Socket s = new java.net.Socket();
        try {
            s.connect(new java.net.InetSocketAddress(host, port), ms);
            return true;
        } catch (java.io.IOException e) {
            return false;
        } finally {
            try {
                s.close();
            } catch (java.io.IOException ignored) {
            }
        }
    }

    /** True for the grant commands this app is allowed to send. */
    public static boolean allowed(String cmd) {
        return cmd != null
                && (cmd.matches("pm grant --user \\d+ [A-Za-z0-9_.]+ android\\.permission\\.[A-Z_]+")
                || cmd.matches("appops set --user \\d+ [A-Za-z0-9_.]+ [A-Z_]+ (allow|ignore|deny|default)")
                || cmd.matches("cmd notification allow_listener [A-Za-z0-9_.$]+/[A-Za-z0-9_.$]+ \\d+"));
    }

    /** True when a shell command's output looks like an error (these commands print nothing on success). */
    static boolean failed(String output) {
        String o = output.toLowerCase();
        return o.contains("exception") || o.contains("error") || o.contains("unknown") || o.contains("failure")
                || o.contains("not found") || o.contains("denied");
    }

    /** A package name such as com.example.app (letters, digits, underscore, at least one dot). */
    public static boolean validPackage(String pkg) {
        return pkg != null && pkg.length() <= 200 && pkg.matches("[A-Za-z][A-Za-z0-9_]*(\\.[A-Za-z0-9_]+)+");
    }

    /**
     * Installs one plain APK by streaming it into `cmd package install` (the same way `adb install` does), with install
     * reason 64 (how the car's whitelist is passed) and -r (replace). grantAll adds -g (grant every permission the app asks
     * for). The file's path never reaches a shell: only its size goes into the command.
     * Result: "OK|Success..." or NOCONN / AUTH / FAIL with the reason (installer failures come back as FAIL|Failure [...]).
     */
    public static String installApk(String keyPath, String host, int port, File apk, boolean grantAll, int approveSeconds,
                                    AdbProgress progress) {
        if (apk == null || !apk.isFile() || !apk.getName().toLowerCase().endsWith(".apk")) {
            return "FAIL|not an .apk file";
        }
        long size = apk.length();
        if (size < 1000 || size > 2000000000L) {
            return "FAIL|the file size is not valid for an APK";
        }
        AdbConnection c = null;
        java.io.InputStream in = null;
        try {
            in = new java.io.FileInputStream(apk);
            byte[] magic = new byte[4];
            if (in.read(magic) != 4 || magic[0] != 'P' || magic[1] != 'K' || magic[2] != 3 || magic[3] != 4) {
                return "FAIL|not an APK (no zip header)";
            }
            in.close();
            in = new java.io.FileInputStream(apk);
            AdbKey key = AdbKey.load(new File(keyPath));
            c = AdbConnection.open(host, port, key, 4000, approveSeconds * 1000);
            String cmd = "cmd package install -S " + size + " --install-reason 64 -r" + (grantAll ? " -g" : "");
            String out = c.exec(cmd, in, size, progress, 240000).trim();
            if (out.contains("Success") && !out.contains("Failure")) {
                return "OK|" + out;
            }
            return "FAIL|" + (out.length() == 0 ? "the installer printed nothing" : out);
        } catch (AdbException e) {
            return e.code + "|" + e.getMessage();
        } catch (Throwable t) {
            return "FAIL|" + t;
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (java.io.IOException ignored) {
                }
            }
            if (c != null) {
                c.close();
            }
        }
    }

    /** Uninstalls a package (for all users) with `pm uninstall`. Result like run(). */
    public static String uninstallPackage(String keyPath, String host, int port, String pkg, int approveSeconds) {
        if (!validPackage(pkg)) {
            return "FAIL|not a package name: " + pkg;
        }
        AdbConnection c = null;
        try {
            AdbKey key = AdbKey.load(new File(keyPath));
            c = AdbConnection.open(host, port, key, 4000, approveSeconds * 1000);
            String out = c.shell("pm uninstall " + pkg, 60000).trim();
            if (out.contains("Success") && !out.contains("Failure")) {
                return "OK|" + out;
            }
            return "FAIL|" + (out.length() == 0 ? "the uninstaller printed nothing" : out);
        } catch (AdbException e) {
            return e.code + "|" + e.getMessage();
        } catch (Throwable t) {
            return "FAIL|" + t;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    /**
     * Result text: "OK|..." when every command ran, otherwise "NOCONN|...", "AUTH|..." or "FAIL|..." with a reason.
     * approveSeconds is how long to wait for the "Allow USB debugging?" prompt on the car the first time.
     */
    public static String run(String keyPath, String host, int port, String[] commands, int approveSeconds) {
        for (int i = 0; i < commands.length; i++) {
            if (!allowed(commands[i])) {
                return "FAIL|command not allowed: " + commands[i];
            }
        }
        AdbConnection c = null;
        try {
            AdbKey key = AdbKey.load(new File(keyPath));
            c = AdbConnection.open(host, port, key, 4000, approveSeconds * 1000);
            StringBuilder done = new StringBuilder();
            for (int i = 0; i < commands.length; i++) {
                String out = c.shell(commands[i], 15000).trim();
                if (failed(out)) {
                    return "FAIL|" + commands[i] + " -> " + out;
                }
                if (done.length() > 0) {
                    done.append("; ");
                }
                done.append(commands[i]);
            }
            return "OK|" + done;
        } catch (AdbException e) {
            return e.code + "|" + e.getMessage();
        } catch (Throwable t) {
            return "FAIL|" + t;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }
}

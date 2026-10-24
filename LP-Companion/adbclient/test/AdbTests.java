import java.io.File;
import java.nio.file.Files;
import java.util.Arrays;
import uz.carhelper.passenger.adb.AdbProgress;
import uz.carhelper.passenger.adb.AdbRunner;

/** Runs the real client against MockAdbd. Exit code 1 if anything fails. */
public class AdbTests {
    static int fails = 0;

    static String sha(byte[] b) throws Exception {
        StringBuilder hex = new StringBuilder();
        for (byte x : java.security.MessageDigest.getInstance("SHA-256").digest(b)) {
            hex.append(String.format("%02x", x));
        }
        return hex.toString();
    }

    static void check(boolean ok, String what) {
        System.out.println((ok ? "  ok   " : "  FAIL ") + what);
        if (!ok) {
            fails++;
        }
    }

    public static void main(String[] args) throws Exception {
        File dir = Files.createTempDirectory("adbtest").toFile();
        File keyFile = new File(dir, "adbkey");
        String c1 = "pm grant --user 10 uz.carhelper.passenger android.permission.WRITE_SECURE_SETTINGS";
        String c2 = "appops set --user 10 uz.carhelper.passenger SYSTEM_ALERT_WINDOW allow";
        String c3 = "cmd notification allow_listener uz.carhelper.passenger/uz.carhelper.passenger.MediaListener 10";
        String[] cmds = {c1, c2, c3};

        System.out.println("1. first run: unknown key, the user taps Allow after 300 ms");
        MockAdbd d = new MockAdbd(true, true, false, 300);
        String r = AdbRunner.run(keyFile.getPath(), "127.0.0.1", d.port(), cmds, 5);
        System.out.println("   result: " + r);
        check(r.startsWith("OK|"), "all three commands reported OK");
        check(d.commands.equals(Arrays.asList(c1, c2, c3)), "adbd received exactly the three commands, in order");
        check(d.events.contains("signature rejected") && d.events.contains("pubkey valid") && d.events.contains("approved"),
                "unknown key -> signature rejected -> valid public key sent -> approved  " + d.events);
        check(keyFile.isFile() && keyFile.length() > 1000, "the private key was saved");

        System.out.println("2. second run with the saved key: no prompt");
        d.events.clear();
        d.commands.clear();
        r = AdbRunner.run(keyFile.getPath(), "127.0.0.1", d.port(), new String[]{c2}, 5);
        check(r.startsWith("OK|"), "ran with the signature alone: " + r);
        check(d.events.contains("signature ok") && !d.events.contains("pubkey valid"), "signature accepted, no public key needed  " + d.events);
        d.stop();

        System.out.println("3. the prompt is never answered (waits 1 s)");
        MockAdbd silent = new MockAdbd(true, false, false, 0);
        long t0 = System.currentTimeMillis();
        r = AdbRunner.run(new File(dir, "key3").getPath(), "127.0.0.1", silent.port(), new String[]{c1}, 1);
        long took = System.currentTimeMillis() - t0;
        check(r.startsWith("AUTH|") && r.contains("not approved"), "AUTH, not approved in time: " + r);
        check(took >= 900 && took < 6000, "waited about the approval time (" + took + " ms)");
        silent.stop();

        System.out.println("4. the user taps Deny");
        MockAdbd denying = new MockAdbd(true, false, true, 0);
        r = AdbRunner.run(new File(dir, "key4").getPath(), "127.0.0.1", denying.port(), new String[]{c1}, 5);
        check(r.startsWith("AUTH|") && r.contains("did not accept"), "AUTH, refused: " + r);
        check(denying.commands.isEmpty(), "no command ran");
        denying.stop();

        System.out.println("5. nothing listening");
        MockAdbd gone = new MockAdbd(true, true, false, 0);
        int deadPort = gone.port();
        gone.stop();
        r = AdbRunner.run(keyFile.getPath(), "127.0.0.1", deadPort, new String[]{c1}, 5);
        check(r.startsWith("NOCONN|"), "NOCONN: " + r);

        System.out.println("6. a command that is not on the allow-list");
        MockAdbd open = new MockAdbd(false, true, false, 0);
        r = AdbRunner.run(keyFile.getPath(), "127.0.0.1", open.port(), new String[]{c1, "rm -rf /data"}, 5);
        check(r.startsWith("FAIL|command not allowed"), "refused before connecting: " + r);
        check(open.commands.isEmpty() && open.events.isEmpty(), "adbd saw nothing at all");

        System.out.println("7. adbd without authentication (ro.adb.secure=0)");
        r = AdbRunner.run(keyFile.getPath(), "127.0.0.1", open.port(), cmds, 5);
        check(r.startsWith("OK|"), "ran without any AUTH: " + r);
        check(open.commands.equals(Arrays.asList(c1, c2, c3)), "three commands received");

        System.out.println("8. a command prints an error / long output in several packets");
        open.commands.clear();
        open.outputs.put(c1, "Exception occurred while executing 'grant':\njava.lang.SecurityException: nope");
        r = AdbRunner.run(keyFile.getPath(), "127.0.0.1", open.port(), new String[]{c1, c2}, 5);
        check(r.startsWith("FAIL|") && r.contains("SecurityException"), "error text becomes FAIL: " + r);
        check(open.commands.size() == 1, "stopped after the failing command");
        open.outputs.clear();
        StringBuilder big = new StringBuilder();
        for (int i = 0; i < 9000; i++) {
            big.append('a');
        }
        open.outputs.put(c2, big.toString());
        open.chunk = 3000;
        r = AdbRunner.run(keyFile.getPath(), "127.0.0.1", open.port(), new String[]{c2, c3}, 5);
        check(r.startsWith("OK|"), "9000 bytes in 3 WRTE packets are consumed, the next command still runs: " + r);
        open.stop();

        System.out.println("9. the allow-list");
        check(AdbRunner.allowed(c1) && AdbRunner.allowed(c2) && AdbRunner.allowed(c3), "the three real commands pass");
        String[] bad = {"pm grant --user 10 uz.carhelper.passenger android.permission.WRITE_SECURE_SETTINGS; reboot",
                "pm grant --user 10 uz.carhelper.passenger android.permission.WRITE_SECURE_SETTINGS && id",
                "appops set --user 10 uz.carhelper.passenger SYSTEM_ALERT_WINDOW allow | sh",
                "cmd notification allow_listener a/b 10 `id`", "rm -rf /", "", "pm uninstall uz.carhelper.passenger",
                "settings put global adb_enabled 0", "am force-stop x", "pm grant --user 10 x android.permission.camera"};
        boolean allBlocked = true;
        for (String b : bad) {
            if (AdbRunner.allowed(b)) {
                allBlocked = false;
                System.out.println("   passed by mistake: [" + b + "]");
            }
        }
        check(allBlocked, "injection / other commands are all refused");

        System.out.println("10. installing an APK by streaming it (the way adb install does)");
        MockAdbd inst = new MockAdbd(false, true, false, 0);
        File apk = new File(dir, "app.apk");
        byte[] body = new byte[1500000];
        new java.util.Random(7).nextBytes(body);
        body[0] = 'P';
        body[1] = 'K';
        body[2] = 3;
        body[3] = 4;
        Files.write(apk.toPath(), body);
        String want = sha(body);
        final long[] seen = {0, 0};
        AdbProgress prog = new AdbProgress() {
            public void onProgress(long done, long total) {
                seen[0] = done;
                seen[1] = total;
            }
        };
        r = AdbRunner.installApk(keyFile.getPath(), "127.0.0.1", inst.port(), apk, false, 5, prog);
        check(r.startsWith("OK|"), "install reports success: " + r.replace('\n', ' '));
        check(want.equals(inst.lastSha) && inst.lastSize == body.length, "every byte arrived, in order (sha-256 equal)");
        check(inst.commands.size() == 1 && inst.commands.get(0).equals("cmd package install -S 1500000 --install-reason 64 -r"),
                "command is exactly: " + inst.commands);
        check(seen[0] == body.length && seen[1] == body.length, "progress reached 100%");
        check(inst.biggestWrite <= 65536 && inst.biggestWrite > 4096, "messages of at most 64 KB (largest " + inst.biggestWrite + ")");

        System.out.println("11. -g option, a device that only takes 4096-byte messages");
        inst.commands.clear();
        r = AdbRunner.installApk(keyFile.getPath(), "127.0.0.1", inst.port(), apk, true, 5, null);
        check(r.startsWith("OK|") && inst.commands.get(0).endsWith(" --install-reason 64 -r -g"), "with -g: " + inst.commands);
        inst.deviceMaxData = 4096;
        inst.biggestWrite = 0;
        r = AdbRunner.installApk(keyFile.getPath(), "127.0.0.1", inst.port(), apk, false, 5, null);
        check(r.startsWith("OK|") && inst.biggestWrite <= 4096 && want.equals(inst.lastSha), "obeys the device's limit (largest " + inst.biggestWrite + ")");
        inst.deviceMaxData = 1048576;

        System.out.println("12. the installer refuses the app");
        inst.installOutput = "Performing Streamed Install\nFailure [INSTALL_FAILED_VERSION_DOWNGRADE]\n";
        r = AdbRunner.installApk(keyFile.getPath(), "127.0.0.1", inst.port(), apk, false, 5, null);
        check(r.startsWith("FAIL|") && r.contains("INSTALL_FAILED_VERSION_DOWNGRADE"), "failure text is passed on: " + r.replace('\n', ' '));
        inst.installOutput = "Performing Streamed Install\nSuccess\n";

        System.out.println("13. files that must never be sent");
        inst.events.clear();
        inst.commands.clear();
        File txt = new File(dir, "notes.txt");
        Files.write(txt.toPath(), body);
        File fake = new File(dir, "fake.apk");
        Files.write(fake.toPath(), new byte[5000]);
        File tiny = new File(dir, "tiny.apk");
        Files.write(tiny.toPath(), new byte[]{'P', 'K', 3, 4, 0});
        check(AdbRunner.installApk(keyFile.getPath(), "127.0.0.1", inst.port(), txt, false, 5, null).contains("not an .apk"), "a .txt is refused");
        check(AdbRunner.installApk(keyFile.getPath(), "127.0.0.1", inst.port(), fake, false, 5, null).contains("no zip header"), "an .apk that is not a zip is refused");
        check(AdbRunner.installApk(keyFile.getPath(), "127.0.0.1", inst.port(), tiny, false, 5, null).contains("size"), "a tiny file is refused");
        check(AdbRunner.installApk(keyFile.getPath(), "127.0.0.1", inst.port(), new File(dir, "nope.apk"), false, 5, null).startsWith("FAIL|"), "a missing file is refused");
        check(inst.events.isEmpty() && inst.commands.isEmpty(), "adbd saw nothing");

        System.out.println("14. uninstalling");
        inst.outputs.put("pm uninstall com.example.app", "Success");
        r = AdbRunner.uninstallPackage(keyFile.getPath(), "127.0.0.1", inst.port(), "com.example.app", 5);
        check(r.startsWith("OK|") && inst.commands.equals(Arrays.asList("pm uninstall com.example.app")), "uninstall ran: " + r + " " + inst.commands);
        inst.outputs.put("pm uninstall com.example.keep", "Failure [DELETE_FAILED_DEVICE_POLICY_MANAGER]");
        r = AdbRunner.uninstallPackage(keyFile.getPath(), "127.0.0.1", inst.port(), "com.example.keep", 5);
        check(r.startsWith("FAIL|") && r.contains("DELETE_FAILED"), "a refusal is passed on: " + r);
        inst.commands.clear();
        String[] badNames = {"a;b", "../x", "x y", "", "com..x", "com.x; reboot", "com.x$(id)", "nodots", "1com.x"};
        boolean namesOk = true;
        for (String n : badNames) {
            if (!AdbRunner.uninstallPackage(keyFile.getPath(), "127.0.0.1", inst.port(), n, 5).startsWith("FAIL|not a package name")) {
                namesOk = false;
                System.out.println("   accepted by mistake: [" + n + "]");
            }
        }
        check(namesOk && inst.commands.isEmpty(), "bad package names are refused before connecting");
        int deadPort2 = inst.port();
        inst.stop();
        check(AdbRunner.installApk(keyFile.getPath(), "127.0.0.1", deadPort2, apk, false, 5, null).startsWith("NOCONN|"), "no adb -> NOCONN for installs too");

        System.out.println("15. adbd that only accepts SHA1withRSA(token) signatures");
        MockAdbd hs = new MockAdbd(true, true, false, 0);
        hs.sigAccept = 1;
        File key15 = new File(dir, "key15");
        r = AdbRunner.run(key15.getPath(), "127.0.0.1", hs.port(), new String[]{c2}, 5);
        check(r.startsWith("OK|") && hs.events.contains("approved"), "a new key still gets approved: " + r + " " + hs.events);
        hs.events.clear();
        r = AdbRunner.run(key15.getPath(), "127.0.0.1", hs.port(), new String[]{c2}, 5);
        check(r.startsWith("OK|") && hs.events.contains("signature rejected") && hs.events.contains("signature ok")
                && !hs.events.contains("pubkey valid"), "saved key: first style rejected, second accepted, no new prompt  " + hs.events);
        check(new String(Files.readAllBytes(new File(dir, "key15.hint").toPath()), "US-ASCII").equals("10"), "the working style was remembered (hint 10)");
        hs.events.clear();
        r = AdbRunner.run(key15.getPath(), "127.0.0.1", hs.port(), new String[]{c2}, 5);
        check(r.startsWith("OK|") && !hs.events.contains("signature rejected") && hs.events.contains("signature ok"),
                "next time it starts with the style that worked  " + hs.events);
        hs.stop();

        System.out.println("16. adbd that only parses the public key in big-endian order");
        MockAdbd be = new MockAdbd(true, true, false, 0);
        be.keyAccept = 1;
        File key16 = new File(dir, "key16");
        r = AdbRunner.run(key16.getPath(), "127.0.0.1", be.port(), new String[]{c2}, 5);
        check(r.startsWith("OK|") && be.events.contains("pubkey INVALID") && be.events.contains("key order: big-endian")
                && be.events.contains("approved"), "usual order ignored, big-endian accepted: " + r + " " + be.events);
        check(new String(Files.readAllBytes(new File(dir, "key16.hint").toPath()), "US-ASCII").equals("01"), "the key order was remembered (hint 01)");
        be.trusted.clear();
        be.events.clear();
        r = AdbRunner.run(key16.getPath(), "127.0.0.1", be.port(), new String[]{c2}, 5);
        check(r.startsWith("OK|") && !be.events.contains("pubkey INVALID") && be.events.contains("approved"),
                "after a car forgot the key, big-endian goes first  " + be.events);
        be.stop();

        System.out.println("17. adbd in wireless-debugging (TLS) mode");
        MockAdbd tl = new MockAdbd(true, true, false, 0);
        tl.tls = true;
        r = AdbRunner.run(new File(dir, "key17").getPath(), "127.0.0.1", tl.port(), new String[]{c1}, 5);
        check(r.startsWith("TLS|") && r.contains("classic network adb"), "says what is wrong: " + r);
        check(tl.commands.isEmpty(), "no command was sent");
        tl.stop();

        System.out.println("18. is anything listening");
        MockAdbd up = new MockAdbd(true, true, false, 0);
        int upPort = up.port();
        check(AdbRunner.listening("127.0.0.1", upPort, 500), "a listening port answers");
        up.stop();
        check(!AdbRunner.listening("127.0.0.1", upPort, 500), "a closed port does not");

        System.out.println(fails == 0 ? "ALL PASSED" : (fails + " FAILED"));
        System.exit(fails == 0 ? 0 : 1);
    }
}

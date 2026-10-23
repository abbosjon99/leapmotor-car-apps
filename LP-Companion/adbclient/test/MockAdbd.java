import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigInteger;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * A stand-in for the car's adbd, written independently of the client: it checks the signature the way adbd does
 * (raw RSA public-key operation, then compare with 00 01 FF.. 00 + SHA-1 DigestInfo + token) and checks the adb public key
 * struct (modulus, rr = R^2 mod n, n0inv) instead of trusting it. Test code only, never shipped.
 */
public class MockAdbd implements Runnable {
    static final int A_CNXN = 0x4e584e43, A_AUTH = 0x48545541, A_OPEN = 0x4e45504f, A_OKAY = 0x59414b4f,
            A_CLSE = 0x45534c43, A_WRTE = 0x45545257, A_STLS = 0x534c5453;
    static final byte[] SHA1_PREFIX = {0x30, 0x21, 0x30, 0x09, 0x06, 0x05, 0x2b, 0x0e, 0x03, 0x02, 0x1a, 0x05, 0x00, 0x04, 0x14};

    final ServerSocket server;
    final boolean secure;
    final boolean approve;       // the user taps "Allow" on the prompt
    final boolean deny;          // the user taps "Deny" (adbd asks for a signature again)
    final long approveDelayMs;
    int sigAccept = 2;           // which signature styles it verifies: 0 = adb's own only, 1 = SHA1withRSA(token) only, 2 = either
    int keyAccept = 2;           // which public key orders it parses: 0 = little-endian only, 1 = big-endian only, 2 = either
    boolean tls = false;         // wireless-debugging mode: answers CNXN with STLS
    int chunk = 0;               // split shell output into WRTE packets of this size (0 = one packet)
    int deviceMaxData = 1048576; // the max payload adbd announces in its CNXN
    String installOutput = "Performing Streamed Install\nSuccess\n";
    volatile String lastSha = null;
    volatile long lastSize = -1;
    volatile int biggestWrite = 0;
    final List<BigInteger[]> trusted = Collections.synchronizedList(new ArrayList<BigInteger[]>());
    final List<String> commands = Collections.synchronizedList(new ArrayList<String>());
    final List<String> events = Collections.synchronizedList(new ArrayList<String>());
    final Map<String, String> outputs = new HashMap<String, String>();
    private final SecureRandom rnd = new SecureRandom();

    MockAdbd(boolean secure, boolean approve, boolean deny, long approveDelayMs) throws IOException {
        this.server = new ServerSocket(0, 5, java.net.InetAddress.getByName("127.0.0.1"));
        this.secure = secure;
        this.approve = approve;
        this.deny = deny;
        this.approveDelayMs = approveDelayMs;
        Thread t = new Thread(this);
        t.setDaemon(true);
        t.start();
    }

    int port() {
        return server.getLocalPort();
    }

    void stop() throws IOException {
        server.close();
    }

    public void run() {
        while (!server.isClosed()) {
            try {
                final Socket s = server.accept();
                Thread t = new Thread(new Runnable() {
                    public void run() {
                        try {
                            serve(s);
                        } catch (Exception e) {
                            events.add("connection ended: " + e);
                        } finally {
                            try {
                                s.close();
                            } catch (IOException ignored) {
                            }
                        }
                    }
                });
                t.setDaemon(true);
                t.start();
            } catch (IOException e) {
                return;
            }
        }
    }

    private static class Msg {
        int cmd, arg0, arg1;
        byte[] data;
    }

    private Msg read(InputStream in) throws IOException {
        byte[] h = readN(in, 24);
        ByteBuffer b = ByteBuffer.wrap(h).order(ByteOrder.LITTLE_ENDIAN);
        Msg m = new Msg();
        m.cmd = b.getInt();
        m.arg0 = b.getInt();
        m.arg1 = b.getInt();
        int len = b.getInt();
        int check = b.getInt();
        int magic = b.getInt();
        if ((m.cmd ^ 0xffffffff) != magic) {
            throw new IOException("bad magic");
        }
        m.data = readN(in, len);
        int sum = 0;
        for (byte x : m.data) {
            sum += x & 0xff;
        }
        if (sum != check) {
            throw new IOException("bad checksum");
        }
        return m;
    }

    private byte[] readN(InputStream in, int n) throws IOException {
        byte[] b = new byte[n];
        int off = 0;
        while (off < n) {
            int r = in.read(b, off, n - off);
            if (r < 0) {
                throw new IOException("eof");
            }
            off += r;
        }
        return b;
    }

    private void send(OutputStream out, int cmd, int arg0, int arg1, byte[] data) throws IOException {
        int sum = 0;
        for (byte x : data) {
            sum += x & 0xff;
        }
        ByteBuffer b = ByteBuffer.allocate(24 + data.length).order(ByteOrder.LITTLE_ENDIAN);
        b.putInt(cmd).putInt(arg0).putInt(arg1).putInt(data.length).putInt(sum).putInt(cmd ^ 0xffffffff).put(data);
        out.write(b.array());
        out.flush();
    }

    private void serve(Socket s) throws Exception {
        InputStream in = s.getInputStream();
        OutputStream out = s.getOutputStream();
        Msg m = read(in);
        if (m.cmd != A_CNXN) {
            throw new IOException("expected CNXN");
        }
        events.add("CNXN " + new String(m.data, "US-ASCII").trim());
        if (tls) {
            events.add("STLS sent");
            send(out, A_STLS, 0x01000000, 0, new byte[0]);
            Thread.sleep(200);
            return;
        }
        if (secure) {
            byte[] token = new byte[20];
            rnd.nextBytes(token);
            send(out, A_AUTH, 1, 0, token);
            boolean authed = false;
            while (!authed) {
                m = read(in);
                if (m.cmd != A_AUTH) {
                    throw new IOException("expected AUTH");
                }
                if (m.arg0 == 2) {
                    if (verify(m.data, token)) {
                        events.add("signature ok");
                        authed = true;
                    } else {
                        events.add("signature rejected");
                        rnd.nextBytes(token);
                        send(out, A_AUTH, 1, 0, token);
                    }
                } else if (m.arg0 == 3) {
                    BigInteger[] key = parseKey(m.data);
                    events.add(key != null ? "pubkey valid" : "pubkey INVALID");
                    if (key == null) {
                        // adbd ignores a key it cannot decode and asks for a signature again
                        rnd.nextBytes(token);
                        send(out, A_AUTH, 1, 0, token);
                        continue;
                    }
                    if (deny) {
                        rnd.nextBytes(token);
                        send(out, A_AUTH, 1, 0, token);
                        continue;
                    }
                    if (!approve) {
                        Thread.sleep(60000); // the prompt is never answered
                        return;
                    }
                    Thread.sleep(approveDelayMs);
                    trusted.add(key);
                    events.add("approved");
                    authed = true;
                }
            }
        }
        send(out, A_CNXN, 0x01000001, deviceMaxData, "device::\0".getBytes("US-ASCII"));
        int remoteId = 100;
        while (true) {
            m = read(in);
            if (m.cmd == A_OPEN) {
                String svc = new String(m.data, "UTF-8");
                if (svc.endsWith("\0")) {
                    svc = svc.substring(0, svc.length() - 1);
                }
                if (svc.startsWith("exec:cmd package install -S ")) {
                    // `adb install` streaming: exactly N bytes follow in WRTE messages, each acknowledged
                    String cmd = svc.substring(5);
                    commands.add(cmd);
                    long total = Long.parseLong(cmd.split(" ")[4]);
                    int local = m.arg0;
                    int remote = remoteId++;
                    send(out, A_OKAY, remote, local, new byte[0]);
                    java.security.MessageDigest sha = java.security.MessageDigest.getInstance("SHA-256");
                    long got = 0;
                    while (got < total) {
                        Msg w = read(in);
                        if (w.cmd != A_WRTE) {
                            throw new IOException("expected WRTE, got 0x" + Integer.toHexString(w.cmd));
                        }
                        if (w.data.length > deviceMaxData) {
                            throw new IOException("payload " + w.data.length + " is larger than the announced " + deviceMaxData);
                        }
                        biggestWrite = Math.max(biggestWrite, w.data.length);
                        sha.update(w.data);
                        got += w.data.length;
                        send(out, A_OKAY, remote, local, new byte[0]);
                    }
                    StringBuilder hex = new StringBuilder();
                    for (byte x : sha.digest()) {
                        hex.append(String.format("%02x", x));
                    }
                    lastSha = hex.toString();
                    lastSize = got;
                    send(out, A_WRTE, remote, local, installOutput.getBytes("UTF-8"));
                    Msg ack = read(in);
                    if (ack.cmd != A_OKAY) {
                        throw new IOException("expected OKAY after the install output");
                    }
                    send(out, A_CLSE, remote, local, new byte[0]);
                    continue;
                }
                if (!svc.startsWith("shell:")) {
                    send(out, A_CLSE, 0, m.arg0, new byte[0]);
                    continue;
                }
                String cmd = svc.substring(6);
                commands.add(cmd);
                int local = m.arg0;
                int remote = remoteId++;
                send(out, A_OKAY, remote, local, new byte[0]);
                String text = outputs.containsKey(cmd) ? outputs.get(cmd) : "";
                byte[] all = text.getBytes("UTF-8");
                int step = chunk > 0 ? chunk : Math.max(all.length, 1);
                for (int off = 0; off < all.length; off += step) {
                    int n = Math.min(step, all.length - off);
                    byte[] part = new byte[n];
                    System.arraycopy(all, off, part, 0, n);
                    send(out, A_WRTE, remote, local, part);
                    Msg ack = read(in);
                    if (ack.cmd != A_OKAY) {
                        throw new IOException("expected OKAY after WRTE");
                    }
                }
                send(out, A_CLSE, remote, local, new byte[0]);
            }
        }
    }

    /**
     * adbd's check: the signature, raised to e mod n, must be the PKCS#1 v1.5 block of SHA-1 DigestInfo + digest, where
     * the digest is the token itself (adb's own style) and/or SHA-1 of the token (what SHA1withRSA produces).
     */
    private boolean verify(byte[] sig, byte[] token) throws Exception {
        BigInteger s = new BigInteger(1, sig);
        byte[] hashed = java.security.MessageDigest.getInstance("SHA-1").digest(token);
        synchronized (trusted) {
            for (BigInteger[] k : trusted) {
                byte[] em = toBytes(s.modPow(k[1], k[0]), 256);
                if (sigAccept != 1 && matches(em, token)) {
                    return true;
                }
                if (sigAccept != 0 && matches(em, hashed)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static boolean matches(byte[] em, byte[] digest) {
        byte[] t = new byte[SHA1_PREFIX.length + digest.length];
        System.arraycopy(SHA1_PREFIX, 0, t, 0, SHA1_PREFIX.length);
        System.arraycopy(digest, 0, t, SHA1_PREFIX.length, digest.length);
        boolean ok = em[0] == 0 && em[1] == 1 && em[256 - t.length - 1] == 0;
        for (int i = 2; ok && i < 256 - t.length - 1; i++) {
            ok = em[i] == (byte) 0xff;
        }
        for (int i = 0; ok && i < t.length; i++) {
            ok = em[256 - t.length + i] == t[i];
        }
        return ok;
    }

    private static byte[] toBytes(BigInteger v, int len) {
        byte[] raw = v.toByteArray();
        byte[] out = new byte[len];
        for (int i = 0; i < Math.min(raw.length, len); i++) {
            out[len - 1 - i] = raw[raw.length - 1 - i];
        }
        return out;
    }

    private static BigInteger le(byte[] b, int off, int len) {
        byte[] be = new byte[len];
        for (int i = 0; i < len; i++) {
            be[len - 1 - i] = b[off + i];
        }
        return new BigInteger(1, be);
    }

    /** Parses the adb public key text and checks every field of the 524-byte struct. Returns {n, e} or null. */
    private BigInteger[] parseKey(byte[] data) {
        try {
            String text = new String(data, "UTF-8");
            if (!text.endsWith("\0")) {
                events.add("pubkey not NUL terminated");
                return null;
            }
            String b64 = text.substring(0, text.length() - 1).split(" ")[0];
            byte[] st = Base64.getDecoder().decode(b64);
            if (st.length != 524) {
                events.add("pubkey struct is " + st.length + " bytes");
                return null;
            }
            BigInteger[] k = null;
            if (keyAccept != 1) {
                k = checkStruct(st);
                if (k != null) {
                    events.add("key order: little-endian");
                }
            }
            if (k == null && keyAccept != 0) {
                byte[] sw = st.clone();
                for (int i = 0; i + 3 < sw.length; i += 4) {
                    sw[i] = st[i + 3];
                    sw[i + 1] = st[i + 2];
                    sw[i + 2] = st[i + 1];
                    sw[i + 3] = st[i];
                }
                k = checkStruct(sw);
                if (k != null) {
                    events.add("key order: big-endian");
                }
            }
            return k;
        } catch (Exception ex) {
            events.add("pubkey parse error " + ex);
            return null;
        }
    }

    /** Checks every field of the little-endian 524-byte struct. Returns {n, e} or null. */
    private BigInteger[] checkStruct(byte[] st) {
        try {
            ByteBuffer b = ByteBuffer.wrap(st).order(ByteOrder.LITTLE_ENDIAN);
            int words = b.getInt(0);
            long n0inv = b.getInt(4) & 0xffffffffL;
            BigInteger n = le(st, 8, 256);
            BigInteger rr = le(st, 264, 256);
            int e = b.getInt(520);
            BigInteger r = BigInteger.ONE.shiftLeft(2048);
            boolean ok = words == 64 && n.bitLength() == 2048 && e == 65537 && rr.equals(r.multiply(r).mod(n));
            long n0 = n.mod(BigInteger.ONE.shiftLeft(32)).longValue();
            ok = ok && ((n0inv * n0) & 0xffffffffL) == 0xffffffffL;
            if (!ok) {
                events.add("pubkey fields wrong: words=" + words + " e=" + e);
                return null;
            }
            return new BigInteger[]{n, BigInteger.valueOf(e)};
        } catch (Exception ex) {
            events.add("pubkey parse error " + ex);
            return null;
        }
    }
}

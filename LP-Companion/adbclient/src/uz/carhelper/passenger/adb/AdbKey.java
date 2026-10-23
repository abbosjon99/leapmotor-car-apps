package uz.carhelper.passenger.adb;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.interfaces.RSAPrivateCrtKey;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.RSAPublicKeySpec;
import java.util.Base64;

/**
 * This app's own adb key: a 2048-bit RSA key pair kept in a private file. adbd asks a client to sign a 20-byte token
 * (RSA PKCS#1 v1.5 over the token as if it were a SHA-1 digest) and, the first time, to send the public key in adb's own
 * format so the user can approve it on the car's screen.
 */
public final class AdbKey {
    /** DigestInfo prefix for SHA-1; adb signs the 20 token bytes as if they were already a SHA-1 digest. */
    static final byte[] SHA1_PREFIX = {0x30, 0x21, 0x30, 0x09, 0x06, 0x05, 0x2b, 0x0e, 0x03, 0x02, 0x1a, 0x05, 0x00, 0x04, 0x14};
    private static final int KEY_BYTES = 256;

    private final RSAPrivateKey priv;
    private final RSAPublicKey pub;
    private final File file;
    /** How this car's adbd took our messages last time: signature style 0/1 and public key order 0 (little) / 1 (big). */
    int sigHint;
    int keyHint;

    private AdbKey(RSAPrivateKey priv, RSAPublicKey pub, File file) {
        this.priv = priv;
        this.pub = pub;
        this.file = file;
        readHint();
    }

    /** The hint lives next to the key as two digits; anything unreadable means the usual way (0, 0). */
    private void readHint() {
        sigHint = 0;
        keyHint = 0;
        File h = new File(file.getPath() + ".hint");
        try {
            if (h.isFile() && h.length() == 2) {
                byte[] b = readAll(h);
                sigHint = b[0] == '1' ? 1 : 0;
                keyHint = b[1] == '1' ? 1 : 0;
            }
        } catch (Exception ignored) {
        }
    }

    /** Keeps the way that worked, so the next connection starts with it. */
    void remember(int sig, int keyOrder) {
        if (sig == sigHint && keyOrder == keyHint) {
            return;
        }
        sigHint = sig;
        keyHint = keyOrder;
        try {
            OutputStream o = new FileOutputStream(new File(file.getPath() + ".hint"));
            try {
                o.write(new byte[]{(byte) ('0' + sig), (byte) ('0' + keyOrder)});
            } finally {
                o.close();
            }
        } catch (Exception ignored) {
        }
    }

    /** Loads the key from the file, or makes a new one (and saves it) when there is none or it can't be read. */
    public static AdbKey load(File file) throws Exception {
        KeyFactory kf = KeyFactory.getInstance("RSA");
        if (file.isFile()) {
            try {
                RSAPrivateCrtKey crt = (RSAPrivateCrtKey) kf.generatePrivate(new PKCS8EncodedKeySpec(readAll(file)));
                RSAPublicKey pub = (RSAPublicKey) kf.generatePublic(new RSAPublicKeySpec(crt.getModulus(), crt.getPublicExponent()));
                return new AdbKey(crt, pub, file);
            } catch (Exception e) {
                file.delete();
                new File(file.getPath() + ".hint").delete();
            }
        }
        KeyPairGenerator g = KeyPairGenerator.getInstance("RSA");
        g.initialize(2048);
        KeyPair kp = g.generateKeyPair();
        File tmp = new File(file.getPath() + ".tmp");
        OutputStream o = new FileOutputStream(tmp);
        try {
            o.write(kp.getPrivate().getEncoded());
        } finally {
            o.close();
        }
        tmp.setReadable(false, false);
        tmp.setWritable(false, false);
        tmp.setReadable(true, true);
        tmp.setWritable(true, true);
        if (!tmp.renameTo(file)) {
            throw new java.io.IOException("cannot save the adb key");
        }
        return new AdbKey((RSAPrivateKey) kp.getPrivate(), (RSAPublicKey) kp.getPublic(), file);
    }

    private static byte[] readAll(File f) throws java.io.IOException {
        InputStream in = new FileInputStream(f);
        try {
            ByteArrayOutputStream b = new ByteArrayOutputStream();
            byte[] buf = new byte[1024];
            int n;
            while ((n = in.read(buf)) > 0) {
                b.write(buf, 0, n);
            }
            return b.toByteArray();
        } finally {
            in.close();
        }
    }

    /** Signs the token the way adbd checks it: raw RSA over 00 01 FF..FF 00 || SHA1 DigestInfo prefix || token. */
    public byte[] signToken(byte[] token) {
        byte[] t = new byte[SHA1_PREFIX.length + token.length];
        System.arraycopy(SHA1_PREFIX, 0, t, 0, SHA1_PREFIX.length);
        System.arraycopy(token, 0, t, SHA1_PREFIX.length, token.length);
        byte[] em = new byte[KEY_BYTES];
        em[1] = 0x01;
        for (int i = 2; i < KEY_BYTES - t.length - 1; i++) {
            em[i] = (byte) 0xff;
        }
        System.arraycopy(t, 0, em, KEY_BYTES - t.length, t.length);
        BigInteger m = new BigInteger(1, em);
        BigInteger s = m.modPow(priv.getPrivateExponent(), priv.getModulus());
        return fixed(s, KEY_BYTES, true);
    }

    /**
     * Signature style 1: a library-style SHA1withRSA over the token (the token is hashed once more), which some
     * adbd builds check instead of adb's own style 0 above.
     */
    public byte[] signToken(byte[] token, int style) throws Exception {
        if (style != 1) {
            return signToken(token);
        }
        java.security.Signature s = java.security.Signature.getInstance("SHA1withRSA");
        s.initSign(priv);
        s.update(token);
        return s.sign();
    }

    /** The public key in adb's usual (little-endian) format. */
    public byte[] adbPublicKey(String name) throws Exception {
        return adbPublicKey(name, false);
    }

    /**
     * The public key in adb's format (base64 of the 524-byte struct) followed by " name" and a NUL. bigEndian swaps
     * the bytes of every 32-bit word of the struct, which is what a few firmware builds expect.
     */
    public byte[] adbPublicKey(String name, boolean bigEndian) throws Exception {
        BigInteger n = pub.getModulus();
        BigInteger r = BigInteger.ONE.shiftLeft(KEY_BYTES * 8);
        BigInteger rr = r.multiply(r).mod(n);
        BigInteger two32 = BigInteger.ONE.shiftLeft(32);
        long n0inv = two32.subtract(n.mod(two32).modInverse(two32)).longValue();
        ByteBuffer b = ByteBuffer.allocate(4 + 4 + KEY_BYTES + KEY_BYTES + 4).order(ByteOrder.LITTLE_ENDIAN);
        b.putInt(KEY_BYTES / 4);
        b.putInt((int) n0inv);
        b.put(fixed(n, KEY_BYTES, false));
        b.put(fixed(rr, KEY_BYTES, false));
        b.putInt(pub.getPublicExponent().intValue());
        byte[] struct = b.array();
        if (bigEndian) {
            for (int i = 0; i + 3 < struct.length; i += 4) {
                byte t = struct[i];
                struct[i] = struct[i + 3];
                struct[i + 3] = t;
                t = struct[i + 1];
                struct[i + 1] = struct[i + 2];
                struct[i + 2] = t;
            }
        }
        String text = Base64.getEncoder().encodeToString(struct) + " " + name + "\0";
        return text.getBytes("UTF-8");
    }

    /** v as exactly len bytes: big-endian when bigEndian, else little-endian. */
    static byte[] fixed(BigInteger v, int len, boolean bigEndian) {
        byte[] raw = v.toByteArray();
        byte[] out = new byte[len];
        int copy = Math.min(raw.length, len);
        for (int i = 0; i < copy; i++) {
            byte x = raw[raw.length - 1 - i];
            if (bigEndian) {
                out[len - 1 - i] = x;
            } else {
                out[i] = x;
            }
        }
        return out;
    }
}

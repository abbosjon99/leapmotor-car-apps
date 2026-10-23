package uz.carhelper.passenger.adb;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

/** A minimal adb client over TCP: connect (with the RSA key handshake) and run shell commands. */
final class AdbConnection {
    static final int A_CNXN = 0x4e584e43;
    static final int A_AUTH = 0x48545541;
    static final int A_OPEN = 0x4e45504f;
    static final int A_OKAY = 0x59414b4f;
    static final int A_CLSE = 0x45534c43;
    static final int A_WRTE = 0x45545257;
    /** adbd in wireless-debugging mode answers our CNXN with this (it wants a TLS handshake next). */
    static final int A_STLS = 0x534c5453;
    static final int AUTH_TOKEN = 1;
    static final int AUTH_SIGNATURE = 2;
    static final int AUTH_RSAPUBLICKEY = 3;
    private static final int VERSION = 0x01000001;
    private static final int MAX_PAYLOAD = 256 * 1024;
    private static final int MAX_MESSAGE = 1024 * 1024;

    private static final class Msg {
        int cmd;
        int arg0;
        int arg1;
        byte[] data;
    }

    private final Socket socket;
    private final InputStream in;
    private final OutputStream out;
    private int nextId = 1;
    /** Largest payload the device accepts in one message (from its CNXN), never above 64 KB for us. */
    private int maxData = 4096;

    private AdbConnection(Socket socket) throws IOException {
        this.socket = socket;
        this.in = socket.getInputStream();
        this.out = socket.getOutputStream();
    }

    /**
     * Connects and authenticates. If adbd does not know our key yet it shows "Allow USB debugging?" on the car's
     * screen; we then wait up to approveMs for the user to accept.
     */
    static AdbConnection open(String host, int port, AdbKey key, int connectMs, int approveMs) throws AdbException {
        Socket s = new Socket();
        try {
            s.connect(new InetSocketAddress(host, port), connectMs);
            s.setTcpNoDelay(true);
            s.setSoTimeout(10000);
        } catch (IOException e) {
            closeQuietly(s);
            throw new AdbException("NOCONN", "cannot reach adb at " + host + ":" + port + " (" + e.getMessage() + ")");
        }
        try {
            AdbConnection c = new AdbConnection(s);
            c.handshake(key, approveMs);
            return c;
        } catch (AdbException e) {
            closeQuietly(s);
            throw e;
        } catch (IOException e) {
            closeQuietly(s);
            throw new AdbException("FAIL", "adb connection failed: " + e);
        }
    }

    /**
     * adbd answers every signature or key it does not take with a fresh token. So: sign the first token the usual way,
     * sign the next one the other way (no prompt for either), and only then send the public key: the usual order first,
     * the other byte order if adbd asks again. Whatever finally worked is remembered with the key file.
     */
    private void handshake(AdbKey key, int approveMs) throws AdbException, IOException {
        int[] sigOrder = {key.sigHint, 1 - key.sigHint};
        int[] keyOrder = {key.keyHint, 1 - key.keyHint};
        int sigsSent = 0;
        int keysSent = 0;
        boolean lastWasKey = false;
        try {
            send(A_CNXN, VERSION, MAX_PAYLOAD, "host::\0".getBytes("US-ASCII"));
            while (true) {
                Msg m = read();
                if (m.cmd == A_CNXN) {
                    if (m.arg1 >= 4096) {
                        maxData = Math.min(m.arg1, 64 * 1024);
                    }
                    if (lastWasKey) {
                        key.remember(key.sigHint, keyOrder[keysSent - 1]);
                    } else if (sigsSent > 0) {
                        key.remember(sigOrder[sigsSent - 1], key.keyHint);
                    }
                    return;
                }
                if (m.cmd == A_STLS) {
                    throw new AdbException("TLS", "the car's adbd wants a TLS connection (wireless-debugging mode); "
                            + "classic network adb on port " + socket.getPort() + " is needed");
                }
                if (m.cmd == A_AUTH && m.arg0 == AUTH_TOKEN) {
                    if (sigsSent < 2) {
                        send(A_AUTH, AUTH_SIGNATURE, 0, key.signToken(m.data, sigOrder[sigsSent]));
                        sigsSent++;
                        lastWasKey = false;
                    } else if (keysSent < 2) {
                        send(A_AUTH, AUTH_RSAPUBLICKEY, 0, key.adbPublicKey("lp-companion@car", keyOrder[keysSent] == 1));
                        keysSent++;
                        lastWasKey = true;
                        socket.setSoTimeout(approveMs);
                    } else {
                        throw new AdbException("AUTH", "the car did not accept this app's key");
                    }
                } else {
                    throw new AdbException("FAIL", "unexpected adb message 0x" + Integer.toHexString(m.cmd));
                }
            }
        } catch (SocketTimeoutException e) {
            boolean keySent = keysSent > 0;
            if (keySent) {
                throw new AdbException("AUTH", "the key was not approved on the car's screen in time");
            }
            throw new AdbException("FAIL", "adb did not answer");
        } catch (AdbException e) {
            throw e;
        } catch (IOException e) {
            throw e;
        } catch (Exception e) {
            throw new AdbException("FAIL", "adb handshake failed: " + e);
        }
    }

    /** Runs one shell command and returns what it printed. */
    String shell(String command, int timeoutMs) throws AdbException {
        try {
            socket.setSoTimeout(timeoutMs);
            int local = nextId++;
            send(A_OPEN, local, 0, ("shell:" + command + "\0").getBytes("UTF-8"));
            int remote = -1;
            ByteArrayOutputStream buf = new ByteArrayOutputStream();
            while (true) {
                Msg m = read();
                if (m.arg1 != local) {
                    continue;
                }
                if (m.cmd == A_OKAY) {
                    remote = m.arg0;
                } else if (m.cmd == A_WRTE) {
                    buf.write(m.data, 0, m.data.length);
                    send(A_OKAY, local, m.arg0, new byte[0]);
                    remote = m.arg0;
                } else if (m.cmd == A_CLSE) {
                    if (remote < 0) {
                        throw new AdbException("FAIL", "adb refused the shell service");
                    }
                    return buf.toString("UTF-8");
                }
            }
        } catch (SocketTimeoutException e) {
            throw new AdbException("FAIL", "the command did not finish in time");
        } catch (AdbException e) {
            throw e;
        } catch (Exception e) {
            throw new AdbException("FAIL", "adb shell failed: " + e);
        }
    }

    /**
     * Runs an "exec:" service (binary-safe, no terminal), feeds it `size` bytes from `data` and returns what it printed.
     * This is how `adb install` streams an APK into `cmd package install -S size`. Every message we send must be
     * acknowledged by the device before the next one (adb's flow control).
     */
    String exec(String command, InputStream data, long size, AdbProgress progress, int timeoutMs) throws AdbException {
        try {
            socket.setSoTimeout(timeoutMs);
            int local = nextId++;
            send(A_OPEN, local, 0, ("exec:" + command + "\0").getBytes("UTF-8"));
            int remote = -1;
            ByteArrayOutputStream text = new ByteArrayOutputStream();
            while (remote < 0) {
                Msg m = read();
                if (m.arg1 != local) {
                    continue;
                }
                if (m.cmd == A_OKAY) {
                    remote = m.arg0;
                } else if (m.cmd == A_CLSE) {
                    throw new AdbException("FAIL", "adb refused the install service");
                } else if (m.cmd == A_WRTE) {
                    text.write(m.data, 0, m.data.length);
                    send(A_OKAY, local, m.arg0, new byte[0]);
                    remote = m.arg0;
                }
            }
            byte[] buf = new byte[maxData];
            long done = 0;
            boolean closed = false;
            while (!closed && done < size) {
                int want = (int) Math.min(buf.length, size - done);
                int n = data.read(buf, 0, want);
                if (n <= 0) {
                    throw new AdbException("FAIL", "the file ended early");
                }
                byte[] part = new byte[n];
                System.arraycopy(buf, 0, part, 0, n);
                send(A_WRTE, local, remote, part);
                boolean acked = false;
                while (!acked && !closed) {
                    Msg m = read();
                    if (m.arg1 != local) {
                        continue;
                    }
                    if (m.cmd == A_OKAY) {
                        acked = true;
                    } else if (m.cmd == A_WRTE) {
                        text.write(m.data, 0, m.data.length);
                        send(A_OKAY, local, m.arg0, new byte[0]);
                    } else if (m.cmd == A_CLSE) {
                        closed = true;
                    }
                }
                if (acked) {
                    done += n;
                    if (progress != null) {
                        progress.onProgress(done, size);
                    }
                }
            }
            while (!closed) {
                Msg m = read();
                if (m.arg1 != local) {
                    continue;
                }
                if (m.cmd == A_WRTE) {
                    text.write(m.data, 0, m.data.length);
                    send(A_OKAY, local, m.arg0, new byte[0]);
                } else if (m.cmd == A_CLSE) {
                    closed = true;
                }
            }
            return text.toString("UTF-8");
        } catch (SocketTimeoutException e) {
            throw new AdbException("FAIL", "the installer did not answer in time");
        } catch (AdbException e) {
            throw e;
        } catch (Exception e) {
            throw new AdbException("FAIL", "adb install failed: " + e);
        }
    }

    void close() {
        closeQuietly(socket);
    }

    private static void closeQuietly(Socket s) {
        try {
            s.close();
        } catch (IOException ignored) {
        }
    }

    private void send(int cmd, int arg0, int arg1, byte[] data) throws IOException {
        int sum = 0;
        for (int i = 0; i < data.length; i++) {
            sum += data[i] & 0xff;
        }
        ByteBuffer b = ByteBuffer.allocate(24 + data.length).order(ByteOrder.LITTLE_ENDIAN);
        b.putInt(cmd).putInt(arg0).putInt(arg1).putInt(data.length).putInt(sum).putInt(cmd ^ 0xffffffff);
        b.put(data);
        out.write(b.array());
        out.flush();
    }

    private Msg read() throws IOException {
        byte[] h = new byte[24];
        readFully(h);
        ByteBuffer b = ByteBuffer.wrap(h).order(ByteOrder.LITTLE_ENDIAN);
        Msg m = new Msg();
        m.cmd = b.getInt();
        m.arg0 = b.getInt();
        m.arg1 = b.getInt();
        int len = b.getInt();
        b.getInt();
        int magic = b.getInt();
        if ((m.cmd ^ 0xffffffff) != magic || len < 0 || len > MAX_MESSAGE) {
            throw new IOException("not an adb message");
        }
        m.data = new byte[len];
        readFully(m.data);
        return m;
    }

    private void readFully(byte[] b) throws IOException {
        int off = 0;
        while (off < b.length) {
            int n = in.read(b, off, b.length - off);
            if (n < 0) {
                throw new IOException("adb closed the connection");
            }
            off += n;
        }
    }
}

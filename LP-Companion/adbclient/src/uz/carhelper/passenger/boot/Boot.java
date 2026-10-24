package uz.carhelper.passenger.boot;

import android.content.Context;
import android.content.Intent;
import android.hardware.display.DisplayManager;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;
import android.view.Display;
import uz.carhelper.passenger.BackRepair;
import uz.carhelper.passenger.BubbleService;
import uz.carhelper.passenger.MainBubbleService;
import uz.carhelper.passenger.Swapper;

/**
 * Brings LP Companion back after the car restarts or wakes from deep sleep.
 *
 * Before this, BOOT_COMPLETED started the two bubble services once and nothing else: BubbleService stops itself when
 * the passenger display (3) does not exist yet, or when its window cannot be added, and nothing restarted it (so the
 * Back repair that runs inside it never ran either); PassengerWatcher only opens the grid on an off -> on change of
 * the passenger screen, so nothing opened when the screen was already on at boot.
 *
 * kick() is called on the main thread by BootReceiver (the car's boot broadcasts) and by MediaListener (the system
 * rebinds a notification listener after every process start, even if no boot broadcast reaches the app). It runs a
 * short housekeeping loop (every 3 s, for 3 minutes after the last kick):
 *   - puts the Back accessibility service back into enabled_accessibility_services (BackRepair.ensure) and lists the
 *     notification listener in enabled_notification_listeners (ListenerGrant.ensure),
 *   - restarts BubbleService / MainBubbleService when they are not running (at most 6 times each),
 *   - once the passenger display has been ON for 20 s, opens the grid there ONCE per boot, unless the "autoOpen"
 *     setting is off.
 * Everything is in try/catch: on any failure it does nothing rather than crash. Log tag: LPBoot.
 */
public final class Boot implements Runnable {
    private static final String TAG = "LPBoot";
    private static final int PASSENGER = 3;
    private static final long FIRST_MS = 5000L;        // let the services BootReceiver just started create themselves
    private static final long TICK_MS = 3000L;
    private static final long WINDOW_MS = 180000L;     // keep working this long after the last kick
    private static final long SETTLE_MS = 20000L;      // the passenger screen must have been on this long first
    private static final long FRESH_MS = 300000L;      // a listener connect counts as "just booted" for this long
    private static final long SAME_BOOT_MS = 120000L;  // boot broadcasts closer than this are one boot
    private static final int MAX_STARTS = 6;

    private static Boot current;
    private static boolean opened;                     // the grid was already opened for this boot
    private static long lastBoot;

    private final Context app;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private long until;
    private boolean wantOpen;
    private long shownSince;
    private int bubbleStarts;
    private int mainStarts;

    private Boot(Context app) {
        this.app = app;
    }

    /**
     * @param why  what triggered it (the broadcast action, or "listener"); only for the log
     * @param boot true for a boot broadcast (always wants the grid opened), false for the listener connecting
     *             (wants it only if the device started less than 5 minutes ago)
     */
    public static void kick(Context context, String why, boolean boot) {
        try {
            Context app = context.getApplicationContext();
            if (app == null) {
                app = context;
            }
            long now = SystemClock.elapsedRealtime();
            boolean open;
            if (boot) {
                if (lastBoot != 0 && now - lastBoot > SAME_BOOT_MS) {
                    opened = false;                    // a later boot signal in a process that survived
                }
                lastBoot = now;
                open = true;
            } else {
                open = now < FRESH_MS;
            }
            Boot b = current;
            if (b == null) {
                b = new Boot(app);
                current = b;
                b.handler.postDelayed(b, FIRST_MS);
            }
            b.until = now + WINDOW_MS;
            if (open && !opened) {
                b.wantOpen = true;
            }
            Log.i(TAG, "kick by " + why + " (up " + (now / 1000) + " s, open=" + b.wantOpen + ")");
        } catch (Throwable t) {
            Log.w(TAG, "kick failed: " + t);
        }
    }

    @Override
    public void run() {
        if (current != this) {
            return;
        }
        long now = SystemClock.elapsedRealtime();
        boolean pending = false;
        try {
            pending = step(now);
        } catch (Throwable t) {
            Log.w(TAG, "tick failed: " + t);
        }
        if (pending && now < until) {
            handler.postDelayed(this, TICK_MS);
        } else {
            current = null;
            Log.i(TAG, "done (pending=" + pending + ", opened=" + opened + ")");
        }
    }

    /** One pass. Returns true while something is still left to do. */
    private boolean step(long now) {
        boolean pending = false;
        if (!BackRepair.ensure(app)) {
            pending = true;                            // WRITE_SECURE_SETTINGS missing; Heal may bring it back
        }
        if (!ListenerGrant.ensure(app)) {
            pending = true;                            // notification access (MediaListener) not listed; same reason
        }
        DisplayManager dm = (DisplayManager) app.getSystemService(Context.DISPLAY_SERVICE);
        Display d = dm == null ? null : dm.getDisplay(PASSENGER);
        boolean on = d != null && d.getState() == Display.STATE_ON;
        if (on) {
            if (shownSince == 0) {
                shownSince = now;
            }
        } else {
            shownSince = 0;
        }

        if (BubbleService.instance == null) {
            if (bubbleStarts < MAX_STARTS) {
                pending = true;
                if (d != null) {                       // no point before the passenger display exists
                    bubbleStarts++;
                    start(BubbleService.class);
                }
            }
        }
        if (MainBubbleService.instance == null) {
            if (mainStarts < MAX_STARTS) {
                pending = true;
                mainStarts++;
                start(MainBubbleService.class);
            }
        }

        if (wantOpen && !opened) {
            if (!app.getSharedPreferences("apps", Context.MODE_PRIVATE).getBoolean("autoOpen", true)) {
                wantOpen = false;                      // the user turned automatic opening off
            } else if (on && now - shownSince >= SETTLE_MS) {
                opened = true;
                wantOpen = false;
                Log.i(TAG, "opening the grid on the passenger screen");
                Swapper.grid(app);
            } else {
                pending = true;                        // if the screen stays off, PassengerWatcher opens it on wake
            }
        }
        return pending;
    }

    private void start(Class<?> service) {
        try {
            app.startForegroundService(new Intent(app, service));
            Log.i(TAG, "started " + service.getSimpleName());
        } catch (Throwable t) {
            Log.w(TAG, "cannot start " + service.getSimpleName() + ": " + t);
        }
    }
}

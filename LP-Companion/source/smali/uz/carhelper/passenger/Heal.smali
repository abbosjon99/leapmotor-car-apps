.class public Luz/carhelper/passenger/Heal;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Gives the app back its own permissions after a reboot or firmware update, by talking to the car's own adbd (wifi adb,
# 127.0.0.1:5555) with the adb client in the adb package. Needs: the INTERNET permission (manifest), wifi adb listening
# on the head unit, and, the first time, "Allow USB debugging?" accepted on the car's screen for this app's own key.
#
# What it checks (and the only commands it will ever send, enforced again in AdbRunner.allowed):
#   WRITE_SECURE_SETTINGS     pm grant --user U <pkg> android.permission.WRITE_SECURE_SETTINGS
#   draw over other apps      appops set --user U <pkg> SYSTEM_ALERT_WINDOW allow
#   notification access       cmd notification allow_listener <pkg>/uz.carhelper.passenger.WheelListener U
# Automatic attempts (pref "healAdb", default on) start when the bubble service starts, at most every 10 minutes, and retry
# a few times when adbd is not up yet (right after boot). "Fix permissions now" in Settings tries once, any time.
# The last result is kept in pref "healResult" ("OK|...", "NOCONN|...", "AUTH|...", "FAIL|...", "NONE|...").

.field private static running:Z
.field private final ctx:Landroid/content/Context;
.field private final manual:Z

.method private constructor <init>(Landroid/content/Context;Z)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/Heal;->ctx:Landroid/content/Context;
    iput-boolean p2, p0, Luz/carhelper/passenger/Heal;->manual:Z
    return-void
.end method

# head + user + " " + pkg + tail
.method private static join(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v1, " "
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

# the grant commands for whatever is missing right now (empty when everything is granted)
.method private static commands(Landroid/content/Context;)[Ljava/lang/String;
    .locals 8
    new-instance v0, Ljava/util/ArrayList;
    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v1
    # Android user id = uid / 100000 (10 for the car's second user)
    invoke-static {}, Landroid/os/Process;->myUid()I
    move-result v2
    const v3, 0x186a0
    div-int/2addr v2, v3

    const-string v3, "android.permission.WRITE_SECURE_SETTINGS"
    invoke-virtual {p0, v3}, Landroid/content/Context;->checkSelfPermission(Ljava/lang/String;)I
    move-result v3
    if-eqz v3, :wss_ok
    const-string v3, "pm grant --user "
    const-string v4, " android.permission.WRITE_SECURE_SETTINGS"
    invoke-static {v3, v2, v1, v4}, Luz/carhelper/passenger/Heal;->join(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :wss_ok

    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z
    move-result v3
    if-nez v3, :overlay_ok
    const-string v3, "appops set --user "
    const-string v4, " SYSTEM_ALERT_WINDOW allow"
    invoke-static {v3, v2, v1, v4}, Luz/carhelper/passenger/Heal;->join(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :overlay_ok

    const-string v3, "notification"
    invoke-virtual {p0, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Landroid/app/NotificationManager;
    new-instance v4, Landroid/content/ComponentName;
    const-class v5, Luz/carhelper/passenger/WheelListener;
    invoke-direct {v4, p0, v5}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {v3, v4}, Landroid/app/NotificationManager;->isNotificationListenerAccessGranted(Landroid/content/ComponentName;)Z
    move-result v3
    if-nez v3, :listener_ok
    new-instance v3, Ljava/lang/StringBuilder;
    const-string v4, "cmd notification allow_listener "
    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, "/uz.carhelper.passenger.WheelListener "
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :listener_ok

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I
    move-result v3
    new-array v3, v3, [Ljava/lang/String;
    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v3
    check-cast v3, [Ljava/lang/String;
    return-object v3
.end method

# true when at least one of the three is missing
.method public static missing(Landroid/content/Context;)Z
    .locals 2
    :try_start_0
    invoke-static {p0}, Luz/carhelper/passenger/Heal;->commands(Landroid/content/Context;)[Ljava/lang/String;
    move-result-object v0
    array-length v0, v0
    if-eqz v0, :none
    const/4 v0, 0x1
    return v0
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :none
    const/4 v0, 0x0
    return v0
.end method

# manual = the Fix permissions now button: no setting check, no throttle, one attempt, always says what happened
.method public static start(Landroid/content/Context;Z)V
    .locals 9
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v0
    if-nez v0, :have_app
    move-object v0, p0
    :have_app
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v3
    if-nez p1, :go
    const-string v2, "healAdb"
    const/4 v5, 0x1
    invoke-interface {v1, v2, v5}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    if-nez v2, :enabled
    return-void
    :enabled
    const-string v2, "healAt"
    const-wide/16 v5, 0x0
    invoke-interface {v1, v2, v5, v6}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J
    move-result-wide v5
    sub-long v5, v3, v5
    const-wide/32 v7, 0x927c0
    cmp-long v2, v5, v7
    if-gez v2, :go
    return-void
    :go
    sget-boolean v2, Luz/carhelper/passenger/Heal;->running:Z
    if-eqz v2, :idle
    return-void
    :idle
    :try_start_0
    invoke-static {v0}, Luz/carhelper/passenger/Heal;->commands(Landroid/content/Context;)[Ljava/lang/String;
    move-result-object v2
    array-length v2, v2
    if-nez v2, :missing
    if-eqz p1, :nothing_to_do
    const-string v2, "All permissions are already granted"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-static {v0, v2}, Luz/carhelper/passenger/Heal;->say(Landroid/content/Context;Ljava/lang/String;)V
    :nothing_to_do
    return-void
    :missing
    const/4 v2, 0x1
    sput-boolean v2, Luz/carhelper/passenger/Heal;->running:Z
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const-string v2, "healAt"
    invoke-interface {v1, v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V
    if-eqz p1, :started
    const-string v2, "Trying to grant the permissions…"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-static {v0, v2}, Luz/carhelper/passenger/Heal;->say(Landroid/content/Context;Ljava/lang/String;)V
    :started
    new-instance v1, Luz/carhelper/passenger/Heal;
    invoke-direct {v1, v0, p1}, Luz/carhelper/passenger/Heal;-><init>(Landroid/content/Context;Z)V
    new-instance v2, Ljava/lang/Thread;
    invoke-direct {v2, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v2}, Ljava/lang/Thread;->start()V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

# toast from any thread
.method private static say(Landroid/content/Context;Ljava/lang/String;)V
    .locals 3
    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    new-instance v1, Luz/carhelper/passenger/HealToast;
    invoke-direct {v1, p0, p1}, Luz/carhelper/passenger/HealToast;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    return-void
.end method

# the background thread: try, retry while adbd is unreachable (automatic mode only), then report
.method public run()V
    .locals 10
    :try_start_0
    iget-object v0, p0, Luz/carhelper/passenger/Heal;->ctx:Landroid/content/Context;
    iget-boolean v1, p0, Luz/carhelper/passenger/Heal;->manual:Z
    const/4 v2, 0x1
    if-nez v1, :attempts_set
    const/4 v2, 0x6
    :attempts_set
    const/4 v3, 0x0
    const-string v9, "FAIL|no attempt"
    :attempt
    invoke-static {v0}, Luz/carhelper/passenger/Heal;->commands(Landroid/content/Context;)[Ljava/lang/String;
    move-result-object v4
    array-length v5, v4
    if-nez v5, :have_cmds
    const-string v9, "NONE|nothing is missing"
    goto :after
    :have_cmds
    # adbd not listening (wifi adb off after a reboot)? switch it on again first, when this app is allowed to
    const-string v6, "127.0.0.1"
    const/16 v7, 0x15b3
    const/4 v8, 0x1
    :try_start_ens
    invoke-static {v0, v6, v7, v8}, Luz/carhelper/passenger/apk/AdbLink;->ensure(Landroid/content/Context;Ljava/lang/String;IZ)Z
    :try_end_ens
    .catch Ljava/lang/Throwable; {:try_start_ens .. :try_end_ens} :catch_ens
    :catch_ens
    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v5
    invoke-virtual {v5}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v5
    const-string v6, "/adbkey"
    invoke-virtual {v5, v6}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    const-string v6, "127.0.0.1"
    const/16 v7, 0x15b3
    const/16 v8, 0x5a
    invoke-static {v5, v6, v7, v4, v8}, Luz/carhelper/passenger/adb/AdbRunner;->run(Ljava/lang/String;Ljava/lang/String;I[Ljava/lang/String;I)Ljava/lang/String;
    move-result-object v9
    const-string v5, "NOCONN|"
    invoke-virtual {v9, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v5
    if-eqz v5, :after
    add-int/lit8 v3, v3, 0x1
    if-ge v3, v2, :after
    const-wide/32 v5, 0xafc8
    invoke-static {v5, v6}, Ljava/lang/Thread;->sleep(J)V
    goto :attempt
    :after
    invoke-direct {p0, v9}, Luz/carhelper/passenger/Heal;->finish(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    const/4 v0, 0x0
    sput-boolean v0, Luz/carhelper/passenger/Heal;->running:Z
    return-void
.end method

# remember the result, log it, say what happened, and after a success bring the bubbles and Back up
.method private finish(Ljava/lang/String;)V
    .locals 6
    iget-object v0, p0, Luz/carhelper/passenger/Heal;->ctx:Landroid/content/Context;
    iget-boolean v1, p0, Luz/carhelper/passenger/Heal;->manual:Z
    const-string v2, "apps"
    const/4 v3, 0x0
    invoke-virtual {v0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v3, "healResult"
    invoke-interface {v2, v3, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V
    const-string v2, "LPCompanion"
    const-string v3, "adb self-grant: "
    invoke-virtual {v3, p1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const-string v2, "OK|"
    invoke-virtual {p1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :not_ok
    :try_start_0
    invoke-static {v0}, Luz/carhelper/passenger/BackRepair;->ensure(Landroid/content/Context;)Z
    invoke-static {v0}, Luz/carhelper/passenger/Heal;->restart(Landroid/content/Context;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    const-string v2, "Permissions granted through the car's ADB"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-static {v0, v2}, Luz/carhelper/passenger/Heal;->say(Landroid/content/Context;Ljava/lang/String;)V
    return-void
    :not_ok
    const-string v2, "AUTH|"
    invoke-virtual {p1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :not_auth
    const-string v2, "Allow the connection on the car's screen (Always allow), then try again"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-static {v0, v2}, Luz/carhelper/passenger/Heal;->say(Landroid/content/Context;Ljava/lang/String;)V
    return-void
    :not_auth
    const-string v2, "TLS|"
    invoke-virtual {p1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :not_tls
    const-string v2, "The car's ADB is in wireless-debugging mode (TLS). Classic network ADB on port 5555 is needed."
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-static {v0, v2}, Luz/carhelper/passenger/Heal;->say(Landroid/content/Context;Ljava/lang/String;)V
    return-void
    :not_tls
    if-eqz v1, :quiet
    const-string v2, "NONE|"
    invoke-virtual {p1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :not_none
    const-string v2, "All permissions are already granted"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-static {v0, v2}, Luz/carhelper/passenger/Heal;->say(Landroid/content/Context;Ljava/lang/String;)V
    return-void
    :not_none
    const-string v2, "NOCONN|"
    invoke-virtual {p1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :failed
    const-string v2, "Could not reach the car's ADB (port 5555)"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-static {v0, v2}, Luz/carhelper/passenger/Heal;->say(Landroid/content/Context;Ljava/lang/String;)V
    return-void
    :failed
    const-string v2, "Could not grant the permissions"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-static {v0, v2}, Luz/carhelper/passenger/Heal;->say(Landroid/content/Context;Ljava/lang/String;)V
    :quiet
    return-void
.end method

# Without the overlay permission both bubble services stop themselves (their addView fails), so there is nothing to stop:
# just start them again now that it is granted. From the background Android may refuse; then opening the grid starts them.
.method private static restart(Landroid/content/Context;)V
    .locals 3
    new-instance v0, Landroid/content/Intent;
    const-class v1, Luz/carhelper/passenger/BubbleService;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    new-instance v0, Landroid/content/Intent;
    const-class v1, Luz/carhelper/passenger/MainBubbleService;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    return-void
.end method

# one line for Settings: what the last attempt came to
.method public static describe(Landroid/content/Context;)Ljava/lang/String;
    .locals 4
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v2, "healResult"
    const/4 v3, 0x0
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-nez v0, :have
    const-string v0, "No attempt yet"
    invoke-static {v0}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    return-object v0
    :have
    const-string v2, "OK|"
    invoke-virtual {v0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :not_ok
    const-string v0, "Permissions granted through the car's ADB"
    invoke-static {v0}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    return-object v0
    :not_ok
    const-string v2, "AUTH|"
    invoke-virtual {v0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :not_auth
    const-string v0, "Allow the connection on the car's screen (Always allow), then try again"
    invoke-static {v0}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    return-object v0
    :not_auth
    const-string v2, "TLS|"
    invoke-virtual {v0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :not_tls
    const-string v0, "The car's ADB is in wireless-debugging mode (TLS). Classic network ADB on port 5555 is needed."
    invoke-static {v0}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    return-object v0
    :not_tls
    const-string v2, "NONE|"
    invoke-virtual {v0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :not_none
    const-string v0, "All permissions are already granted"
    invoke-static {v0}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    return-object v0
    :not_none
    const-string v2, "NOCONN|"
    invoke-virtual {v0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :failed
    const-string v0, "Could not reach the car's ADB (port 5555)"
    invoke-static {v0}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    return-object v0
    :failed
    const-string v0, "Could not grant the permissions"
    invoke-static {v0}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

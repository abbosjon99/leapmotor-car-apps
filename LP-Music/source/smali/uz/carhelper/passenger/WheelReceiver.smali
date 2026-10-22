.class public Luz/carhelper/passenger/WheelReceiver;
.super Landroid/content/BroadcastReceiver;

# Steering-wheel media buttons for sideloaded players.
# Leapmotor's volumecontrol broadcasts "com.leapmotor.steerwheelcontrol.media" with int extra "action":
#   1 = left/PREVIOUS, 4 = right/NEXT, 7 = center/PLAY-PAUSE, 0 = release.
# Target: a playing session that isn't the car's (com.leapmotor.*, Bluetooth); else the most recently
# active such session (getActiveSessions is ordered newest first). If a car source is playing and
# the target isn't, the car handles the button alone. Can be turned off in Settings (pref "wheel").
# Needs WheelListener's notification-listener access (granted over ADB) for getActiveSessions.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V
    return-void
.end method

.method static getSessions(Landroid/content/Context;)Ljava/util/List;
    .locals 4
    :try_start_0
    const-string v0, "media_session"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/media/session/MediaSessionManager;
    new-instance v1, Landroid/content/ComponentName;
    const-class v2, Luz/carhelper/passenger/WheelListener;
    invoke-direct {v1, p0, v2}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {v0, v1}, Landroid/media/session/MediaSessionManager;->getActiveSessions(Landroid/content/ComponentName;)Ljava/util/List;
    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-object v0
    :catch_0
    move-exception v0
    const-string v1, "LPWheel"
    const-string v2, "getActiveSessions failed (listener access missing?)"
    invoke-static {v1, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    new-instance v0, Ljava/util/ArrayList;
    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V
    return-object v0
.end method

.method static isPlaying(Landroid/media/session/MediaController;)Z
    .locals 3
    invoke-virtual {p0}, Landroid/media/session/MediaController;->getPlaybackState()Landroid/media/session/PlaybackState;
    move-result-object v0
    const/4 v1, 0x0
    if-eqz v0, :no
    invoke-virtual {v0}, Landroid/media/session/PlaybackState;->getState()I
    move-result v0
    const/4 v2, 0x3
    if-ne v0, v2, :no
    const/4 v1, 0x1
    :no
    return v1
.end method

.method static isCar(Ljava/lang/String;)Z
    .locals 1
    const-string v0, "com.leapmotor."
    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :yes
    const-string v0, "com.android.bluetooth"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    :yes
    return v0
.end method

# first playing non-car session, else the first (most recent) non-car session, else null
.method static findTarget(Ljava/util/List;)Landroid/media/session/MediaController;
    .locals 5
    const/4 v4, 0x0
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v0
    :loop
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z
    move-result v3
    if-eqz v3, :end
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/media/session/MediaController;
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v2
    invoke-static {v2}, Luz/carhelper/passenger/WheelReceiver;->isCar(Ljava/lang/String;)Z
    move-result v3
    if-nez v3, :loop
    invoke-static {v1}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v3
    if-eqz v3, :not_playing
    return-object v1
    :not_playing
    if-nez v4, :loop
    move-object v4, v1
    goto :loop
    :end
    return-object v4
.end method

.method static anyCarPlaying(Ljava/util/List;)Z
    .locals 4
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v0
    :loop
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z
    move-result v1
    if-eqz v1, :no
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/media/session/MediaController;
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v2
    invoke-static {v2}, Luz/carhelper/passenger/WheelReceiver;->isCar(Ljava/lang/String;)Z
    move-result v3
    if-eqz v3, :loop
    invoke-static {v1}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v3
    if-eqz v3, :loop
    const/4 v0, 0x1
    return v0
    :no
    const/4 v0, 0x0
    return v0
.end method

.method static key(Landroid/media/session/MediaController;I)V
    .locals 2
    new-instance v0, Landroid/view/KeyEvent;
    const/4 v1, 0x0
    invoke-direct {v0, v1, p1}, Landroid/view/KeyEvent;-><init>(II)V
    invoke-virtual {p0, v0}, Landroid/media/session/MediaController;->dispatchMediaButtonEvent(Landroid/view/KeyEvent;)Z
    new-instance v0, Landroid/view/KeyEvent;
    const/4 v1, 0x1
    invoke-direct {v0, v1, p1}, Landroid/view/KeyEvent;-><init>(II)V
    invoke-virtual {p0, v0}, Landroid/media/session/MediaController;->dispatchMediaButtonEvent(Landroid/view/KeyEvent;)Z
    return-void
.end method

# one guard pass: pause playing car sessions, resume the target if it should be playing
.method static guard(Landroid/content/Context;Landroid/media/session/MediaController;Z)V
    .locals 4
    invoke-static {p0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v0
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v0
    :loop
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z
    move-result v1
    if-eqz v1, :end
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/media/session/MediaController;
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v2
    const-string v3, "com.leapmotor."
    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v3
    if-eqz v3, :loop
    invoke-static {v1}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v3
    if-eqz v3, :loop
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getTransportControls()Landroid/media/session/MediaController$TransportControls;
    move-result-object v3
    invoke-virtual {v3}, Landroid/media/session/MediaController$TransportControls;->pause()V
    goto :loop
    :end
    if-eqz p2, :done
    invoke-static {p1}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v1
    if-nez v1, :done
    invoke-virtual {p1}, Landroid/media/session/MediaController;->getTransportControls()Landroid/media/session/MediaController$TransportControls;
    move-result-object v1
    invoke-virtual {v1}, Landroid/media/session/MediaController$TransportControls;->play()V
    :done
    return-void
.end method

.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 9
    # enabled in Settings? (default on)
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p1, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "wheel"
    const/4 v2, 0x1
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    if-nez v0, :enabled
    return-void
    :enabled

    const-string v0, "action"
    const/4 v1, 0x0
    invoke-virtual {p2, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I
    move-result v0
    const/4 v1, 0x1
    if-eq v0, v1, :ok
    const/4 v1, 0x4
    if-eq v0, v1, :ok
    const/4 v1, 0x7
    if-eq v0, v1, :ok
    return-void

    :ok
    invoke-static {p1}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v2
    invoke-static {v2}, Luz/carhelper/passenger/WheelReceiver;->findTarget(Ljava/util/List;)Landroid/media/session/MediaController;
    move-result-object v3
    if-nez v3, :have
    return-void
    :have
    invoke-static {v3}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v4
    if-nez v4, :act
    invoke-static {v2}, Luz/carhelper/passenger/WheelReceiver;->anyCarPlaying(Ljava/util/List;)Z
    move-result v5
    if-eqz v5, :act
    return-void

    :act
    const/4 v5, 0x7
    if-ne v0, v5, :skip
    if-eqz v4, :do_play
    const/16 v6, 0x7f
    const/4 v7, 0x0
    goto :send
    :do_play
    const/16 v6, 0x7e
    const/4 v7, 0x1
    goto :send
    :skip
    const/16 v6, 0x57
    const/4 v5, 0x1
    if-ne v0, v5, :skip_set
    const/16 v6, 0x58
    :skip_set
    move v7, v4

    :send
    invoke-static {v3, v6}, Luz/carhelper/passenger/WheelReceiver;->key(Landroid/media/session/MediaController;I)V
    const-string v5, "LPWheel"
    invoke-virtual {v3}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v8
    invoke-static {v5, v8}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    # guard against the car's own media app for ~1.5 s, without blocking the main thread
    # WheelGuard(ctx, target, want, pending, handler) needs consecutive registers v3..v7
    invoke-virtual {p0}, Landroid/content/BroadcastReceiver;->goAsync()Landroid/content/BroadcastReceiver$PendingResult;
    move-result-object v8
    new-instance v1, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v2
    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v2
    move v5, v7
    move-object v6, v8
    move-object v7, v1
    move-object v4, v3
    move-object v3, v2
    new-instance v2, Luz/carhelper/passenger/WheelGuard;
    invoke-direct/range {v2 .. v7}, Luz/carhelper/passenger/WheelGuard;-><init>(Landroid/content/Context;Landroid/media/session/MediaController;ZLandroid/content/BroadcastReceiver$PendingResult;Landroid/os/Handler;)V
    const-wide/16 v3, 0x1f4
    invoke-virtual {v7, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
.end method

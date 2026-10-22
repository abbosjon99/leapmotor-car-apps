.class public Luz/carhelper/passenger/MediaBrowser;
.super Landroid/service/media/MediaBrowserService;

# The car's dock/media UI discovers media apps by binding their MediaBrowserService. This one
# owns a MediaSession that MediaMirror keeps in sync with the playing sideloaded player, so the
# dock card can show the song and its controls come back to that player (via MediaCb).
# Also hosts the type-13 Migu announce (MiguBridge) and the steerwheelcontrol key channel.

.field private session:Landroid/media/session/MediaSession;
.field private handler:Landroid/os/Handler;
.field private steer:Landroid/content/BroadcastReceiver;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/service/media/MediaBrowserService;-><init>()V
    return-void
.end method

.method public onCreate()V
    .locals 8
    invoke-super {p0}, Landroid/service/media/MediaBrowserService;->onCreate()V

    # silent foreground notification so the service survives
    const-string v0, "notification"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/app/NotificationManager;
    new-instance v1, Landroid/app/NotificationChannel;
    const-string v2, "lpmusic"
    const-string v3, "LP Music"
    const/4 v4, 0x1
    invoke-direct {v1, v2, v3, v4}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V
    invoke-virtual {v0, v1}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V
    new-instance v1, Landroid/app/Notification$Builder;
    invoke-direct {v1, p0, v2}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;
    move-result-object v3
    iget v3, v3, Landroid/content/pm/ApplicationInfo;->icon:I
    invoke-virtual {v1, v3}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;
    const-string v3, "LP Music"
    invoke-virtual {v1, v3}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;
    invoke-virtual {v1}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;
    move-result-object v1
    const/4 v3, 0x1
    invoke-virtual {p0, v3, v1}, Landroid/app/Service;->startForeground(ILandroid/app/Notification;)V

    # LP Music gate: if disabled in settings, run nothing
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->enabled(Landroid/content/Context;)Z
    move-result v0
    if-nez v0, :lp_enabled
    invoke-virtual {p0}, Landroid/app/Service;->stopSelf()V
    return-void
    :lp_enabled

    # our MediaSession
    new-instance v0, Landroid/media/session/MediaSession;
    const-string v1, "LPMusic"
    invoke-direct {v0, p0, v1}, Landroid/media/session/MediaSession;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    iput-object v0, p0, Luz/carhelper/passenger/MediaBrowser;->session:Landroid/media/session/MediaSession;
    const/4 v1, 0x3
    invoke-virtual {v0, v1}, Landroid/media/session/MediaSession;->setFlags(I)V
    new-instance v1, Luz/carhelper/passenger/MediaCb;
    invoke-direct {v1, p0}, Luz/carhelper/passenger/MediaCb;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, v1}, Landroid/media/session/MediaSession;->setCallback(Landroid/media/session/MediaSession$Callback;)V
    invoke-virtual {v0}, Landroid/media/session/MediaSession;->getSessionToken()Landroid/media/session/MediaSession$Token;
    move-result-object v1
    invoke-virtual {p0, v1}, Landroid/service/media/MediaBrowserService;->setSessionToken(Landroid/media/session/MediaSession$Token;)V

    # handler + mirror + Migu announce
    new-instance v1, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v2
    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v1, p0, Luz/carhelper/passenger/MediaBrowser;->handler:Landroid/os/Handler;
    new-instance v2, Luz/carhelper/passenger/MediaMirror;
    invoke-direct {v2, p0, v1, v0}, Luz/carhelper/passenger/MediaMirror;-><init>(Landroid/content/Context;Landroid/os/Handler;Landroid/media/session/MediaSession;)V
    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    new-instance v2, Luz/carhelper/passenger/MiguBridge;
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v3
    invoke-direct {v2, v3, v1}, Luz/carhelper/passenger/MiguBridge;-><init>(Landroid/content/Context;Landroid/os/Handler;)V
    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    # steerwheelcontrol.media key channel
    new-instance v1, Luz/carhelper/passenger/SteerWheelReceiver;
    invoke-direct {v1}, Luz/carhelper/passenger/SteerWheelReceiver;-><init>()V
    iput-object v1, p0, Luz/carhelper/passenger/MediaBrowser;->steer:Landroid/content/BroadcastReceiver;
    new-instance v2, Landroid/content/IntentFilter;
    const-string v3, "com.leapmotor.steerwheelcontrol.media"
    invoke-direct {v2, v3}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V
    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;
    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 1
    const/4 v0, 0x1
    return v0
.end method

.method public onGetRoot(Ljava/lang/String;ILandroid/os/Bundle;)Landroid/service/media/MediaBrowserService$BrowserRoot;
    .locals 2
    new-instance v0, Landroid/service/media/MediaBrowserService$BrowserRoot;
    const-string v1, "root"
    const/4 p1, 0x0
    invoke-direct {v0, v1, p1}, Landroid/service/media/MediaBrowserService$BrowserRoot;-><init>(Ljava/lang/String;Landroid/os/Bundle;)V
    return-object v0
.end method

.method public onLoadChildren(Ljava/lang/String;Landroid/service/media/MediaBrowserService$Result;)V
    .locals 1
    new-instance v0, Ljava/util/ArrayList;
    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V
    invoke-virtual {p2, v0}, Landroid/service/media/MediaBrowserService$Result;->sendResult(Ljava/lang/Object;)V
    return-void
.end method

.method public onDestroy()V
    .locals 2
    iget-object v0, p0, Luz/carhelper/passenger/MediaBrowser;->steer:Landroid/content/BroadcastReceiver;
    if-eqz v0, :no_steer
    :try_start_0
    invoke-virtual {p0, v0}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :no_steer
    iget-object v0, p0, Luz/carhelper/passenger/MediaBrowser;->handler:Landroid/os/Handler;
    if-eqz v0, :no_h
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V
    :no_h
    iget-object v0, p0, Luz/carhelper/passenger/MediaBrowser;->session:Landroid/media/session/MediaSession;
    if-eqz v0, :no_s
    invoke-virtual {v0}, Landroid/media/session/MediaSession;->release()V
    :no_s
    invoke-super {p0}, Landroid/service/media/MediaBrowserService;->onDestroy()V
    return-void
.end method

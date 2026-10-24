.class public Luz/carhelper/passenger/WheelListener;
.super Landroid/service/notification/NotificationListenerService;

# Its first job is to let WheelReceiver call MediaSessionManager.getActiveSessions(); it reads no notifications.
# Its second job is a start-up path that does not depend on a boot broadcast: the system binds an enabled
# notification listener after every restart / deep-sleep wake, so when it connects and the media service is not
# running, start it (same as BootReceiver). MediaBrowser itself stops again if LP Music is switched off.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/service/notification/NotificationListenerService;-><init>()V
    return-void
.end method

.method public onListenerConnected()V
    .locals 2
    invoke-super {p0}, Landroid/service/notification/NotificationListenerService;->onListenerConnected()V
    sget-boolean v0, Luz/carhelper/passenger/MediaBrowser;->running:Z
    if-nez v0, :done
    new-instance v0, Landroid/content/Intent;
    const-class v1, Luz/carhelper/passenger/MediaBrowser;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    :try_start_0
    invoke-virtual {p0, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :done
    return-void
.end method

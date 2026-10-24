.class public Luz/carhelper/passenger/MediaListener;
.super Landroid/service/notification/NotificationListenerService;

# Notification access for the now-playing card (was called WheelListener until 2.34, a leftover from the steering-wheel
# feature). It reads no notifications: Android only lets an app list other apps' media sessions
# (MediaSessionManager.getActiveSessions, see WheelReceiver.getSessions) when it passes an enabled notification listener,
# and this is that listener. NowPlaying, Closer, MainActivity and OpenPlayerActivity depend on it.
# Its second job: the system rebinds it after every process start, even when no boot broadcast reached the app, so
# connecting is a second "the car just came back" signal for Boot (restart the bubbles, put Back back, open the grid
# if the device started less than 5 minutes ago).
# The grant lives in Settings.Secure enabled_notification_listeners as uz.carhelper.passenger/uz.carhelper.passenger.MediaListener;
# boot/ListenerGrant moves an old WheelListener entry over to it, Heal does the same over the car's adb as a fallback.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/service/notification/NotificationListenerService;-><init>()V
    return-void
.end method

.method public onListenerConnected()V
    .locals 3
    invoke-super {p0}, Landroid/service/notification/NotificationListenerService;->onListenerConnected()V
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v0
    const-string v1, "listener"
    const/4 v2, 0x0
    invoke-static {v0, v1, v2}, Luz/carhelper/passenger/boot/Boot;->kick(Landroid/content/Context;Ljava/lang/String;Z)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

.class public Luz/carhelper/passenger/Perm;
.super Ljava/lang/Object;

# The one permission LP Music needs: notification access for WheelListener (without it MediaSessionManager.getActiveSessions
# shows no player, so nothing can be announced or controlled). The car has the standard "Notification access" page
# (com.android.car.settings NotificationAccessActivity, answers android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS), so the
# app only opens that page; the user switches "LP Music wheel buttons" on there. An adb command does the same:
#   adb shell cmd notification allow_listener com.migu.car.music/uz.carhelper.passenger.WheelListener 10

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# true while the notification access is NOT granted
.method public static missing(Landroid/content/Context;)Z
    .locals 4
    :try_start_0
    const-string v0, "notification"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/app/NotificationManager;
    new-instance v1, Landroid/content/ComponentName;
    const-class v2, Luz/carhelper/passenger/WheelListener;
    invoke-direct {v1, p0, v2}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {v0, v1}, Landroid/app/NotificationManager;->isNotificationListenerAccessGranted(Landroid/content/ComponentName;)Z
    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    if-eqz v0, :yes
    const/4 v0, 0x0
    return v0
    :catch_0
    :yes
    const/4 v0, 0x1
    return v0
.end method

# open the car's Notification access page; false when the car has no such page
.method public static open(Landroid/content/Context;)Z
    .locals 2
    new-instance v0, Landroid/content/Intent;
    const-string v1, "android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS"
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const/high16 v1, 0x10000000
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_0
    invoke-virtual {p0, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    const/4 v0, 0x1
    return v0
    :catch_0
    const/4 v0, 0x0
    return v0
.end method

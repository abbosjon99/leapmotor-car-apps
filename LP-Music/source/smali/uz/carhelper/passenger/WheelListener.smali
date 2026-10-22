.class public Luz/carhelper/passenger/WheelListener;
.super Landroid/service/notification/NotificationListenerService;

# Empty listener: its only purpose is to let WheelReceiver call MediaSessionManager.getActiveSessions().
# It reads no notifications.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/service/notification/NotificationListenerService;-><init>()V
    return-void
.end method

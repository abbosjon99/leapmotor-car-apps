.class public Luz/carhelper/passenger/BackRepair;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Puts BackService back into enabled_accessibility_services when the car drops it (seen after restarts).
# Only appends LP Companion's entry; every other enabled service (e.g. the car's aispeech one) is kept.
# Needs WRITE_SECURE_SETTINGS, granted once over ADB:
#   adb shell pm grant --user 10 uz.carhelper.passenger android.permission.WRITE_SECURE_SETTINGS
# Runs from BubbleService: every 10 s for the first 2 min after start, then every 60 s.

.field private final ctx:Landroid/content/Context;
.field private final handler:Landroid/os/Handler;
.field private tries:I

.method public constructor <init>(Landroid/content/Context;Landroid/os/Handler;)V
    .locals 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/BackRepair;->ctx:Landroid/content/Context;
    iput-object p2, p0, Luz/carhelper/passenger/BackRepair;->handler:Landroid/os/Handler;
    const/16 v0, 0xc
    iput v0, p0, Luz/carhelper/passenger/BackRepair;->tries:I
    return-void
.end method

# true = BackService is listed (already, or just added); false = not allowed to write the setting
.method public static ensure(Landroid/content/Context;)Z
    .locals 5
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    const-string v1, "enabled_accessibility_services"
    invoke-static {v0, v1}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "uz.carhelper.passenger/uz.carhelper.passenger.BackService"
    if-eqz v2, :write
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z
    move-result v4
    if-nez v4, :write
    const-string v4, "uz.carhelper.passenger/"
    invoke-virtual {v2, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v4
    if-eqz v4, :append
    const/4 v0, 0x1
    return v0

    :append
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    const-string v2, ":"
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3

    :write
    :try_start_0
    invoke-static {v0, v1, v3}, Landroid/provider/Settings$Secure;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z
    const-string v1, "accessibility_enabled"
    const/4 v2, 0x1
    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Secure;->putInt(Landroid/content/ContentResolver;Ljava/lang/String;I)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    const-string v0, "LPCompanion"
    const-string v1, "Back accessibility service re-enabled"
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    const/4 v0, 0x1
    return v0

    :catch_0
    const-string v0, "LPCompanion"
    const-string v1, "cannot re-enable Back: WRITE_SECURE_SETTINGS not granted"
    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    const/4 v0, 0x0
    return v0
.end method

.method public run()V
    .locals 4
    sget-object v0, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    if-nez v0, :later
    iget-object v0, p0, Luz/carhelper/passenger/BackRepair;->ctx:Landroid/content/Context;
    invoke-static {v0}, Luz/carhelper/passenger/BackRepair;->ensure(Landroid/content/Context;)Z
    :later
    const-wide/32 v2, 0xea60
    iget v0, p0, Luz/carhelper/passenger/BackRepair;->tries:I
    if-lez v0, :post
    add-int/lit8 v0, v0, -0x1
    iput v0, p0, Luz/carhelper/passenger/BackRepair;->tries:I
    const-wide/16 v2, 0x2710
    :post
    iget-object v1, p0, Luz/carhelper/passenger/BackRepair;->handler:Landroid/os/Handler;
    invoke-virtual {v1, p0, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
.end method

.class public Luz/carhelper/passenger/BootReceiver;
.super Landroid/content/BroadcastReceiver;

# Starts the passenger bubble after the car boots.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V
    return-void
.end method

.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 3
    # the car shows the passenger sidebar after boot
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p1, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v1, "barHidden"
    const/4 v2, 0x1
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    new-instance v0, Landroid/content/Intent;
    const-class v1, Luz/carhelper/passenger/BubbleService;
    invoke-direct {v0, p1, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    :try_start_0
    invoke-virtual {p1, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    new-instance v0, Landroid/content/Intent;
    const-class v1, Luz/carhelper/passenger/MainBubbleService;
    invoke-direct {v0, p1, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    :try_start_1
    invoke-virtual {p1, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    :catch_1
    # keep trying after this: restart the bubbles if they stop, put Back back, open the grid once the passenger
    # screen is on (Boot also logs which broadcast the car really sent: adb logcat -s LPBoot)
    :try_start_2
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;
    move-result-object v1
    # a boot signal wants the grid opened; an update of the app (MY_PACKAGE_REPLACED) only restarts what the update
    # stopped (bubbles, Back, notification access) and opens nothing
    const-string v2, "android.intent.action.MY_PACKAGE_REPLACED"
    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    xor-int/lit8 v2, v2, 0x1
    invoke-static {p1, v1, v2}, Luz/carhelper/passenger/boot/Boot;->kick(Landroid/content/Context;Ljava/lang/String;Z)V
    :try_end_2
    .catch Ljava/lang/Throwable; {:try_start_2 .. :try_end_2} :catch_2
    :catch_2
    return-void
.end method

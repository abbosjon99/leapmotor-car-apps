.class public Luz/carhelper/passenger/Wake;
.super Ljava/lang/Object;

# Opening something on the passenger screen should make it show, even if the car has put that
# screen to sleep. The car's idle handler (com.leapmotor.screensaver) has two modes:
#   screensaver - a photo window over display 3. Its receiver for
#                 com.leapmotor.system.service.DISMISS removes it (no permission needed).
#   screen rest - the screen is "turned off": the service writes Settings.Global display_1_state = 1
#                 and the car blanks it. A tap on the car resets display_1_state / display_2_state to 0;
#                 we do the same (needs the WRITE_SECURE_SETTINGS grant, skipped quietly without it).
# LP Companion's own black "Screen off" cover is removed too.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static passenger(Landroid/content/Context;)V
    .locals 4

    # photo screensaver
    :try_start_0
    new-instance v0, Landroid/content/Intent;
    const-string v1, "com.leapmotor.system.service.DISMISS"
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    invoke-virtual {p0, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0

    # screen rest: only touch the settings when the car actually put the screen to rest
    :try_start_1
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    const-string v1, "display_1_state"
    invoke-static {v0, v1}, Landroid/provider/Settings$Global;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :own
    const-string v3, "0"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :own
    invoke-static {v0, v1, v3}, Landroid/provider/Settings$Global;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z
    const-string v1, "display_2_state"
    invoke-static {v0, v1, v3}, Landroid/provider/Settings$Global;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    :catch_1
    :own

    # our own black cover (bubble panel's "Screen off")
    invoke-static {}, Luz/carhelper/passenger/BubbleService;->uncover()V
    invoke-static {}, Luz/carhelper/passenger/MainBubbleService;->uncover()V
    return-void
.end method

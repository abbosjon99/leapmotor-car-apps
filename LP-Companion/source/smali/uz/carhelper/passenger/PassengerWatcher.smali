.class public Luz/carhelper/passenger/PassengerWatcher;
.super Ljava/lang/Object;
.implements Landroid/hardware/display/DisplayManager$DisplayListener;

# Watches the passenger display (3). When it powers on (the passenger opens their
# windows / screen), LP Companion's grid is brought to the front there, unless the
# "autoOpen" setting is off. Debounced so repeated display events fire it once.

.field private final ctx:Landroid/content/Context;
.field private final dm:Landroid/hardware/display/DisplayManager;
.field private lastOn:Z
.field private lastOpen:J

.method public constructor <init>(Landroid/content/Context;Landroid/hardware/display/DisplayManager;)V
    .locals 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/PassengerWatcher;->ctx:Landroid/content/Context;
    iput-object p2, p0, Luz/carhelper/passenger/PassengerWatcher;->dm:Landroid/hardware/display/DisplayManager;
    const/4 v0, 0x1
    iput-boolean v0, p0, Luz/carhelper/passenger/PassengerWatcher;->lastOn:Z
    return-void
.end method

.method public onDisplayAdded(I)V
    .locals 0
    return-void
.end method

.method public onDisplayRemoved(I)V
    .locals 0
    return-void
.end method

.method public onDisplayChanged(I)V
    .locals 9
    const/4 v0, 0x3
    if-eq p1, v0, :passenger
    return-void
    :passenger
    iget-object v0, p0, Luz/carhelper/passenger/PassengerWatcher;->dm:Landroid/hardware/display/DisplayManager;
    const/4 v1, 0x3
    invoke-virtual {v0, v1}, Landroid/hardware/display/DisplayManager;->getDisplay(I)Landroid/view/Display;
    move-result-object v0
    if-nez v0, :have
    return-void
    :have
    invoke-virtual {v0}, Landroid/view/Display;->getState()I
    move-result v0
    # STATE_ON == 2
    const/4 v1, 0x2
    if-ne v0, v1, :off
    const/4 v2, 0x1
    goto :state_done
    :off
    const/4 v2, 0x0
    :state_done
    iget-boolean v3, p0, Luz/carhelper/passenger/PassengerWatcher;->lastOn:Z
    iput-boolean v2, p0, Luz/carhelper/passenger/PassengerWatcher;->lastOn:Z
    # only act on an off -> on transition
    if-eqz v2, :bail
    if-nez v3, :bail

    # setting gate: pref "apps" / "autoOpen", default on
    iget-object v3, p0, Luz/carhelper/passenger/PassengerWatcher;->ctx:Landroid/content/Context;
    const-string v4, "apps"
    const/4 v5, 0x0
    invoke-virtual {v3, v4, v5}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v4
    const-string v5, "autoOpen"
    const/4 v6, 0x1
    invoke-interface {v4, v5, v6}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v4
    if-eqz v4, :bail

    # debounce: at most once per 2 s
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v4
    iget-wide v6, p0, Luz/carhelper/passenger/PassengerWatcher;->lastOpen:J
    sub-long v8, v4, v6
    const-wide/16 v6, 0x7d0
    cmp-long v6, v8, v6
    if-ltz v6, :bail
    iput-wide v4, p0, Luz/carhelper/passenger/PassengerWatcher;->lastOpen:J

    new-instance v4, Landroid/content/Intent;
    const-class v5, Luz/carhelper/passenger/MainActivity;
    invoke-direct {v4, v3, v5}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    const/high16 v5, 0x10000000
    invoke-virtual {v4, v5}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_0
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v5
    const/4 v6, 0x3
    invoke-virtual {v5, v6}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v5}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v5
    invoke-virtual {v3, v4, v5}, Landroid/content/Context;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void
    :catch_0
    move-exception v4
    :bail
    return-void
.end method

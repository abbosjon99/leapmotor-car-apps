.class public Luz/carhelper/passenger/Closer;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Closes the given packages in two steps (scheduled after the passenger screen was sent Home):
#  1) stop playback through each app's media session, so players drop their foreground service
#  2) 2.5 s later, kill their background processes (ActivityManager.killBackgroundProcesses)
# Android refuses step 2 for apps that still run a foreground service, hence step 1.

.field private final ctx:Landroid/content/Context;
.field private final pkgs:[Ljava/lang/String;
.field private phase:I

.method public constructor <init>(Landroid/content/Context;[Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/Closer;->ctx:Landroid/content/Context;
    iput-object p2, p0, Luz/carhelper/passenger/Closer;->pkgs:[Ljava/lang/String;
    return-void
.end method

.method private isListed(Ljava/lang/String;)Z
    .locals 4
    iget-object v0, p0, Luz/carhelper/passenger/Closer;->pkgs:[Ljava/lang/String;
    array-length v1, v0
    const/4 v2, 0x0
    :loop
    if-ge v2, v1, :no
    aget-object v3, v0, v2
    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :yes
    add-int/lit8 v2, v2, 0x1
    goto :loop
    :yes
    const/4 v0, 0x1
    return v0
    :no
    const/4 v0, 0x0
    return v0
.end method

.method public run()V
    .locals 6
    iget v0, p0, Luz/carhelper/passenger/Closer;->phase:I
    if-nez v0, :kill

    # step 1: stop their media sessions
    const/4 v0, 0x1
    iput v0, p0, Luz/carhelper/passenger/Closer;->phase:I
    :try_start_0
    iget-object v0, p0, Luz/carhelper/passenger/Closer;->ctx:Landroid/content/Context;
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v0
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v0
    :sess_loop
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z
    move-result v1
    if-eqz v1, :sess_end
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/media/session/MediaController;
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v2}, Luz/carhelper/passenger/Closer;->isListed(Ljava/lang/String;)Z
    move-result v3
    if-eqz v3, :sess_loop
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getTransportControls()Landroid/media/session/MediaController$TransportControls;
    move-result-object v3
    invoke-virtual {v3}, Landroid/media/session/MediaController$TransportControls;->pause()V
    invoke-virtual {v3}, Landroid/media/session/MediaController$TransportControls;->stop()V
    const-string v3, "PassengerApps-stop"
    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    goto :sess_loop
    :sess_end
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    const-wide/16 v1, 0x9c4
    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void

    # step 2: kill their background processes
    :kill
    iget-object v0, p0, Luz/carhelper/passenger/Closer;->ctx:Landroid/content/Context;
    const-string v1, "activity"
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/app/ActivityManager;
    iget-object v2, p0, Luz/carhelper/passenger/Closer;->pkgs:[Ljava/lang/String;
    array-length v3, v2
    const/4 v4, 0x0
    :loop
    if-ge v4, v3, :end
    aget-object v5, v2, v4
    invoke-virtual {v1, v5}, Landroid/app/ActivityManager;->killBackgroundProcesses(Ljava/lang/String;)V
    const-string v0, "PassengerApps"
    invoke-static {v0, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    add-int/lit8 v4, v4, 0x1
    goto :loop
    :end
    return-void
.end method

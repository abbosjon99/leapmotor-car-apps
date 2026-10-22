.class public Luz/carhelper/passenger/MusicGate;
.super Ljava/lang/Object;

# LP Music settings + runtime gating, read from prefs file "music":
#   "enabled"     master on/off (default on)
#   "yieldDiplay" hand the wheel keys to DiPlay while it is playing (default on)
# shouldHandle() = enabled AND NOT (yieldDiplay AND DiPlay is playing).
# "DiPlay is playing" = com.shihab.diplay holds a MediaSession in the playing state.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static enabled(Landroid/content/Context;)Z
    .locals 3
    const-string v0, "music"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "enabled"
    const/4 v2, 0x1
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
.end method

.method public static yieldDiplay(Landroid/content/Context;)Z
    .locals 3
    const-string v0, "music"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "yieldDiplay"
    const/4 v2, 0x1
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
.end method

.method public static releaseButtons(Landroid/content/Context;)Z
    .locals 3
    const-string v0, "music"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "releaseButtons"
    const/4 v2, 0x1
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
.end method

.method public static diplayInstalled(Landroid/content/Context;)Z
    .locals 3
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v0
    const-string v1, "com.shihab.diplay"
    const/4 v2, 0x0
    :try_start_0
    invoke-virtual {v0, v1, v2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    const/4 v0, 0x1
    return v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    const/4 v0, 0x0
    return v0
.end method

.method public static diplayPlaying(Landroid/content/Context;)Z
    .locals 4
    invoke-static {p0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v0
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v0
    :loop
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z
    move-result v1
    if-eqz v1, :no
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/media/session/MediaController;
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v2
    const-string v3, "com.shihab.diplay"
    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :loop
    invoke-static {v1}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v2
    if-eqz v2, :loop
    const/4 v0, 0x1
    return v0
    :no
    const/4 v0, 0x0
    return v0
.end method

.method public static shouldHandle(Landroid/content/Context;)Z
    .locals 1
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->enabled(Landroid/content/Context;)Z
    move-result v0
    if-nez v0, :check_yield
    const/4 v0, 0x0
    return v0
    :check_yield
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->yieldDiplay(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :yes
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->diplayPlaying(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :yes
    const/4 v0, 0x0
    return v0
    :yes
    const/4 v0, 0x1
    return v0
.end method

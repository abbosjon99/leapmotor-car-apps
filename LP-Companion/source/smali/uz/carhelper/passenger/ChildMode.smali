.class public Luz/carhelper/passenger/ChildMode;
.super Ljava/lang/Object;

# Child mode is shared across LP Companion and LP Music through a Settings.Secure flag
# ("lp_companion_child" = "1"/"0"). LP Companion owns it (it has WRITE_SECURE_SETTINGS) and
# mirrors its local "kid" pref here; LP Music only reads it to lock itself.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static sync(Landroid/content/Context;Z)V
    .locals 3
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    const-string v1, "lp_companion_child"
    if-eqz p1, :off
    const-string v2, "1"
    goto :put
    :off
    const-string v2, "0"
    :put
    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Secure;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

.method public static locked(Landroid/content/Context;)Z
    .locals 3
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    const-string v1, "lp_companion_child"
    invoke-static {v0, v1}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    const-string v1, "1"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    return v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    const/4 v0, 0x0
    return v0
.end method

# true when this UI context is on the car's MAIN screen (display 0)
.method private static onMain(Landroid/content/Context;)Z
    .locals 2
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getDisplay()Landroid/view/Display;
    move-result-object v0
    if-eqz v0, :no
    invoke-virtual {v0}, Landroid/view/Display;->getDisplayId()I
    move-result v0
    if-nez v0, :no
    const/4 v0, 0x1
    return v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :no
    const/4 v0, 0x0
    return v0
.end method

# true when child mode is on and this UI is on the passenger screen (the main screen is never restricted)
.method public static lockedHere(Landroid/content/Context;)Z
    .locals 3
    invoke-static {p0}, Luz/carhelper/passenger/ChildMode;->onMain(Landroid/content/Context;)Z
    move-result v0
    if-nez v0, :no
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v2, "kid"
    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
    :no
    const/4 v0, 0x0
    return v0
.end method

# a fresh LP Companion grid on the passenger screen (display 3). NEW_TASK | MULTIPLE_TASK like the
# main bubble's child toggle, so it can sit next to a main-screen instance and reads the new mode.
.method public static openGrid(Landroid/content/Context;)V
    .locals 3
    invoke-static {p0}, Luz/carhelper/passenger/Wake;->passenger(Landroid/content/Context;)V
    new-instance v0, Landroid/content/Intent;
    const-class v1, Luz/carhelper/passenger/MainActivity;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    const/high16 v1, 0x18000000
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_0
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v1
    const/4 v2, 0x3
    invoke-virtual {v1, v2}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v1}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v1
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

# Child mode was just switched ON: an allowed ("Kids") app that is running on the passenger screen stays exactly
# where it is; a non-allowed one is closed. Returns true when the filtered grid should be opened there (the front
# app was closed, or LP Companion does not know what is in front).
.method public static takeOver(Landroid/content/Context;)Z
    .locals 9
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "lastPassenger"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :open
    new-instance v2, Ljava/util/HashSet;
    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V
    const-string v3, "kidApps"
    invoke-interface {v0, v3, v2}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v2
    invoke-interface {v2, v1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :close_it
    # allowed app: only leave it alone if it is really still running there
    new-instance v2, Ljava/util/HashSet;
    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V
    const-string v3, "running"
    invoke-interface {v0, v3, v2}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v2
    invoke-interface {v2, v1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :open
    const/4 v0, 0x0
    return v0
    :close_it
    const/4 v2, 0x1
    new-array v2, v2, [Ljava/lang/String;
    const/4 v3, 0x0
    aput-object v1, v2, v3
    new-instance v3, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v4
    invoke-direct {v3, v4}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    new-instance v4, Luz/carhelper/passenger/Closer;
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v5
    invoke-direct {v4, v5, v2}, Luz/carhelper/passenger/Closer;-><init>(Landroid/content/Context;[Ljava/lang/String;)V
    const-wide/16 v5, 0x320
    invoke-virtual {v3, v4, v5, v6}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v2, "lastPassenger"
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    :open
    const/4 v0, 0x1
    return v0
.end method

# Child mode was just switched ON from the main screen: close the passenger app unless it is allowed, and put the
# filtered grid on the passenger screen only when nothing allowed is in front. Does nothing when child mode was
# switched on from the passenger screen itself.
.method public static enter(Landroid/content/Context;)V
    .locals 1
    invoke-static {p0}, Luz/carhelper/passenger/ChildMode;->onMain(Landroid/content/Context;)Z
    move-result v0
    if-nez v0, :main
    return-void
    :main
    invoke-static {p0}, Luz/carhelper/passenger/ChildMode;->takeOver(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :stay
    invoke-static {p0}, Luz/carhelper/passenger/ChildMode;->openGrid(Landroid/content/Context;)V
    :stay
    return-void
.end method

# Child mode was just switched OFF. Nothing to do: grids that are already open follow the kid pref live
# (MainActivity's listener), and an app running on the passenger screen is left where it is.
.method public static exit(Landroid/content/Context;)V
    .locals 0
    return-void
.end method

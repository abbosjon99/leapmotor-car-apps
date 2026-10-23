.class public Luz/carhelper/passenger/Swapper;
.super Ljava/lang/Object;

# Bubble's swap button. Moves the app last opened on the passenger screen from the grid
# (prefs "apps"/"lastPassenger") to the main screen, display 0, and remembers it as "onMain".
# With nothing on the passenger screen, the next tap brings "onMain" back to display 3.
# Launching a running app toward another display moves its task there (same as the grid).
# An app on the main screen is taken out of the "running" set so Close apps / auto-close
# don't close it there. Does nothing in kid mode.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static swap(Landroid/content/Context;)V
    .locals 9
    # v0 = prefs, v2 = package, v3 = target display, v4 = message
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    # kid mode: apps stay on the passenger screen
    const-string v1, "kid"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1
    const-string v4, "Swap is off in kid mode"
    if-nez v1, :toast
    const-string v1, "lastPassenger"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/4 v3, 0x0
    const-string v4, "Moved to the main screen — tap swap again to bring it back"
    if-nez v2, :have_app
    const-string v1, "onMain"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-nez v2, :to_passenger
    const-string v4, "Nothing to swap — open an app from the LP Companion grid first"
    goto :toast
    :to_passenger
    const/4 v3, 0x3
    const-string v4, "Moved back to the passenger screen"

    :have_app
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v5
    invoke-virtual {v5, v2}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;
    move-result-object v6
    if-nez v6, :launch
    const-string v4, "That app is no longer installed"
    goto :toast
    :launch
    # NEW_TASK | MULTIPLE_TASK: reparents the running task to the target display
    # (plain NEW_TASK just reuses it in place on this car, so the app never moved)
    const/high16 v7, 0x18000000
    invoke-virtual {v6, v7}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_0
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v7
    invoke-virtual {v7, v3}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v7}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v7
    invoke-virtual {p0, v6, v7}, Landroid/content/Context;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    # remember where it is now
    new-instance v5, Ljava/util/HashSet;
    invoke-direct {v5}, Ljava/util/HashSet;-><init>()V
    const-string v1, "running"
    invoke-interface {v0, v1, v5}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v6
    new-instance v5, Ljava/util/HashSet;
    invoke-direct {v5, v6}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v6
    if-nez v3, :now_passenger
    invoke-virtual {v5, v2}, Ljava/util/HashSet;->remove(Ljava/lang/Object;)Z
    const-string v7, "onMain"
    invoke-interface {v6, v7, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const-string v7, "lastPassenger"
    invoke-interface {v6, v7}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    goto :save
    :now_passenger
    invoke-virtual {v5, v2}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    const-string v7, "lastPassenger"
    invoke-interface {v6, v7, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const-string v7, "onMain"
    invoke-interface {v6, v7}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    :save
    invoke-interface {v6, v1, v5}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v6}, Landroid/content/SharedPreferences$Editor;->apply()V
    goto :toast

    :catch_0
    move-exception v4
    invoke-virtual {v4}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v4

    :toast
    const/4 v1, 0x1
    invoke-static {p0, v4, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    return-void
.end method

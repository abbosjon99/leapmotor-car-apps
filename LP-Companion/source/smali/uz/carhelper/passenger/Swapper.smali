.class public Luz/carhelper/passenger/Swapper;
.super Ljava/lang/Object;

# Moves an app between the two screens. `to` is 0 (main screen, the "<-" button) or 3 (passenger screen, "->").
#   to 0: the app last opened on the passenger screen from the grid (prefs "apps"/"lastPassenger", still in "running")
#   to 3: the app that was moved to the main screen before (prefs "apps"/"onMain")
# Only apps LP Companion itself opened or moved are known, so "nothing to move" can be shown (buttons gray).
#
# The launch is NEW_TASK | RESET_TASK_IF_NEEDED, exactly like a grid tap. Checked on the car: Android then MOVES the
# app's existing task to the other display. The earlier NEW_TASK | MULTIPLE_TASK made a brand-new task on every
# swap and left the old one running, so an app (Yandex Music Lite) ended up open on both screens.
# After the launch the screen the app left is covered (passenger: the LP Companion grid, main: the car's Home), so
# an app that already had a second task on the target screen (an old duplicate) cannot keep showing where it was.
# Off in child mode. An app on the main screen is taken out of the "running" set so Close apps / auto-close
# don't close it there.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# the package that would be moved toward `to`, or null
.method private static target(Landroid/content/Context;I)Ljava/lang/String;
    .locals 4
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    if-nez p1, :to_passenger
    # toward the main screen: the app last opened on the passenger screen, if it is still running there
    const-string v1, "lastPassenger"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :none
    new-instance v2, Ljava/util/HashSet;
    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V
    const-string v3, "running"
    invoke-interface {v0, v3, v2}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v2
    invoke-interface {v2, v1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :none
    return-object v1
    :to_passenger
    const-string v1, "onMain"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    return-object v1
    :none
    const/4 v1, 0x0
    return-object v1
.end method

# true when there is an app to move toward `to` (and child mode is off); the panels gray the button otherwise
.method public static canMove(Landroid/content/Context;I)Z
    .locals 3
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v2, "kid"
    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    if-nez v0, :no
    invoke-static {p0, p1}, Luz/carhelper/passenger/Swapper;->target(Landroid/content/Context;I)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :no
    const/4 v0, 0x1
    return v0
    :no
    const/4 v0, 0x0
    return v0
.end method

# the car's Home on the main screen
.method public static home(Landroid/content/Context;)V
    .locals 3
    new-instance v0, Landroid/content/Intent;
    const-string v1, "android.intent.action.MAIN"
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v1, "android.intent.category.HOME"
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    const/high16 v1, 0x10000000
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_0
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v1
    const/4 v2, 0x0
    invoke-virtual {v1, v2}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v1}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v1
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

# the LP Companion grid on the passenger screen (reuses the grid task that is already there)
.method public static grid(Landroid/content/Context;)V
    .locals 3
    new-instance v0, Landroid/content/Intent;
    const-class v1, Luz/carhelper/passenger/MainActivity;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    const/high16 v1, 0x10200000
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

.method public static move(Landroid/content/Context;I)V
    .locals 9
    # v0 = prefs, v2 = package, v4 = message
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    # child mode: apps stay on the passenger screen
    const-string v1, "kid"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1
    const-string v4, "Moving apps is off in child mode"
    invoke-static {v4}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-nez v1, :toast
    invoke-static {p0, p1}, Luz/carhelper/passenger/Swapper;->target(Landroid/content/Context;I)Ljava/lang/String;
    move-result-object v2
    if-nez v2, :have_app
    const-string v4, "No app on the passenger screen to move"
    invoke-static {v4}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz p1, :toast
    const-string v4, "No app on the main screen to move"
    invoke-static {v4}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    goto :toast

    :have_app
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v5
    invoke-virtual {v5, v2}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;
    move-result-object v6
    const-string v4, "That app is no longer installed"
    invoke-static {v4}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v6, :toast
    invoke-virtual {v6}, Landroid/content/Intent;->getComponent()Landroid/content/ComponentName;
    move-result-object v5
    if-eqz v5, :toast
    # Rebuild the intent exactly like a grid tap: action MAIN, category LAUNCHER, component only. The intent from
    # getLaunchIntentForPackage also carries pkg=, so it differs from the task's root intent and Android then starts
    # a SECOND instance of the activity on top of the old one (seen on the car: the moved task had 2 activities).
    new-instance v6, Landroid/content/Intent;
    const-string v7, "android.intent.action.MAIN"
    invoke-direct {v6, v7}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v7, "android.intent.category.LAUNCHER"
    invoke-virtual {v6, v7}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    invoke-virtual {v6, v5}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;
    # NEW_TASK | RESET_TASK_IF_NEEDED moves the running task to the other display (no MULTIPLE_TASK: it duplicates)
    const/high16 v7, 0x10200000
    invoke-virtual {v6, v7}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    # going to the passenger screen: wake it first
    const/4 v7, 0x3
    if-ne p1, v7, :no_wake
    invoke-static {p0}, Luz/carhelper/passenger/Wake;->passenger(Landroid/content/Context;)V
    :no_wake
    :try_start_0
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v7
    invoke-virtual {v7, p1}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
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
    if-nez p1, :now_passenger
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

    # cover the screen the app left, message for the one it went to
    if-eqz p1, :left_passenger
    invoke-static {p0}, Luz/carhelper/passenger/Swapper;->home(Landroid/content/Context;)V
    const-string v4, "Moved to the passenger screen"
    invoke-static {v4}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    goto :toast
    :left_passenger
    invoke-static {p0}, Luz/carhelper/passenger/Swapper;->grid(Landroid/content/Context;)V
    const-string v4, "Moved to the main screen"
    invoke-static {v4}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
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

# Open a named app on a chosen screen (long-press menu on a grid tile). `to` is 0 (main) or 3 (passenger). Same launch
# as move(): MAIN + LAUNCHER + component, NEW_TASK | RESET_TASK_IF_NEEDED, so an app that is already running on the
# other screen is MOVED, not duplicated. Keeps the "running" / "lastPassenger" / "onMain" records right and covers the
# screen the app left (passenger: the LP grid, main: the car's Home) when LP knew it was there.
.method public static openOn(Landroid/content/Context;Ljava/lang/String;I)V
    .locals 8
    const-string v7, "That app is no longer installed"
    invoke-static {v7}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v7
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v0
    invoke-virtual {v0, p1}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;
    move-result-object v1
    if-eqz v1, :toast
    invoke-virtual {v1}, Landroid/content/Intent;->getComponent()Landroid/content/ComponentName;
    move-result-object v1
    if-eqz v1, :toast
    new-instance v2, Landroid/content/Intent;
    const-string v3, "android.intent.action.MAIN"
    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v3, "android.intent.category.LAUNCHER"
    invoke-virtual {v2, v3}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    invoke-virtual {v2, v1}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;
    const/high16 v3, 0x10200000
    invoke-virtual {v2, v3}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    const/4 v3, 0x3
    if-ne p2, v3, :no_wake
    invoke-static {p0}, Luz/carhelper/passenger/Wake;->passenger(Landroid/content/Context;)V
    :no_wake
    :try_start_0
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v3
    invoke-virtual {v3, p2}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v3}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v3
    invoke-virtual {p0, v2, v3}, Landroid/content/Context;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    # records: v0 = prefs, v1 = "running" copy, v2 = editor, v3/v4 = old lastPassenger / onMain, v5 = cover passenger, v6 = cover main
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    new-instance v1, Ljava/util/HashSet;
    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V
    const-string v2, "running"
    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v3
    new-instance v1, Ljava/util/HashSet;
    invoke-direct {v1, v3}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V
    const-string v2, "lastPassenger"
    const/4 v3, 0x0
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const-string v2, "onMain"
    const/4 v4, 0x0
    invoke-interface {v0, v2, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const/4 v5, 0x0
    const/4 v6, 0x0
    if-nez p2, :to_passenger
    # to the main screen
    invoke-virtual {v1, p1}, Ljava/util/HashSet;->remove(Ljava/lang/Object;)Z
    const-string v7, "onMain"
    invoke-interface {v2, v7, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-virtual {p1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v7
    if-eqz v7, :save
    const-string v7, "lastPassenger"
    invoke-interface {v2, v7}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const/4 v5, 0x1
    goto :save
    :to_passenger
    invoke-virtual {v1, p1}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    const-string v7, "lastPassenger"
    invoke-interface {v2, v7, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-virtual {p1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v7
    if-eqz v7, :save
    const-string v7, "onMain"
    invoke-interface {v2, v7}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const/4 v6, 0x1
    :save
    const-string v7, "running"
    invoke-interface {v2, v7, v1}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    if-eqz v5, :no_cover_pass
    invoke-static {p0}, Luz/carhelper/passenger/Swapper;->grid(Landroid/content/Context;)V
    :no_cover_pass
    if-eqz v6, :no_cover_main
    invoke-static {p0}, Luz/carhelper/passenger/Swapper;->home(Landroid/content/Context;)V
    :no_cover_main
    const-string v7, "Opened on the main screen"
    invoke-static {v7}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v7
    if-eqz p2, :toast
    const-string v7, "Opened on the passenger screen"
    invoke-static {v7}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v7
    goto :toast

    :catch_0
    move-exception v7
    invoke-virtual {v7}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v7

    :toast
    const/4 v0, 0x0
    invoke-static {p0, v7, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    return-void
.end method

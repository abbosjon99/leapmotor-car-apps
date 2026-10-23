.class public Luz/carhelper/passenger/OpenPlayerActivity;
.super Landroid/app/Activity;

# Opens the sideloaded player that is playing (or was used last). If none, opens LP Companion's
# grid (package uz.carhelper.passenger) when it's installed, else just closes.
# Launched when the car's media card is tapped.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 4
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
    # locked while child mode is on (shared with LP Companion)
    invoke-static {p0}, Luz/carhelper/passenger/ChildMode;->locked(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :not_child_locked
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :not_child_locked
    const/4 v0, 0x0
    :try_start_0
    invoke-static {p0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v1
    invoke-static {v1}, Luz/carhelper/passenger/WheelReceiver;->findTarget(Ljava/util/List;)Landroid/media/session/MediaController;
    move-result-object v1
    if-eqz v1, :fallback
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v1
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v2
    invoke-virtual {v2, v1}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;
    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :fallback
    if-nez v0, :launch
    # resume the last player we remembered, even if it isn't holding a session right now
    const-string v1, "music"
    const/4 v2, 0x0
    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    const-string v2, "lastPlayer"
    const/4 v3, 0x0
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :try_companion
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v2
    invoke-virtual {v2, v1}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;
    move-result-object v0
    if-nez v0, :launch
    :try_companion
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v1
    const-string v2, "uz.carhelper.passenger"
    invoke-virtual {v1, v2}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;
    move-result-object v0
    if-nez v0, :launch
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :launch
    const/high16 v1, 0x10000000
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_1
    invoke-virtual {p0, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    :catch_1
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
.end method

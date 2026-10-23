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

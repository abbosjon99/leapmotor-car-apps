.class public Luz/carhelper/passenger/SettingsRefresh;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Posted by Heal on the main thread after a repair worked: reloads the Settings page, if it is open and has no unsaved
# changes, so the Status rows show the new state without a tap on "Re-check status".

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public run()V
    .locals 0
    :try_start_0
    invoke-static {}, Luz/carhelper/passenger/SettingsActivity;->refresh()V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

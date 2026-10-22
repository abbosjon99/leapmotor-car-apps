.class public Luz/carhelper/passenger/SteerWheelReceiver;
.super Landroid/content/BroadcastReceiver;

# Second wheel-key channel ("steer"), next to the Migu METER.CTRL one ("meter").
# The car broadcasts com.leapmotor.steerwheelcontrol.media with int extra "action":
#   1 = previous, 4 = next, 7 = play/pause, 0 = release (ignored).
# Registered by BubbleService while it runs (not in the manifest). Each press goes through
# KeyDedup, so a press that also arrives as METER.CTRL is handled once.
# If a car source (com.leapmotor.*, Bluetooth) is playing and our target isn't, the press is
# left to the car. Off when the "wheel" setting is off.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V
    return-void
.end method

.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 7
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p1, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "wheel"
    const/4 v2, 0x1
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    if-nez v0, :enabled
    return-void
    :enabled

    # v1 = button: 1 previous, 2 next, 3 play/pause
    const-string v0, "action"
    const/4 v1, -0x1
    invoke-virtual {p2, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I
    move-result v0
    const/4 v1, 0x1
    const/4 v2, 0x1
    if-eq v0, v2, :mapped
    const/4 v1, 0x2
    const/4 v2, 0x4
    if-eq v0, v2, :mapped
    const/4 v1, 0x3
    const/4 v2, 0x7
    if-eq v0, v2, :mapped
    return-void
    :mapped

    invoke-static {p1}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v2
    invoke-static {v2}, Luz/carhelper/passenger/WheelReceiver;->findTarget(Ljava/util/List;)Landroid/media/session/MediaController;
    move-result-object v3
    if-nez v3, :have_target
    return-void
    :have_target
    invoke-static {v3}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v4
    if-nez v4, :ours
    invoke-static {v2}, Luz/carhelper/passenger/WheelReceiver;->anyCarPlaying(Ljava/util/List;)Z
    move-result v5
    if-eqz v5, :ours
    const-string v5, "LPWheelKeys"
    const-string v6, "channel=steer: a car source is playing, left to the car"
    invoke-static {v5, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-void
    :ours

    const-string v5, "steer"
    invoke-static {v5, v1}, Luz/carhelper/passenger/KeyDedup;->accept(Ljava/lang/String;I)Z
    move-result v5
    if-nez v5, :send
    return-void

    :send
    invoke-virtual {v3}, Landroid/media/session/MediaController;->getTransportControls()Landroid/media/session/MediaController$TransportControls;
    move-result-object v5
    const/4 v6, 0x1
    if-ne v1, v6, :not_prev
    invoke-virtual {v5}, Landroid/media/session/MediaController$TransportControls;->skipToPrevious()V
    goto :log
    :not_prev
    const/4 v6, 0x2
    if-ne v1, v6, :toggle
    invoke-virtual {v5}, Landroid/media/session/MediaController$TransportControls;->skipToNext()V
    goto :log
    :toggle
    if-eqz v4, :play
    invoke-virtual {v5}, Landroid/media/session/MediaController$TransportControls;->pause()V
    goto :log
    :play
    invoke-virtual {v5}, Landroid/media/session/MediaController$TransportControls;->play()V

    :log
    const-string v5, "LPWheelKeys"
    new-instance v6, Ljava/lang/StringBuilder;
    const-string v0, "channel=steer sent to "
    invoke-direct {v6, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v3}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-static {v5, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

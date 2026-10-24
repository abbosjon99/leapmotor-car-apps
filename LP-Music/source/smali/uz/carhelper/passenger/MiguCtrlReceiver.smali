.class public Luz/carhelper/passenger/MiguCtrlReceiver;
.super Landroid/content/BroadcastReceiver;

# Car -> "Migu" (media type 13) commands, forwarded to the active sideloaded player:
#   com.leapmotor.action.METER.CTRL  value "1" = previous, "2" = next, "3" = play/pause toggle,
#                                    keyEventType "steeringWheel" | "backRow" (ignored), playMediaType int 13
#   com.leapmotor.action.VOICE.CTRL  value JSON {"type":"play"|"pause"|"stop"|"next"|"nextOne"|"pre"|"preOne",...},
#                                    playMediaType int 13
# These are what the car's MultiMedia app sends for the steering wheel, the dock card buttons and
# voice once our type-13 announce (MiguBridge) is its current source. See FINDINGS.md.
# METER.CTRL presses go through KeyDedup ("meter" channel); voice commands don't.
# Logged under tag LPWheelKeys.
# Only for playMediaType 13 (what MiguBridge announces). Off when the "wheel" setting is off.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V
    return-void
.end method

# The dock card's heart button: the car sends it to SourceService as ISourceController.collectionAction (see
# SourceService$Ctl), and LP Music uses it as "previous track". Public because SourceService is in another package.
.method public static previous(Landroid/content/Context;)V
    .locals 3
    :try_start_0
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->shouldHandle(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :done
    invoke-static {p0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v0
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->findTarget(Ljava/util/List;)Landroid/media/session/MediaController;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/media/session/MediaController;->getTransportControls()Landroid/media/session/MediaController$TransportControls;
    move-result-object v1
    invoke-virtual {v1}, Landroid/media/session/MediaController$TransportControls;->skipToPrevious()V
    invoke-static {}, Luz/carhelper/passenger/MiguBridge;->kick()V
    const-string v1, "LPWheelKeys"
    const-string v2, "dock heart (collectionAction) -> previous"
    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :done
    :done
    return-void
.end method

.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 7
    # LP Music gate: off, or yielding to a playing DiPlay
    invoke-static {p1}, Luz/carhelper/passenger/MusicGate;->shouldHandle(Landroid/content/Context;)Z
    move-result v0
    if-nez v0, :enabled
    return-void
    :enabled

    const-string v0, "playMediaType"
    const/4 v1, -0x1
    invoke-virtual {p2, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I
    move-result v0
    const/16 v1, 0xd
    if-eq v0, v1, :mine
    return-void
    :mine
    const-string v0, "value"
    invoke-virtual {p2, v0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-nez v0, :have_value
    return-void
    :have_value
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;
    move-result-object v1

    invoke-static {p1}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v2
    invoke-static {v2}, Luz/carhelper/passenger/WheelReceiver;->findTarget(Ljava/util/List;)Landroid/media/session/MediaController;
    move-result-object v2
    if-nez v2, :have_target
    return-void
    :have_target
    invoke-virtual {v2}, Landroid/media/session/MediaController;->getTransportControls()Landroid/media/session/MediaController$TransportControls;
    move-result-object v3

    # steering wheel (METER.CTRL): plain "1" / "2" / "3" -> button 1 previous / 2 next / 3 play-pause,
    # through KeyDedup ("meter" channel) so a press also seen on steerwheelcontrol.media runs once
    const-string v4, "com.leapmotor.action.METER.CTRL"
    invoke-virtual {v4, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-eqz v4, :voice
    const/4 v5, 0x2
    const-string v4, "2"
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-nez v4, :meter_dedup
    const/4 v5, 0x1
    const-string v4, "1"
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-nez v4, :meter_dedup
    const/4 v5, 0x3
    const-string v4, "3"
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-nez v4, :meter_dedup
    return-void
    :meter_dedup
    const-string v4, "meter"
    invoke-static {v4, v5}, Luz/carhelper/passenger/KeyDedup;->accept(Ljava/lang/String;I)Z
    move-result v4
    if-nez v4, :meter_go
    return-void
    :meter_go
    const/4 v4, 0x1
    if-eq v5, v4, :do_prev
    const/4 v4, 0x2
    if-eq v5, v4, :do_next
    goto :do_toggle

    # voice / dock / play-pause (VOICE.CTRL): JSON {"type": ..., "state": -1, ...}
    # the car's own sources send play | pause | stop; the voice assistant also sends
    # nextOne | preOne. "stop" only pauses: the player's session should stay alive.
    :voice
    :try_start_0
    new-instance v4, Lorg/json/JSONObject;
    invoke-direct {v4, v0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    const-string v5, "type"
    const-string v6, ""
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    invoke-virtual {v4}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;
    move-result-object v4
    const-string v5, "pause"
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-nez v5, :do_pause
    const-string v5, "stop"
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-nez v5, :do_pause
    const-string v5, "play"
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-nez v5, :do_play
    const-string v5, "next"
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-nez v5, :do_next
    const-string v5, "nextone"
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-nez v5, :do_next
    const-string v5, "pre"
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-nez v5, :do_prev
    const-string v5, "preone"
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-nez v5, :do_prev
    const-string v5, "previous"
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-nez v5, :do_prev
    return-void
    :catch_0
    return-void

    :do_next
    invoke-virtual {v3}, Landroid/media/session/MediaController$TransportControls;->skipToNext()V
    goto :log
    :do_prev
    invoke-virtual {v3}, Landroid/media/session/MediaController$TransportControls;->skipToPrevious()V
    goto :log
    :do_play
    invoke-virtual {v3}, Landroid/media/session/MediaController$TransportControls;->play()V
    goto :log
    :do_pause
    invoke-virtual {v3}, Landroid/media/session/MediaController$TransportControls;->pause()V
    goto :log
    :do_toggle
    invoke-static {v2}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v4
    if-eqz v4, :do_play
    goto :do_pause

    # e.g. "com.leapmotor.action.METER.CTRL 2 -> ru.yandex.music" (also under LPWheelKeys for testing)
    :log
    # tell the car the new play state quickly (MiguBridge announces every 0.5 s for a moment)
    invoke-static {}, Luz/carhelper/passenger/MiguBridge;->kick()V
    const-string v4, "LPWheelKeys"
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v6, " "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v6, " -> "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v6
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static {v4, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

.class public Luz/carhelper/passenger/MediaCb;
.super Landroid/media/session/MediaSession$Callback;

# Our MediaSession's callback. The car (or anything else) controlling "LP Music" is forwarded
# to the real sideloaded player that we mirror.

.field private final ctx:Landroid/content/Context;

.method public constructor <init>(Landroid/content/Context;)V
    .locals 0
    invoke-direct {p0}, Landroid/media/session/MediaSession$Callback;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/MediaCb;->ctx:Landroid/content/Context;
    return-void
.end method

.method private tc()Landroid/media/session/MediaController$TransportControls;
    .locals 1
    iget-object v0, p0, Luz/carhelper/passenger/MediaCb;->ctx:Landroid/content/Context;
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v0
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->findTarget(Ljava/util/List;)Landroid/media/session/MediaController;
    move-result-object v0
    if-nez v0, :have
    const/4 v0, 0x0
    return-object v0
    :have
    invoke-virtual {v0}, Landroid/media/session/MediaController;->getTransportControls()Landroid/media/session/MediaController$TransportControls;
    move-result-object v0
    return-object v0
.end method

.method public onPlay()V
    .locals 1
    invoke-direct {p0}, Luz/carhelper/passenger/MediaCb;->tc()Landroid/media/session/MediaController$TransportControls;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/media/session/MediaController$TransportControls;->play()V
    :done
    return-void
.end method

.method public onPause()V
    .locals 1
    invoke-direct {p0}, Luz/carhelper/passenger/MediaCb;->tc()Landroid/media/session/MediaController$TransportControls;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/media/session/MediaController$TransportControls;->pause()V
    :done
    return-void
.end method

.method public onSkipToNext()V
    .locals 1
    invoke-direct {p0}, Luz/carhelper/passenger/MediaCb;->tc()Landroid/media/session/MediaController$TransportControls;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/media/session/MediaController$TransportControls;->skipToNext()V
    :done
    return-void
.end method

.method public onSkipToPrevious()V
    .locals 1
    invoke-direct {p0}, Luz/carhelper/passenger/MediaCb;->tc()Landroid/media/session/MediaController$TransportControls;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/media/session/MediaController$TransportControls;->skipToPrevious()V
    :done
    return-void
.end method

.method public onStop()V
    .locals 1
    invoke-direct {p0}, Luz/carhelper/passenger/MediaCb;->tc()Landroid/media/session/MediaController$TransportControls;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/media/session/MediaController$TransportControls;->stop()V
    :done
    return-void
.end method

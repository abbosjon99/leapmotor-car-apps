.class public Luz/carhelper/passenger/MediaMirror;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Every 1 s: copy the playing sideloaded player's title/artist/album/art and play state into
# our own MediaSession, so the car's dock card (which binds our MediaBrowserService) shows it.
# When no sideloaded player is the target, the session goes inactive.

.field private final ctx:Landroid/content/Context;
.field private final handler:Landroid/os/Handler;
.field private final session:Landroid/media/session/MediaSession;

.method public constructor <init>(Landroid/content/Context;Landroid/os/Handler;Landroid/media/session/MediaSession;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/MediaMirror;->ctx:Landroid/content/Context;
    iput-object p2, p0, Luz/carhelper/passenger/MediaMirror;->handler:Landroid/os/Handler;
    iput-object p3, p0, Luz/carhelper/passenger/MediaMirror;->session:Landroid/media/session/MediaSession;
    return-void
.end method

# metadata string or "" (never null)
.method private static s(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    if-eqz p0, :empty
    invoke-virtual {p0, p1}, Landroid/media/MediaMetadata;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :empty
    return-object v0
    :empty
    const-string v0, ""
    return-object v0
.end method

.method public run()V
    .locals 3
    :try_start_0
    invoke-direct {p0}, Luz/carhelper/passenger/MediaMirror;->update()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    goto :again
    :catch_0
    move-exception v0
    const-string v1, "LPMusic"
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :again
    iget-object v0, p0, Luz/carhelper/passenger/MediaMirror;->handler:Landroid/os/Handler;
    const-wide/16 v1, 0x3e8
    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
.end method

.method private update()V
    .locals 10
    iget-object v9, p0, Luz/carhelper/passenger/MediaMirror;->session:Landroid/media/session/MediaSession;
    iget-object v0, p0, Luz/carhelper/passenger/MediaMirror;->ctx:Landroid/content/Context;
    # LP Music gate: if off, or yielding to a playing DiPlay, go inactive and stop mirroring
    invoke-static {v0}, Luz/carhelper/passenger/MusicGate;->shouldHandle(Landroid/content/Context;)Z
    move-result v1
    if-nez v1, :gate_ok
    const/4 v1, 0x0
    invoke-virtual {v9, v1}, Landroid/media/session/MediaSession;->setActive(Z)V
    return-void
    :gate_ok
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v0
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->findTarget(Ljava/util/List;)Landroid/media/session/MediaController;
    move-result-object v0
    if-nez v0, :have
    const/4 v1, 0x0
    invoke-virtual {v9, v1}, Landroid/media/session/MediaSession;->setActive(Z)V
    return-void

    :have
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v1
    invoke-virtual {v0}, Landroid/media/session/MediaController;->getMetadata()Landroid/media/MediaMetadata;
    move-result-object v2

    new-instance v3, Landroid/media/MediaMetadata$Builder;
    invoke-direct {v3}, Landroid/media/MediaMetadata$Builder;-><init>()V
    const-string v4, "android.media.metadata.TITLE"
    invoke-static {v2, v4}, Luz/carhelper/passenger/MediaMirror;->s(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v3, v4, v5}, Landroid/media/MediaMetadata$Builder;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/media/MediaMetadata$Builder;
    const-string v4, "android.media.metadata.ARTIST"
    invoke-static {v2, v4}, Luz/carhelper/passenger/MediaMirror;->s(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v3, v4, v5}, Landroid/media/MediaMetadata$Builder;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/media/MediaMetadata$Builder;
    const-string v4, "android.media.metadata.ALBUM"
    invoke-static {v2, v4}, Luz/carhelper/passenger/MediaMirror;->s(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v3, v4, v5}, Landroid/media/MediaMetadata$Builder;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/media/MediaMetadata$Builder;
    const-string v4, "android.media.metadata.DISPLAY_TITLE"
    invoke-static {v2, v4}, Luz/carhelper/passenger/MediaMirror;->s(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v3, v4, v5}, Landroid/media/MediaMetadata$Builder;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/media/MediaMetadata$Builder;

    # album art, only if the player has one
    if-eqz v2, :noart
    const-string v4, "android.media.metadata.ALBUM_ART"
    invoke-virtual {v2, v4}, Landroid/media/MediaMetadata;->getBitmap(Ljava/lang/String;)Landroid/graphics/Bitmap;
    move-result-object v5
    if-eqz v5, :noart
    invoke-virtual {v3, v4, v5}, Landroid/media/MediaMetadata$Builder;->putBitmap(Ljava/lang/String;Landroid/graphics/Bitmap;)Landroid/media/MediaMetadata$Builder;
    :noart
    invoke-virtual {v3}, Landroid/media/MediaMetadata$Builder;->build()Landroid/media/MediaMetadata;
    move-result-object v3
    invoke-virtual {v9, v3}, Landroid/media/session/MediaSession;->setMetadata(Landroid/media/MediaMetadata;)V

    # playback state: mirror position and play/pause
    const-wide/16 v4, 0x0
    invoke-virtual {v0}, Landroid/media/session/MediaController;->getPlaybackState()Landroid/media/session/PlaybackState;
    move-result-object v6
    if-eqz v6, :nopos
    invoke-virtual {v6}, Landroid/media/session/PlaybackState;->getPosition()J
    move-result-wide v4
    :nopos
    new-instance v6, Landroid/media/session/PlaybackState$Builder;
    invoke-direct {v6}, Landroid/media/session/PlaybackState$Builder;-><init>()V
    const-wide/16 v7, 0x237
    invoke-virtual {v6, v7, v8}, Landroid/media/session/PlaybackState$Builder;->setActions(J)Landroid/media/session/PlaybackState$Builder;
    const/4 v7, 0x2
    if-eqz v1, :state_set
    const/4 v7, 0x3
    :state_set
    const/high16 v8, 0x3f800000
    invoke-virtual {v6, v7, v4, v5, v8}, Landroid/media/session/PlaybackState$Builder;->setState(IJF)Landroid/media/session/PlaybackState$Builder;
    invoke-virtual {v6}, Landroid/media/session/PlaybackState$Builder;->build()Landroid/media/session/PlaybackState;
    move-result-object v6
    invoke-virtual {v9, v6}, Landroid/media/session/MediaSession;->setPlaybackState(Landroid/media/session/PlaybackState;)V
    const/4 v0, 0x1
    invoke-virtual {v9, v0}, Landroid/media/session/MediaSession;->setActive(Z)V
    return-void
.end method

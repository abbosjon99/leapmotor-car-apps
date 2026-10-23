.class public Luz/carhelper/passenger/MediaMirror;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Used to copy the playing player's title/artist/art/state into our own MediaSession. Not any more:
# nothing on the car reads that session, and Android's car media service (CAR.MEDIA, com.android.car)
# treats a playing session as the new media source and pauses the real player: every time Yandex
# Music started, the log showed "Changing media source ... uz.carhelper.music" and Yandex gave up
# audio focus a few ms later, then resumed, then paused again (play/pause flapping). See FINDINGS.md.
# So the session stays inactive. What is left, every 1 s: remember which player is in use
# ("music"/"lastPlayer") so OpenPlayerActivity can reopen it.

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
    .locals 4
    # our session is never active (see the header)
    iget-object v0, p0, Luz/carhelper/passenger/MediaMirror;->session:Landroid/media/session/MediaSession;
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/media/session/MediaSession;->setActive(Z)V

    iget-object v0, p0, Luz/carhelper/passenger/MediaMirror;->ctx:Landroid/content/Context;
    invoke-static {v0}, Luz/carhelper/passenger/MusicGate;->shouldHandle(Landroid/content/Context;)Z
    move-result v1
    if-nez v1, :gate_ok
    return-void
    :gate_ok
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v1
    invoke-static {v1}, Luz/carhelper/passenger/WheelReceiver;->findTarget(Ljava/util/List;)Landroid/media/session/MediaController;
    move-result-object v1
    if-nez v1, :have
    return-void
    :have
    # remember this player so the car's media card can resume it after it closes
    const-string v2, "music"
    const/4 v3, 0x0
    invoke-virtual {v0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v2, "lastPlayer"
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v3
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    return-void
.end method

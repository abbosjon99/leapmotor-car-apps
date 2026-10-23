.class public Luz/carhelper/passenger/MiguBridge;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Announce the active sideloaded player to the car's media center the way NetEase and Migu do:
# every 1.5 s, one broadcast when something changed
#   com.leapmotor.transfer.MEDIA.INFO  extras: info = NotifyOutBean JSON, bitmap = cover JPEG
# The car's MultiMedia app (com.leapmotor.multimedia, the only receiver) accepts media type 13
# from any sender, remembers it as the last played source, pushes it to the dock card
# (launcher3:smartdock) and the instrument cluster, and from then on routes the steering wheel,
# the dock buttons and voice as METER.CTRL / VOICE.CTRL broadcasts (MiguCtrlReceiver).
# JSON data fields (MediaBody): albumId, artist, duration (ms), imagUrl, name = title,
# state (1 play, 0 pause, 2 stop), title = album, type = 13, uniqueId.
# The dock card loads imagUrl with Glide, so the cover is served as a content:// URL by
# CoverProvider; the bitmap extra (200 px JPEG) is what the cluster shows.
# Only announces while the player plays, plus one "paused" update, so it never takes over the
# source from the car's radio / Bluetooth while idle. Off when LP Music is disabled.
# See FINDINGS.md.

.field private final ctx:Landroid/content/Context;
.field private final handler:Landroid/os/Handler;
.field private last:Ljava/lang/String;
.field private lastPlaying:Z
# number of quick 0.5 s ticks left after a car command (see kick)
.field private fastLeft:I
.field private static sInstance:Luz/carhelper/passenger/MiguBridge;

.method public constructor <init>(Landroid/content/Context;Landroid/os/Handler;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/MiguBridge;->ctx:Landroid/content/Context;
    iput-object p2, p0, Luz/carhelper/passenger/MiguBridge;->handler:Landroid/os/Handler;
    sput-object p0, Luz/carhelper/passenger/MiguBridge;->sInstance:Luz/carhelper/passenger/MiguBridge;
    return-void
.end method

# After the car's play/pause/next/previous reached the player, re-announce quickly: the car picks
# "pause" or "play" for the next wheel press from the last announced state, so a state that lags
# by up to 1.5 s makes a fast second press do the wrong thing.
.method static kick()V
    .locals 4
    sget-object v0, Luz/carhelper/passenger/MiguBridge;->sInstance:Luz/carhelper/passenger/MiguBridge;
    if-eqz v0, :none
    const/4 v1, 0x4
    iput v1, v0, Luz/carhelper/passenger/MiguBridge;->fastLeft:I
    iget-object v1, v0, Luz/carhelper/passenger/MiguBridge;->handler:Landroid/os/Handler;
    invoke-virtual {v1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V
    const-wide/16 v2, 0xc8
    invoke-virtual {v1, v0, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :none
    return-void
.end method

.method public run()V
    .locals 4
    :try_start_0
    invoke-direct {p0}, Luz/carhelper/passenger/MiguBridge;->tick()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    goto :again
    :catch_0
    move-exception v0
    const-string v1, "LPMigu"
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :again
    iget-object v0, p0, Luz/carhelper/passenger/MiguBridge;->handler:Landroid/os/Handler;
    # keep exactly one pending run
    invoke-virtual {v0, p0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V
    const-wide/16 v1, 0x5dc
    iget v3, p0, Luz/carhelper/passenger/MiguBridge;->fastLeft:I
    if-lez v3, :post
    add-int/lit8 v3, v3, -0x1
    iput v3, p0, Luz/carhelper/passenger/MiguBridge;->fastLeft:I
    const-wide/16 v1, 0x1f4
    :post
    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
.end method

.method private static str(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
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

.method private static jpeg(Landroid/graphics/Bitmap;I)[B
    .locals 2
    new-instance v0, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V
    sget-object v1, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;
    invoke-virtual {p0, v1, p1, v0}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v0
    return-object v0
.end method

# cover for the dock card: 300 px JPEG at <cache>/cover.jpg, served by CoverProvider
.method private static writeCover(Landroid/content/Context;Landroid/graphics/Bitmap;)V
    .locals 5
    :try_start_0
    const/16 v0, 0x12c
    const/4 v1, 0x1
    invoke-static {p1, v0, v0, v1}, Landroid/graphics/Bitmap;->createScaledBitmap(Landroid/graphics/Bitmap;IIZ)Landroid/graphics/Bitmap;
    move-result-object v0
    new-instance v1, Ljava/io/File;
    invoke-virtual {p0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;
    move-result-object v2
    const-string v3, "cover.jpg"
    invoke-direct {v1, v2, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v2, Ljava/io/FileOutputStream;
    invoke-direct {v2, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    sget-object v3, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;
    const/16 v4, 0x55
    invoke-virtual {v0, v3, v4, v2}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void
    :catch_0
    move-exception v0
    const-string v1, "LPMigu"
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

.method private tick()V
    .locals 13
    # LP Music gate: off, or yielding to a playing DiPlay (don't announce type 13 then)
    iget-object v0, p0, Luz/carhelper/passenger/MiguBridge;->ctx:Landroid/content/Context;
    invoke-static {v0}, Luz/carhelper/passenger/MusicGate;->shouldHandle(Landroid/content/Context;)Z
    move-result v1
    if-nez v1, :enabled
    return-void
    :enabled

    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v1
    invoke-static {v1}, Luz/carhelper/passenger/WheelReceiver;->findTarget(Ljava/util/List;)Landroid/media/session/MediaController;
    move-result-object v1
    if-nez v1, :have
    return-void
    :have
    invoke-static {v1}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v2
    if-nez v2, :announce
    iget-boolean v3, p0, Luz/carhelper/passenger/MiguBridge;->lastPlaying:Z
    if-nez v3, :announce
    return-void

    :announce
    # v3 metadata, v4 title, v5 artist, v6 album, v7 duration (ms), v8 cover bitmap or null
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getMetadata()Landroid/media/MediaMetadata;
    move-result-object v3
    const-string v4, "android.media.metadata.TITLE"
    invoke-static {v3, v4}, Luz/carhelper/passenger/MiguBridge;->str(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    const-string v5, "android.media.metadata.ARTIST"
    invoke-static {v3, v5}, Luz/carhelper/passenger/MiguBridge;->str(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    const-string v6, "android.media.metadata.ALBUM"
    invoke-static {v3, v6}, Luz/carhelper/passenger/MiguBridge;->str(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6

    const/4 v7, 0x0
    const/4 v8, 0x0
    if-eqz v3, :art_done
    const-string v9, "android.media.metadata.DURATION"
    invoke-virtual {v3, v9}, Landroid/media/MediaMetadata;->getLong(Ljava/lang/String;)J
    move-result-wide v9
    long-to-int v7, v9
    if-gez v7, :dur_ok
    const/4 v7, 0x0
    :dur_ok
    const-string v9, "android.media.metadata.ALBUM_ART"
    invoke-virtual {v3, v9}, Landroid/media/MediaMetadata;->getBitmap(Ljava/lang/String;)Landroid/graphics/Bitmap;
    move-result-object v8
    if-nez v8, :art_done
    const-string v9, "android.media.metadata.ART"
    invoke-virtual {v3, v9}, Landroid/media/MediaMetadata;->getBitmap(Ljava/lang/String;)Landroid/graphics/Bitmap;
    move-result-object v8
    :art_done

    # v9 = bitmap extra (200 px JPEG, or a 1x1 placeholder), v10 = imagUrl for the dock card
    const-string v10, ""
    if-nez v8, :have_art
    const/4 v9, 0x1
    sget-object v11, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;
    invoke-static {v9, v9, v11}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;
    move-result-object v11
    const/16 v12, 0x50
    invoke-static {v11, v12}, Luz/carhelper/passenger/MiguBridge;->jpeg(Landroid/graphics/Bitmap;I)[B
    move-result-object v9
    goto :art_ready
    :have_art
    const/16 v11, 0xc8
    const/4 v12, 0x1
    invoke-static {v8, v11, v11, v12}, Landroid/graphics/Bitmap;->createScaledBitmap(Landroid/graphics/Bitmap;IIZ)Landroid/graphics/Bitmap;
    move-result-object v11
    const/16 v12, 0x32
    invoke-static {v11, v12}, Luz/carhelper/passenger/MiguBridge;->jpeg(Landroid/graphics/Bitmap;I)[B
    move-result-object v9
    # the URL carries a hash of the cover so a new cover is a new URL (Glide caches by URL)
    invoke-static {v9}, Ljava/util/Arrays;->hashCode([B)I
    move-result v11
    new-instance v12, Ljava/lang/StringBuilder;
    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V
    const-string v10, "content://com.migu.car.music.cover/cover.jpg?v="
    invoke-virtual {v12, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v12, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v10
    :art_ready

    # data = {albumId:null, artist, duration, imagUrl, name:title, state:1|0, title:album, type:13, uniqueId}
    new-instance v11, Lorg/json/JSONObject;
    invoke-direct {v11}, Lorg/json/JSONObject;-><init>()V
    const-string v12, "albumId"
    sget-object v3, Lorg/json/JSONObject;->NULL:Ljava/lang/Object;
    invoke-virtual {v11, v12, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v12, "artist"
    invoke-virtual {v11, v12, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v12, "duration"
    invoke-virtual {v11, v12, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v12, "imagUrl"
    invoke-virtual {v11, v12, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v12, "name"
    invoke-virtual {v11, v12, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v12, "state"
    invoke-virtual {v11, v12, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v12, "title"
    invoke-virtual {v11, v12, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v12, "type"
    const/16 v3, 0xd
    invoke-virtual {v11, v12, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v12, "uniqueId"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v6
    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v6, ":"
    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/String;->hashCode()I
    move-result v6
    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v11, v12, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    # root = {data, detail:{format:"jpeg", length:<bitmap bytes>, offset:0}, type:"music"}
    new-instance v12, Lorg/json/JSONObject;
    invoke-direct {v12}, Lorg/json/JSONObject;-><init>()V
    const-string v3, "data"
    invoke-virtual {v12, v3, v11}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    new-instance v11, Lorg/json/JSONObject;
    invoke-direct {v11}, Lorg/json/JSONObject;-><init>()V
    const-string v3, "format"
    const-string v6, "jpeg"
    invoke-virtual {v11, v3, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v3, "length"
    array-length v6, v9
    invoke-virtual {v11, v3, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v3, "offset"
    const/4 v6, 0x0
    invoke-virtual {v11, v3, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v3, "detail"
    invoke-virtual {v12, v3, v11}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v3, "type"
    const-string v6, "music"
    invoke-virtual {v12, v3, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    invoke-virtual {v12}, Lorg/json/JSONObject;->toString()Ljava/lang/String;
    move-result-object v12

    # only send when something changed
    iget-object v3, p0, Luz/carhelper/passenger/MiguBridge;->last:Ljava/lang/String;
    invoke-virtual {v12, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :send
    return-void
    :send
    iput-object v12, p0, Luz/carhelper/passenger/MiguBridge;->last:Ljava/lang/String;
    iput-boolean v2, p0, Luz/carhelper/passenger/MiguBridge;->lastPlaying:Z

    # the dock card cover must exist before the car reads imagUrl
    if-eqz v8, :no_file
    invoke-static {v0, v8}, Luz/carhelper/passenger/MiguBridge;->writeCover(Landroid/content/Context;Landroid/graphics/Bitmap;)V
    :no_file

    new-instance v3, Landroid/content/Intent;
    const-string v6, "com.leapmotor.transfer.MEDIA.INFO"
    invoke-direct {v3, v6}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v6, "info"
    invoke-virtual {v3, v6, v12}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
    const-string v6, "bitmap"
    invoke-virtual {v3, v6, v9}, Landroid/content/Intent;->putExtra(Ljava/lang/String;[B)Landroid/content/Intent;
    const/high16 v6, 0x11000000
    invoke-virtual {v3, v6}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    invoke-virtual {v0, v3}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    const-string v6, "LPMigu"
    invoke-static {v6, v12}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

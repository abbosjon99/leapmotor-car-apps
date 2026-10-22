.class public Luz/carhelper/passenger/MiguBridge;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# "Act as Migu": every 1.5 s, announce the active sideloaded player to the car's media app as
# Migu (media type 13) with the broadcast it uses for third-party players:
#   com.leapmotor.transfer.MEDIA.INFO  extras: info = NotifyOutBean JSON, bitmap = cover JPEG
# The car then makes type 13 its current source, shows the song, and routes the steering-wheel
# buttons as METER.CTRL / VOICE.CTRL broadcasts (handled by MiguCtrlReceiver) instead of
# resuming its own player. Only announces while the player plays, plus one "paused" update,
# so it never takes over the source from the car's radio / Bluetooth while idle.
# Off when the "wheel" setting is off.

.field private final ctx:Landroid/content/Context;
.field private final handler:Landroid/os/Handler;
.field private last:Ljava/lang/String;
.field private lastPlaying:Z

.method public constructor <init>(Landroid/content/Context;Landroid/os/Handler;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/MiguBridge;->ctx:Landroid/content/Context;
    iput-object p2, p0, Luz/carhelper/passenger/MiguBridge;->handler:Landroid/os/Handler;
    return-void
.end method

.method public run()V
    .locals 3
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
    const-wide/16 v1, 0x5dc
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

.method private tick()V
    .locals 12
    # enabled? (same switch as the wheel buttons, default on)
    iget-object v0, p0, Luz/carhelper/passenger/MiguBridge;->ctx:Landroid/content/Context;
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    const-string v2, "wheel"
    const/4 v3, 0x1
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
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

    # data = {albumId:null, artist, duration:0, imagUrl:"", name:title, state:1|0, title:album, type:13, uniqueId}
    new-instance v7, Lorg/json/JSONObject;
    invoke-direct {v7}, Lorg/json/JSONObject;-><init>()V
    const-string v8, "albumId"
    sget-object v9, Lorg/json/JSONObject;->NULL:Ljava/lang/Object;
    invoke-virtual {v7, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v8, "artist"
    invoke-virtual {v7, v8, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v8, "duration"
    const/4 v9, 0x0
    invoke-virtual {v7, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v8, "imagUrl"
    const-string v9, ""
    invoke-virtual {v7, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v8, "name"
    invoke-virtual {v7, v8, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v8, "state"
    invoke-virtual {v7, v8, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v8, "title"
    invoke-virtual {v7, v8, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v8, "type"
    const/16 v9, 0xd
    invoke-virtual {v7, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v8, "uniqueId"
    new-instance v9, Ljava/lang/StringBuilder;
    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v1}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v10
    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v10, ":"
    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/String;->hashCode()I
    move-result v10
    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v9
    invoke-virtual {v7, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    # root = {data, detail:{format:null, length:0, offset:0}, type:"music"}
    new-instance v8, Lorg/json/JSONObject;
    invoke-direct {v8}, Lorg/json/JSONObject;-><init>()V
    const-string v9, "data"
    invoke-virtual {v8, v9, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    new-instance v7, Lorg/json/JSONObject;
    invoke-direct {v7}, Lorg/json/JSONObject;-><init>()V
    const-string v9, "format"
    sget-object v10, Lorg/json/JSONObject;->NULL:Ljava/lang/Object;
    invoke-virtual {v7, v9, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v9, "length"
    const/4 v10, 0x0
    invoke-virtual {v7, v9, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v9, "offset"
    invoke-virtual {v7, v9, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v9, "detail"
    invoke-virtual {v8, v9, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v9, "type"
    const-string v10, "music"
    invoke-virtual {v8, v9, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    invoke-virtual {v8}, Lorg/json/JSONObject;->toString()Ljava/lang/String;
    move-result-object v8

    # only send when something changed
    iget-object v9, p0, Luz/carhelper/passenger/MiguBridge;->last:Ljava/lang/String;
    invoke-virtual {v8, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v9
    if-eqz v9, :send
    return-void
    :send
    iput-object v8, p0, Luz/carhelper/passenger/MiguBridge;->last:Ljava/lang/String;
    iput-boolean v2, p0, Luz/carhelper/passenger/MiguBridge;->lastPlaying:Z

    # cover: album art scaled to 200 px, or a 1x1 placeholder
    const/4 v9, 0x0
    if-eqz v3, :no_art
    const-string v10, "android.media.metadata.ALBUM_ART"
    invoke-virtual {v3, v10}, Landroid/media/MediaMetadata;->getBitmap(Ljava/lang/String;)Landroid/graphics/Bitmap;
    move-result-object v9
    if-nez v9, :have_art
    const-string v10, "android.media.metadata.ART"
    invoke-virtual {v3, v10}, Landroid/media/MediaMetadata;->getBitmap(Ljava/lang/String;)Landroid/graphics/Bitmap;
    move-result-object v9
    if-eqz v9, :no_art
    :have_art
    const/16 v10, 0xc8
    const/4 v11, 0x1
    invoke-static {v9, v10, v10, v11}, Landroid/graphics/Bitmap;->createScaledBitmap(Landroid/graphics/Bitmap;IIZ)Landroid/graphics/Bitmap;
    move-result-object v9
    goto :encode
    :no_art
    const/4 v10, 0x1
    sget-object v11, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;
    invoke-static {v10, v10, v11}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;
    move-result-object v9
    :encode
    new-instance v10, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v10}, Ljava/io/ByteArrayOutputStream;-><init>()V
    sget-object v11, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;
    const/16 v3, 0x50
    invoke-virtual {v9, v11, v3, v10}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z
    invoke-virtual {v10}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v10

    new-instance v9, Landroid/content/Intent;
    const-string v11, "com.leapmotor.transfer.MEDIA.INFO"
    invoke-direct {v9, v11}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v11, "info"
    invoke-virtual {v9, v11, v8}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
    const-string v11, "bitmap"
    invoke-virtual {v9, v11, v10}, Landroid/content/Intent;->putExtra(Ljava/lang/String;[B)Landroid/content/Intent;
    const/high16 v11, 0x11000000
    invoke-virtual {v9, v11}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    invoke-virtual {v0, v9}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    const-string v11, "LPMigu"
    invoke-static {v11, v8}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

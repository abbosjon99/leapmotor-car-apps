.class public final Luz/carhelper/passenger/apk/AdbLink;
.super Ljava/lang/Object;
.source "AdbLink.java"


# static fields
.field public static final HOST:Ljava/lang/String; = "127.0.0.1"

.field public static final PORT:I = 0x15b3

.field private static final TAG:Ljava/lang/String; = "LPCompanion"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static ensure(Landroid/content/Context;Ljava/lang/String;IZ)Z
    .locals 8

    .line 26
    const-string v0, "development_settings_enabled"

    const-string v1, "adb_enabled"

    const-string v2, "LPCompanion"

    .line 0
    const-string v3, "adb_enabled is on but nothing listens on "

    const-string v4, "adb is not listening on "

    const/16 v5, 0x258

    .line 26
    invoke-static {p1, p2, v5}, Luz/carhelper/passenger/adb/AdbRunner;->listening(Ljava/lang/String;II)Z

    move-result v5

    const/4 v6, 0x1

    if-eqz v5, :cond_0

    return v6

    :cond_0
    const/4 v5, 0x0

    if-nez p3, :cond_1

    return v5

    .line 33
    :cond_1
    :try_start_0
    const-string p3, "android.permission.WRITE_SECURE_SETTINGS"

    invoke-virtual {p0, p3}, Landroid/content/Context;->checkSelfPermission(Ljava/lang/String;)I

    move-result p3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const-string v7, ":"

    if-eqz p3, :cond_2

    .line 34
    :try_start_1
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " and WRITE_SECURE_SETTINGS is not granted"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return v5

    .line 37
    :cond_2
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    .line 38
    invoke-static {p0, v1, v5}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p3

    if-nez p3, :cond_3

    .line 39
    invoke-static {p0, v1, v6}, Landroid/provider/Settings$Global;->putInt(Landroid/content/ContentResolver;Ljava/lang/String;I)Z

    .line 40
    const-string p3, "adb_enabled was off: switched on"

    invoke-static {v2, p3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 42
    :cond_3
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-static {v2, p3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    const/16 p3, 0x1f40

    .line 44
    invoke-static {p1, p2, p3}, Luz/carhelper/passenger/apk/AdbLink;->waitListening(Ljava/lang/String;II)Z

    move-result p3

    if-eqz p3, :cond_4

    return v6

    .line 47
    :cond_4
    invoke-static {p0, v0, v5}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p3

    if-nez p3, :cond_5

    .line 48
    invoke-static {p0, v0, v6}, Landroid/provider/Settings$Global;->putInt(Landroid/content/ContentResolver;Ljava/lang/String;I)Z

    .line 49
    const-string p0, "development_settings_enabled was off: switched on"

    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/16 p0, 0x1770

    .line 50
    invoke-static {p1, p2, p0}, Luz/carhelper/passenger/apk/AdbLink;->waitListening(Ljava/lang/String;II)Z

    move-result p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    return p0

    :catchall_0
    move-exception p0

    .line 53
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "could not switch adb on: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_5
    return v5
.end method

.method private static waitListening(Ljava/lang/String;II)Z
    .locals 5

    .line 59
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    int-to-long v2, p2

    add-long/2addr v0, v2

    .line 60
    :goto_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    cmp-long p2, v2, v0

    const/4 v2, 0x0

    if-gez p2, :cond_1

    const/16 p2, 0x190

    .line 61
    invoke-static {p0, p1, p2}, Luz/carhelper/passenger/adb/AdbRunner;->listening(Ljava/lang/String;II)Z

    move-result p2

    if-eqz p2, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const-wide/16 v3, 0x1f4

    .line 65
    :try_start_0
    invoke-static {v3, v4}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    :cond_1
    return v2
.end method

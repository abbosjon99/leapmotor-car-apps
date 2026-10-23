.class public final Luz/carhelper/passenger/adb/AdbRunner;
.super Ljava/lang/Object;
.source "AdbRunner.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static allowed(Ljava/lang/String;)Z
    .locals 1

    if-eqz p0, :cond_1

    .line 32
    const-string v0, "pm grant --user \\d+ [A-Za-z0-9_.]+ android\\.permission\\.[A-Z_]+"

    .line 33
    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "appops set --user \\d+ [A-Za-z0-9_.]+ [A-Z_]+ (allow|ignore|deny|default)"

    .line 34
    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "cmd notification allow_listener [A-Za-z0-9_.$]+/[A-Za-z0-9_.$]+ \\d+"

    .line 35
    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_1

    :cond_0
    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method static failed(Ljava/lang/String;)Z
    .locals 1

    .line 40
    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    .line 41
    const-string v0, "exception"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "error"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "unknown"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "failure"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "not found"

    .line 42
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "denied"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method public static installApk(Ljava/lang/String;Ljava/lang/String;ILjava/io/File;ZILuz/carhelper/passenger/adb/AdbProgress;)Ljava/lang/String;
    .locals 13

    move-object/from16 v0, p3

    const-string v1, "OK|"

    const-string v2, "FAIL|"

    const-string v3, "cmd package install -S "

    if-eqz v0, :cond_10

    .line 58
    invoke-virtual/range {p3 .. p3}, Ljava/io/File;->isFile()Z

    move-result v4

    if-eqz v4, :cond_10

    invoke-virtual/range {p3 .. p3}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v4

    const-string v5, ".apk"

    invoke-virtual {v4, v5}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_0

    goto/16 :goto_6

    .line 61
    :cond_0
    invoke-virtual/range {p3 .. p3}, Ljava/io/File;->length()J

    move-result-wide v8

    const-wide/16 v4, 0x3e8

    cmp-long v4, v8, v4

    if-ltz v4, :cond_f

    const-wide/32 v4, 0x77359400

    cmp-long v4, v8, v4

    if-lez v4, :cond_1

    goto/16 :goto_5

    :cond_1
    const/4 v4, 0x0

    .line 68
    :try_start_0
    new-instance v5, Ljava/io/FileInputStream;

    invoke-direct {v5, v0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_0 .. :try_end_0} :catch_6
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    const/4 v6, 0x4

    .line 69
    :try_start_1
    new-array v7, v6, [B

    .line 70
    invoke-virtual {v5, v7}, Ljava/io/InputStream;->read([B)I

    move-result v10

    if-ne v10, v6, :cond_8

    const/4 v10, 0x0

    aget-byte v10, v7, v10

    const/16 v11, 0x50

    if-ne v10, v11, :cond_8

    const/4 v10, 0x1

    aget-byte v10, v7, v10

    const/16 v11, 0x4b

    if-ne v10, v11, :cond_8

    const/4 v10, 0x2

    aget-byte v10, v7, v10

    const/4 v11, 0x3

    if-ne v10, v11, :cond_8

    aget-byte v7, v7, v11

    if-eq v7, v6, :cond_2

    goto/16 :goto_1

    .line 73
    :cond_2
    invoke-virtual {v5}, Ljava/io/InputStream;->close()V

    .line 74
    new-instance v12, Ljava/io/FileInputStream;

    invoke-direct {v12, v0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_1
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_1 .. :try_end_1} :catch_4
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 75
    :try_start_2
    new-instance v0, Ljava/io/File;

    move-object v5, p0

    invoke-direct {v0, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-static {v0}, Luz/carhelper/passenger/adb/AdbKey;->load(Ljava/io/File;)Luz/carhelper/passenger/adb/AdbKey;

    move-result-object v0

    move/from16 v5, p5

    mul-int/lit16 v5, v5, 0x3e8

    const/16 v6, 0xfa0

    move-object v7, p1

    move v10, p2

    .line 76
    invoke-static {p1, p2, v0, v6, v5}, Luz/carhelper/passenger/adb/AdbConnection;->open(Ljava/lang/String;ILuz/carhelper/passenger/adb/AdbKey;II)Luz/carhelper/passenger/adb/AdbConnection;

    move-result-object v4

    .line 77
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v8, v9}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v3, " --install-reason 64 -r"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p4, :cond_3

    const-string v3, " -g"

    goto :goto_0

    :cond_3
    const-string v3, ""

    :goto_0
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    const v11, 0x3a980

    move-object v5, v4

    move-object v7, v12

    move-object/from16 v10, p6

    .line 78
    invoke-virtual/range {v5 .. v11}, Luz/carhelper/passenger/adb/AdbConnection;->exec(Ljava/lang/String;Ljava/io/InputStream;JLuz/carhelper/passenger/adb/AdbProgress;I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 79
    const-string v3, "Success"

    invoke-virtual {v0, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_5

    const-string v3, "Failure"

    invoke-virtual {v0, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_5

    .line 80
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_2
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_2 .. :try_end_2} :catch_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 90
    :try_start_3
    invoke-virtual {v12}, Ljava/io/InputStream;->close()V
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_0

    :catch_0
    if-eqz v4, :cond_4

    .line 95
    invoke-virtual {v4}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_4
    return-object v0

    .line 82
    :cond_5
    :try_start_4
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v3

    if-nez v3, :cond_6

    const-string v0, "the installer printed nothing"

    :cond_6
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_4
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_4 .. :try_end_4} :catch_2
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 90
    :try_start_5
    invoke-virtual {v12}, Ljava/io/InputStream;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_1

    :catch_1
    if-eqz v4, :cond_7

    .line 95
    invoke-virtual {v4}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_7
    return-object v0

    :catchall_0
    move-exception v0

    move-object v1, v4

    move-object v4, v12

    goto :goto_2

    :catch_2
    move-exception v0

    goto :goto_3

    .line 71
    :cond_8
    :goto_1
    :try_start_6
    const-string v0, "FAIL|not an APK (no zip header)"
    :try_end_6
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_6 .. :try_end_6} :catch_4
    .catchall {:try_start_6 .. :try_end_6} :catchall_1

    .line 90
    :try_start_7
    invoke-virtual {v5}, Ljava/io/InputStream;->close()V
    :try_end_7
    .catch Ljava/io/IOException; {:try_start_7 .. :try_end_7} :catch_3

    :catch_3
    return-object v0

    :catchall_1
    move-exception v0

    move-object v1, v4

    move-object v4, v5

    goto :goto_2

    :catch_4
    move-exception v0

    move-object v12, v5

    goto :goto_3

    :catchall_2
    move-exception v0

    move-object v1, v4

    .line 86
    :goto_2
    :try_start_8
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_3

    if-eqz v4, :cond_9

    .line 90
    :try_start_9
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V
    :try_end_9
    .catch Ljava/io/IOException; {:try_start_9 .. :try_end_9} :catch_5

    :catch_5
    :cond_9
    if-eqz v1, :cond_a

    .line 95
    invoke-virtual {v1}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_a
    return-object v0

    :catchall_3
    move-exception v0

    goto :goto_4

    :catch_6
    move-exception v0

    move-object v12, v4

    .line 84
    :goto_3
    :try_start_a
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, v0, Luz/carhelper/passenger/adb/AdbException;->code:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "|"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Luz/carhelper/passenger/adb/AdbException;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_a
    .catchall {:try_start_a .. :try_end_a} :catchall_4

    if-eqz v12, :cond_b

    .line 90
    :try_start_b
    invoke-virtual {v12}, Ljava/io/InputStream;->close()V
    :try_end_b
    .catch Ljava/io/IOException; {:try_start_b .. :try_end_b} :catch_7

    :catch_7
    :cond_b
    if-eqz v4, :cond_c

    .line 95
    invoke-virtual {v4}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_c
    return-object v0

    :catchall_4
    move-exception v0

    move-object v1, v4

    move-object v4, v12

    :goto_4
    if-eqz v4, :cond_d

    .line 90
    :try_start_c
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V
    :try_end_c
    .catch Ljava/io/IOException; {:try_start_c .. :try_end_c} :catch_8

    :catch_8
    :cond_d
    if-eqz v1, :cond_e

    .line 95
    invoke-virtual {v1}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    .line 97
    :cond_e
    throw v0

    .line 63
    :cond_f
    :goto_5
    const-string v0, "FAIL|the file size is not valid for an APK"

    return-object v0

    .line 59
    :cond_10
    :goto_6
    const-string v0, "FAIL|not an .apk file"

    return-object v0
.end method

.method public static listening(Ljava/lang/String;II)Z
    .locals 2

    .line 16
    new-instance v0, Ljava/net/Socket;

    invoke-direct {v0}, Ljava/net/Socket;-><init>()V

    .line 18
    :try_start_0
    new-instance v1, Ljava/net/InetSocketAddress;

    invoke-direct {v1, p0, p1}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;I)V

    invoke-virtual {v0, v1, p2}, Ljava/net/Socket;->connect(Ljava/net/SocketAddress;I)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 24
    :try_start_1
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    :catch_0
    const/4 p0, 0x1

    return p0

    :catchall_0
    move-exception p0

    :try_start_2
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_1

    .line 27
    :catch_1
    throw p0

    .line 24
    :catch_2
    :try_start_3
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_3

    :catch_3
    const/4 p0, 0x0

    return p0
.end method

.method public static run(Ljava/lang/String;Ljava/lang/String;I[Ljava/lang/String;I)Ljava/lang/String;
    .locals 4

    .line 130
    const-string v0, "FAIL|"

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    array-length v3, p3

    if-ge v2, v3, :cond_1

    .line 131
    aget-object v3, p3, v2

    invoke-static {v3}, Luz/carhelper/passenger/adb/AdbRunner;->allowed(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_0

    .line 132
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p1, "FAIL|command not allowed: "

    invoke-direct {p0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    aget-object p1, p3, v2

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    const/4 v2, 0x0

    .line 137
    :try_start_0
    new-instance v3, Ljava/io/File;

    invoke-direct {v3, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-static {v3}, Luz/carhelper/passenger/adb/AdbKey;->load(Ljava/io/File;)Luz/carhelper/passenger/adb/AdbKey;

    move-result-object p0

    mul-int/lit16 p4, p4, 0x3e8

    const/16 v3, 0xfa0

    .line 138
    invoke-static {p1, p2, p0, v3, p4}, Luz/carhelper/passenger/adb/AdbConnection;->open(Ljava/lang/String;ILuz/carhelper/passenger/adb/AdbKey;II)Luz/carhelper/passenger/adb/AdbConnection;

    move-result-object v2

    .line 139
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    .line 140
    :goto_1
    array-length p1, p3

    if-ge v1, p1, :cond_5

    .line 141
    aget-object p1, p3, v1

    const/16 p2, 0x3a98

    invoke-virtual {v2, p1, p2}, Luz/carhelper/passenger/adb/AdbConnection;->shell(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 142
    invoke-static {p1}, Luz/carhelper/passenger/adb/AdbRunner;->failed(Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_3

    .line 143
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object p2, p3, v1

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " -> "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v2, :cond_2

    .line 157
    invoke-virtual {v2}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_2
    return-object p0

    .line 145
    :cond_3
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->length()I

    move-result p1

    if-lez p1, :cond_4

    .line 146
    const-string p1, "; "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 148
    :cond_4
    aget-object p1, p3, v1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 150
    :cond_5
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "OK|"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_1
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz v2, :cond_6

    .line 157
    invoke-virtual {v2}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_6
    return-object p0

    :catchall_0
    move-exception p0

    .line 154
    :try_start_2
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    if-eqz v2, :cond_7

    .line 157
    invoke-virtual {v2}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_7
    return-object p0

    :catch_0
    move-exception p0

    .line 152
    :try_start_3
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object p2, p0, Luz/carhelper/passenger/adb/AdbException;->code:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, "|"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Luz/carhelper/passenger/adb/AdbException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    if-eqz v2, :cond_8

    .line 157
    invoke-virtual {v2}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_8
    return-object p0

    :catchall_1
    move-exception p0

    if-eqz v2, :cond_9

    invoke-virtual {v2}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    .line 159
    :cond_9
    throw p0
.end method

.method public static uninstallPackage(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;I)Ljava/lang/String;
    .locals 5

    const-string v0, "OK|"

    const-string v1, "FAIL|"

    const-string v2, "pm uninstall "

    .line 102
    invoke-static {p3}, Luz/carhelper/passenger/adb/AdbRunner;->validPackage(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_0

    .line 103
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p1, "FAIL|not a package name: "

    invoke-direct {p0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 v3, 0x0

    .line 107
    :try_start_0
    new-instance v4, Ljava/io/File;

    invoke-direct {v4, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-static {v4}, Luz/carhelper/passenger/adb/AdbKey;->load(Ljava/io/File;)Luz/carhelper/passenger/adb/AdbKey;

    move-result-object p0

    mul-int/lit16 p4, p4, 0x3e8

    const/16 v4, 0xfa0

    .line 108
    invoke-static {p1, p2, p0, v4, p4}, Luz/carhelper/passenger/adb/AdbConnection;->open(Ljava/lang/String;ILuz/carhelper/passenger/adb/AdbKey;II)Luz/carhelper/passenger/adb/AdbConnection;

    move-result-object v3

    .line 109
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const p1, 0xea60

    invoke-virtual {v3, p0, p1}, Luz/carhelper/passenger/adb/AdbConnection;->shell(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 110
    const-string p1, "Success"

    invoke-virtual {p0, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p1

    if-eqz p1, :cond_2

    const-string p1, "Failure"

    invoke-virtual {p0, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p1

    if-nez p1, :cond_2

    .line 111
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v3, :cond_1

    .line 120
    invoke-virtual {v3}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_1
    return-object p0

    .line 113
    :cond_2
    :try_start_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p2

    if-nez p2, :cond_3

    const-string p0, "the uninstaller printed nothing"

    :cond_3
    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_1
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz v3, :cond_4

    .line 120
    invoke-virtual {v3}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_4
    return-object p0

    :catchall_0
    move-exception p0

    .line 117
    :try_start_2
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    if-eqz v3, :cond_5

    .line 120
    invoke-virtual {v3}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_5
    return-object p0

    :catch_0
    move-exception p0

    .line 115
    :try_start_3
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object p2, p0, Luz/carhelper/passenger/adb/AdbException;->code:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, "|"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Luz/carhelper/passenger/adb/AdbException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    if-eqz v3, :cond_6

    .line 120
    invoke-virtual {v3}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    :cond_6
    return-object p0

    :catchall_1
    move-exception p0

    if-eqz v3, :cond_7

    invoke-virtual {v3}, Luz/carhelper/passenger/adb/AdbConnection;->close()V

    .line 122
    :cond_7
    throw p0
.end method

.method public static validPackage(Ljava/lang/String;)Z
    .locals 2

    if-eqz p0, :cond_0

    .line 47
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0xc8

    if-gt v0, v1, :cond_0

    const-string v0, "[A-Za-z][A-Za-z0-9_]*(\\.[A-Za-z0-9_]+)+"

    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

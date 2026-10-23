.class final Luz/carhelper/passenger/adb/AdbConnection;
.super Ljava/lang/Object;
.source "AdbConnection.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Luz/carhelper/passenger/adb/AdbConnection$Msg;
    }
.end annotation


# static fields
.field static final AUTH_RSAPUBLICKEY:I = 0x3

.field static final AUTH_SIGNATURE:I = 0x2

.field static final AUTH_TOKEN:I = 0x1

.field static final A_AUTH:I = 0x48545541

.field static final A_CLSE:I = 0x45534c43

.field static final A_CNXN:I = 0x4e584e43

.field static final A_OKAY:I = 0x59414b4f

.field static final A_OPEN:I = 0x4e45504f

.field static final A_STLS:I = 0x534c5453

.field static final A_WRTE:I = 0x45545257

.field private static final MAX_MESSAGE:I = 0x100000

.field private static final MAX_PAYLOAD:I = 0x40000

.field private static final VERSION:I = 0x1000001


# instance fields
.field private final in:Ljava/io/InputStream;

.field private maxData:I

.field private nextId:I

.field private final out:Ljava/io/OutputStream;

.field private final socket:Ljava/net/Socket;


# direct methods
.method private constructor <init>(Ljava/net/Socket;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 44
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    .line 40
    iput v0, p0, Luz/carhelper/passenger/adb/AdbConnection;->nextId:I

    const/16 v0, 0x1000

    .line 42
    iput v0, p0, Luz/carhelper/passenger/adb/AdbConnection;->maxData:I

    .line 45
    iput-object p1, p0, Luz/carhelper/passenger/adb/AdbConnection;->socket:Ljava/net/Socket;

    .line 46
    invoke-virtual {p1}, Ljava/net/Socket;->getInputStream()Ljava/io/InputStream;

    move-result-object v0

    iput-object v0, p0, Luz/carhelper/passenger/adb/AdbConnection;->in:Ljava/io/InputStream;

    .line 47
    invoke-virtual {p1}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object p1

    iput-object p1, p0, Luz/carhelper/passenger/adb/AdbConnection;->out:Ljava/io/OutputStream;

    return-void
.end method

.method private static closeQuietly(Ljava/net/Socket;)V
    .locals 0

    .line 263
    :try_start_0
    invoke-virtual {p0}, Ljava/net/Socket;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method

.method private handshake(Luz/carhelper/passenger/adb/AdbKey;I)V
    .locals 13
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Luz/carhelper/passenger/adb/AdbException;,
            Ljava/io/IOException;
        }
    .end annotation

    .line 83
    const-string v0, "AUTH"

    const-string v1, "FAIL"

    iget v2, p1, Luz/carhelper/passenger/adb/AdbKey;->sigHint:I

    iget v3, p1, Luz/carhelper/passenger/adb/AdbKey;->sigHint:I

    const/4 v4, 0x1

    rsub-int/lit8 v3, v3, 0x1

    filled-new-array {v2, v3}, [I

    move-result-object v2

    .line 84
    iget v3, p1, Luz/carhelper/passenger/adb/AdbKey;->keyHint:I

    iget v5, p1, Luz/carhelper/passenger/adb/AdbKey;->keyHint:I

    rsub-int/lit8 v5, v5, 0x1

    filled-new-array {v3, v5}, [I

    move-result-object v3

    const/4 v5, 0x0

    .line 89
    :try_start_0
    const-string v6, "host::\u0000"

    const-string v7, "US-ASCII"

    invoke-virtual {v6, v7}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v6

    const v7, 0x4e584e43    # 9.072519E8f

    const v8, 0x1000001

    const/high16 v9, 0x40000

    invoke-direct {p0, v7, v8, v9, v6}, Luz/carhelper/passenger/adb/AdbConnection;->send(III[B)V
    :try_end_0
    .catch Ljava/net/SocketTimeoutException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move v6, v5

    move v8, v6

    move v9, v8

    .line 91
    :goto_0
    :try_start_1
    invoke-direct {p0}, Luz/carhelper/passenger/adb/AdbConnection;->read()Luz/carhelper/passenger/adb/AdbConnection$Msg;

    move-result-object v10

    .line 92
    iget v11, v10, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    if-ne v11, v7, :cond_3

    .line 93
    iget p2, v10, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg1:I

    const/16 v7, 0x1000

    if-lt p2, v7, :cond_0

    .line 94
    iget p2, v10, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg1:I

    const/high16 v7, 0x10000

    invoke-static {p2, v7}, Ljava/lang/Math;->min(II)I

    move-result p2

    iput p2, p0, Luz/carhelper/passenger/adb/AdbConnection;->maxData:I

    :cond_0
    if-eqz v9, :cond_1

    .line 97
    iget p2, p1, Luz/carhelper/passenger/adb/AdbKey;->sigHint:I

    add-int/lit8 v2, v8, -0x1

    aget v2, v3, v2

    invoke-virtual {p1, p2, v2}, Luz/carhelper/passenger/adb/AdbKey;->remember(II)V

    goto :goto_1

    :cond_1
    if-lez v6, :cond_2

    sub-int/2addr v6, v4

    .line 99
    aget p2, v2, v6

    iget v2, p1, Luz/carhelper/passenger/adb/AdbKey;->keyHint:I

    invoke-virtual {p1, p2, v2}, Luz/carhelper/passenger/adb/AdbKey;->remember(II)V

    :cond_2
    :goto_1
    return-void

    .line 103
    :cond_3
    iget v9, v10, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    const v11, 0x534c5453

    if-eq v9, v11, :cond_8

    .line 107
    iget v9, v10, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    const v11, 0x48545541

    if-ne v9, v11, :cond_7

    iget v9, v10, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg0:I

    if-ne v9, v4, :cond_7

    const/4 v9, 0x2

    if-ge v6, v9, :cond_4

    .line 109
    iget-object v10, v10, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    aget v12, v2, v6

    invoke-virtual {p1, v10, v12}, Luz/carhelper/passenger/adb/AdbKey;->signToken([BI)[B

    move-result-object v10

    invoke-direct {p0, v11, v9, v5, v10}, Luz/carhelper/passenger/adb/AdbConnection;->send(III[B)V

    add-int/lit8 v6, v6, 0x1

    move v9, v5

    goto :goto_0

    :cond_4
    if-ge v8, v9, :cond_6

    .line 113
    const-string v9, "lp-companion@car"

    aget v10, v3, v8

    if-ne v10, v4, :cond_5

    move v10, v4

    goto :goto_2

    :cond_5
    move v10, v5

    :goto_2
    invoke-virtual {p1, v9, v10}, Luz/carhelper/passenger/adb/AdbKey;->adbPublicKey(Ljava/lang/String;Z)[B

    move-result-object v9

    const/4 v10, 0x3

    invoke-direct {p0, v11, v10, v5, v9}, Luz/carhelper/passenger/adb/AdbConnection;->send(III[B)V

    add-int/lit8 v8, v8, 0x1

    .line 116
    iget-object v9, p0, Luz/carhelper/passenger/adb/AdbConnection;->socket:Ljava/net/Socket;

    invoke-virtual {v9, p2}, Ljava/net/Socket;->setSoTimeout(I)V

    move v9, v4

    goto :goto_0

    .line 118
    :cond_6
    new-instance p1, Luz/carhelper/passenger/adb/AdbException;

    const-string p2, "the car did not accept this app\'s key"

    invoke-direct {p1, v0, p2}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p1

    .line 121
    :cond_7
    new-instance p1, Luz/carhelper/passenger/adb/AdbException;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "unexpected adb message 0x"

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v10, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    invoke-static {v2}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p1, v1, p2}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p1

    .line 104
    :cond_8
    new-instance p1, Luz/carhelper/passenger/adb/AdbException;

    const-string p2, "TLS"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "the car\'s adbd wants a TLS connection (wireless-debugging mode); classic network adb on port "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Luz/carhelper/passenger/adb/AdbConnection;->socket:Ljava/net/Socket;

    .line 105
    invoke-virtual {v3}, Ljava/net/Socket;->getPort()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " is needed"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p1, p2, v2}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catch Ljava/net/SocketTimeoutException; {:try_start_1 .. :try_end_1} :catch_4
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_1 .. :try_end_1} :catch_2
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    :catch_0
    move-exception p1

    .line 135
    new-instance p2, Luz/carhelper/passenger/adb/AdbException;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "adb handshake failed: "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p2, v1, p1}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p2

    :catch_1
    move-exception p1

    .line 133
    throw p1

    :catch_2
    move-exception p1

    .line 131
    throw p1

    :catch_3
    move v8, v5

    :catch_4
    if-lez v8, :cond_9

    goto :goto_3

    :cond_9
    move v4, v5

    :goto_3
    if-eqz v4, :cond_a

    .line 127
    new-instance p1, Luz/carhelper/passenger/adb/AdbException;

    const-string p2, "the key was not approved on the car\'s screen in time"

    invoke-direct {p1, v0, p2}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p1

    .line 129
    :cond_a
    new-instance p1, Luz/carhelper/passenger/adb/AdbException;

    const-string p2, "adb did not answer"

    invoke-direct {p1, v1, p2}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p1
.end method

.method static open(Ljava/lang/String;ILuz/carhelper/passenger/adb/AdbKey;II)Luz/carhelper/passenger/adb/AdbConnection;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Luz/carhelper/passenger/adb/AdbException;
        }
    .end annotation

    .line 55
    new-instance v0, Ljava/net/Socket;

    invoke-direct {v0}, Ljava/net/Socket;-><init>()V

    .line 57
    :try_start_0
    new-instance v1, Ljava/net/InetSocketAddress;

    invoke-direct {v1, p0, p1}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;I)V

    invoke-virtual {v0, v1, p3}, Ljava/net/Socket;->connect(Ljava/net/SocketAddress;I)V

    const/4 p3, 0x1

    .line 58
    invoke-virtual {v0, p3}, Ljava/net/Socket;->setTcpNoDelay(Z)V

    const/16 p3, 0x2710

    .line 59
    invoke-virtual {v0, p3}, Ljava/net/Socket;->setSoTimeout(I)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2

    .line 65
    :try_start_1
    new-instance p0, Luz/carhelper/passenger/adb/AdbConnection;

    invoke-direct {p0, v0}, Luz/carhelper/passenger/adb/AdbConnection;-><init>(Ljava/net/Socket;)V

    .line 66
    invoke-direct {p0, p2, p4}, Luz/carhelper/passenger/adb/AdbConnection;->handshake(Luz/carhelper/passenger/adb/AdbKey;I)V
    :try_end_1
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 72
    invoke-static {v0}, Luz/carhelper/passenger/adb/AdbConnection;->closeQuietly(Ljava/net/Socket;)V

    .line 73
    new-instance p1, Luz/carhelper/passenger/adb/AdbException;

    new-instance p2, Ljava/lang/StringBuilder;

    const-string p3, "adb connection failed: "

    invoke-direct {p2, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p2, "FAIL"

    invoke-direct {p1, p2, p0}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p1

    :catch_1
    move-exception p0

    .line 69
    invoke-static {v0}, Luz/carhelper/passenger/adb/AdbConnection;->closeQuietly(Ljava/net/Socket;)V

    .line 70
    throw p0

    :catch_2
    move-exception p2

    .line 61
    invoke-static {v0}, Luz/carhelper/passenger/adb/AdbConnection;->closeQuietly(Ljava/net/Socket;)V

    .line 62
    new-instance p3, Luz/carhelper/passenger/adb/AdbException;

    new-instance p4, Ljava/lang/StringBuilder;

    const-string v0, "cannot reach adb at "

    invoke-direct {p4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ":"

    invoke-virtual {p4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " ("

    invoke-virtual {p4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {p4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "NOCONN"

    invoke-direct {p3, p1, p0}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p3
.end method

.method private read()Luz/carhelper/passenger/adb/AdbConnection$Msg;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/16 v0, 0x18

    .line 281
    new-array v0, v0, [B

    .line 282
    invoke-direct {p0, v0}, Luz/carhelper/passenger/adb/AdbConnection;->readFully([B)V

    .line 283
    invoke-static {v0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v0

    .line 284
    new-instance v1, Luz/carhelper/passenger/adb/AdbConnection$Msg;

    const/4 v2, 0x0

    invoke-direct {v1, v2}, Luz/carhelper/passenger/adb/AdbConnection$Msg;-><init>(Luz/carhelper/passenger/adb/AdbConnection$1;)V

    .line 285
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    iput v2, v1, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    .line 286
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    iput v2, v1, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg0:I

    .line 287
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    iput v2, v1, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg1:I

    .line 288
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    .line 289
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I

    .line 290
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 291
    iget v3, v1, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    not-int v3, v3

    if-ne v3, v0, :cond_0

    if-ltz v2, :cond_0

    const/high16 v0, 0x100000

    if-gt v2, v0, :cond_0

    .line 294
    new-array v0, v2, [B

    iput-object v0, v1, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    .line 295
    iget-object v0, v1, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    invoke-direct {p0, v0}, Luz/carhelper/passenger/adb/AdbConnection;->readFully([B)V

    return-object v1

    .line 292
    :cond_0
    new-instance v0, Ljava/io/IOException;

    const-string v1, "not an adb message"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method private readFully([B)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/4 v0, 0x0

    .line 301
    :goto_0
    array-length v1, p1

    if-ge v0, v1, :cond_1

    .line 302
    iget-object v1, p0, Luz/carhelper/passenger/adb/AdbConnection;->in:Ljava/io/InputStream;

    array-length v2, p1

    sub-int/2addr v2, v0

    invoke-virtual {v1, p1, v0, v2}, Ljava/io/InputStream;->read([BII)I

    move-result v1

    if-ltz v1, :cond_0

    add-int/2addr v0, v1

    goto :goto_0

    .line 304
    :cond_0
    new-instance p1, Ljava/io/IOException;

    const-string v0, "adb closed the connection"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    :cond_1
    return-void
.end method

.method private send(III[B)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/4 v0, 0x0

    move v1, v0

    .line 270
    :goto_0
    array-length v2, p4

    if-ge v0, v2, :cond_0

    .line 271
    aget-byte v2, p4, v0

    and-int/lit16 v2, v2, 0xff

    add-int/2addr v1, v2

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 273
    :cond_0
    array-length v0, p4

    add-int/lit8 v0, v0, 0x18

    invoke-static {v0}, Ljava/nio/ByteBuffer;->allocate(I)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v2, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v2}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v0

    .line 274
    invoke-virtual {v0, p1}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    move-result-object v2

    invoke-virtual {v2, p2}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    move-result-object p2

    invoke-virtual {p2, p3}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    move-result-object p2

    array-length p3, p4

    invoke-virtual {p2, p3}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    move-result-object p2

    invoke-virtual {p2, v1}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    move-result-object p2

    not-int p1, p1

    invoke-virtual {p2, p1}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    .line 275
    invoke-virtual {v0, p4}, Ljava/nio/ByteBuffer;->put([B)Ljava/nio/ByteBuffer;

    .line 276
    iget-object p1, p0, Luz/carhelper/passenger/adb/AdbConnection;->out:Ljava/io/OutputStream;

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->array()[B

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/OutputStream;->write([B)V

    .line 277
    iget-object p1, p0, Luz/carhelper/passenger/adb/AdbConnection;->out:Ljava/io/OutputStream;

    invoke-virtual {p1}, Ljava/io/OutputStream;->flush()V

    return-void
.end method


# virtual methods
.method close()V
    .locals 1

    .line 258
    iget-object v0, p0, Luz/carhelper/passenger/adb/AdbConnection;->socket:Ljava/net/Socket;

    invoke-static {v0}, Luz/carhelper/passenger/adb/AdbConnection;->closeQuietly(Ljava/net/Socket;)V

    return-void
.end method

.method exec(Ljava/lang/String;Ljava/io/InputStream;JLuz/carhelper/passenger/adb/AdbProgress;I)Ljava/lang/String;
    .locals 22
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Luz/carhelper/passenger/adb/AdbException;
        }
    .end annotation

    move-object/from16 v1, p0

    move-wide/from16 v2, p3

    move-object/from16 v0, p5

    .line 181
    const-string v4, "UTF-8"

    const-string v5, "FAIL"

    .line 0
    const-string v6, "exec:"

    .line 181
    :try_start_0
    iget-object v7, v1, Luz/carhelper/passenger/adb/AdbConnection;->socket:Ljava/net/Socket;

    move/from16 v8, p6

    invoke-virtual {v7, v8}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 182
    iget v7, v1, Luz/carhelper/passenger/adb/AdbConnection;->nextId:I

    add-int/lit8 v8, v7, 0x1

    iput v8, v1, Luz/carhelper/passenger/adb/AdbConnection;->nextId:I

    .line 183
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    move-object/from16 v6, p1

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "\u0000"

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v6, v4}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v6

    const/4 v8, 0x0

    const v9, 0x4e45504f    # 8.2759366E8f

    invoke-direct {v1, v9, v7, v8, v6}, Luz/carhelper/passenger/adb/AdbConnection;->send(III[B)V

    .line 185
    new-instance v6, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v6}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/4 v9, -0x1

    :cond_0
    :goto_0
    const v10, 0x45534c43

    const v11, 0x45545257

    const v12, 0x59414b4f

    if-gez v9, :cond_4

    .line 187
    invoke-direct/range {p0 .. p0}, Luz/carhelper/passenger/adb/AdbConnection;->read()Luz/carhelper/passenger/adb/AdbConnection$Msg;

    move-result-object v13

    .line 188
    iget v14, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg1:I

    if-eq v14, v7, :cond_1

    goto :goto_0

    .line 191
    :cond_1
    iget v14, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    if-ne v14, v12, :cond_2

    .line 192
    iget v9, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg0:I

    goto :goto_0

    .line 193
    :cond_2
    iget v14, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    if-eq v14, v10, :cond_3

    .line 195
    iget v10, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    if-ne v10, v11, :cond_0

    .line 196
    iget-object v9, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    iget-object v10, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    array-length v10, v10

    invoke-virtual {v6, v9, v8, v10}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 197
    iget v9, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg0:I

    new-array v10, v8, [B

    invoke-direct {v1, v12, v7, v9, v10}, Luz/carhelper/passenger/adb/AdbConnection;->send(III[B)V

    .line 198
    iget v9, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg0:I

    goto :goto_0

    .line 194
    :cond_3
    new-instance v0, Luz/carhelper/passenger/adb/AdbException;

    const-string v2, "adb refused the install service"

    invoke-direct {v0, v5, v2}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw v0

    .line 201
    :cond_4
    iget v13, v1, Luz/carhelper/passenger/adb/AdbConnection;->maxData:I

    new-array v14, v13, [B

    const-wide/16 v15, 0x0

    move/from16 v17, v8

    :goto_1
    const/16 v18, 0x1

    if-nez v17, :cond_d

    cmp-long v19, v15, v2

    if-gez v19, :cond_d

    int-to-long v10, v13

    move/from16 v20, v13

    sub-long v12, v2, v15

    .line 205
    invoke-static {v10, v11, v12, v13}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v10

    long-to-int v10, v10

    move-object/from16 v11, p2

    .line 206
    invoke-virtual {v11, v14, v8, v10}, Ljava/io/InputStream;->read([BII)I

    move-result v10

    if-lez v10, :cond_c

    .line 210
    new-array v12, v10, [B

    .line 211
    invoke-static {v14, v8, v12, v8, v10}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    const v13, 0x45545257

    .line 212
    invoke-direct {v1, v13, v7, v9, v12}, Luz/carhelper/passenger/adb/AdbConnection;->send(III[B)V

    move v12, v8

    :goto_2
    if-nez v12, :cond_9

    if-nez v17, :cond_9

    .line 215
    invoke-direct/range {p0 .. p0}, Luz/carhelper/passenger/adb/AdbConnection;->read()Luz/carhelper/passenger/adb/AdbConnection$Msg;

    move-result-object v13

    .line 216
    iget v8, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg1:I

    if-eq v8, v7, :cond_5

    :goto_3
    const/4 v8, 0x0

    goto :goto_2

    .line 219
    :cond_5
    iget v8, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    move/from16 v21, v9

    const v9, 0x59414b4f

    if-ne v8, v9, :cond_6

    move/from16 v12, v18

    goto :goto_4

    .line 221
    :cond_6
    iget v8, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    const v9, 0x45545257

    if-ne v8, v9, :cond_7

    .line 222
    iget-object v8, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    iget-object v9, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    array-length v9, v9

    const/4 v11, 0x0

    invoke-virtual {v6, v8, v11, v9}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 223
    iget v8, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg0:I

    new-array v9, v11, [B

    const v11, 0x59414b4f

    invoke-direct {v1, v11, v7, v8, v9}, Luz/carhelper/passenger/adb/AdbConnection;->send(III[B)V

    goto :goto_4

    .line 224
    :cond_7
    iget v8, v13, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    const v9, 0x45534c43

    if-ne v8, v9, :cond_8

    move/from16 v17, v18

    :cond_8
    :goto_4
    move-object/from16 v11, p2

    move/from16 v9, v21

    goto :goto_3

    :cond_9
    move/from16 v21, v9

    if-eqz v12, :cond_b

    int-to-long v8, v10

    add-long/2addr v8, v15

    if-eqz v0, :cond_a

    .line 231
    invoke-interface {v0, v8, v9, v2, v3}, Luz/carhelper/passenger/adb/AdbProgress;->onProgress(JJ)V

    :cond_a
    move-wide v15, v8

    :cond_b
    move/from16 v13, v20

    move/from16 v9, v21

    const/4 v8, 0x0

    const v10, 0x45534c43

    const v11, 0x45545257

    const v12, 0x59414b4f

    goto/16 :goto_1

    .line 208
    :cond_c
    new-instance v0, Luz/carhelper/passenger/adb/AdbException;

    const-string v2, "the file ended early"

    invoke-direct {v0, v5, v2}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw v0

    :cond_d
    :goto_5
    if-nez v17, :cond_10

    .line 236
    invoke-direct/range {p0 .. p0}, Luz/carhelper/passenger/adb/AdbConnection;->read()Luz/carhelper/passenger/adb/AdbConnection$Msg;

    move-result-object v0

    .line 237
    iget v2, v0, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg1:I

    if-eq v2, v7, :cond_e

    goto :goto_5

    .line 240
    :cond_e
    iget v2, v0, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    const v3, 0x45545257

    if-ne v2, v3, :cond_f

    .line 241
    iget-object v2, v0, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    iget-object v8, v0, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    array-length v8, v8

    const/4 v9, 0x0

    invoke-virtual {v6, v2, v9, v8}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 242
    iget v0, v0, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg0:I

    new-array v2, v9, [B

    const v8, 0x59414b4f

    invoke-direct {v1, v8, v7, v0, v2}, Luz/carhelper/passenger/adb/AdbConnection;->send(III[B)V

    const v2, 0x45534c43

    goto :goto_5

    :cond_f
    const v8, 0x59414b4f

    const/4 v9, 0x0

    .line 243
    iget v0, v0, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    const v2, 0x45534c43

    if-ne v0, v2, :cond_d

    move/from16 v17, v18

    goto :goto_5

    .line 247
    :cond_10
    invoke-virtual {v6, v4}, Ljava/io/ByteArrayOutputStream;->toString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Ljava/net/SocketTimeoutException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    move-exception v0

    .line 253
    new-instance v2, Luz/carhelper/passenger/adb/AdbException;

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "adb install failed: "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v2, v5, v0}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw v2

    :catch_1
    move-exception v0

    .line 251
    throw v0

    .line 249
    :catch_2
    new-instance v0, Luz/carhelper/passenger/adb/AdbException;

    const-string v2, "the installer did not answer in time"

    invoke-direct {v0, v5, v2}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw v0
.end method

.method shell(Ljava/lang/String;I)Ljava/lang/String;
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Luz/carhelper/passenger/adb/AdbException;
        }
    .end annotation

    .line 142
    const-string v0, "UTF-8"

    const-string v1, "FAIL"

    .line 0
    const-string v2, "shell:"

    .line 142
    :try_start_0
    iget-object v3, p0, Luz/carhelper/passenger/adb/AdbConnection;->socket:Ljava/net/Socket;

    invoke-virtual {v3, p2}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 143
    iget p2, p0, Luz/carhelper/passenger/adb/AdbConnection;->nextId:I

    add-int/lit8 v3, p2, 0x1

    iput v3, p0, Luz/carhelper/passenger/adb/AdbConnection;->nextId:I

    .line 144
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\u0000"

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p1

    const/4 v2, 0x0

    const v3, 0x4e45504f    # 8.2759366E8f

    invoke-direct {p0, v3, p2, v2, p1}, Luz/carhelper/passenger/adb/AdbConnection;->send(III[B)V

    .line 146
    new-instance p1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/4 v3, -0x1

    .line 148
    :cond_0
    :goto_0
    invoke-direct {p0}, Luz/carhelper/passenger/adb/AdbConnection;->read()Luz/carhelper/passenger/adb/AdbConnection$Msg;

    move-result-object v4

    .line 149
    iget v5, v4, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg1:I

    if-eq v5, p2, :cond_1

    goto :goto_0

    .line 152
    :cond_1
    iget v5, v4, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    const v6, 0x59414b4f

    if-ne v5, v6, :cond_2

    .line 153
    iget v3, v4, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg0:I

    goto :goto_0

    .line 154
    :cond_2
    iget v5, v4, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    const v7, 0x45545257

    if-ne v5, v7, :cond_3

    .line 155
    iget-object v3, v4, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    iget-object v5, v4, Luz/carhelper/passenger/adb/AdbConnection$Msg;->data:[B

    array-length v5, v5

    invoke-virtual {p1, v3, v2, v5}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 156
    iget v3, v4, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg0:I

    new-array v5, v2, [B

    invoke-direct {p0, v6, p2, v3, v5}, Luz/carhelper/passenger/adb/AdbConnection;->send(III[B)V

    .line 157
    iget v3, v4, Luz/carhelper/passenger/adb/AdbConnection$Msg;->arg0:I

    goto :goto_0

    .line 158
    :cond_3
    iget v4, v4, Luz/carhelper/passenger/adb/AdbConnection$Msg;->cmd:I

    const v5, 0x45534c43

    if-ne v4, v5, :cond_0

    if-ltz v3, :cond_4

    .line 162
    invoke-virtual {p1, v0}, Ljava/io/ByteArrayOutputStream;->toString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 160
    :cond_4
    new-instance p1, Luz/carhelper/passenger/adb/AdbException;

    const-string p2, "adb refused the shell service"

    invoke-direct {p1, v1, p2}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catch Ljava/net/SocketTimeoutException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Luz/carhelper/passenger/adb/AdbException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception p1

    .line 170
    new-instance p2, Luz/carhelper/passenger/adb/AdbException;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "adb shell failed: "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p2, v1, p1}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p2

    :catch_1
    move-exception p1

    .line 168
    throw p1

    .line 166
    :catch_2
    new-instance p1, Luz/carhelper/passenger/adb/AdbException;

    const-string p2, "the command did not finish in time"

    invoke-direct {p1, v1, p2}, Luz/carhelper/passenger/adb/AdbException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw p1
.end method

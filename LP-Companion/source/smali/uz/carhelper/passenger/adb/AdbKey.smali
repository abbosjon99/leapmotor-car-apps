.class public final Luz/carhelper/passenger/adb/AdbKey;
.super Ljava/lang/Object;
.source "AdbKey.java"


# static fields
.field private static final KEY_BYTES:I = 0x100

.field static final SHA1_PREFIX:[B


# instance fields
.field private final file:Ljava/io/File;

.field keyHint:I

.field private final priv:Ljava/security/interfaces/RSAPrivateKey;

.field private final pub:Ljava/security/interfaces/RSAPublicKey;

.field sigHint:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/16 v0, 0xf

    .line 29
    new-array v0, v0, [B

    fill-array-data v0, :array_0

    sput-object v0, Luz/carhelper/passenger/adb/AdbKey;->SHA1_PREFIX:[B

    return-void

    :array_0
    .array-data 1
        0x30t
        0x21t
        0x30t
        0x9t
        0x6t
        0x5t
        0x2bt
        0xet
        0x3t
        0x2t
        0x1at
        0x5t
        0x0t
        0x4t
        0x14t
    .end array-data
.end method

.method private constructor <init>(Ljava/security/interfaces/RSAPrivateKey;Ljava/security/interfaces/RSAPublicKey;Ljava/io/File;)V
    .locals 0

    .line 39
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 40
    iput-object p1, p0, Luz/carhelper/passenger/adb/AdbKey;->priv:Ljava/security/interfaces/RSAPrivateKey;

    .line 41
    iput-object p2, p0, Luz/carhelper/passenger/adb/AdbKey;->pub:Ljava/security/interfaces/RSAPublicKey;

    .line 42
    iput-object p3, p0, Luz/carhelper/passenger/adb/AdbKey;->file:Ljava/io/File;

    .line 43
    invoke-direct {p0}, Luz/carhelper/passenger/adb/AdbKey;->readHint()V

    return-void
.end method

.method static fixed(Ljava/math/BigInteger;IZ)[B
    .locals 5

    .line 195
    invoke-virtual {p0}, Ljava/math/BigInteger;->toByteArray()[B

    move-result-object p0

    .line 196
    new-array v0, p1, [B

    .line 197
    array-length v1, p0

    invoke-static {v1, p1}, Ljava/lang/Math;->min(II)I

    move-result v1

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    .line 199
    array-length v3, p0

    add-int/lit8 v3, v3, -0x1

    sub-int/2addr v3, v2

    aget-byte v3, p0, v3

    if-eqz p2, :cond_0

    add-int/lit8 v4, p1, -0x1

    sub-int/2addr v4, v2

    .line 201
    aput-byte v3, v0, v4

    goto :goto_1

    .line 203
    :cond_0
    aput-byte v3, v0, v2

    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    return-object v0
.end method

.method public static load(Ljava/io/File;)Luz/carhelper/passenger/adb/AdbKey;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 81
    const-string v0, "RSA"

    invoke-static {v0}, Ljava/security/KeyFactory;->getInstance(Ljava/lang/String;)Ljava/security/KeyFactory;

    move-result-object v1

    .line 82
    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 84
    :try_start_0
    new-instance v2, Ljava/security/spec/PKCS8EncodedKeySpec;

    invoke-static {p0}, Luz/carhelper/passenger/adb/AdbKey;->readAll(Ljava/io/File;)[B

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/security/spec/PKCS8EncodedKeySpec;-><init>([B)V

    invoke-virtual {v1, v2}, Ljava/security/KeyFactory;->generatePrivate(Ljava/security/spec/KeySpec;)Ljava/security/PrivateKey;

    move-result-object v2

    check-cast v2, Ljava/security/interfaces/RSAPrivateCrtKey;

    .line 85
    new-instance v3, Ljava/security/spec/RSAPublicKeySpec;

    invoke-interface {v2}, Ljava/security/interfaces/RSAPrivateCrtKey;->getModulus()Ljava/math/BigInteger;

    move-result-object v4

    invoke-interface {v2}, Ljava/security/interfaces/RSAPrivateCrtKey;->getPublicExponent()Ljava/math/BigInteger;

    move-result-object v5

    invoke-direct {v3, v4, v5}, Ljava/security/spec/RSAPublicKeySpec;-><init>(Ljava/math/BigInteger;Ljava/math/BigInteger;)V

    invoke-virtual {v1, v3}, Ljava/security/KeyFactory;->generatePublic(Ljava/security/spec/KeySpec;)Ljava/security/PublicKey;

    move-result-object v1

    check-cast v1, Ljava/security/interfaces/RSAPublicKey;

    .line 86
    new-instance v3, Luz/carhelper/passenger/adb/AdbKey;

    invoke-direct {v3, v2, v1, p0}, Luz/carhelper/passenger/adb/AdbKey;-><init>(Ljava/security/interfaces/RSAPrivateKey;Ljava/security/interfaces/RSAPublicKey;Ljava/io/File;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v3

    .line 88
    :catch_0
    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    .line 89
    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ".hint"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    .line 92
    :cond_0
    invoke-static {v0}, Ljava/security/KeyPairGenerator;->getInstance(Ljava/lang/String;)Ljava/security/KeyPairGenerator;

    move-result-object v0

    const/16 v1, 0x800

    .line 93
    invoke-virtual {v0, v1}, Ljava/security/KeyPairGenerator;->initialize(I)V

    .line 94
    invoke-virtual {v0}, Ljava/security/KeyPairGenerator;->generateKeyPair()Ljava/security/KeyPair;

    move-result-object v0

    .line 95
    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ".tmp"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 96
    new-instance v2, Ljava/io/FileOutputStream;

    invoke-direct {v2, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 98
    :try_start_1
    invoke-virtual {v0}, Ljava/security/KeyPair;->getPrivate()Ljava/security/PrivateKey;

    move-result-object v3

    invoke-interface {v3}, Ljava/security/PrivateKey;->getEncoded()[B

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/io/OutputStream;->write([B)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 100
    invoke-virtual {v2}, Ljava/io/OutputStream;->close()V

    const/4 v2, 0x0

    .line 102
    invoke-virtual {v1, v2, v2}, Ljava/io/File;->setReadable(ZZ)Z

    .line 103
    invoke-virtual {v1, v2, v2}, Ljava/io/File;->setWritable(ZZ)Z

    const/4 v2, 0x1

    .line 104
    invoke-virtual {v1, v2, v2}, Ljava/io/File;->setReadable(ZZ)Z

    .line 105
    invoke-virtual {v1, v2, v2}, Ljava/io/File;->setWritable(ZZ)Z

    .line 106
    invoke-virtual {v1, p0}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 109
    new-instance v1, Luz/carhelper/passenger/adb/AdbKey;

    invoke-virtual {v0}, Ljava/security/KeyPair;->getPrivate()Ljava/security/PrivateKey;

    move-result-object v2

    check-cast v2, Ljava/security/interfaces/RSAPrivateKey;

    invoke-virtual {v0}, Ljava/security/KeyPair;->getPublic()Ljava/security/PublicKey;

    move-result-object v0

    check-cast v0, Ljava/security/interfaces/RSAPublicKey;

    invoke-direct {v1, v2, v0, p0}, Luz/carhelper/passenger/adb/AdbKey;-><init>(Ljava/security/interfaces/RSAPrivateKey;Ljava/security/interfaces/RSAPublicKey;Ljava/io/File;)V

    return-object v1

    .line 107
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string v0, "cannot save the adb key"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :catchall_0
    move-exception p0

    .line 100
    invoke-virtual {v2}, Ljava/io/OutputStream;->close()V

    .line 101
    throw p0
.end method

.method private static readAll(Ljava/io/File;)[B
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 113
    new-instance v0, Ljava/io/FileInputStream;

    invoke-direct {v0, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    .line 115
    :try_start_0
    new-instance p0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v1, 0x400

    .line 116
    new-array v1, v1, [B

    .line 118
    :goto_0
    invoke-virtual {v0, v1}, Ljava/io/InputStream;->read([B)I

    move-result v2

    if-lez v2, :cond_0

    const/4 v3, 0x0

    .line 119
    invoke-virtual {p0, v1, v3, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    .line 121
    :cond_0
    invoke-virtual {p0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 123
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V

    return-object p0

    :catchall_0
    move-exception p0

    invoke-virtual {v0}, Ljava/io/InputStream;->close()V

    .line 124
    throw p0
.end method

.method private readHint()V
    .locals 6

    const/4 v0, 0x0

    .line 48
    iput v0, p0, Luz/carhelper/passenger/adb/AdbKey;->sigHint:I

    .line 49
    iput v0, p0, Luz/carhelper/passenger/adb/AdbKey;->keyHint:I

    .line 50
    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Luz/carhelper/passenger/adb/AdbKey;->file:Ljava/io/File;

    invoke-virtual {v3}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ".hint"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 52
    :try_start_0
    invoke-virtual {v1}, Ljava/io/File;->isFile()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v2

    const-wide/16 v4, 0x2

    cmp-long v2, v2, v4

    if-nez v2, :cond_2

    .line 53
    invoke-static {v1}, Luz/carhelper/passenger/adb/AdbKey;->readAll(Ljava/io/File;)[B

    move-result-object v1

    .line 54
    aget-byte v2, v1, v0

    const/16 v3, 0x31

    const/4 v4, 0x1

    if-ne v2, v3, :cond_0

    move v2, v4

    goto :goto_0

    :cond_0
    move v2, v0

    :goto_0
    iput v2, p0, Luz/carhelper/passenger/adb/AdbKey;->sigHint:I

    .line 55
    aget-byte v1, v1, v4

    if-ne v1, v3, :cond_1

    move v0, v4

    :cond_1
    iput v0, p0, Luz/carhelper/passenger/adb/AdbKey;->keyHint:I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_2
    return-void
.end method


# virtual methods
.method public adbPublicKey(Ljava/lang/String;)[B
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    const/4 v0, 0x0

    .line 159
    invoke-virtual {p0, p1, v0}, Luz/carhelper/passenger/adb/AdbKey;->adbPublicKey(Ljava/lang/String;Z)[B

    move-result-object p1

    return-object p1
.end method

.method public adbPublicKey(Ljava/lang/String;Z)[B
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 167
    iget-object v0, p0, Luz/carhelper/passenger/adb/AdbKey;->pub:Ljava/security/interfaces/RSAPublicKey;

    invoke-interface {v0}, Ljava/security/interfaces/RSAPublicKey;->getModulus()Ljava/math/BigInteger;

    move-result-object v0

    .line 168
    sget-object v1, Ljava/math/BigInteger;->ONE:Ljava/math/BigInteger;

    const/16 v2, 0x800

    invoke-virtual {v1, v2}, Ljava/math/BigInteger;->shiftLeft(I)Ljava/math/BigInteger;

    move-result-object v1

    .line 169
    invoke-virtual {v1, v1}, Ljava/math/BigInteger;->multiply(Ljava/math/BigInteger;)Ljava/math/BigInteger;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/math/BigInteger;->mod(Ljava/math/BigInteger;)Ljava/math/BigInteger;

    move-result-object v1

    .line 170
    sget-object v2, Ljava/math/BigInteger;->ONE:Ljava/math/BigInteger;

    const/16 v3, 0x20

    invoke-virtual {v2, v3}, Ljava/math/BigInteger;->shiftLeft(I)Ljava/math/BigInteger;

    move-result-object v2

    .line 171
    invoke-virtual {v0, v2}, Ljava/math/BigInteger;->mod(Ljava/math/BigInteger;)Ljava/math/BigInteger;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/math/BigInteger;->modInverse(Ljava/math/BigInteger;)Ljava/math/BigInteger;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/math/BigInteger;->subtract(Ljava/math/BigInteger;)Ljava/math/BigInteger;

    move-result-object v2

    invoke-virtual {v2}, Ljava/math/BigInteger;->longValue()J

    move-result-wide v2

    const/16 v4, 0x20c

    .line 172
    invoke-static {v4}, Ljava/nio/ByteBuffer;->allocate(I)Ljava/nio/ByteBuffer;

    move-result-object v4

    sget-object v5, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v4, v5}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v4

    const/16 v5, 0x40

    .line 173
    invoke-virtual {v4, v5}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    long-to-int v2, v2

    .line 174
    invoke-virtual {v4, v2}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    const/16 v2, 0x100

    const/4 v3, 0x0

    .line 175
    invoke-static {v0, v2, v3}, Luz/carhelper/passenger/adb/AdbKey;->fixed(Ljava/math/BigInteger;IZ)[B

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/nio/ByteBuffer;->put([B)Ljava/nio/ByteBuffer;

    .line 176
    invoke-static {v1, v2, v3}, Luz/carhelper/passenger/adb/AdbKey;->fixed(Ljava/math/BigInteger;IZ)[B

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/nio/ByteBuffer;->put([B)Ljava/nio/ByteBuffer;

    .line 177
    iget-object v0, p0, Luz/carhelper/passenger/adb/AdbKey;->pub:Ljava/security/interfaces/RSAPublicKey;

    invoke-interface {v0}, Ljava/security/interfaces/RSAPublicKey;->getPublicExponent()Ljava/math/BigInteger;

    move-result-object v0

    invoke-virtual {v0}, Ljava/math/BigInteger;->intValue()I

    move-result v0

    invoke-virtual {v4, v0}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    .line 178
    invoke-virtual {v4}, Ljava/nio/ByteBuffer;->array()[B

    move-result-object v0

    if-eqz p2, :cond_0

    :goto_0
    add-int/lit8 p2, v3, 0x3

    .line 180
    array-length v1, v0

    if-ge p2, v1, :cond_0

    .line 181
    aget-byte v1, v0, v3

    .line 182
    aget-byte v2, v0, p2

    aput-byte v2, v0, v3

    .line 183
    aput-byte v1, v0, p2

    add-int/lit8 p2, v3, 0x1

    .line 184
    aget-byte v1, v0, p2

    add-int/lit8 v2, v3, 0x2

    .line 185
    aget-byte v4, v0, v2

    aput-byte v4, v0, p2

    .line 186
    aput-byte v1, v0, v2

    add-int/lit8 v3, v3, 0x4

    goto :goto_0

    .line 189
    :cond_0
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Ljava/util/Base64;->getEncoder()Ljava/util/Base64$Encoder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/util/Base64$Encoder;->encodeToString([B)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\u0000"

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 190
    const-string p2, "UTF-8"

    invoke-virtual {p1, p2}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p1

    return-object p1
.end method

.method remember(II)V
    .locals 4

    .line 63
    iget v0, p0, Luz/carhelper/passenger/adb/AdbKey;->sigHint:I

    if-ne p1, v0, :cond_0

    iget v0, p0, Luz/carhelper/passenger/adb/AdbKey;->keyHint:I

    if-ne p2, v0, :cond_0

    return-void

    .line 66
    :cond_0
    iput p1, p0, Luz/carhelper/passenger/adb/AdbKey;->sigHint:I

    .line 67
    iput p2, p0, Luz/carhelper/passenger/adb/AdbKey;->keyHint:I

    .line 69
    :try_start_0
    new-instance v0, Ljava/io/FileOutputStream;

    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Luz/carhelper/passenger/adb/AdbKey;->file:Ljava/io/File;

    invoke-virtual {v3}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ".hint"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    add-int/lit8 p1, p1, 0x30

    int-to-byte p1, p1

    add-int/lit8 p2, p2, 0x30

    int-to-byte p2, p2

    const/4 v1, 0x2

    .line 71
    :try_start_1
    new-array v1, v1, [B

    const/4 v2, 0x0

    aput-byte p1, v1, v2

    const/4 p1, 0x1

    aput-byte p2, v1, p1

    invoke-virtual {v0, v1}, Ljava/io/OutputStream;->write([B)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 73
    :try_start_2
    invoke-virtual {v0}, Ljava/io/OutputStream;->close()V

    goto :goto_0

    :catchall_0
    move-exception p1

    invoke-virtual {v0}, Ljava/io/OutputStream;->close()V

    .line 74
    throw p1
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    :catch_0
    :goto_0
    return-void
.end method

.method public signToken([B)[B
    .locals 8

    .line 129
    sget-object v0, Luz/carhelper/passenger/adb/AdbKey;->SHA1_PREFIX:[B

    array-length v1, v0

    array-length v2, p1

    add-int/2addr v1, v2

    new-array v2, v1, [B

    .line 130
    array-length v3, v0

    const/4 v4, 0x0

    invoke-static {v0, v4, v2, v4, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 131
    array-length v0, v0

    array-length v3, p1

    invoke-static {p1, v4, v2, v0, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    const/16 p1, 0x100

    .line 132
    new-array v0, p1, [B

    const/4 v3, 0x1

    .line 133
    aput-byte v3, v0, v3

    const/4 v5, 0x2

    :goto_0
    rsub-int v6, v1, 0x100

    rsub-int v7, v1, 0xff

    if-ge v5, v7, :cond_0

    const/4 v6, -0x1

    .line 135
    aput-byte v6, v0, v5

    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 137
    :cond_0
    invoke-static {v2, v4, v0, v6, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 138
    new-instance v1, Ljava/math/BigInteger;

    invoke-direct {v1, v3, v0}, Ljava/math/BigInteger;-><init>(I[B)V

    .line 139
    iget-object v0, p0, Luz/carhelper/passenger/adb/AdbKey;->priv:Ljava/security/interfaces/RSAPrivateKey;

    invoke-interface {v0}, Ljava/security/interfaces/RSAPrivateKey;->getPrivateExponent()Ljava/math/BigInteger;

    move-result-object v0

    iget-object v2, p0, Luz/carhelper/passenger/adb/AdbKey;->priv:Ljava/security/interfaces/RSAPrivateKey;

    invoke-interface {v2}, Ljava/security/interfaces/RSAPrivateKey;->getModulus()Ljava/math/BigInteger;

    move-result-object v2

    invoke-virtual {v1, v0, v2}, Ljava/math/BigInteger;->modPow(Ljava/math/BigInteger;Ljava/math/BigInteger;)Ljava/math/BigInteger;

    move-result-object v0

    .line 140
    invoke-static {v0, p1, v3}, Luz/carhelper/passenger/adb/AdbKey;->fixed(Ljava/math/BigInteger;IZ)[B

    move-result-object p1

    return-object p1
.end method

.method public signToken([BI)[B
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    const/4 v0, 0x1

    if-eq p2, v0, :cond_0

    .line 149
    invoke-virtual {p0, p1}, Luz/carhelper/passenger/adb/AdbKey;->signToken([B)[B

    move-result-object p1

    return-object p1

    .line 151
    :cond_0
    const-string p2, "SHA1withRSA"

    invoke-static {p2}, Ljava/security/Signature;->getInstance(Ljava/lang/String;)Ljava/security/Signature;

    move-result-object p2

    .line 152
    iget-object v0, p0, Luz/carhelper/passenger/adb/AdbKey;->priv:Ljava/security/interfaces/RSAPrivateKey;

    invoke-virtual {p2, v0}, Ljava/security/Signature;->initSign(Ljava/security/PrivateKey;)V

    .line 153
    invoke-virtual {p2, p1}, Ljava/security/Signature;->update([B)V

    .line 154
    invoke-virtual {p2}, Ljava/security/Signature;->sign()[B

    move-result-object p1

    return-object p1
.end method

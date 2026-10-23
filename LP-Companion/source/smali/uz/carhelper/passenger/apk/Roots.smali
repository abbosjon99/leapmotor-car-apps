.class final Luz/carhelper/passenger/apk/Roots;
.super Ljava/lang/Object;
.source "Roots.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Luz/carhelper/passenger/apk/Roots$Root;,
        Luz/carhelper/passenger/apk/Roots$Entry;
    }
.end annotation


# static fields
.field private static final MAX_ENTRIES:I = 0x1f4

.field private static final NEVER:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 6

    .line 84
    const-string v4, ".trash"

    const-string v5, "lost+found"

    const-string v0, "android"

    const-string v1, "system volume information"

    const-string v2, "$recycle.bin"

    const-string v3, "lost.dir"

    filled-new-array/range {v0 .. v5}, [Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    sput-object v0, Luz/carhelper/passenger/apk/Roots;->NEVER:Ljava/util/List;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static allowed(Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;)Z
    .locals 4

    const/4 v0, 0x0

    .line 90
    :try_start_0
    iget-object p0, p0, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    invoke-virtual {p0}, Ljava/io/File;->getCanonicalPath()Ljava/lang/String;

    move-result-object p0

    .line 91
    invoke-virtual {p1}, Ljava/io/File;->getCanonicalPath()Ljava/lang/String;

    move-result-object p1

    .line 92
    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const-string v2, "/"

    if-nez v1, :cond_0

    :try_start_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    return v0

    .line 95
    :cond_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {p1, p0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    .line 96
    invoke-virtual {p0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p1

    const/4 v1, 0x1

    if-eqz p1, :cond_1

    .line 97
    invoke-virtual {p0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    .line 99
    :cond_1
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p1

    if-nez p1, :cond_2

    return v1

    .line 102
    :cond_2
    invoke-virtual {p0, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    move p1, v0

    .line 103
    :goto_0
    array-length v2, p0

    if-ge p1, v2, :cond_5

    .line 104
    aget-object v2, p0, p1

    .line 105
    const-string v3, "."

    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_4

    sget-object v3, Luz/carhelper/passenger/apk/Roots;->NEVER:Ljava/util/List;

    invoke-virtual {v2}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v3, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz v2, :cond_3

    goto :goto_1

    :cond_3
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    :cond_4
    :goto_1
    return v0

    :cond_5
    return v1

    :catchall_0
    return v0
.end method

.method static children(Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;)Ljava/util/List;
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Luz/carhelper/passenger/apk/Roots$Root;",
            "Ljava/io/File;",
            ")",
            "Ljava/util/List<",
            "Luz/carhelper/passenger/apk/Roots$Entry;",
            ">;"
        }
    .end annotation

    .line 117
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 120
    :try_start_0
    invoke-virtual {p1}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    const/4 p1, 0x0

    :goto_0
    if-nez p1, :cond_0

    return-object v0

    .line 126
    :cond_0
    array-length v1, p1

    const/4 v2, 0x0

    :goto_1
    if-ge v2, v1, :cond_7

    aget-object v3, p1, v2

    .line 127
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v4

    const/16 v5, 0x1f4

    if-lt v4, v5, :cond_1

    goto :goto_3

    .line 130
    :cond_1
    invoke-virtual {v3}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v4

    .line 131
    const-string v5, "."

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_6

    invoke-static {p0, v3}, Luz/carhelper/passenger/apk/Roots;->allowed(Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;)Z

    move-result v5

    if-nez v5, :cond_2

    goto :goto_2

    .line 134
    :cond_2
    new-instance v5, Luz/carhelper/passenger/apk/Roots$Entry;

    invoke-direct {v5}, Luz/carhelper/passenger/apk/Roots$Entry;-><init>()V

    .line 135
    iput-object v3, v5, Luz/carhelper/passenger/apk/Roots$Entry;->file:Ljava/io/File;

    .line 136
    invoke-virtual {v3}, Ljava/io/File;->isDirectory()Z

    move-result v6

    const/4 v7, 0x1

    if-eqz v6, :cond_3

    .line 137
    iput-boolean v7, v5, Luz/carhelper/passenger/apk/Roots$Entry;->dir:Z

    .line 138
    invoke-interface {v0, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_2

    .line 139
    :cond_3
    invoke-virtual {v3}, Ljava/io/File;->isFile()Z

    move-result v3

    if-eqz v3, :cond_6

    .line 140
    invoke-virtual {v4}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v3

    .line 141
    const-string v4, ".apk"

    invoke-virtual {v3, v4}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_4

    .line 142
    iput-boolean v7, v5, Luz/carhelper/passenger/apk/Roots$Entry;->apk:Z

    .line 143
    invoke-interface {v0, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_2

    .line 144
    :cond_4
    const-string v4, ".xapk"

    invoke-virtual {v3, v4}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_5

    const-string v4, ".apks"

    invoke-virtual {v3, v4}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_5

    const-string v4, ".apkm"

    invoke-virtual {v3, v4}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_6

    .line 145
    :cond_5
    iput-boolean v7, v5, Luz/carhelper/passenger/apk/Roots$Entry;->bundle:Z

    .line 146
    invoke-interface {v0, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_6
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 150
    :cond_7
    :goto_3
    new-instance p0, Luz/carhelper/passenger/apk/Roots$1;

    invoke-direct {p0}, Luz/carhelper/passenger/apk/Roots$1;-><init>()V

    invoke-static {v0, p0}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    return-object v0
.end method

.method static hiddenAtTop(Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;)Z
    .locals 1

    .line 163
    invoke-static {p0}, Luz/carhelper/passenger/apk/Roots;->isDeviceRoot(Luz/carhelper/passenger/apk/Roots$Root;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p1}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-virtual {p1}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v0

    iget-object p0, p0, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    invoke-virtual {v0, p0}, Ljava/io/File;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    .line 164
    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p0

    const-string p1, "Android"

    invoke-virtual {p0, p1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static isDeviceRoot(Luz/carhelper/passenger/apk/Roots$Root;)Z
    .locals 1

    .line 81
    iget-boolean v0, p0, Luz/carhelper/passenger/apk/Roots$Root;->removable:Z

    if-nez v0, :cond_0

    iget-object p0, p0, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p0

    const-string v0, "Download"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method static list(Landroid/content/Context;)Ljava/util/List;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/List<",
            "Luz/carhelper/passenger/apk/Roots$Root;",
            ">;"
        }
    .end annotation

    .line 44
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 45
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v1

    .line 46
    new-instance v2, Ljava/io/File;

    const-string v3, "Download"

    invoke-direct {v2, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 47
    invoke-virtual {v2}, Ljava/io/File;->isDirectory()Z

    move-result v3

    if-eqz v3, :cond_0

    .line 48
    new-instance v3, Luz/carhelper/passenger/apk/Roots$Root;

    invoke-direct {v3}, Luz/carhelper/passenger/apk/Roots$Root;-><init>()V

    .line 49
    const-string v4, "Downloads"

    invoke-static {v4}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iput-object v4, v3, Luz/carhelper/passenger/apk/Roots$Root;->label:Ljava/lang/String;

    .line 50
    iput-object v2, v3, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    .line 51
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 53
    :cond_0
    new-instance v2, Luz/carhelper/passenger/apk/Roots$Root;

    invoke-direct {v2}, Luz/carhelper/passenger/apk/Roots$Root;-><init>()V

    .line 54
    const-string v3, "Device storage"

    invoke-static {v3}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iput-object v3, v2, Luz/carhelper/passenger/apk/Roots$Root;->label:Ljava/lang/String;

    .line 55
    iput-object v1, v2, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    .line 56
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 58
    :try_start_0
    const-string v1, "storage"

    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/storage/StorageManager;

    .line 59
    invoke-virtual {v1}, Landroid/os/storage/StorageManager;->getStorageVolumes()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_1
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_6

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/storage/StorageVolume;

    .line 60
    invoke-virtual {v2}, Landroid/os/storage/StorageVolume;->isPrimary()Z

    move-result v3

    if-eqz v3, :cond_2

    goto :goto_0

    .line 63
    :cond_2
    invoke-virtual {v2}, Landroid/os/storage/StorageVolume;->getDirectory()Ljava/io/File;

    move-result-object v3

    if-eqz v3, :cond_1

    .line 64
    const-string v4, "mounted"

    invoke-virtual {v2}, Landroid/os/storage/StorageVolume;->getState()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_3

    goto :goto_0

    .line 67
    :cond_3
    new-instance v4, Luz/carhelper/passenger/apk/Roots$Root;

    invoke-direct {v4}, Luz/carhelper/passenger/apk/Roots$Root;-><init>()V

    .line 68
    invoke-virtual {v2, p0}, Landroid/os/storage/StorageVolume;->getDescription(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_4

    .line 69
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v5

    if-nez v5, :cond_5

    :cond_4
    const-string v2, "USB drive"

    invoke-static {v2}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    :cond_5
    iput-object v2, v4, Luz/carhelper/passenger/apk/Roots$Root;->label:Ljava/lang/String;

    .line 70
    iput-object v3, v4, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    const/4 v2, 0x1

    .line 71
    iput-boolean v2, v4, Luz/carhelper/passenger/apk/Roots$Root;->removable:Z

    .line 72
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    :cond_6
    return-object v0
.end method

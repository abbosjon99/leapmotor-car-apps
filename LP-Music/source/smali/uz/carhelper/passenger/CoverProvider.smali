.class public Luz/carhelper/passenger/CoverProvider;
.super Landroid/content/ContentProvider;

# Serves the current cover (written by MiguBridge to <cache>/cover.jpg) as
# content://com.migu.car.music.cover/cover.jpg?v=<hash>. The car's dock card (launcher3:smartdock)
# loads MediaBody.imagUrl with Glide, which reads content:// URLs; the path and the query are
# ignored, there is only ever one file. Read-only, no query/insert/update/delete.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V
    return-void
.end method

.method public onCreate()Z
    .locals 1
    const/4 v0, 0x1
    return v0
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .locals 1
    const-string v0, "image/jpeg"
    return-object v0
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public openFile(Landroid/net/Uri;Ljava/lang/String;)Landroid/os/ParcelFileDescriptor;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/FileNotFoundException;
        }
    .end annotation
    new-instance v0, Ljava/io/File;
    invoke-virtual {p0}, Landroid/content/ContentProvider;->getContext()Landroid/content/Context;
    move-result-object v1
    invoke-virtual {v1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;
    move-result-object v1
    const-string v2, "cover.jpg"
    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    const/high16 v1, 0x10000000
    invoke-static {v0, v1}, Landroid/os/ParcelFileDescriptor;->open(Ljava/io/File;I)Landroid/os/ParcelFileDescriptor;
    move-result-object v0
    return-object v0
.end method

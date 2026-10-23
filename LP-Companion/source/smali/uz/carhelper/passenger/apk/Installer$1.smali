.class Luz/carhelper/passenger/apk/Installer$1;
.super Ljava/lang/Object;
.source "Installer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/Installer;->install(Landroid/app/Activity;Ljava/io/File;ZLuz/carhelper/passenger/adb/AdbProgress;Luz/carhelper/passenger/apk/Installer$Done;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$apk:Ljava/io/File;

.field final synthetic val$done:Luz/carhelper/passenger/apk/Installer$Done;

.field final synthetic val$grantAll:Z

.field final synthetic val$progress:Luz/carhelper/passenger/adb/AdbProgress;


# direct methods
.method constructor <init>(Landroid/app/Activity;Ljava/io/File;ZLuz/carhelper/passenger/adb/AdbProgress;Luz/carhelper/passenger/apk/Installer$Done;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 101
    iput-object p1, p0, Luz/carhelper/passenger/apk/Installer$1;->val$a:Landroid/app/Activity;

    iput-object p2, p0, Luz/carhelper/passenger/apk/Installer$1;->val$apk:Ljava/io/File;

    iput-boolean p3, p0, Luz/carhelper/passenger/apk/Installer$1;->val$grantAll:Z

    iput-object p4, p0, Luz/carhelper/passenger/apk/Installer$1;->val$progress:Luz/carhelper/passenger/adb/AdbProgress;

    iput-object p5, p0, Luz/carhelper/passenger/apk/Installer$1;->val$done:Luz/carhelper/passenger/apk/Installer$Done;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 8

    .line 103
    iget-object v0, p0, Luz/carhelper/passenger/apk/Installer$1;->val$a:Landroid/app/Activity;

    invoke-static {v0}, Luz/carhelper/passenger/apk/Installer;->access$000(Landroid/content/Context;)V

    .line 104
    iget-object v0, p0, Luz/carhelper/passenger/apk/Installer$1;->val$a:Landroid/app/Activity;

    invoke-static {v0}, Luz/carhelper/passenger/apk/Installer;->keyPath(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iget-object v4, p0, Luz/carhelper/passenger/apk/Installer$1;->val$apk:Ljava/io/File;

    iget-boolean v5, p0, Luz/carhelper/passenger/apk/Installer$1;->val$grantAll:Z

    const/16 v6, 0x5a

    iget-object v7, p0, Luz/carhelper/passenger/apk/Installer$1;->val$progress:Luz/carhelper/passenger/adb/AdbProgress;

    const-string v2, "127.0.0.1"

    const/16 v3, 0x15b3

    invoke-static/range {v1 .. v7}, Luz/carhelper/passenger/adb/AdbRunner;->installApk(Ljava/lang/String;Ljava/lang/String;ILjava/io/File;ZILuz/carhelper/passenger/adb/AdbProgress;)Ljava/lang/String;

    move-result-object v0

    .line 105
    iget-object v1, p0, Luz/carhelper/passenger/apk/Installer$1;->val$a:Landroid/app/Activity;

    new-instance v2, Luz/carhelper/passenger/apk/Installer$1$1;

    invoke-direct {v2, p0, v0}, Luz/carhelper/passenger/apk/Installer$1$1;-><init>(Luz/carhelper/passenger/apk/Installer$1;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

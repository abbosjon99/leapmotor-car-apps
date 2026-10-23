.class Luz/carhelper/passenger/apk/Installer$2;
.super Ljava/lang/Object;
.source "Installer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/Installer;->uninstall(Landroid/app/Activity;Ljava/lang/String;Luz/carhelper/passenger/apk/Installer$Done;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$done:Luz/carhelper/passenger/apk/Installer$Done;

.field final synthetic val$pkg:Ljava/lang/String;


# direct methods
.method constructor <init>(Landroid/app/Activity;Ljava/lang/String;Luz/carhelper/passenger/apk/Installer$Done;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 118
    iput-object p1, p0, Luz/carhelper/passenger/apk/Installer$2;->val$a:Landroid/app/Activity;

    iput-object p2, p0, Luz/carhelper/passenger/apk/Installer$2;->val$pkg:Ljava/lang/String;

    iput-object p3, p0, Luz/carhelper/passenger/apk/Installer$2;->val$done:Luz/carhelper/passenger/apk/Installer$Done;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 120
    iget-object v0, p0, Luz/carhelper/passenger/apk/Installer$2;->val$a:Landroid/app/Activity;

    invoke-static {v0}, Luz/carhelper/passenger/apk/Installer;->access$000(Landroid/content/Context;)V

    .line 121
    iget-object v0, p0, Luz/carhelper/passenger/apk/Installer$2;->val$a:Landroid/app/Activity;

    invoke-static {v0}, Luz/carhelper/passenger/apk/Installer;->keyPath(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Luz/carhelper/passenger/apk/Installer$2;->val$pkg:Ljava/lang/String;

    const/16 v2, 0x5a

    const-string v3, "127.0.0.1"

    const/16 v4, 0x15b3

    invoke-static {v0, v3, v4, v1, v2}, Luz/carhelper/passenger/adb/AdbRunner;->uninstallPackage(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    .line 122
    iget-object v1, p0, Luz/carhelper/passenger/apk/Installer$2;->val$a:Landroid/app/Activity;

    new-instance v2, Luz/carhelper/passenger/apk/Installer$2$1;

    invoke-direct {v2, p0, v0}, Luz/carhelper/passenger/apk/Installer$2$1;-><init>(Luz/carhelper/passenger/apk/Installer$2;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

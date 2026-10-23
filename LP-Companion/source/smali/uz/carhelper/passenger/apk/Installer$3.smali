.class Luz/carhelper/passenger/apk/Installer$3;
.super Ljava/lang/Object;
.source "Installer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/Installer;->grantAllFiles(Landroid/app/Activity;Luz/carhelper/passenger/apk/Installer$Done;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$done:Luz/carhelper/passenger/apk/Installer$Done;


# direct methods
.method constructor <init>(Landroid/app/Activity;Luz/carhelper/passenger/apk/Installer$Done;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 135
    iput-object p1, p0, Luz/carhelper/passenger/apk/Installer$3;->val$a:Landroid/app/Activity;

    iput-object p2, p0, Luz/carhelper/passenger/apk/Installer$3;->val$done:Luz/carhelper/passenger/apk/Installer$Done;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 137
    iget-object v0, p0, Luz/carhelper/passenger/apk/Installer$3;->val$a:Landroid/app/Activity;

    invoke-static {v0}, Luz/carhelper/passenger/apk/Installer;->access$000(Landroid/content/Context;)V

    .line 138
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "appops set --user "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Luz/carhelper/passenger/apk/Installer;->userId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Luz/carhelper/passenger/apk/Installer$3;->val$a:Landroid/app/Activity;

    invoke-virtual {v1}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " MANAGE_EXTERNAL_STORAGE allow"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 139
    iget-object v1, p0, Luz/carhelper/passenger/apk/Installer$3;->val$a:Landroid/app/Activity;

    invoke-static {v1}, Luz/carhelper/passenger/apk/Installer;->keyPath(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    filled-new-array {v0}, [Ljava/lang/String;

    move-result-object v0

    const/16 v2, 0x5a

    const-string v3, "127.0.0.1"

    const/16 v4, 0x15b3

    invoke-static {v1, v3, v4, v0, v2}, Luz/carhelper/passenger/adb/AdbRunner;->run(Ljava/lang/String;Ljava/lang/String;I[Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    .line 140
    iget-object v1, p0, Luz/carhelper/passenger/apk/Installer$3;->val$a:Landroid/app/Activity;

    new-instance v2, Luz/carhelper/passenger/apk/Installer$3$1;

    invoke-direct {v2, p0, v0}, Luz/carhelper/passenger/apk/Installer$3$1;-><init>(Luz/carhelper/passenger/apk/Installer$3;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

.class Luz/carhelper/passenger/apk/InstallDialog$8;
.super Ljava/lang/Object;
.source "InstallDialog.java"

# interfaces
.implements Luz/carhelper/passenger/apk/Installer$Done;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/InstallDialog;->run(Landroid/app/Activity;Ljava/io/File;Luz/carhelper/passenger/apk/ApkInfo;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$c:Luz/carhelper/passenger/apk/Cards$Card;

.field final synthetic val$info:Luz/carhelper/passenger/apk/ApkInfo;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/Cards$Card;Luz/carhelper/passenger/apk/ApkInfo;Landroid/app/Activity;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 214
    iput-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    iput-object p2, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$info:Luz/carhelper/passenger/apk/ApkInfo;

    iput-object p3, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$a:Landroid/app/Activity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public done(ZLjava/lang/String;Ljava/lang/String;)V
    .locals 4

    .line 216
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    invoke-virtual {v0}, Luz/carhelper/passenger/apk/Cards$Card;->dismiss()V

    if-eqz p1, :cond_0

    .line 217
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$info:Luz/carhelper/passenger/apk/ApkInfo;

    iget-boolean v0, v0, Luz/carhelper/passenger/apk/ApkInfo;->self:Z

    if-nez v0, :cond_0

    .line 218
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$a:Landroid/app/Activity;

    iget-object v1, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$info:Luz/carhelper/passenger/apk/ApkInfo;

    iget-object v1, v1, Luz/carhelper/passenger/apk/ApkInfo;->pkg:Ljava/lang/String;

    iget-object v2, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$info:Luz/carhelper/passenger/apk/ApkInfo;

    iget-object v2, v2, Luz/carhelper/passenger/apk/ApkInfo;->label:Ljava/lang/String;

    iget-object v3, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$info:Luz/carhelper/passenger/apk/ApkInfo;

    iget-object v3, v3, Luz/carhelper/passenger/apk/ApkInfo;->versionName:Ljava/lang/String;

    invoke-static {v0, v1, v2, v3}, Luz/carhelper/passenger/apk/ApkStore;->add(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 220
    :cond_0
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$a:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 221
    iget-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$a:Landroid/app/Activity;

    invoke-virtual {p1}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    const/4 p3, 0x1

    invoke-static {p1, p2, p3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void

    .line 224
    :cond_1
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$a:Landroid/app/Activity;

    iget-object v1, p0, Luz/carhelper/passenger/apk/InstallDialog$8;->val$info:Luz/carhelper/passenger/apk/ApkInfo;

    iget-object v1, v1, Luz/carhelper/passenger/apk/ApkInfo;->label:Ljava/lang/String;

    invoke-static {v0, p1, v1, p2, p3}, Luz/carhelper/passenger/apk/InstallDialog;->result(Landroid/app/Activity;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

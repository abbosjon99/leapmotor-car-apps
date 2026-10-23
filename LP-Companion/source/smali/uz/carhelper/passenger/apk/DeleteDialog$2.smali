.class Luz/carhelper/passenger/apk/DeleteDialog$2;
.super Ljava/lang/Object;
.source "DeleteDialog.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/DeleteDialog;->show(Landroid/app/Activity;Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;Ljava/lang/Runnable;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$afterwards:Ljava/lang/Runnable;

.field final synthetic val$c:Luz/carhelper/passenger/apk/Cards$Card;

.field final synthetic val$file:Ljava/io/File;

.field final synthetic val$root:Luz/carhelper/passenger/apk/Roots$Root;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/Cards$Card;Ljava/io/File;Luz/carhelper/passenger/apk/Roots$Root;Landroid/app/Activity;Ljava/lang/Runnable;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 30
    iput-object p1, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    iput-object p2, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$file:Ljava/io/File;

    iput-object p3, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$root:Luz/carhelper/passenger/apk/Roots$Root;

    iput-object p4, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$a:Landroid/app/Activity;

    iput-object p5, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$afterwards:Ljava/lang/Runnable;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 32
    iget-object p1, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    invoke-virtual {p1}, Luz/carhelper/passenger/apk/Cards$Card;->dismiss()V

    .line 33
    iget-object p1, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$file:Ljava/io/File;

    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p1

    .line 34
    const-string v0, ".apk"

    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x1

    if-nez v0, :cond_0

    const-string v0, ".xapk"

    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, ".apks"

    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, ".apkm"

    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 35
    :cond_0
    iget-object p1, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$file:Ljava/io/File;

    invoke-virtual {p1}, Ljava/io/File;->isFile()Z

    move-result p1

    if-eqz p1, :cond_1

    iget-object p1, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$root:Luz/carhelper/passenger/apk/Roots$Root;

    iget-object v0, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$file:Ljava/io/File;

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/Roots;->allowed(Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;)Z

    move-result p1

    if-eqz p1, :cond_1

    iget-object p1, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$file:Ljava/io/File;

    invoke-virtual {p1}, Ljava/io/File;->delete()Z

    move-result p1

    if-eqz p1, :cond_1

    move p1, v1

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    .line 36
    :goto_0
    iget-object v0, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$a:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    if-eqz p1, :cond_2

    const-string p1, "File deleted"

    goto :goto_1

    :cond_2
    const-string p1, "Could not delete the file"

    :goto_1
    invoke-static {p1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 37
    iget-object p1, p0, Luz/carhelper/passenger/apk/DeleteDialog$2;->val$afterwards:Ljava/lang/Runnable;

    if-eqz p1, :cond_3

    .line 38
    invoke-interface {p1}, Ljava/lang/Runnable;->run()V

    :cond_3
    return-void
.end method

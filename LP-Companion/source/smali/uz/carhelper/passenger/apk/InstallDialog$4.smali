.class Luz/carhelper/passenger/apk/InstallDialog$4;
.super Ljava/lang/Object;
.source "InstallDialog.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/InstallDialog;->show(Landroid/app/Activity;Ljava/io/File;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$apk:Ljava/io/File;

.field final synthetic val$c:Luz/carhelper/passenger/apk/Cards$Card;

.field final synthetic val$grant:[Z

.field final synthetic val$info:Luz/carhelper/passenger/apk/ApkInfo;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/Cards$Card;Landroid/app/Activity;Ljava/io/File;Luz/carhelper/passenger/apk/ApkInfo;[Z)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 152
    iput-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$4;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    iput-object p2, p0, Luz/carhelper/passenger/apk/InstallDialog$4;->val$a:Landroid/app/Activity;

    iput-object p3, p0, Luz/carhelper/passenger/apk/InstallDialog$4;->val$apk:Ljava/io/File;

    iput-object p4, p0, Luz/carhelper/passenger/apk/InstallDialog$4;->val$info:Luz/carhelper/passenger/apk/ApkInfo;

    iput-object p5, p0, Luz/carhelper/passenger/apk/InstallDialog$4;->val$grant:[Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 4

    .line 154
    iget-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$4;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    invoke-virtual {p1}, Luz/carhelper/passenger/apk/Cards$Card;->dismiss()V

    .line 155
    iget-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$4;->val$a:Landroid/app/Activity;

    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$4;->val$apk:Ljava/io/File;

    iget-object v1, p0, Luz/carhelper/passenger/apk/InstallDialog$4;->val$info:Luz/carhelper/passenger/apk/ApkInfo;

    iget-object v2, p0, Luz/carhelper/passenger/apk/InstallDialog$4;->val$grant:[Z

    const/4 v3, 0x0

    aget-boolean v2, v2, v3

    invoke-static {p1, v0, v1, v2}, Luz/carhelper/passenger/apk/InstallDialog;->access$100(Landroid/app/Activity;Ljava/io/File;Luz/carhelper/passenger/apk/ApkInfo;Z)V

    return-void
.end method

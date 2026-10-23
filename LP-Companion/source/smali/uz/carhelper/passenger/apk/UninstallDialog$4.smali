.class Luz/carhelper/passenger/apk/UninstallDialog$4;
.super Ljava/lang/Object;
.source "UninstallDialog.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/UninstallDialog;->confirm(Landroid/app/Activity;Luz/carhelper/passenger/apk/ApkStore$Entry;Landroid/widget/LinearLayout;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$c:Luz/carhelper/passenger/apk/Cards$Card;

.field final synthetic val$e:Luz/carhelper/passenger/apk/ApkStore$Entry;

.field final synthetic val$list:Landroid/widget/LinearLayout;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/Cards$Card;Landroid/app/Activity;Luz/carhelper/passenger/apk/ApkStore$Entry;Landroid/widget/LinearLayout;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 113
    iput-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    iput-object p2, p0, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$a:Landroid/app/Activity;

    iput-object p3, p0, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$e:Luz/carhelper/passenger/apk/ApkStore$Entry;

    iput-object p4, p0, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$list:Landroid/widget/LinearLayout;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 115
    iget-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    invoke-virtual {p1}, Luz/carhelper/passenger/apk/Cards$Card;->dismiss()V

    .line 116
    iget-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$a:Landroid/app/Activity;

    invoke-virtual {p1}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    const-string v0, "Uninstalling\u2026"

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {p1, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 117
    iget-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$a:Landroid/app/Activity;

    iget-object v0, p0, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$e:Luz/carhelper/passenger/apk/ApkStore$Entry;

    iget-object v0, v0, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    new-instance v1, Luz/carhelper/passenger/apk/UninstallDialog$4$1;

    invoke-direct {v1, p0}, Luz/carhelper/passenger/apk/UninstallDialog$4$1;-><init>(Luz/carhelper/passenger/apk/UninstallDialog$4;)V

    invoke-static {p1, v0, v1}, Luz/carhelper/passenger/apk/Installer;->uninstall(Landroid/app/Activity;Ljava/lang/String;Luz/carhelper/passenger/apk/Installer$Done;)V

    return-void
.end method

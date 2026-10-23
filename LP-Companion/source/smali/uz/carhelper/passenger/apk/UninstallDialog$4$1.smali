.class Luz/carhelper/passenger/apk/UninstallDialog$4$1;
.super Ljava/lang/Object;
.source "UninstallDialog.java"

# interfaces
.implements Luz/carhelper/passenger/apk/Installer$Done;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/UninstallDialog$4;->onClick(Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Luz/carhelper/passenger/apk/UninstallDialog$4;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/UninstallDialog$4;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 117
    iput-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$4$1;->this$0:Luz/carhelper/passenger/apk/UninstallDialog$4;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public done(ZLjava/lang/String;Ljava/lang/String;)V
    .locals 1

    if-eqz p1, :cond_0

    .line 120
    iget-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$4$1;->this$0:Luz/carhelper/passenger/apk/UninstallDialog$4;

    iget-object p1, p1, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$a:Landroid/app/Activity;

    iget-object p3, p0, Luz/carhelper/passenger/apk/UninstallDialog$4$1;->this$0:Luz/carhelper/passenger/apk/UninstallDialog$4;

    iget-object p3, p3, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$e:Luz/carhelper/passenger/apk/ApkStore$Entry;

    iget-object p3, p3, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    invoke-static {p1, p3}, Luz/carhelper/passenger/apk/ApkStore;->remove(Landroid/content/Context;Ljava/lang/String;)V

    .line 122
    :cond_0
    iget-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$4$1;->this$0:Luz/carhelper/passenger/apk/UninstallDialog$4;

    iget-object p1, p1, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$a:Landroid/app/Activity;

    invoke-virtual {p1}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v0, p0, Luz/carhelper/passenger/apk/UninstallDialog$4$1;->this$0:Luz/carhelper/passenger/apk/UninstallDialog$4;

    iget-object v0, v0, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$e:Luz/carhelper/passenger/apk/ApkStore$Entry;

    iget-object v0, v0, Luz/carhelper/passenger/apk/ApkStore$Entry;->label:Ljava/lang/String;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ": "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const/4 p3, 0x1

    invoke-static {p1, p2, p3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 123
    iget-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$4$1;->this$0:Luz/carhelper/passenger/apk/UninstallDialog$4;

    iget-object p1, p1, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$a:Landroid/app/Activity;

    invoke-virtual {p1}, Landroid/app/Activity;->isFinishing()Z

    move-result p1

    if-nez p1, :cond_1

    .line 124
    iget-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$4$1;->this$0:Luz/carhelper/passenger/apk/UninstallDialog$4;

    iget-object p1, p1, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$a:Landroid/app/Activity;

    iget-object p2, p0, Luz/carhelper/passenger/apk/UninstallDialog$4$1;->this$0:Luz/carhelper/passenger/apk/UninstallDialog$4;

    iget-object p2, p2, Luz/carhelper/passenger/apk/UninstallDialog$4;->val$list:Landroid/widget/LinearLayout;

    invoke-static {p1, p2}, Luz/carhelper/passenger/apk/UninstallDialog;->access$100(Landroid/app/Activity;Landroid/widget/LinearLayout;)V

    :cond_1
    return-void
.end method

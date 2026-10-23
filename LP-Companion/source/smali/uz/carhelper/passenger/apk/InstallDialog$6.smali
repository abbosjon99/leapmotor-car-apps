.class Luz/carhelper/passenger/apk/InstallDialog$6;
.super Ljava/lang/Object;
.source "InstallDialog.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/InstallDialog;->confirmGrant(Landroid/app/Activity;Ljava/lang/Runnable;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$c:Luz/carhelper/passenger/apk/Cards$Card;

.field final synthetic val$yes:Ljava/lang/Runnable;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/Cards$Card;Ljava/lang/Runnable;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 179
    iput-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$6;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    iput-object p2, p0, Luz/carhelper/passenger/apk/InstallDialog$6;->val$yes:Ljava/lang/Runnable;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    .line 181
    iget-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$6;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    invoke-virtual {p1}, Luz/carhelper/passenger/apk/Cards$Card;->dismiss()V

    .line 182
    iget-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$6;->val$yes:Ljava/lang/Runnable;

    invoke-interface {p1}, Ljava/lang/Runnable;->run()V

    return-void
.end method

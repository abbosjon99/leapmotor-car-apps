.class Luz/carhelper/passenger/apk/InstallDialog$5;
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


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/Cards$Card;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 174
    iput-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$5;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    .line 176
    iget-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$5;->val$c:Luz/carhelper/passenger/apk/Cards$Card;

    invoke-virtual {p1}, Luz/carhelper/passenger/apk/Cards$Card;->dismiss()V

    return-void
.end method

.class Luz/carhelper/passenger/apk/InstallDialog$9;
.super Ljava/lang/Object;
.source "InstallDialog.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/InstallDialog;->result(Landroid/app/Activity;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$r:Luz/carhelper/passenger/apk/Cards$Card;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/Cards$Card;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 238
    iput-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$9;->val$r:Luz/carhelper/passenger/apk/Cards$Card;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    .line 240
    iget-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$9;->val$r:Luz/carhelper/passenger/apk/Cards$Card;

    invoke-virtual {p1}, Luz/carhelper/passenger/apk/Cards$Card;->dismiss()V

    return-void
.end method

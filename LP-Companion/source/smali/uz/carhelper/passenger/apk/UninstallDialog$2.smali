.class Luz/carhelper/passenger/apk/UninstallDialog$2;
.super Ljava/lang/Object;
.source "UninstallDialog.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/UninstallDialog;->fill(Landroid/app/Activity;Landroid/widget/LinearLayout;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$e:Luz/carhelper/passenger/apk/ApkStore$Entry;

.field final synthetic val$list:Landroid/widget/LinearLayout;


# direct methods
.method constructor <init>(Landroid/app/Activity;Luz/carhelper/passenger/apk/ApkStore$Entry;Landroid/widget/LinearLayout;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 88
    iput-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$2;->val$a:Landroid/app/Activity;

    iput-object p2, p0, Luz/carhelper/passenger/apk/UninstallDialog$2;->val$e:Luz/carhelper/passenger/apk/ApkStore$Entry;

    iput-object p3, p0, Luz/carhelper/passenger/apk/UninstallDialog$2;->val$list:Landroid/widget/LinearLayout;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 90
    iget-object p1, p0, Luz/carhelper/passenger/apk/UninstallDialog$2;->val$a:Landroid/app/Activity;

    iget-object v0, p0, Luz/carhelper/passenger/apk/UninstallDialog$2;->val$e:Luz/carhelper/passenger/apk/ApkStore$Entry;

    iget-object v1, p0, Luz/carhelper/passenger/apk/UninstallDialog$2;->val$list:Landroid/widget/LinearLayout;

    invoke-static {p1, v0, v1}, Luz/carhelper/passenger/apk/UninstallDialog;->access$000(Landroid/app/Activity;Luz/carhelper/passenger/apk/ApkStore$Entry;Landroid/widget/LinearLayout;)V

    return-void
.end method

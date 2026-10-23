.class Luz/carhelper/passenger/apk/InstallDialog$2;
.super Ljava/lang/Object;
.source "InstallDialog.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


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

.field final synthetic val$grant:[Z

.field final synthetic val$quiet:[Z

.field final synthetic val$sw:Landroid/widget/Switch;


# direct methods
.method constructor <init>([Z[ZLandroid/app/Activity;Landroid/widget/Switch;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 123
    iput-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$quiet:[Z

    iput-object p2, p0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$grant:[Z

    iput-object p3, p0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$a:Landroid/app/Activity;

    iput-object p4, p0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$sw:Landroid/widget/Switch;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 3

    .line 125
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$quiet:[Z

    const/4 v1, 0x0

    aget-boolean v2, v0, v1

    if-eqz v2, :cond_0

    return-void

    :cond_0
    if-nez p2, :cond_1

    .line 129
    iget-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$grant:[Z

    aput-boolean v1, p1, v1

    return-void

    :cond_1
    const/4 p2, 0x1

    .line 133
    aput-boolean p2, v0, v1

    .line 134
    invoke-virtual {p1, v1}, Landroid/widget/CompoundButton;->setChecked(Z)V

    .line 135
    iget-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$quiet:[Z

    aput-boolean v1, p1, v1

    .line 136
    iget-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$a:Landroid/app/Activity;

    new-instance p2, Luz/carhelper/passenger/apk/InstallDialog$2$1;

    invoke-direct {p2, p0}, Luz/carhelper/passenger/apk/InstallDialog$2$1;-><init>(Luz/carhelper/passenger/apk/InstallDialog$2;)V

    invoke-static {p1, p2}, Luz/carhelper/passenger/apk/InstallDialog;->access$000(Landroid/app/Activity;Ljava/lang/Runnable;)V

    return-void
.end method

.class Luz/carhelper/passenger/apk/InstallDialog$2$1;
.super Ljava/lang/Object;
.source "InstallDialog.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/InstallDialog$2;->onCheckedChanged(Landroid/widget/CompoundButton;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Luz/carhelper/passenger/apk/InstallDialog$2;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/InstallDialog$2;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 136
    iput-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$2$1;->this$0:Luz/carhelper/passenger/apk/InstallDialog$2;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 138
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$2$1;->this$0:Luz/carhelper/passenger/apk/InstallDialog$2;

    iget-object v0, v0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$quiet:[Z

    const/4 v1, 0x0

    const/4 v2, 0x1

    aput-boolean v2, v0, v1

    .line 139
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$2$1;->this$0:Luz/carhelper/passenger/apk/InstallDialog$2;

    iget-object v0, v0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$sw:Landroid/widget/Switch;

    invoke-virtual {v0, v2}, Landroid/widget/Switch;->setChecked(Z)V

    .line 140
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$2$1;->this$0:Luz/carhelper/passenger/apk/InstallDialog$2;

    iget-object v0, v0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$quiet:[Z

    aput-boolean v1, v0, v1

    .line 141
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$2$1;->this$0:Luz/carhelper/passenger/apk/InstallDialog$2;

    iget-object v0, v0, Luz/carhelper/passenger/apk/InstallDialog$2;->val$grant:[Z

    aput-boolean v2, v0, v1

    return-void
.end method

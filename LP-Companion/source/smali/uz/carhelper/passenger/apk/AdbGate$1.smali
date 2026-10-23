.class Luz/carhelper/passenger/apk/AdbGate$1;
.super Ljava/lang/Object;
.source "AdbGate.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/AdbGate;->apply(Landroid/app/Activity;Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$revive:Z

.field final synthetic val$rows:[Landroid/view/View;

.field final synthetic val$titles:[Ljava/lang/String;


# direct methods
.method constructor <init>(Landroid/app/Activity;Z[Landroid/view/View;[Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 40
    iput-object p1, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$a:Landroid/app/Activity;

    iput-boolean p2, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$revive:Z

    iput-object p3, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$rows:[Landroid/view/View;

    iput-object p4, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$titles:[Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 42
    iget-object v0, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$a:Landroid/app/Activity;

    const/16 v1, 0x15b3

    iget-boolean v2, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$revive:Z

    const-string v3, "127.0.0.1"

    invoke-static {v0, v3, v1, v2}, Luz/carhelper/passenger/apk/AdbLink;->ensure(Landroid/content/Context;Ljava/lang/String;IZ)Z

    move-result v0

    .line 43
    iget-object v1, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$a:Landroid/app/Activity;

    new-instance v2, Luz/carhelper/passenger/apk/AdbGate$1$1;

    invoke-direct {v2, p0, v0}, Luz/carhelper/passenger/apk/AdbGate$1$1;-><init>(Luz/carhelper/passenger/apk/AdbGate$1;Z)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

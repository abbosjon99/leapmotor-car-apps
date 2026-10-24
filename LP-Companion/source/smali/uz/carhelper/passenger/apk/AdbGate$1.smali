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

.field final synthetic val$heal:Landroid/view/View;

.field final synthetic val$healTitle:Ljava/lang/String;

.field final synthetic val$revive:Z

.field final synthetic val$rows:[Landroid/view/View;

.field final synthetic val$titles:[Ljava/lang/String;


# direct methods
.method constructor <init>(Landroid/app/Activity;Z[Landroid/view/View;[Ljava/lang/String;Landroid/view/View;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 57
    iput-object p1, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$a:Landroid/app/Activity;

    iput-boolean p2, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$revive:Z

    iput-object p3, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$rows:[Landroid/view/View;

    iput-object p4, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$titles:[Ljava/lang/String;

    iput-object p5, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$heal:Landroid/view/View;

    iput-object p6, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$healTitle:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 10

    .line 59
    iget-object v0, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$a:Landroid/app/Activity;

    iget-boolean v1, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$revive:Z

    const-string v2, "127.0.0.1"

    const/16 v3, 0x15b3

    invoke-static {v0, v2, v3, v1}, Luz/carhelper/passenger/apk/AdbLink;->ensure(Landroid/content/Context;Ljava/lang/String;IZ)Z

    move-result v0

    .line 61
    :goto_0
    iget-object v4, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$a:Landroid/app/Activity;

    iget-object v5, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$rows:[Landroid/view/View;

    iget-object v6, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$titles:[Ljava/lang/String;

    iget-object v7, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$heal:Landroid/view/View;

    iget-object v8, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$healTitle:Ljava/lang/String;

    move v9, v0

    invoke-static/range {v4 .. v9}, Luz/carhelper/passenger/apk/AdbGate;->access$000(Landroid/app/Activity;[Landroid/view/View;[Ljava/lang/String;Landroid/view/View;Ljava/lang/String;Z)V

    move v1, v0

    :goto_1
    if-ne v1, v0, :cond_2

    const-wide/16 v4, 0xbb8

    .line 65
    :try_start_0
    invoke-static {v4, v5}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    .line 69
    iget-object v1, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$a:Landroid/app/Activity;

    invoke-virtual {v1}, Landroid/app/Activity;->isFinishing()Z

    move-result v1

    if-nez v1, :cond_1

    iget-object v1, p0, Luz/carhelper/passenger/apk/AdbGate$1;->val$a:Landroid/app/Activity;

    invoke-virtual {v1}, Landroid/app/Activity;->isDestroyed()Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_2

    :cond_0
    const/16 v1, 0x258

    .line 72
    invoke-static {v2, v3, v1}, Luz/carhelper/passenger/adb/AdbRunner;->listening(Ljava/lang/String;II)Z

    move-result v1

    goto :goto_1

    :catch_0
    :cond_1
    :goto_2
    return-void

    :cond_2
    move v0, v1

    goto :goto_0
.end method

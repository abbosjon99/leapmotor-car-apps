.class Luz/carhelper/passenger/apk/InstallDialog$7;
.super Ljava/lang/Object;
.source "InstallDialog.java"

# interfaces
.implements Luz/carhelper/passenger/adb/AdbProgress;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/InstallDialog;->run(Landroid/app/Activity;Ljava/io/File;Luz/carhelper/passenger/apk/ApkInfo;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$bar:Landroid/widget/ProgressBar;

.field final synthetic val$pct:Landroid/widget/TextView;


# direct methods
.method constructor <init>(Landroid/app/Activity;Landroid/widget/ProgressBar;Landroid/widget/TextView;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 203
    iput-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$7;->val$a:Landroid/app/Activity;

    iput-object p2, p0, Luz/carhelper/passenger/apk/InstallDialog$7;->val$bar:Landroid/widget/ProgressBar;

    iput-object p3, p0, Luz/carhelper/passenger/apk/InstallDialog$7;->val$pct:Landroid/widget/TextView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onProgress(JJ)V
    .locals 8

    .line 205
    iget-object v0, p0, Luz/carhelper/passenger/apk/InstallDialog$7;->val$a:Landroid/app/Activity;

    new-instance v7, Luz/carhelper/passenger/apk/InstallDialog$7$1;

    move-object v1, v7

    move-object v2, p0

    move-wide v3, p3

    move-wide v5, p1

    invoke-direct/range {v1 .. v6}, Luz/carhelper/passenger/apk/InstallDialog$7$1;-><init>(Luz/carhelper/passenger/apk/InstallDialog$7;JJ)V

    invoke-virtual {v0, v7}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

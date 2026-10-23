.class Luz/carhelper/passenger/apk/InstallDialog$7$1;
.super Ljava/lang/Object;
.source "InstallDialog.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/InstallDialog$7;->onProgress(JJ)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Luz/carhelper/passenger/apk/InstallDialog$7;

.field final synthetic val$done:J

.field final synthetic val$total:J


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/InstallDialog$7;JJ)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010,
            0x1010
        }
        names = {
            null,
            null,
            null
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 205
    iput-object p1, p0, Luz/carhelper/passenger/apk/InstallDialog$7$1;->this$0:Luz/carhelper/passenger/apk/InstallDialog$7;

    iput-wide p2, p0, Luz/carhelper/passenger/apk/InstallDialog$7$1;->val$total:J

    iput-wide p4, p0, Luz/carhelper/passenger/apk/InstallDialog$7$1;->val$done:J

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 6

    .line 207
    iget-wide v0, p0, Luz/carhelper/passenger/apk/InstallDialog$7$1;->val$total:J

    const-wide/16 v2, 0x0

    cmp-long v2, v0, v2

    if-gtz v2, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    iget-wide v2, p0, Luz/carhelper/passenger/apk/InstallDialog$7$1;->val$done:J

    const-wide/16 v4, 0x3e8

    mul-long/2addr v2, v4

    div-long/2addr v2, v0

    long-to-int v0, v2

    .line 208
    :goto_0
    iget-object v1, p0, Luz/carhelper/passenger/apk/InstallDialog$7$1;->this$0:Luz/carhelper/passenger/apk/InstallDialog$7;

    iget-object v1, v1, Luz/carhelper/passenger/apk/InstallDialog$7;->val$bar:Landroid/widget/ProgressBar;

    invoke-virtual {v1, v0}, Landroid/widget/ProgressBar;->setProgress(I)V

    .line 209
    iget-object v1, p0, Luz/carhelper/passenger/apk/InstallDialog$7$1;->this$0:Luz/carhelper/passenger/apk/InstallDialog$7;

    iget-object v1, v1, Luz/carhelper/passenger/apk/InstallDialog$7;->val$pct:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    div-int/lit8 v0, v0, 0xa

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "%"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.class Luz/carhelper/passenger/apk/AdbGate$1$1;
.super Ljava/lang/Object;
.source "AdbGate.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/AdbGate$1;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Luz/carhelper/passenger/apk/AdbGate$1;

.field final synthetic val$up:Z


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/AdbGate$1;Z)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010
        }
        names = {
            null,
            null
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 43
    iput-object p1, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->this$0:Luz/carhelper/passenger/apk/AdbGate$1;

    iput-boolean p2, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->val$up:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 45
    iget-object v0, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->this$0:Luz/carhelper/passenger/apk/AdbGate$1;

    iget-object v0, v0, Luz/carhelper/passenger/apk/AdbGate$1;->val$a:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-nez v0, :cond_5

    iget-object v0, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->this$0:Luz/carhelper/passenger/apk/AdbGate$1;

    iget-object v0, v0, Luz/carhelper/passenger/apk/AdbGate$1;->val$a:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_5

    :cond_0
    const/4 v0, 0x0

    .line 48
    :goto_0
    iget-object v1, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->this$0:Luz/carhelper/passenger/apk/AdbGate$1;

    iget-object v1, v1, Luz/carhelper/passenger/apk/AdbGate$1;->val$rows:[Landroid/view/View;

    array-length v1, v1

    if-ge v0, v1, :cond_5

    .line 49
    iget-object v1, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->this$0:Luz/carhelper/passenger/apk/AdbGate$1;

    iget-object v1, v1, Luz/carhelper/passenger/apk/AdbGate$1;->val$rows:[Landroid/view/View;

    aget-object v1, v1, v0

    invoke-static {v1}, Luz/carhelper/passenger/apk/AdbGate;->access$000(Landroid/view/View;)Landroid/widget/TextView;

    move-result-object v1

    if-nez v1, :cond_1

    goto :goto_4

    .line 53
    :cond_1
    iget-object v2, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->this$0:Luz/carhelper/passenger/apk/AdbGate$1;

    iget-object v2, v2, Luz/carhelper/passenger/apk/AdbGate$1;->val$rows:[Landroid/view/View;

    aget-object v2, v2, v0

    iget-boolean v3, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->val$up:Z

    if-eqz v3, :cond_2

    invoke-static {}, Luz/carhelper/passenger/apk/AdbGate;->access$100()[Ljava/lang/String;

    move-result-object v3

    aget-object v3, v3, v0

    goto :goto_1

    :cond_2
    const-string v3, "#adboff"

    :goto_1
    invoke-virtual {v2, v3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    .line 54
    iget-object v2, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->this$0:Luz/carhelper/passenger/apk/AdbGate$1;

    iget-object v2, v2, Luz/carhelper/passenger/apk/AdbGate$1;->val$rows:[Landroid/view/View;

    aget-object v2, v2, v0

    iget-boolean v3, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->val$up:Z

    if-eqz v3, :cond_3

    const/high16 v3, 0x3f800000    # 1.0f

    goto :goto_2

    :cond_3
    const v3, 0x3ecccccd    # 0.4f

    :goto_2
    invoke-virtual {v2, v3}, Landroid/view/View;->setAlpha(F)V

    .line 55
    iget-boolean v2, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->val$up:Z

    if-eqz v2, :cond_4

    iget-object v2, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->this$0:Luz/carhelper/passenger/apk/AdbGate$1;

    iget-object v2, v2, Luz/carhelper/passenger/apk/AdbGate$1;->val$titles:[Ljava/lang/String;

    aget-object v2, v2, v0

    goto :goto_3

    :cond_4
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Luz/carhelper/passenger/apk/AdbGate$1$1;->this$0:Luz/carhelper/passenger/apk/AdbGate$1;

    iget-object v3, v3, Luz/carhelper/passenger/apk/AdbGate$1;->val$titles:[Ljava/lang/String;

    aget-object v3, v3, v0

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "  \u00b7  "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "needs ADB"

    invoke-static {v3}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    :goto_3
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :goto_4
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_5
    :goto_5
    return-void
.end method

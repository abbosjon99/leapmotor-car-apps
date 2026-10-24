.class Luz/carhelper/passenger/apk/AdbGate$2;
.super Ljava/lang/Object;
.source "AdbGate.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/AdbGate;->show(Landroid/app/Activity;[Landroid/view/View;[Ljava/lang/String;Landroid/view/View;Ljava/lang/String;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;

.field final synthetic val$heal:Landroid/view/View;

.field final synthetic val$healTitle:Ljava/lang/String;

.field final synthetic val$rows:[Landroid/view/View;

.field final synthetic val$titles:[Ljava/lang/String;

.field final synthetic val$up:Z


# direct methods
.method constructor <init>(Landroid/app/Activity;[Landroid/view/View;Z[Ljava/lang/String;Landroid/view/View;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 84
    iput-object p1, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$a:Landroid/app/Activity;

    iput-object p2, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$rows:[Landroid/view/View;

    iput-boolean p3, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$up:Z

    iput-object p4, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$titles:[Ljava/lang/String;

    iput-object p5, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$heal:Landroid/view/View;

    iput-object p6, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$healTitle:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 8

    .line 86
    iget-object v0, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$a:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-nez v0, :cond_9

    iget-object v0, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$a:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_6

    :cond_0
    const/4 v0, 0x0

    .line 89
    :goto_0
    iget-object v1, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$rows:[Landroid/view/View;

    array-length v2, v1

    const-string v3, "  \u00b7  "

    const/high16 v4, 0x3f800000    # 1.0f

    const v5, 0x3ecccccd    # 0.4f

    const-string v6, "#adboff"

    if-ge v0, v2, :cond_5

    .line 90
    aget-object v1, v1, v0

    invoke-static {v1}, Luz/carhelper/passenger/apk/AdbGate;->access$100(Landroid/view/View;)Landroid/widget/TextView;

    move-result-object v1

    if-nez v1, :cond_1

    goto :goto_3

    .line 94
    :cond_1
    iget-object v2, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$rows:[Landroid/view/View;

    aget-object v2, v2, v0

    iget-boolean v7, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$up:Z

    if-eqz v7, :cond_2

    invoke-static {}, Luz/carhelper/passenger/apk/AdbGate;->access$200()[Ljava/lang/String;

    move-result-object v6

    aget-object v6, v6, v0

    :cond_2
    invoke-virtual {v2, v6}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    .line 95
    iget-object v2, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$rows:[Landroid/view/View;

    aget-object v2, v2, v0

    iget-boolean v6, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$up:Z

    if-eqz v6, :cond_3

    goto :goto_1

    :cond_3
    move v4, v5

    :goto_1
    invoke-virtual {v2, v4}, Landroid/view/View;->setAlpha(F)V

    .line 96
    iget-boolean v2, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$up:Z

    if-eqz v2, :cond_4

    iget-object v2, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$titles:[Ljava/lang/String;

    aget-object v2, v2, v0

    goto :goto_2

    :cond_4
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$titles:[Ljava/lang/String;

    aget-object v4, v4, v0

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "needs ADB"

    invoke-static {v3}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    :goto_2
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :goto_3
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 98
    :cond_5
    iget-object v0, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$heal:Landroid/view/View;

    instance-of v1, v0, Landroid/widget/TextView;

    if-eqz v1, :cond_9

    .line 99
    iget-boolean v1, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$up:Z

    if-eqz v1, :cond_6

    const-string v6, "#heal"

    :cond_6
    invoke-virtual {v0, v6}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    .line 100
    iget-object v0, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$heal:Landroid/view/View;

    iget-boolean v1, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$up:Z

    if-eqz v1, :cond_7

    goto :goto_4

    :cond_7
    move v4, v5

    :goto_4
    invoke-virtual {v0, v4}, Landroid/view/View;->setAlpha(F)V

    .line 101
    iget-object v0, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$heal:Landroid/view/View;

    check-cast v0, Landroid/widget/TextView;

    iget-boolean v1, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$up:Z

    if-eqz v1, :cond_8

    iget-object v1, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$healTitle:Ljava/lang/String;

    goto :goto_5

    .line 102
    :cond_8
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Luz/carhelper/passenger/apk/AdbGate$2;->val$healTitle:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "turn ADB on in the car\'s settings"

    invoke-static {v2}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 101
    :goto_5
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_9
    :goto_6
    return-void
.end method

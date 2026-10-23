.class Luz/carhelper/passenger/apk/Cards$1;
.super Ljava/lang/Object;
.source "Cards.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/Cards;->lock(Landroid/app/Dialog;Landroid/widget/TextView;Ljava/lang/String;I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field left:I

.field final synthetic val$b:Landroid/widget/TextView;

.field final synthetic val$d:Landroid/app/Dialog;

.field final synthetic val$h:Landroid/os/Handler;

.field final synthetic val$label:Ljava/lang/String;

.field final synthetic val$seconds:I


# direct methods
.method constructor <init>(ILandroid/app/Dialog;Landroid/widget/TextView;Ljava/lang/String;Landroid/os/Handler;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 115
    iput p1, p0, Luz/carhelper/passenger/apk/Cards$1;->val$seconds:I

    iput-object p2, p0, Luz/carhelper/passenger/apk/Cards$1;->val$d:Landroid/app/Dialog;

    iput-object p3, p0, Luz/carhelper/passenger/apk/Cards$1;->val$b:Landroid/widget/TextView;

    iput-object p4, p0, Luz/carhelper/passenger/apk/Cards$1;->val$label:Ljava/lang/String;

    iput-object p5, p0, Luz/carhelper/passenger/apk/Cards$1;->val$h:Landroid/os/Handler;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 116
    iput p1, p0, Luz/carhelper/passenger/apk/Cards$1;->left:I

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 119
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$1;->val$d:Landroid/app/Dialog;

    invoke-virtual {v0}, Landroid/app/Dialog;->isShowing()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 122
    :cond_0
    iget v0, p0, Luz/carhelper/passenger/apk/Cards$1;->left:I

    const/4 v1, 0x1

    sub-int/2addr v0, v1

    iput v0, p0, Luz/carhelper/passenger/apk/Cards$1;->left:I

    if-gtz v0, :cond_1

    .line 124
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$1;->val$b:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setEnabled(Z)V

    .line 125
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$1;->val$b:Landroid/widget/TextView;

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setAlpha(F)V

    .line 126
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$1;->val$b:Landroid/widget/TextView;

    iget-object v1, p0, Luz/carhelper/passenger/apk/Cards$1;->val$label:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 128
    :cond_1
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$1;->val$b:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Luz/carhelper/passenger/apk/Cards$1;->val$label:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " ("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Luz/carhelper/passenger/apk/Cards$1;->left:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ")"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 129
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$1;->val$h:Landroid/os/Handler;

    const-wide/16 v1, 0x3e8

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :goto_0
    return-void
.end method

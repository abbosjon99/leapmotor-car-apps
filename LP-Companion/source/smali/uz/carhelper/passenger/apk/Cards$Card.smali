.class final Luz/carhelper/passenger/apk/Cards$Card;
.super Ljava/lang/Object;
.source "Cards.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Luz/carhelper/passenger/apk/Cards;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Card"
.end annotation


# instance fields
.field final act:Landroid/app/Activity;

.field final box:Landroid/widget/LinearLayout;

.field final dialog:Landroid/app/Dialog;


# direct methods
.method constructor <init>(Landroid/app/Activity;I)V
    .locals 5

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 34
    iput-object p1, p0, Luz/carhelper/passenger/apk/Cards$Card;->act:Landroid/app/Activity;

    .line 35
    new-instance v0, Landroid/app/Dialog;

    invoke-direct {v0, p1}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Luz/carhelper/passenger/apk/Cards$Card;->dialog:Landroid/app/Dialog;

    const/4 v1, 0x1

    .line 36
    invoke-virtual {v0, v1}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    .line 37
    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v2, p0, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    .line 38
    invoke-virtual {v2, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const p1, 0x24ffffff

    const/high16 v3, 0x42100000    # 36.0f

    const v4, -0xfebe3d6

    .line 39
    invoke-static {v4, p1, v3}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p1

    invoke-virtual {v2, p1}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    const/16 p1, 0x1e

    const/16 v3, 0x1c

    const/16 v4, 0x24

    .line 40
    invoke-virtual {v2, v4, p1, v4, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 41
    invoke-virtual {v0, v2}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 42
    invoke-virtual {v0, v1}, Landroid/app/Dialog;->setCanceledOnTouchOutside(Z)V

    .line 43
    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    .line 44
    new-instance v0, Landroid/graphics/drawable/ColorDrawable;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V

    invoke-virtual {p1, v0}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    const/4 v0, -0x2

    .line 45
    invoke-virtual {p1, p2, v0}, Landroid/view/Window;->setLayout(II)V

    return-void
.end method


# virtual methods
.method dismiss()V
    .locals 1

    .line 67
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$Card;->dialog:Landroid/app/Dialog;

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    return-void
.end method

.method line(Ljava/lang/String;IFI)Landroid/widget/TextView;
    .locals 2

    .line 56
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$Card;->act:Landroid/app/Activity;

    const/4 v1, 0x0

    invoke-static {v0, p1, p3, p2, v1}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object p1

    .line 57
    invoke-virtual {p1, v1, p4, v1, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 58
    iget-object p2, p0, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    invoke-virtual {p2, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-object p1
.end method

.method show()V
    .locals 1

    .line 63
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$Card;->dialog:Landroid/app/Dialog;

    invoke-virtual {v0}, Landroid/app/Dialog;->show()V

    return-void
.end method

.method title(Ljava/lang/String;)Landroid/widget/TextView;
    .locals 4

    .line 49
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$Card;->act:Landroid/app/Activity;

    const/4 v1, -0x1

    const/4 v2, 0x1

    const/high16 v3, 0x41f00000    # 30.0f

    invoke-static {v0, p1, v3, v1, v2}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object p1

    const/4 v0, 0x0

    const/16 v1, 0xa

    .line 50
    invoke-virtual {p1, v0, v0, v0, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 51
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    invoke-virtual {v0, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-object p1
.end method

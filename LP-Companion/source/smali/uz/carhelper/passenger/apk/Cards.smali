.class final Luz/carhelper/passenger/apk/Cards;
.super Ljava/lang/Object;
.source "Cards.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Luz/carhelper/passenger/apk/Cards$Card;
    }
.end annotation


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static T(Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    .line 24
    invoke-static {p0}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static accent(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;
    .locals 6

    const v3, -0xd08b27

    const/4 v4, 0x0

    const v2, -0xc27401

    move-object v0, p0

    move-object v1, p1

    move-object v5, p2

    .line 87
    invoke-static/range {v0 .. v5}, Luz/carhelper/passenger/apk/Cards;->button(Landroid/app/Activity;Ljava/lang/String;IIILandroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object p0

    return-object p0
.end method

.method static button(Landroid/app/Activity;Ljava/lang/String;IIILandroid/view/View$OnClickListener;)Landroid/widget/TextView;
    .locals 0

    .line 77
    invoke-static {p0, p1, p2, p3, p4}, Luz/carhelper/passenger/Ui;->pill(Landroid/content/Context;Ljava/lang/CharSequence;III)Landroid/widget/TextView;

    move-result-object p0

    .line 78
    invoke-virtual {p0, p5}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-object p0
.end method

.method static buttons(Landroid/app/Activity;Landroid/view/View;Landroid/view/View;)Landroid/widget/LinearLayout;
    .locals 3

    .line 96
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/16 v1, 0x10

    .line 97
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/4 v1, 0x0

    const/16 v2, 0x16

    .line 98
    invoke-virtual {v0, v1, v2, v1, v1}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 99
    invoke-virtual {v0, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 100
    new-instance p1, Landroid/view/View;

    invoke-direct {p1, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 101
    new-instance p0, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v1, 0x1

    const/high16 v2, 0x3f800000    # 1.0f

    invoke-direct {p0, v1, v1, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v0, p1, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 102
    invoke-virtual {v0, p2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-object v0
.end method

.method static capHeight(Landroid/widget/ScrollView;I)V
    .locals 2

    .line 137
    invoke-virtual {p0}, Landroid/widget/ScrollView;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    new-instance v1, Luz/carhelper/passenger/apk/Cards$2;

    invoke-direct {v1, p0, p1}, Luz/carhelper/passenger/apk/Cards$2;-><init>(Landroid/widget/ScrollView;I)V

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->addOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    return-void
.end method

.method static grey(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;
    .locals 6

    const v3, 0x44ffffff    # 2047.9999f

    const v4, 0x24ffffff

    const v2, 0x2effffff

    move-object v0, p0

    move-object v1, p1

    move-object v5, p2

    .line 83
    invoke-static/range {v0 .. v5}, Luz/carhelper/passenger/apk/Cards;->button(Landroid/app/Activity;Ljava/lang/String;IIILandroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object p0

    return-object p0
.end method

.method static lock(Landroid/app/Dialog;Landroid/widget/TextView;Ljava/lang/String;I)V
    .locals 8

    .line 111
    new-instance v6, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {v6, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    const/4 v0, 0x0

    .line 112
    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setEnabled(Z)V

    const v0, 0x3ee66666    # 0.45f

    .line 113
    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setAlpha(F)V

    .line 114
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " ("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ")"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 115
    new-instance v7, Luz/carhelper/passenger/apk/Cards$1;

    move-object v0, v7

    move v1, p3

    move-object v2, p0

    move-object v3, p1

    move-object v4, p2

    move-object v5, v6

    invoke-direct/range {v0 .. v5}, Luz/carhelper/passenger/apk/Cards$1;-><init>(ILandroid/app/Dialog;Landroid/widget/TextView;Ljava/lang/String;Landroid/os/Handler;)V

    const-wide/16 p0, 0x3e8

    invoke-virtual {v6, v7, p0, p1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method static red(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;
    .locals 6

    const v3, -0x36c5c1

    const/4 v4, 0x0

    const v2, -0x1ab7b3

    move-object v0, p0

    move-object v1, p1

    move-object v5, p2

    .line 91
    invoke-static/range {v0 .. v5}, Luz/carhelper/passenger/apk/Cards;->button(Landroid/app/Activity;Ljava/lang/String;IIILandroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object p0

    return-object p0
.end method

.method static size(J)Ljava/lang/String;
    .locals 6

    const-wide/16 v0, 0x400

    cmp-long v0, p0, v0

    if-gez v0, :cond_0

    .line 150
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p0, " B"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    long-to-double p0, p0

    const-wide/high16 v0, 0x4090000000000000L    # 1024.0

    div-double/2addr p0, v0

    .line 153
    const-string v2, "MB"

    const-string v3, "GB"

    const-string v4, "KB"

    filled-new-array {v4, v2, v3}, [Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    :goto_0
    cmpl-double v4, p0, v0

    if-ltz v4, :cond_1

    const/4 v4, 0x2

    if-ge v3, v4, :cond_1

    div-double/2addr p0, v0

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 159
    :cond_1
    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    const-wide/high16 v4, 0x4059000000000000L    # 100.0

    cmpl-double v1, p0, v4

    if-ltz v1, :cond_2

    const-string v1, "%.0f %s"

    goto :goto_1

    :cond_2
    const-string v1, "%.1f %s"

    :goto_1
    invoke-static {p0, p1}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p0

    aget-object p1, v2, v3

    filled-new-array {p0, p1}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v0, v1, p0}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static width(Landroid/app/Activity;I)I
    .locals 0

    .line 72
    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->widthPixels:I

    add-int/lit8 p0, p0, -0x50

    .line 73
    invoke-static {p1, p0}, Ljava/lang/Math;->min(II)I

    move-result p0

    return p0
.end method

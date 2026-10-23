.class public final Luz/carhelper/passenger/apk/AdbGate;
.super Ljava/lang/Object;
.source "AdbGate.java"


# static fields
.field private static final TAGS:[Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 20
    const-string v0, "#files"

    const-string v1, "#uninstall"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Luz/carhelper/passenger/apk/AdbGate;->TAGS:[Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/view/View;)Landroid/widget/TextView;
    .locals 0

    .line 16
    invoke-static {p0}, Luz/carhelper/passenger/apk/AdbGate;->titleOf(Landroid/view/View;)Landroid/widget/TextView;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$100()[Ljava/lang/String;
    .locals 1

    .line 16
    sget-object v0, Luz/carhelper/passenger/apk/AdbGate;->TAGS:[Ljava/lang/String;

    return-object v0
.end method

.method public static apply(Landroid/app/Activity;Landroid/view/View;)V
    .locals 8

    .line 23
    sget-object v0, Luz/carhelper/passenger/apk/AdbGate;->TAGS:[Ljava/lang/String;

    array-length v1, v0

    new-array v1, v1, [Landroid/view/View;

    .line 24
    array-length v0, v0

    new-array v0, v0, [Ljava/lang/String;

    const/4 v2, 0x0

    move v3, v2

    move v4, v3

    .line 26
    :goto_0
    sget-object v5, Luz/carhelper/passenger/apk/AdbGate;->TAGS:[Ljava/lang/String;

    array-length v6, v5

    const/4 v7, 0x1

    if-ge v3, v6, :cond_1

    .line 27
    aget-object v5, v5, v3

    invoke-virtual {p1, v5}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v5

    aput-object v5, v1, v3

    .line 28
    invoke-static {v5}, Luz/carhelper/passenger/apk/AdbGate;->titleOf(Landroid/view/View;)Landroid/widget/TextView;

    move-result-object v5

    if-eqz v5, :cond_0

    .line 30
    invoke-virtual {v5}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v4

    invoke-interface {v4}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v4

    aput-object v4, v0, v3

    .line 32
    aget-object v4, v1, v3

    const/high16 v5, 0x3f000000    # 0.5f

    invoke-virtual {v4, v5}, Landroid/view/View;->setAlpha(F)V

    .line 33
    aget-object v4, v1, v3

    const-string v5, "#adboff"

    invoke-virtual {v4, v5}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    move v4, v7

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_1
    if-nez v4, :cond_2

    return-void

    .line 39
    :cond_2
    const-string p1, "apps"

    invoke-virtual {p0, p1, v2}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p1

    const-string v2, "healAdb"

    invoke-interface {p1, v2, v7}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p1

    .line 40
    new-instance v2, Ljava/lang/Thread;

    new-instance v3, Luz/carhelper/passenger/apk/AdbGate$1;

    invoke-direct {v3, p0, p1, v1, v0}, Luz/carhelper/passenger/apk/AdbGate$1;-><init>(Landroid/app/Activity;Z[Landroid/view/View;[Ljava/lang/String;)V

    invoke-direct {v2, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 61
    invoke-virtual {v2}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private static titleOf(Landroid/view/View;)Landroid/widget/TextView;
    .locals 2

    .line 65
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_0

    check-cast p0, Landroid/view/ViewGroup;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-lez v0, :cond_0

    const/4 v0, 0x0

    .line 66
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    instance-of v1, v1, Landroid/widget/TextView;

    if-eqz v1, :cond_0

    .line 67
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object p0

    check-cast p0, Landroid/widget/TextView;

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

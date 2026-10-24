.class public final Luz/carhelper/passenger/apk/AdbGate;
.super Ljava/lang/Object;
.source "AdbGate.java"


# static fields
.field private static final HEAL:Ljava/lang/String; = "#heal"

.field private static final POLL_MS:J = 0xbb8L

.field private static final TAGS:[Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 25
    const-string v0, "#files"

    const-string v1, "#uninstall"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Luz/carhelper/passenger/apk/AdbGate;->TAGS:[Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/app/Activity;[Landroid/view/View;[Ljava/lang/String;Landroid/view/View;Ljava/lang/String;Z)V
    .locals 0

    .line 21
    invoke-static/range {p0 .. p5}, Luz/carhelper/passenger/apk/AdbGate;->show(Landroid/app/Activity;[Landroid/view/View;[Ljava/lang/String;Landroid/view/View;Ljava/lang/String;Z)V

    return-void
.end method

.method static synthetic access$100(Landroid/view/View;)Landroid/widget/TextView;
    .locals 0

    .line 21
    invoke-static {p0}, Luz/carhelper/passenger/apk/AdbGate;->titleOf(Landroid/view/View;)Landroid/widget/TextView;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$200()[Ljava/lang/String;
    .locals 1

    .line 21
    sget-object v0, Luz/carhelper/passenger/apk/AdbGate;->TAGS:[Ljava/lang/String;

    return-object v0
.end method

.method public static apply(Landroid/app/Activity;Landroid/view/View;)V
    .locals 10

    .line 30
    sget-object v0, Luz/carhelper/passenger/apk/AdbGate;->TAGS:[Ljava/lang/String;

    array-length v1, v0

    new-array v5, v1, [Landroid/view/View;

    .line 31
    array-length v0, v0

    new-array v6, v0, [Ljava/lang/String;

    const/4 v0, 0x0

    move v1, v0

    move v2, v1

    .line 33
    :goto_0
    sget-object v3, Luz/carhelper/passenger/apk/AdbGate;->TAGS:[Ljava/lang/String;

    array-length v4, v3

    const-string v7, "#adboff"

    const/high16 v8, 0x3f000000    # 0.5f

    const/4 v9, 0x1

    if-ge v1, v4, :cond_1

    .line 34
    aget-object v3, v3, v1

    invoke-virtual {p1, v3}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v3

    aput-object v3, v5, v1

    .line 35
    invoke-static {v3}, Luz/carhelper/passenger/apk/AdbGate;->titleOf(Landroid/view/View;)Landroid/widget/TextView;

    move-result-object v3

    if-eqz v3, :cond_0

    .line 37
    invoke-virtual {v3}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    aput-object v2, v6, v1

    .line 39
    aget-object v2, v5, v1

    invoke-virtual {v2, v8}, Landroid/view/View;->setAlpha(F)V

    .line 40
    aget-object v2, v5, v1

    invoke-virtual {v2, v7}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    move v2, v9

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 43
    :cond_1
    const-string v1, "#heal"

    invoke-virtual {p1, v1}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object p1

    .line 45
    instance-of v1, p1, Landroid/widget/TextView;

    if-eqz v1, :cond_2

    .line 46
    move-object v1, p1

    check-cast v1, Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v1

    invoke-interface {v1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v1

    .line 47
    invoke-virtual {p1, v8}, Landroid/view/View;->setAlpha(F)V

    .line 48
    invoke-virtual {p1, v7}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    move-object v8, v1

    move v2, v9

    goto :goto_1

    :cond_2
    const/4 v1, 0x0

    move-object v8, v1

    :goto_1
    if-nez v2, :cond_3

    return-void

    .line 56
    :cond_3
    const-string v1, "apps"

    invoke-virtual {p0, v1, v0}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "healAdb"

    invoke-interface {v0, v1, v9}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v4

    .line 57
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Luz/carhelper/passenger/apk/AdbGate$1;

    move-object v2, v1

    move-object v3, p0

    move-object v7, p1

    invoke-direct/range {v2 .. v8}, Luz/carhelper/passenger/apk/AdbGate$1;-><init>(Landroid/app/Activity;Z[Landroid/view/View;[Ljava/lang/String;Landroid/view/View;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 78
    invoke-virtual {v0, v9}, Ljava/lang/Thread;->setDaemon(Z)V

    .line 79
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private static show(Landroid/app/Activity;[Landroid/view/View;[Ljava/lang/String;Landroid/view/View;Ljava/lang/String;Z)V
    .locals 8

    .line 84
    new-instance v7, Luz/carhelper/passenger/apk/AdbGate$2;

    move-object v0, v7

    move-object v1, p0

    move-object v2, p1

    move v3, p5

    move-object v4, p2

    move-object v5, p3

    move-object v6, p4

    invoke-direct/range {v0 .. v6}, Luz/carhelper/passenger/apk/AdbGate$2;-><init>(Landroid/app/Activity;[Landroid/view/View;Z[Ljava/lang/String;Landroid/view/View;Ljava/lang/String;)V

    invoke-virtual {p0, v7}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static titleOf(Landroid/view/View;)Landroid/widget/TextView;
    .locals 2

    .line 109
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_0

    check-cast p0, Landroid/view/ViewGroup;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-lez v0, :cond_0

    const/4 v0, 0x0

    .line 110
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    instance-of v1, v1, Landroid/widget/TextView;

    if-eqz v1, :cond_0

    .line 111
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object p0

    check-cast p0, Landroid/widget/TextView;

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

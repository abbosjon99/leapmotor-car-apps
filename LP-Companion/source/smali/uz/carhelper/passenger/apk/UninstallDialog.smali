.class public final Luz/carhelper/passenger/apk/UninstallDialog;
.super Ljava/lang/Object;
.source "UninstallDialog.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 27
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/app/Activity;Luz/carhelper/passenger/apk/ApkStore$Entry;Landroid/widget/LinearLayout;)V
    .locals 0

    .line 26
    invoke-static {p0, p1, p2}, Luz/carhelper/passenger/apk/UninstallDialog;->confirm(Landroid/app/Activity;Luz/carhelper/passenger/apk/ApkStore$Entry;Landroid/widget/LinearLayout;)V

    return-void
.end method

.method static synthetic access$100(Landroid/app/Activity;Landroid/widget/LinearLayout;)V
    .locals 0

    .line 26
    invoke-static {p0, p1}, Luz/carhelper/passenger/apk/UninstallDialog;->fill(Landroid/app/Activity;Landroid/widget/LinearLayout;)V

    return-void
.end method

.method private static confirm(Landroid/app/Activity;Luz/carhelper/passenger/apk/ApkStore$Entry;Landroid/widget/LinearLayout;)V
    .locals 5

    .line 103
    new-instance v0, Luz/carhelper/passenger/apk/Cards$Card;

    const/16 v1, 0x35c

    invoke-static {p0, v1}, Luz/carhelper/passenger/apk/Cards;->width(Landroid/app/Activity;I)I

    move-result v1

    invoke-direct {v0, p0, v1}, Luz/carhelper/passenger/apk/Cards$Card;-><init>(Landroid/app/Activity;I)V

    .line 104
    const-string v1, "Uninstall this app?"

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Luz/carhelper/passenger/apk/Cards$Card;->title(Ljava/lang/String;)Landroid/widget/TextView;

    .line 105
    iget-object v1, p1, Luz/carhelper/passenger/apk/ApkStore$Entry;->label:Ljava/lang/String;

    const/high16 v2, 0x41c00000    # 24.0f

    const/4 v3, 0x0

    const/4 v4, -0x1

    invoke-virtual {v0, v1, v4, v2, v3}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 106
    iget-object v1, p1, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    const/high16 v2, 0x41800000    # 16.0f

    const/4 v3, 0x2

    const v4, -0x7f000001

    invoke-virtual {v0, v1, v4, v2, v3}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 107
    const-string v1, "The app and its data are deleted. This cannot be undone."

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const/high16 v2, 0x41a00000    # 20.0f

    const/16 v3, 0xc

    const v4, -0x9495

    invoke-virtual {v0, v1, v4, v2, v3}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 108
    const-string v1, "Cancel"

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Luz/carhelper/passenger/apk/UninstallDialog$3;

    invoke-direct {v2, v0}, Luz/carhelper/passenger/apk/UninstallDialog$3;-><init>(Luz/carhelper/passenger/apk/Cards$Card;)V

    invoke-static {p0, v1, v2}, Luz/carhelper/passenger/apk/Cards;->grey(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v1

    .line 113
    const-string v2, "Uninstall"

    invoke-static {v2}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    new-instance v4, Luz/carhelper/passenger/apk/UninstallDialog$4;

    invoke-direct {v4, v0, p0, p1, p2}, Luz/carhelper/passenger/apk/UninstallDialog$4;-><init>(Luz/carhelper/passenger/apk/Cards$Card;Landroid/app/Activity;Luz/carhelper/passenger/apk/ApkStore$Entry;Landroid/widget/LinearLayout;)V

    invoke-static {p0, v3, v4}, Luz/carhelper/passenger/apk/Cards;->red(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object p1

    .line 130
    iget-object p2, v0, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    invoke-static {p0, v1, p1}, Luz/carhelper/passenger/apk/Cards;->buttons(Landroid/app/Activity;Landroid/view/View;Landroid/view/View;)Landroid/widget/LinearLayout;

    move-result-object p0

    invoke-virtual {p2, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 131
    invoke-virtual {v0}, Luz/carhelper/passenger/apk/Cards$Card;->show()V

    .line 132
    iget-object p0, v0, Luz/carhelper/passenger/apk/Cards$Card;->dialog:Landroid/app/Dialog;

    invoke-static {v2}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    const/16 v0, 0xa

    invoke-static {p0, p1, p2, v0}, Luz/carhelper/passenger/apk/Cards;->lock(Landroid/app/Dialog;Landroid/widget/TextView;Ljava/lang/String;I)V

    return-void
.end method

.method private static fill(Landroid/app/Activity;Landroid/widget/LinearLayout;)V
    .locals 12

    .line 54
    invoke-virtual {p1}, Landroid/widget/LinearLayout;->removeAllViews()V

    .line 55
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    .line 56
    invoke-static {p0}, Luz/carhelper/passenger/apk/ApkStore;->all(Landroid/content/Context;)Ljava/util/List;

    move-result-object v1

    .line 58
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v2

    const/4 v3, 0x1

    sub-int/2addr v2, v3

    const/4 v4, 0x0

    move v5, v4

    :goto_0
    const/16 v6, 0x10

    if-ltz v2, :cond_2

    .line 59
    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Luz/carhelper/passenger/apk/ApkStore$Entry;

    .line 60
    iget-object v8, v7, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_0

    goto/16 :goto_2

    .line 65
    :cond_0
    :try_start_0
    iget-object v8, v7, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    invoke-virtual {v0, v8}, Landroid/content/pm/PackageManager;->getApplicationIcon(Ljava/lang/String;)Landroid/graphics/drawable/Drawable;

    move-result-object v8
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    add-int/lit8 v5, v5, 0x1

    .line 71
    new-instance v9, Landroid/widget/LinearLayout;

    invoke-direct {v9, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 72
    invoke-virtual {v9, v6}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v6, 0x12

    const/16 v10, 0xe

    .line 73
    invoke-virtual {v9, v6, v10, v6, v10}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    const v6, 0x22ffffff

    const/high16 v10, 0x41c00000    # 24.0f

    .line 74
    invoke-static {v4, v6, v4, v10}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;

    move-result-object v6

    invoke-virtual {v9, v6}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 75
    new-instance v6, Landroid/widget/ImageView;

    invoke-direct {v6, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    .line 76
    invoke-virtual {v6, v8}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 77
    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v10, 0x38

    invoke-direct {v8, v10, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v9, v6, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 78
    new-instance v6, Landroid/widget/LinearLayout;

    invoke-direct {v6, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 79
    invoke-virtual {v6, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v8, 0x14

    .line 80
    invoke-virtual {v6, v8, v4, v8, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 81
    iget-object v8, v7, Luz/carhelper/passenger/apk/ApkStore$Entry;->label:Ljava/lang/String;

    const/high16 v10, 0x41d00000    # 26.0f

    const/4 v11, -0x1

    invoke-static {p0, v8, v10, v11, v4}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v8

    .line 82
    invoke-virtual {v8, v3}, Landroid/widget/TextView;->setSingleLine(Z)V

    .line 83
    sget-object v10, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v8, v10}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    .line 84
    invoke-virtual {v6, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 85
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v10, v7, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v10, v7, Luz/carhelper/passenger/apk/ApkStore$Entry;->version:Ljava/lang/String;

    invoke-virtual {v10}, Ljava/lang/String;->length()I

    move-result v10

    if-lez v10, :cond_1

    new-instance v10, Ljava/lang/StringBuilder;

    const-string v11, "   "

    invoke-direct {v10, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v11, v7, Luz/carhelper/passenger/apk/ApkStore$Entry;->version:Ljava/lang/String;

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    goto :goto_1

    :cond_1
    const-string v10, ""

    :goto_1
    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    const/high16 v10, 0x41800000    # 16.0f

    const v11, -0x7f000001

    invoke-static {p0, v8, v10, v11, v4}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v8

    invoke-virtual {v6, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 86
    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v10, -0x2

    const/high16 v11, 0x3f800000    # 1.0f

    invoke-direct {v8, v4, v10, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v9, v6, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 87
    const-string v6, "Uninstall"

    invoke-static {v6}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    const/high16 v8, 0x41a00000    # 20.0f

    const v10, -0x9495

    invoke-static {p0, v6, v8, v10, v3}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v6

    invoke-virtual {v9, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 88
    new-instance v6, Luz/carhelper/passenger/apk/UninstallDialog$2;

    invoke-direct {v6, p0, v7, p1}, Luz/carhelper/passenger/apk/UninstallDialog$2;-><init>(Landroid/app/Activity;Luz/carhelper/passenger/apk/ApkStore$Entry;Landroid/widget/LinearLayout;)V

    invoke-virtual {v9, v6}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 93
    invoke-virtual {p1, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    goto :goto_2

    .line 67
    :catch_0
    iget-object v6, v7, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    invoke-static {p0, v6}, Luz/carhelper/passenger/apk/ApkStore;->remove(Landroid/content/Context;Ljava/lang/String;)V

    :goto_2
    add-int/lit8 v2, v2, -0x1

    goto/16 :goto_0

    :cond_2
    if-nez v5, :cond_3

    .line 96
    const-string v0, "Nothing installed from here yet."

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/high16 v1, 0x41b00000    # 22.0f

    const v2, -0x4c000001

    invoke-static {p0, v0, v1, v2, v4}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object p0

    const/4 v0, 0x6

    .line 97
    invoke-virtual {p0, v0, v6, v0, v6}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 98
    invoke-virtual {p1, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :cond_3
    return-void
.end method

.method public static show(Landroid/app/Activity;)V
    .locals 6

    .line 31
    new-instance v0, Luz/carhelper/passenger/apk/Cards$Card;

    const/16 v1, 0x384

    invoke-static {p0, v1}, Luz/carhelper/passenger/apk/Cards;->width(Landroid/app/Activity;I)I

    move-result v1

    invoke-direct {v0, p0, v1}, Luz/carhelper/passenger/apk/Cards$Card;-><init>(Landroid/app/Activity;I)V

    .line 32
    const-string v1, "Uninstall apps"

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Luz/carhelper/passenger/apk/Cards$Card;->title(Ljava/lang/String;)Landroid/widget/TextView;

    .line 33
    const-string v1, "Only apps installed from LP Companion are listed."

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const v2, -0x7f000001

    const/high16 v3, 0x41900000    # 18.0f

    const/4 v4, 0x0

    invoke-virtual {v0, v1, v2, v3, v4}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 34
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x1

    .line 35
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 36
    new-instance v2, Landroid/widget/ScrollView;

    invoke-direct {v2, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    .line 37
    invoke-virtual {v2, v4}, Landroid/widget/ScrollView;->setVerticalScrollBarEnabled(Z)V

    .line 38
    invoke-virtual {v2, v1}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    .line 39
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v4, 0xe

    .line 40
    iput v4, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 41
    iget-object v4, v0, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    invoke-virtual {v4, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const/16 v3, 0x14a

    .line 42
    invoke-static {v2, v3}, Luz/carhelper/passenger/apk/Cards;->capHeight(Landroid/widget/ScrollView;I)V

    .line 43
    iget-object v2, v0, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    const-string v3, "Close"

    invoke-static {v3}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    new-instance v4, Luz/carhelper/passenger/apk/UninstallDialog$1;

    invoke-direct {v4, v0}, Luz/carhelper/passenger/apk/UninstallDialog$1;-><init>(Luz/carhelper/passenger/apk/Cards$Card;)V

    invoke-static {p0, v3, v4}, Luz/carhelper/passenger/apk/Cards;->grey(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v3

    new-instance v4, Landroid/view/View;

    invoke-direct {v4, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    invoke-static {p0, v3, v4}, Luz/carhelper/passenger/apk/Cards;->buttons(Landroid/app/Activity;Landroid/view/View;Landroid/view/View;)Landroid/widget/LinearLayout;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 48
    invoke-static {p0, v1}, Luz/carhelper/passenger/apk/UninstallDialog;->fill(Landroid/app/Activity;Landroid/widget/LinearLayout;)V

    .line 49
    invoke-virtual {v0}, Luz/carhelper/passenger/apk/Cards$Card;->show()V

    return-void
.end method

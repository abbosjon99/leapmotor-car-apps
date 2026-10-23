.class public Luz/carhelper/passenger/apk/ApkManagerActivity;
.super Landroid/app/Activity;
.source "ApkManagerActivity.java"


# instance fields
.field private column:Landroid/widget/LinearLayout;

.field private dir:Ljava/io/File;

.field private firstShow:Z

.field private rootIndex:I

.field private roots:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Luz/carhelper/passenger/apk/Roots$Root;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 28
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    const/4 v0, 0x0

    .line 30
    iput v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->rootIndex:I

    const/4 v0, 0x1

    .line 33
    iput-boolean v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->firstShow:Z

    return-void
.end method

.method static synthetic access$000(Luz/carhelper/passenger/apk/ApkManagerActivity;)V
    .locals 0

    .line 28
    invoke-direct {p0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->refresh()V

    return-void
.end method

.method static synthetic access$100(Luz/carhelper/passenger/apk/ApkManagerActivity;)I
    .locals 0

    .line 28
    iget p0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->rootIndex:I

    return p0
.end method

.method static synthetic access$102(Luz/carhelper/passenger/apk/ApkManagerActivity;I)I
    .locals 0

    .line 28
    iput p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->rootIndex:I

    return p1
.end method

.method static synthetic access$200(Luz/carhelper/passenger/apk/ApkManagerActivity;)Ljava/io/File;
    .locals 0

    .line 28
    iget-object p0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    return-object p0
.end method

.method static synthetic access$202(Luz/carhelper/passenger/apk/ApkManagerActivity;Ljava/io/File;)Ljava/io/File;
    .locals 0

    .line 28
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    return-object p1
.end method

.method static synthetic access$300(Luz/carhelper/passenger/apk/ApkManagerActivity;)Ljava/util/List;
    .locals 0

    .line 28
    iget-object p0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->roots:Ljava/util/List;

    return-object p0
.end method

.method static synthetic access$302(Luz/carhelper/passenger/apk/ApkManagerActivity;Ljava/util/List;)Ljava/util/List;
    .locals 0

    .line 28
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->roots:Ljava/util/List;

    return-object p1
.end method

.method private pill(Ljava/lang/String;ZLandroid/view/View$OnClickListener;)Landroid/widget/TextView;
    .locals 0

    if-eqz p2, :cond_0

    .line 79
    invoke-static {p0, p1, p3}, Luz/carhelper/passenger/apk/Cards;->accent(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object p1

    goto :goto_0

    :cond_0
    invoke-static {p0, p1, p3}, Luz/carhelper/passenger/apk/Cards;->grey(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object p1

    :goto_0
    return-object p1
.end method

.method private refresh()V
    .locals 16

    move-object/from16 v0, p0

    .line 83
    const-string v1, "/"

    iget-object v2, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->column:Landroid/widget/LinearLayout;

    invoke-virtual {v2}, Landroid/widget/LinearLayout;->removeAllViews()V

    .line 84
    iget-object v2, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->roots:Ljava/util/List;

    iget v3, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->rootIndex:I

    invoke-interface {v2, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Luz/carhelper/passenger/apk/Roots$Root;

    .line 87
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/16 v4, 0x10

    .line 88
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 89
    new-instance v5, Landroid/widget/LinearLayout;

    invoke-direct {v5, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v6, 0x1

    .line 90
    invoke-virtual {v5, v6}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 91
    const-string v7, "Install apps from storage"

    invoke-static {v7}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const/high16 v8, 0x42080000    # 34.0f

    const/4 v9, -0x1

    invoke-static {v0, v7, v8, v9, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v7

    invoke-virtual {v5, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 92
    const-string v7, "Tap an app to install it. Only plain .apk files are installed."

    invoke-static {v7}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const/high16 v8, 0x41900000    # 18.0f

    const v10, -0x7f000001

    const/4 v11, 0x0

    invoke-static {v0, v7, v8, v10, v11}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v7

    invoke-virtual {v5, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 93
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v8, -0x2

    const/high16 v10, 0x3f800000    # 1.0f

    invoke-direct {v7, v11, v8, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v5, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 94
    const-string v5, "Close"

    invoke-static {v5}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    new-instance v7, Luz/carhelper/passenger/apk/ApkManagerActivity$1;

    invoke-direct {v7, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity$1;-><init>(Luz/carhelper/passenger/apk/ApkManagerActivity;)V

    invoke-static {v0, v5, v7}, Luz/carhelper/passenger/apk/Cards;->grey(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v5

    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 99
    iget-object v5, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->column:Landroid/widget/LinearLayout;

    invoke-virtual {v5, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 102
    invoke-static {}, Luz/carhelper/passenger/apk/Installer;->allFiles()Z

    move-result v3

    const/16 v5, 0x16

    const/high16 v7, 0x41b00000    # 22.0f

    const/high16 v12, 0x42100000    # 36.0f

    const v13, 0x24ffffff

    const v14, 0x1affffff

    const/16 v15, 0x1c

    if-nez v3, :cond_0

    .line 103
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 104
    invoke-virtual {v1, v6}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 105
    invoke-static {v14, v13, v12}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    const/16 v2, 0x24

    const/16 v3, 0x1e

    .line 106
    invoke-virtual {v1, v2, v3, v2, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 107
    const-string v2, "To see the files, this app needs All files access. The car\'s ADB can grant it."

    invoke-static {v2}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2, v7, v9, v11}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 108
    const-string v2, "Grant access"

    invoke-static {v2}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    new-instance v3, Luz/carhelper/passenger/apk/ApkManagerActivity$2;

    invoke-direct {v3, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity$2;-><init>(Luz/carhelper/passenger/apk/ApkManagerActivity;)V

    invoke-static {v0, v2, v3}, Luz/carhelper/passenger/apk/Cards;->accent(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v2

    .line 119
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v3, v8, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 120
    iput v5, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 121
    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 122
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v2, v9, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 123
    iput v15, v2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 124
    iget-object v3, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->column:Landroid/widget/LinearLayout;

    invoke-virtual {v3, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-void

    .line 129
    :cond_0
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 130
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 131
    invoke-virtual {v3, v11, v15, v11, v11}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    move v9, v11

    .line 132
    :goto_0
    iget-object v15, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->roots:Ljava/util/List;

    invoke-interface {v15}, Ljava/util/List;->size()I

    move-result v15

    if-ge v9, v15, :cond_2

    .line 134
    iget-object v15, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->roots:Ljava/util/List;

    invoke-interface {v15, v9}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v15

    check-cast v15, Luz/carhelper/passenger/apk/Roots$Root;

    iget-object v15, v15, Luz/carhelper/passenger/apk/Roots$Root;->label:Ljava/lang/String;

    iget v7, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->rootIndex:I

    if-ne v9, v7, :cond_1

    move v7, v6

    goto :goto_1

    :cond_1
    move v7, v11

    :goto_1
    new-instance v12, Luz/carhelper/passenger/apk/ApkManagerActivity$3;

    invoke-direct {v12, v0, v9}, Luz/carhelper/passenger/apk/ApkManagerActivity$3;-><init>(Luz/carhelper/passenger/apk/ApkManagerActivity;I)V

    invoke-direct {v0, v15, v7, v12}, Luz/carhelper/passenger/apk/ApkManagerActivity;->pill(Ljava/lang/String;ZLandroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v7

    .line 141
    new-instance v12, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v12, v8, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v15, 0xe

    .line 142
    iput v15, v12, Landroid/widget/LinearLayout$LayoutParams;->rightMargin:I

    .line 143
    invoke-virtual {v3, v7, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    add-int/lit8 v9, v9, 0x1

    const/high16 v7, 0x41b00000    # 22.0f

    const/high16 v12, 0x42100000    # 36.0f

    goto :goto_0

    .line 145
    :cond_2
    new-instance v7, Landroid/view/View;

    invoke-direct {v7, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 146
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v9, v6, v6, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v7, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 147
    const-string v7, "Refresh"

    invoke-static {v7}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    new-instance v9, Luz/carhelper/passenger/apk/ApkManagerActivity$4;

    invoke-direct {v9, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity$4;-><init>(Luz/carhelper/passenger/apk/ApkManagerActivity;)V

    invoke-static {v0, v7, v9}, Luz/carhelper/passenger/apk/Cards;->grey(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v7

    invoke-virtual {v3, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 157
    iget-object v7, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->column:Landroid/widget/LinearLayout;

    invoke-virtual {v7, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 160
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 161
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v4, 0xc

    .line 162
    invoke-virtual {v3, v11, v5, v11, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 165
    :try_start_0
    iget-object v4, v2, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    invoke-virtual {v4}, Ljava/io/File;->getCanonicalPath()Ljava/lang/String;

    move-result-object v4

    .line 166
    iget-object v5, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    invoke-virtual {v5}, Ljava/io/File;->getCanonicalPath()Ljava/lang/String;

    move-result-object v5

    .line 167
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v7

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v9

    if-le v7, v9, :cond_3

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    invoke-virtual {v5, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 170
    :catch_0
    :cond_3
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v5, v2, Luz/carhelper/passenger/apk/Roots$Root;->label:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "  "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/high16 v4, 0x41a00000    # 20.0f

    const v5, -0x4c000001

    invoke-static {v0, v1, v4, v5, v11}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v1

    .line 171
    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setSingleLine(Z)V

    .line 172
    sget-object v4, Landroid/text/TextUtils$TruncateAt;->MIDDLE:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    .line 173
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v4, v11, v8, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 174
    iget-object v1, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    iget-object v4, v2, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    invoke-virtual {v1, v4}, Ljava/io/File;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_4

    iget-object v1, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    invoke-virtual {v1}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v1

    if-eqz v1, :cond_4

    .line 175
    const-string v1, "Up"

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v4, Luz/carhelper/passenger/apk/ApkManagerActivity$5;

    invoke-direct {v4, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity$5;-><init>(Luz/carhelper/passenger/apk/ApkManagerActivity;)V

    invoke-static {v0, v1, v4}, Luz/carhelper/passenger/apk/Cards;->grey(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 182
    :cond_4
    iget-object v1, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->column:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 185
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 186
    invoke-virtual {v1, v6}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/high16 v3, 0x42100000    # 36.0f

    .line 187
    invoke-static {v14, v13, v3}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    const/16 v3, 0xa

    .line 188
    invoke-virtual {v1, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 189
    iget-object v3, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    invoke-static {v2, v3}, Luz/carhelper/passenger/apk/Roots;->children(Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;)Ljava/util/List;

    move-result-object v3

    .line 190
    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_5

    .line 191
    const-string v4, "No folders or .apk files here."

    invoke-static {v4}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const/high16 v6, 0x41b00000    # 22.0f

    invoke-static {v0, v4, v6, v5, v11}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v4

    const/16 v5, 0x1a

    const/16 v6, 0x18

    .line 192
    invoke-virtual {v4, v5, v6, v5, v6}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 193
    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 195
    :cond_5
    :goto_2
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v4

    if-ge v11, v4, :cond_6

    .line 196
    invoke-interface {v3, v11}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Luz/carhelper/passenger/apk/Roots$Entry;

    invoke-direct {v0, v2, v4}, Luz/carhelper/passenger/apk/ApkManagerActivity;->row(Luz/carhelper/passenger/apk/Roots$Root;Luz/carhelper/passenger/apk/Roots$Entry;)Landroid/view/View;

    move-result-object v4

    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    add-int/lit8 v11, v11, 0x1

    goto :goto_2

    .line 198
    :cond_6
    iget-object v2, v0, Luz/carhelper/passenger/apk/ApkManagerActivity;->column:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-void
.end method

.method private row(Luz/carhelper/passenger/apk/Roots$Root;Luz/carhelper/passenger/apk/Roots$Entry;)Landroid/view/View;
    .locals 9

    .line 202
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/16 v1, 0x10

    .line 203
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v2, 0x18

    const/16 v3, 0x12

    .line 204
    invoke-virtual {v0, v2, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    const/4 v2, 0x0

    const v3, 0x22ffffff

    const/high16 v4, 0x41c00000    # 24.0f

    .line 205
    invoke-static {v2, v3, v2, v4}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 206
    iget-object v3, p2, Luz/carhelper/passenger/apk/Roots$Entry;->file:Ljava/io/File;

    invoke-virtual {v3}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v3

    .line 207
    iget-boolean v5, p2, Luz/carhelper/passenger/apk/Roots$Entry;->dir:Z

    if-eqz v5, :cond_0

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "/"

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    :cond_0
    iget-boolean v5, p2, Luz/carhelper/passenger/apk/Roots$Entry;->dir:Z

    const v6, -0x7f000001

    if-eqz v5, :cond_1

    const/4 v5, -0x1

    goto :goto_0

    :cond_1
    iget-boolean v5, p2, Luz/carhelper/passenger/apk/Roots$Entry;->bundle:Z

    if-eqz v5, :cond_2

    move v5, v6

    goto :goto_0

    :cond_2
    const v5, -0x301c01

    :goto_0
    iget-boolean v7, p2, Luz/carhelper/passenger/apk/Roots$Entry;->dir:Z

    invoke-static {p0, v3, v4, v5, v7}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v3

    const/4 v4, 0x1

    .line 208
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setSingleLine(Z)V

    .line 209
    sget-object v5, Landroid/text/TextUtils$TruncateAt;->MIDDLE:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v3, v5}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    .line 210
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, -0x2

    const/high16 v8, 0x3f800000    # 1.0f

    invoke-direct {v5, v2, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v0, v3, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 211
    iget-boolean v3, p2, Luz/carhelper/passenger/apk/Roots$Entry;->dir:Z

    if-nez v3, :cond_3

    .line 212
    iget-object v3, p2, Luz/carhelper/passenger/apk/Roots$Entry;->file:Ljava/io/File;

    invoke-virtual {v3}, Ljava/io/File;->length()J

    move-result-wide v7

    invoke-static {v7, v8}, Luz/carhelper/passenger/apk/Cards;->size(J)Ljava/lang/String;

    move-result-object v3

    const/high16 v5, 0x41900000    # 18.0f

    invoke-static {p0, v3, v5, v6, v2}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v3

    .line 213
    invoke-virtual {v3, v1, v2, v1, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 214
    invoke-virtual {v0, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 215
    const-string v1, "Delete"

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const v3, -0x9495

    invoke-static {p0, v1, v5, v3, v4}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v1

    const/16 v3, 0x16

    const/16 v4, 0xa

    .line 216
    invoke-virtual {v1, v3, v4, v3, v4}, Landroid/widget/TextView;->setPadding(IIII)V

    const v3, 0x66e5484d

    const/high16 v4, 0x42c80000    # 100.0f

    const v5, 0x33e5484d

    .line 217
    invoke-static {v5, v3, v2, v4}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 218
    new-instance v2, Luz/carhelper/passenger/apk/ApkManagerActivity$6;

    invoke-direct {v2, p0, p1, p2}, Luz/carhelper/passenger/apk/ApkManagerActivity$6;-><init>(Luz/carhelper/passenger/apk/ApkManagerActivity;Luz/carhelper/passenger/apk/Roots$Root;Luz/carhelper/passenger/apk/Roots$Entry;)V

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 227
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 229
    :cond_3
    new-instance v1, Luz/carhelper/passenger/apk/ApkManagerActivity$7;

    invoke-direct {v1, p0, p2, p1}, Luz/carhelper/passenger/apk/ApkManagerActivity$7;-><init>(Luz/carhelper/passenger/apk/ApkManagerActivity;Luz/carhelper/passenger/apk/Roots$Entry;Luz/carhelper/passenger/apk/Roots$Root;)V

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-object v0
.end method


# virtual methods
.method public onBackPressed()V
    .locals 3

    .line 70
    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->roots:Ljava/util/List;

    if-eqz v0, :cond_0

    iget-object v1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    if-eqz v1, :cond_0

    iget v2, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->rootIndex:I

    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Luz/carhelper/passenger/apk/Roots$Root;

    iget-object v0, v0, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    invoke-virtual {v1, v0}, Ljava/io/File;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 71
    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v0

    iput-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    .line 72
    invoke-direct {p0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->refresh()V

    goto :goto_0

    .line 74
    :cond_0
    invoke-virtual {p0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->finish()V

    :goto_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 5

    .line 37
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 38
    invoke-static {p0}, Luz/carhelper/passenger/Lang;->init(Landroid/content/Context;)V

    .line 39
    new-instance p1, Landroid/widget/ScrollView;

    invoke-direct {p1, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    .line 40
    invoke-static {}, Luz/carhelper/passenger/Ui;->pageBg()Landroid/graphics/drawable/GradientDrawable;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/ScrollView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    const/4 v0, 0x0

    .line 41
    invoke-virtual {p1, v0}, Landroid/widget/ScrollView;->setVerticalScrollBarEnabled(Z)V

    .line 42
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->column:Landroid/widget/LinearLayout;

    const/4 v1, 0x1

    .line 43
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 44
    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->column:Landroid/widget/LinearLayout;

    const/16 v2, 0x28

    const/16 v3, 0x48

    const/16 v4, 0x30

    invoke-virtual {v0, v4, v2, v4, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 45
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v2, 0x4b0

    const/4 v3, -0x2

    invoke-direct {v0, v2, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 46
    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 47
    iget-object v1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->column:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v1, v0}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 48
    invoke-virtual {p0, p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->setContentView(Landroid/view/View;)V

    return-void
.end method

.method protected onResume()V
    .locals 3

    .line 53
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    .line 54
    invoke-static {p0}, Luz/carhelper/passenger/Lang;->init(Landroid/content/Context;)V

    .line 55
    invoke-static {p0}, Luz/carhelper/passenger/apk/Roots;->list(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    iput-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->roots:Ljava/util/List;

    .line 56
    iget-boolean v1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->firstShow:Z

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    .line 57
    iput-boolean v2, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->firstShow:Z

    .line 58
    iput v2, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->rootIndex:I

    .line 59
    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Luz/carhelper/passenger/apk/Roots$Root;

    iget-object v0, v0, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    iput-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    goto :goto_0

    .line 60
    :cond_0
    iget v1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->rootIndex:I

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lt v1, v0, :cond_1

    .line 61
    iput v2, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->rootIndex:I

    .line 62
    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->roots:Ljava/util/List;

    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Luz/carhelper/passenger/apk/Roots$Root;

    iget-object v0, v0, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    iput-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity;->dir:Ljava/io/File;

    .line 64
    :cond_1
    :goto_0
    invoke-direct {p0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->refresh()V

    return-void
.end method

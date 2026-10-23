.class final Luz/carhelper/passenger/apk/InstallDialog;
.super Ljava/lang/Object;
.source "InstallDialog.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/app/Activity;Ljava/lang/Runnable;)V
    .locals 0

    .line 27
    invoke-static {p0, p1}, Luz/carhelper/passenger/apk/InstallDialog;->confirmGrant(Landroid/app/Activity;Ljava/lang/Runnable;)V

    return-void
.end method

.method static synthetic access$100(Landroid/app/Activity;Ljava/io/File;Luz/carhelper/passenger/apk/ApkInfo;Z)V
    .locals 0

    .line 27
    invoke-static {p0, p1, p2, p3}, Luz/carhelper/passenger/apk/InstallDialog;->run(Landroid/app/Activity;Ljava/io/File;Luz/carhelper/passenger/apk/ApkInfo;Z)V

    return-void
.end method

.method private static confirmGrant(Landroid/app/Activity;Ljava/lang/Runnable;)V
    .locals 5

    .line 171
    new-instance v0, Luz/carhelper/passenger/apk/Cards$Card;

    const/16 v1, 0x334

    invoke-static {p0, v1}, Luz/carhelper/passenger/apk/Cards;->width(Landroid/app/Activity;I)I

    move-result v1

    invoke-direct {v0, p0, v1}, Luz/carhelper/passenger/apk/Cards$Card;-><init>(Landroid/app/Activity;I)V

    .line 172
    const-string v1, "Grant all permissions?"

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Luz/carhelper/passenger/apk/Cards$Card;->title(Ljava/lang/String;)Landroid/widget/TextView;

    .line 173
    const-string v1, "Every permission the app asks for is granted without asking you. This can break the system. Only turn it on if you know what you are doing."

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const/high16 v2, 0x41b00000    # 22.0f

    const/4 v3, 0x0

    const v4, -0x9495

    invoke-virtual {v0, v1, v4, v2, v3}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 174
    const-string v1, "Keep it off"

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Luz/carhelper/passenger/apk/InstallDialog$5;

    invoke-direct {v2, v0}, Luz/carhelper/passenger/apk/InstallDialog$5;-><init>(Luz/carhelper/passenger/apk/Cards$Card;)V

    invoke-static {p0, v1, v2}, Luz/carhelper/passenger/apk/Cards;->grey(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v1

    .line 179
    const-string v2, "I know what I am doing"

    invoke-static {v2}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    new-instance v3, Luz/carhelper/passenger/apk/InstallDialog$6;

    invoke-direct {v3, v0, p1}, Luz/carhelper/passenger/apk/InstallDialog$6;-><init>(Luz/carhelper/passenger/apk/Cards$Card;Ljava/lang/Runnable;)V

    invoke-static {p0, v2, v3}, Luz/carhelper/passenger/apk/Cards;->red(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object p1

    .line 185
    iget-object v2, v0, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    invoke-static {p0, v1, p1}, Luz/carhelper/passenger/apk/Cards;->buttons(Landroid/app/Activity;Landroid/view/View;Landroid/view/View;)Landroid/widget/LinearLayout;

    move-result-object p0

    invoke-virtual {v2, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 186
    invoke-virtual {v0}, Luz/carhelper/passenger/apk/Cards$Card;->show()V

    return-void
.end method

.method private static line(Landroid/app/Activity;Ljava/lang/String;IFI)Landroid/widget/TextView;
    .locals 1

    const/4 v0, 0x0

    .line 164
    invoke-static {p0, p1, p3, p2, v0}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object p0

    .line 165
    invoke-virtual {p0, v0, p4, v0, v0}, Landroid/widget/TextView;->setPadding(IIII)V

    return-object p0
.end method

.method static result(Landroid/app/Activity;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 4

    .line 230
    new-instance v0, Luz/carhelper/passenger/apk/Cards$Card;

    const/16 v1, 0x334

    invoke-static {p0, v1}, Luz/carhelper/passenger/apk/Cards;->width(Landroid/app/Activity;I)I

    move-result v1

    invoke-direct {v0, p0, v1}, Luz/carhelper/passenger/apk/Cards$Card;-><init>(Landroid/app/Activity;I)V

    if-eqz p1, :cond_0

    .line 231
    const-string v1, "Installed"

    goto :goto_0

    :cond_0
    const-string v1, "Could not install the app"

    :goto_0
    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Luz/carhelper/passenger/apk/Cards$Card;->title(Ljava/lang/String;)Landroid/widget/TextView;

    const/4 v1, -0x1

    const/high16 v2, 0x41b00000    # 22.0f

    const/4 v3, 0x0

    .line 232
    invoke-virtual {v0, p2, v1, v2, v3}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    if-eqz p1, :cond_1

    const p2, -0xb52180

    goto :goto_1

    :cond_1
    const p2, -0x9495

    :goto_1
    const/16 v1, 0xa

    .line 233
    invoke-virtual {v0, p3, p2, v2, v1}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    if-nez p1, :cond_3

    if-eqz p4, :cond_3

    .line 234
    invoke-virtual {p4}, Ljava/lang/String;->length()I

    move-result p1

    if-lez p1, :cond_3

    const/16 p1, 0x20

    .line 235
    invoke-virtual {p4, v1, p1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p1

    .line 236
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p2

    const/16 p3, 0x104

    if-le p2, p3, :cond_2

    invoke-virtual {p1, v3, p3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    :cond_2
    const/high16 p2, 0x41800000    # 16.0f

    const/16 p3, 0xc

    const p4, -0x7f000001

    invoke-virtual {v0, p1, p4, p2, p3}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 238
    :cond_3
    iget-object p1, v0, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    new-instance p2, Landroid/view/View;

    invoke-direct {p2, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    const-string p3, "OK"

    invoke-static {p3}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    new-instance p4, Luz/carhelper/passenger/apk/InstallDialog$9;

    invoke-direct {p4, v0}, Luz/carhelper/passenger/apk/InstallDialog$9;-><init>(Luz/carhelper/passenger/apk/Cards$Card;)V

    invoke-static {p0, p3, p4}, Luz/carhelper/passenger/apk/Cards;->accent(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object p3

    invoke-static {p0, p2, p3}, Luz/carhelper/passenger/apk/Cards;->buttons(Landroid/app/Activity;Landroid/view/View;Landroid/view/View;)Landroid/widget/LinearLayout;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 243
    invoke-virtual {v0}, Luz/carhelper/passenger/apk/Cards$Card;->show()V

    return-void
.end method

.method private static run(Landroid/app/Activity;Ljava/io/File;Luz/carhelper/passenger/apk/ApkInfo;Z)V
    .locals 6

    .line 191
    new-instance v0, Luz/carhelper/passenger/apk/Cards$Card;

    const/16 v1, 0x2f8

    invoke-static {p0, v1}, Luz/carhelper/passenger/apk/Cards;->width(Landroid/app/Activity;I)I

    move-result v1

    invoke-direct {v0, p0, v1}, Luz/carhelper/passenger/apk/Cards$Card;-><init>(Landroid/app/Activity;I)V

    .line 192
    iget-object v1, v0, Luz/carhelper/passenger/apk/Cards$Card;->dialog:Landroid/app/Dialog;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/app/Dialog;->setCancelable(Z)V

    .line 193
    iget-object v1, v0, Luz/carhelper/passenger/apk/Cards$Card;->dialog:Landroid/app/Dialog;

    invoke-virtual {v1, v2}, Landroid/app/Dialog;->setCanceledOnTouchOutside(Z)V

    .line 194
    const-string v1, "Installing\u2026"

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Luz/carhelper/passenger/apk/Cards$Card;->title(Ljava/lang/String;)Landroid/widget/TextView;

    .line 195
    iget-object v1, p2, Luz/carhelper/passenger/apk/ApkInfo;->label:Ljava/lang/String;

    const v3, -0x4c000001

    const/high16 v4, 0x41b00000    # 22.0f

    invoke-virtual {v0, v1, v3, v4, v2}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 196
    new-instance v1, Landroid/widget/ProgressBar;

    const/4 v2, 0x0

    const v3, 0x1010078

    invoke-direct {v1, p0, v2, v3}, Landroid/widget/ProgressBar;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    const/16 v2, 0x3e8

    .line 197
    invoke-virtual {v1, v2}, Landroid/widget/ProgressBar;->setMax(I)V

    .line 198
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v3, -0x1

    const/16 v4, 0x18

    invoke-direct {v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v3, 0x16

    .line 199
    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 200
    iget-object v3, v0, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    invoke-virtual {v3, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const/high16 v2, 0x41900000    # 18.0f

    const/16 v3, 0x8

    .line 201
    const-string v4, "0%"

    const v5, -0x7f000001

    invoke-virtual {v0, v4, v5, v2, v3}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    move-result-object v2

    .line 202
    invoke-virtual {v0}, Luz/carhelper/passenger/apk/Cards$Card;->show()V

    .line 203
    new-instance v3, Luz/carhelper/passenger/apk/InstallDialog$7;

    invoke-direct {v3, p0, v1, v2}, Luz/carhelper/passenger/apk/InstallDialog$7;-><init>(Landroid/app/Activity;Landroid/widget/ProgressBar;Landroid/widget/TextView;)V

    .line 214
    new-instance v1, Luz/carhelper/passenger/apk/InstallDialog$8;

    invoke-direct {v1, v0, p2, p0}, Luz/carhelper/passenger/apk/InstallDialog$8;-><init>(Luz/carhelper/passenger/apk/Cards$Card;Luz/carhelper/passenger/apk/ApkInfo;Landroid/app/Activity;)V

    invoke-static {p0, p1, p3, v3, v1}, Luz/carhelper/passenger/apk/Installer;->install(Landroid/app/Activity;Ljava/io/File;ZLuz/carhelper/passenger/adb/AdbProgress;Luz/carhelper/passenger/apk/Installer$Done;)V

    return-void
.end method

.method static show(Landroid/app/Activity;Ljava/io/File;)V
    .locals 18

    move-object/from16 v6, p0

    .line 32
    invoke-static/range {p0 .. p1}, Luz/carhelper/passenger/apk/ApkInfo;->read(Landroid/content/Context;Ljava/io/File;)Luz/carhelper/passenger/apk/ApkInfo;

    move-result-object v4

    const v0, -0x4c000001

    const/high16 v1, 0x41b00000    # 22.0f

    const/4 v2, 0x0

    if-nez v4, :cond_0

    .line 34
    new-instance v3, Luz/carhelper/passenger/apk/Cards$Card;

    const/16 v4, 0x2f8

    invoke-static {v6, v4}, Luz/carhelper/passenger/apk/Cards;->width(Landroid/app/Activity;I)I

    move-result v4

    invoke-direct {v3, v6, v4}, Luz/carhelper/passenger/apk/Cards$Card;-><init>(Landroid/app/Activity;I)V

    .line 35
    const-string v4, "This is not an app"

    invoke-static {v4}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Luz/carhelper/passenger/apk/Cards$Card;->title(Ljava/lang/String;)Landroid/widget/TextView;

    .line 36
    const-string v4, "The file could not be read as an Android app."

    invoke-static {v4}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4, v0, v1, v2}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 37
    iget-object v0, v3, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    new-instance v1, Landroid/view/View;

    invoke-direct {v1, v6}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    const-string v2, "OK"

    invoke-static {v2}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    new-instance v4, Luz/carhelper/passenger/apk/InstallDialog$1;

    invoke-direct {v4, v3}, Luz/carhelper/passenger/apk/InstallDialog$1;-><init>(Luz/carhelper/passenger/apk/Cards$Card;)V

    invoke-static {v6, v2, v4}, Luz/carhelper/passenger/apk/Cards;->accent(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v2

    invoke-static {v6, v1, v2}, Luz/carhelper/passenger/apk/Cards;->buttons(Landroid/app/Activity;Landroid/view/View;Landroid/view/View;)Landroid/widget/LinearLayout;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 42
    invoke-virtual {v3}, Luz/carhelper/passenger/apk/Cards$Card;->show()V

    return-void

    .line 45
    :cond_0
    new-instance v7, Luz/carhelper/passenger/apk/Cards$Card;

    const/16 v3, 0x3d4

    invoke-static {v6, v3}, Luz/carhelper/passenger/apk/Cards;->width(Landroid/app/Activity;I)I

    move-result v3

    invoke-direct {v7, v6, v3}, Luz/carhelper/passenger/apk/Cards$Card;-><init>(Landroid/app/Activity;I)V

    .line 48
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v6}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/16 v5, 0x10

    .line 49
    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 50
    new-instance v8, Landroid/widget/ImageView;

    invoke-direct {v8, v6}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    .line 51
    iget-object v9, v4, Luz/carhelper/passenger/apk/ApkInfo;->icon:Landroid/graphics/drawable/Drawable;

    if-eqz v9, :cond_1

    .line 52
    iget-object v9, v4, Luz/carhelper/passenger/apk/ApkInfo;->icon:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v8, v9}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 54
    :cond_1
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v10, 0x54

    invoke-direct {v9, v10, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v3, v8, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 55
    new-instance v8, Landroid/widget/LinearLayout;

    invoke-direct {v8, v6}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v9, 0x1

    .line 56
    invoke-virtual {v8, v9}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v10, 0x18

    .line 57
    invoke-virtual {v8, v10, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 58
    iget-object v10, v4, Luz/carhelper/passenger/apk/ApkInfo;->label:Ljava/lang/String;

    const/high16 v11, 0x41f00000    # 30.0f

    const/4 v12, -0x1

    invoke-static {v6, v10, v11, v12, v9}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v10

    .line 59
    invoke-virtual {v10, v9}, Landroid/widget/TextView;->setSingleLine(Z)V

    .line 60
    sget-object v11, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v10, v11}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    .line 61
    invoke-virtual {v8, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 62
    iget-object v10, v4, Luz/carhelper/passenger/apk/ApkInfo;->pkg:Ljava/lang/String;

    const/high16 v11, 0x41900000    # 18.0f

    const v13, -0x7f000001

    invoke-static {v6, v10, v11, v13, v2}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v10

    invoke-virtual {v8, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 63
    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v11, -0x2

    const/high16 v14, 0x3f800000    # 1.0f

    invoke-direct {v10, v2, v11, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v8, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 64
    iget-object v8, v7, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    invoke-virtual {v8, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 67
    new-instance v3, Landroid/widget/ScrollView;

    invoke-direct {v3, v6}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    .line 68
    invoke-virtual {v3, v2}, Landroid/widget/ScrollView;->setVerticalScrollBarEnabled(Z)V

    .line 69
    new-instance v8, Landroid/widget/LinearLayout;

    invoke-direct {v8, v6}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 70
    invoke-virtual {v8, v9}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 71
    invoke-virtual {v3, v8}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    .line 72
    iget-object v10, v7, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    new-instance v15, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v15, v12, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v10, v3, v15}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const/16 v10, 0x12c

    .line 73
    invoke-static {v3, v10}, Luz/carhelper/passenger/apk/Cards;->capHeight(Landroid/widget/ScrollView;I)V

    .line 77
    iget-boolean v3, v4, Luz/carhelper/passenger/apk/ApkInfo;->installed:Z

    const/16 v10, -0x37a9

    const-string v15, "  \u00b7  "

    if-nez v3, :cond_2

    .line 78
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v16, "New app"

    invoke-static/range {v16 .. v16}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v3, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v11, v4, Luz/carhelper/passenger/apk/ApkInfo;->versionName:Ljava/lang/String;

    invoke-virtual {v3, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    move-object v11, v3

    goto/16 :goto_1

    .line 79
    :cond_2
    iget-wide v13, v4, Luz/carhelper/passenger/apk/ApkInfo;->versionCode:J

    iget-wide v11, v4, Luz/carhelper/passenger/apk/ApkInfo;->installedVersionCode:J

    cmp-long v11, v13, v11

    if-lez v11, :cond_3

    .line 80
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "Update"

    invoke-static {v12}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v12, ":  "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, v4, Luz/carhelper/passenger/apk/ApkInfo;->installedVersionName:Ljava/lang/String;

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v12, "  \u2192  "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, v4, Luz/carhelper/passenger/apk/ApkInfo;->versionName:Ljava/lang/String;

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    :goto_0
    const/4 v12, -0x1

    goto :goto_1

    .line 81
    :cond_3
    iget-wide v11, v4, Luz/carhelper/passenger/apk/ApkInfo;->versionCode:J

    iget-wide v13, v4, Luz/carhelper/passenger/apk/ApkInfo;->installedVersionCode:J

    cmp-long v11, v11, v13

    if-nez v11, :cond_4

    .line 82
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "Same version as the installed one"

    invoke-static {v12}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, v4, Luz/carhelper/passenger/apk/ApkInfo;->versionName:Ljava/lang/String;

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    goto :goto_0

    .line 84
    :cond_4
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "Older than the installed version. The install will fail."

    invoke-static {v12}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v12, "  ("

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, v4, Luz/carhelper/passenger/apk/ApkInfo;->versionName:Ljava/lang/String;

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v12, ")"

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    move v12, v10

    :goto_1
    const/16 v13, 0xe

    .line 87
    invoke-static {v6, v11, v12, v1, v13}, Luz/carhelper/passenger/apk/InstallDialog;->line(Landroid/app/Activity;Ljava/lang/String;IFI)Landroid/widget/TextView;

    move-result-object v11

    invoke-virtual {v8, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 88
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "Size"

    invoke-static {v12}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v12, ": "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v14, v4, Luz/carhelper/passenger/apk/ApkInfo;->size:J

    invoke-static {v14, v15}, Luz/carhelper/passenger/apk/Cards;->size(J)Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v11, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v14, "   \u00b7   "

    invoke-virtual {v11, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v14, "Permissions asked"

    invoke-static {v14}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v11, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v14, v4, Luz/carhelper/passenger/apk/ApkInfo;->permissionCount:I

    invoke-virtual {v11, v14}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    const/high16 v14, 0x41a00000    # 20.0f

    const/4 v15, 0x6

    .line 89
    invoke-static {v6, v11, v0, v14, v15}, Luz/carhelper/passenger/apk/InstallDialog;->line(Landroid/app/Activity;Ljava/lang/String;IFI)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v8, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 90
    iget-object v0, v4, Luz/carhelper/passenger/apk/ApkInfo;->sensitive:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lez v0, :cond_7

    .line 91
    new-instance v0, Ljava/lang/StringBuilder;

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v17, "Sensitive permissions"

    invoke-static/range {v17 .. v17}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v11, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    move v3, v2

    .line 92
    :goto_2
    iget-object v11, v4, Luz/carhelper/passenger/apk/ApkInfo;->sensitive:Ljava/util/List;

    invoke-interface {v11}, Ljava/util/List;->size()I

    move-result v11

    if-ge v3, v11, :cond_6

    if-lez v3, :cond_5

    .line 94
    const-string v11, ", "

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 96
    :cond_5
    iget-object v11, v4, Luz/carhelper/passenger/apk/ApkInfo;->sensitive:Ljava/util/List;

    invoke-interface {v11, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Ljava/lang/String;

    invoke-static {v11}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 98
    :cond_6
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v6, v0, v10, v14, v15}, Luz/carhelper/passenger/apk/InstallDialog;->line(Landroid/app/Activity;Ljava/lang/String;IFI)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v8, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 100
    :cond_7
    const-string v0, "Install only apps you trust. This install skips the car\'s app whitelist and uses the car\'s ADB rights."

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const v3, -0x9495

    invoke-static {v6, v0, v3, v14, v13}, Luz/carhelper/passenger/apk/InstallDialog;->line(Landroid/app/Activity;Ljava/lang/String;IFI)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v8, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 101
    iget-boolean v0, v4, Luz/carhelper/passenger/apk/ApkInfo;->installed:Z

    const/16 v10, 0xa

    if-eqz v0, :cond_8

    iget-boolean v0, v4, Luz/carhelper/passenger/apk/ApkInfo;->sameSigner:Z

    if-nez v0, :cond_8

    .line 102
    const-string v0, "This app is signed with a different key than the installed copy. The install will fail unless you uninstall the old one first (its data is lost)."

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v6, v0, v3, v14, v10}, Luz/carhelper/passenger/apk/InstallDialog;->line(Landroid/app/Activity;Ljava/lang/String;IFI)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v8, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 104
    :cond_8
    iget-boolean v0, v4, Luz/carhelper/passenger/apk/ApkInfo;->self:Z

    if-eqz v0, :cond_9

    .line 105
    const-string v0, "This replaces LP Companion itself. The app will restart and you will not see the result."

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v6, v0, v3, v14, v10}, Luz/carhelper/passenger/apk/InstallDialog;->line(Landroid/app/Activity;Ljava/lang/String;IFI)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v8, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 109
    :cond_9
    new-array v8, v9, [Z

    aput-boolean v2, v8, v2

    .line 110
    new-array v0, v9, [Z

    aput-boolean v2, v0, v2

    .line 111
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v6}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 112
    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v5, 0x12

    .line 113
    invoke-virtual {v3, v2, v5, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 114
    new-instance v5, Landroid/widget/LinearLayout;

    invoke-direct {v5, v6}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 115
    invoke-virtual {v5, v9}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 116
    const-string v9, "Grant all permissions (-g)"

    invoke-static {v9}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    const/4 v11, -0x1

    invoke-static {v6, v9, v1, v11, v2}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v5, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 117
    const-string v1, "Off: the app asks for them itself. Only for experts."

    invoke-static {v1}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const/high16 v9, 0x41880000    # 17.0f

    const v11, -0x7f000001

    invoke-static {v6, v1, v9, v11, v2}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v5, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 118
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v9, 0x3f800000    # 1.0f

    const/4 v11, -0x2

    invoke-direct {v1, v2, v11, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v5, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 119
    new-instance v1, Landroid/widget/Switch;

    invoke-direct {v1, v6}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    .line 120
    invoke-static {v1}, Luz/carhelper/passenger/Ui;->tintSwitch(Landroid/widget/Switch;)V

    .line 121
    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 122
    iget-object v2, v7, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 123
    new-instance v2, Luz/carhelper/passenger/apk/InstallDialog$2;

    invoke-direct {v2, v0, v8, v6, v1}, Luz/carhelper/passenger/apk/InstallDialog$2;-><init>([Z[ZLandroid/app/Activity;Landroid/widget/Switch;)V

    invoke-virtual {v1, v2}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    .line 147
    const-string v0, "Cancel"

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Luz/carhelper/passenger/apk/InstallDialog$3;

    invoke-direct {v1, v7}, Luz/carhelper/passenger/apk/InstallDialog$3;-><init>(Luz/carhelper/passenger/apk/Cards$Card;)V

    invoke-static {v6, v0, v1}, Luz/carhelper/passenger/apk/Cards;->grey(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v9

    .line 152
    const-string v11, "Install"

    invoke-static {v11}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    new-instance v13, Luz/carhelper/passenger/apk/InstallDialog$4;

    move-object v0, v13

    move-object v1, v7

    move-object/from16 v2, p0

    move-object/from16 v3, p1

    move-object v5, v8

    invoke-direct/range {v0 .. v5}, Luz/carhelper/passenger/apk/InstallDialog$4;-><init>(Luz/carhelper/passenger/apk/Cards$Card;Landroid/app/Activity;Ljava/io/File;Luz/carhelper/passenger/apk/ApkInfo;[Z)V

    invoke-static {v6, v12, v13}, Luz/carhelper/passenger/apk/Cards;->accent(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v0

    .line 158
    iget-object v1, v7, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    invoke-static {v6, v9, v0}, Luz/carhelper/passenger/apk/Cards;->buttons(Landroid/app/Activity;Landroid/view/View;Landroid/view/View;)Landroid/widget/LinearLayout;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 159
    invoke-virtual {v7}, Luz/carhelper/passenger/apk/Cards$Card;->show()V

    .line 160
    iget-object v1, v7, Luz/carhelper/passenger/apk/Cards$Card;->dialog:Landroid/app/Dialog;

    invoke-static {v11}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v0, v2, v10}, Luz/carhelper/passenger/apk/Cards;->lock(Landroid/app/Dialog;Landroid/widget/TextView;Ljava/lang/String;I)V

    return-void
.end method

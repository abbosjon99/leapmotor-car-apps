.class public Luz/carhelper/passenger/CloseDialog;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# "Close apps" popup: a dark rounded card with one row per app (icon, name, x) that closes just
# that app when tapped, plus Cancel and a red Close all. Replaces the stock AlertDialog list.
# Sized to fit the 720 px passenger screen: the list scrolls after about 3.5 rows.

.field private final act:Luz/carhelper/passenger/MainActivity;
.field private final pkgs:[Ljava/lang/String;
.field private dlg:Landroid/app/Dialog;
.field private list:Landroid/widget/LinearLayout;
.field private scroll:Landroid/widget/ScrollView;

.method private constructor <init>(Luz/carhelper/passenger/MainActivity;[Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/CloseDialog;->act:Luz/carhelper/passenger/MainActivity;
    iput-object p2, p0, Luz/carhelper/passenger/CloseDialog;->pkgs:[Ljava/lang/String;
    return-void
.end method

# p1 = package names, p2 = the matching app labels
.method public static show(Luz/carhelper/passenger/MainActivity;[Ljava/lang/String;[Ljava/lang/String;)V
    .locals 1
    new-instance v0, Luz/carhelper/passenger/CloseDialog;
    invoke-direct {v0, p0, p1}, Luz/carhelper/passenger/CloseDialog;-><init>(Luz/carhelper/passenger/MainActivity;[Ljava/lang/String;)V
    invoke-direct {v0, p2}, Luz/carhelper/passenger/CloseDialog;->build([Ljava/lang/String;)V
    return-void
.end method

.method private build([Ljava/lang/String;)V
    .locals 11
    iget-object v0, p0, Luz/carhelper/passenger/CloseDialog;->act:Luz/carhelper/passenger/MainActivity;
    iget-object v10, p0, Luz/carhelper/passenger/CloseDialog;->pkgs:[Ljava/lang/String;

    new-instance v1, Landroid/app/Dialog;
    invoke-direct {v1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/app/Dialog;->requestWindowFeature(I)Z
    iput-object v1, p0, Luz/carhelper/passenger/CloseDialog;->dlg:Landroid/app/Dialog;

    # card
    new-instance v2, Landroid/widget/LinearLayout;
    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v3, 0x1
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const v3, 0xf0141c2a
    sget v4, Luz/carhelper/passenger/Ui;->STROKE:I
    const/high16 v5, 0x42100000
    invoke-static {v3, v4, v5}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    const/16 v3, 0x24
    const/16 v4, 0x1e
    const/16 v5, 0x1c
    invoke-virtual {v2, v3, v4, v3, v5}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # title + hint
    const-string v3, "Close apps"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const/high16 v4, 0x42000000
    const/4 v5, -0x1
    const/4 v6, 0x1
    invoke-static {v0, v3, v4, v5, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    const-string v3, "Tap an app to close it"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const/high16 v4, 0x41a00000
    sget v5, Luz/carhelper/passenger/Ui;->TEXT3:I
    const/4 v6, 0x0
    invoke-static {v0, v3, v4, v5, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v3
    const/4 v4, 0x2
    const/16 v5, 0x10
    invoke-virtual {v3, v6, v4, v6, v5}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # one row per app
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v4, 0x1
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V
    array-length v4, v10
    const/4 v5, 0x0
    :row_loop
    if-ge v5, v4, :rows_done
    invoke-direct {p0, v3, v5, p1}, Luz/carhelper/passenger/CloseDialog;->row(Landroid/widget/LinearLayout;I[Ljava/lang/String;)V
    add-int/lit8 v5, v5, 0x1
    goto :row_loop
    :rows_done

    # list height: 84 px per row, at most 294
    new-instance v5, Landroid/widget/ScrollView;
    invoke-direct {v5, v0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V
    iput-object v5, p0, Luz/carhelper/passenger/CloseDialog;->scroll:Landroid/widget/ScrollView;
    iput-object v3, p0, Luz/carhelper/passenger/CloseDialog;->list:Landroid/widget/LinearLayout;
    invoke-virtual {v5, v3}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V
    const/4 v6, 0x0
    invoke-virtual {v5, v6}, Landroid/view/View;->setVerticalScrollBarEnabled(Z)V
    mul-int/lit8 v6, v4, 0x54
    const/16 v7, 0x126
    if-le v6, v7, :height_ok
    move v6, v7
    :height_ok
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v8, -0x1
    invoke-direct {v7, v8, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v2, v5, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # buttons: Cancel on the left, red Close all on the right
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v4, 0x10
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/4 v4, 0x0
    const/16 v5, 0x16
    invoke-virtual {v3, v4, v5, v4, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    const-string v5, "Cancel"
    invoke-static {v5}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    const v6, 0x2effffff
    const v7, 0x44ffffff
    sget v8, Luz/carhelper/passenger/Ui;->STROKE:I
    invoke-static {v0, v5, v6, v7, v8}, Luz/carhelper/passenger/Ui;->pill(Landroid/content/Context;Ljava/lang/CharSequence;III)Landroid/widget/TextView;
    move-result-object v5
    const-string v6, "#cancel"
    invoke-virtual {v5, v6}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/view/View;
    invoke-direct {v5, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v7, 0x1
    const/high16 v8, 0x3f800000
    invoke-direct {v6, v4, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v3, v5, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # "All but music": only when a listed app is playing and something else is open too
    invoke-direct {p0}, Luz/carhelper/passenger/CloseDialog;->playing()[Ljava/lang/String;
    move-result-object v5
    array-length v5, v5
    if-eqz v5, :no_keep
    array-length v6, v10
    if-le v6, v5, :no_keep
    const-string v5, "All but music"
    invoke-static {v5}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    sget v6, Luz/carhelper/passenger/Ui;->ACCENT:I
    sget v7, Luz/carhelper/passenger/Ui;->ACCENT_PRESSED:I
    invoke-static {v0, v5, v6, v7, v4}, Luz/carhelper/passenger/Ui;->pill(Landroid/content/Context;Ljava/lang/CharSequence;III)Landroid/widget/TextView;
    move-result-object v5
    const-string v6, "#keep"
    invoke-virtual {v5, v6}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v7, -0x2
    invoke-direct {v6, v7, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v7, 0x14
    invoke-virtual {v6, v4, v4, v7, v4}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v3, v5, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :no_keep

    const-string v5, "Close all"
    invoke-static {v5}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    const v6, 0xffe5484d
    const v7, 0xffc93a3f
    invoke-static {v0, v5, v6, v7, v4}, Luz/carhelper/passenger/Ui;->pill(Landroid/content/Context;Ljava/lang/CharSequence;III)Landroid/widget/TextView;
    move-result-object v5
    const-string v6, "#all"
    invoke-virtual {v5, v6}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # show: transparent window so only the rounded card is visible, 1000 px wide
    invoke-virtual {v1, v2}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V
    const/4 v3, 0x1
    invoke-virtual {v1, v3}, Landroid/app/Dialog;->setCanceledOnTouchOutside(Z)V
    invoke-virtual {v1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
    move-result-object v3
    new-instance v4, Landroid/graphics/drawable/ColorDrawable;
    const/4 v5, 0x0
    invoke-direct {v4, v5}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v3, v4}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V
    const/16 v4, 0x3e8
    const/4 v5, -0x2
    invoke-virtual {v3, v4, v5}, Landroid/view/Window;->setLayout(II)V
    invoke-virtual {v1}, Landroid/app/Dialog;->show()V
    return-void
.end method

# p1 = list, p2 = index, p3 = labels; the row tag is the index as text
.method private row(Landroid/widget/LinearLayout;I[Ljava/lang/String;)V
    .locals 9
    iget-object v0, p0, Luz/carhelper/passenger/CloseDialog;->act:Luz/carhelper/passenger/MainActivity;
    iget-object v8, p0, Luz/carhelper/passenger/CloseDialog;->pkgs:[Ljava/lang/String;

    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v2, 0x12
    const/16 v3, 0xe
    invoke-virtual {v1, v2, v3, v2, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const/4 v2, 0x0
    const v3, 0x22ffffff
    const/high16 v4, 0x41c00000
    invoke-static {v2, v3, v2, v4}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v2
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-static {p2}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v1, v2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # icon (56 px); apps whose icon can't be loaded just show the name
    aget-object v2, v8, p2
    new-instance v3, Landroid/widget/ImageView;
    invoke-direct {v3, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v4
    :try_start_0
    invoke-virtual {v4, v2}, Landroid/content/pm/PackageManager;->getApplicationIcon(Ljava/lang/String;)Landroid/graphics/drawable/Drawable;
    move-result-object v5
    invoke-virtual {v3, v5}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v6, 0x38
    invoke-direct {v5, v6, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, v3, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # name, takes the free width
    aget-object v3, p3, p2
    const/high16 v4, 0x41d00000
    const/4 v5, -0x1
    const/4 v6, 0x0
    invoke-static {v0, v3, v4, v5, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v3
    const/16 v4, 0x14
    invoke-virtual {v3, v4, v6, v4, v6}, Landroid/widget/TextView;->setPadding(IIII)V
    const/4 v4, 0x1
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setMaxLines(I)V
    sget-object v4, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x2
    const/high16 v7, 0x3f800000
    invoke-direct {v4, v6, v5, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v1, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # small x on the right
    new-instance v3, Landroid/widget/ImageView;
    invoke-direct {v3, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;
    move-result-object v4
    const-string v5, "ic_close"
    const-string v7, "drawable"
    invoke-virtual {v0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v4, v5, v7, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v4
    invoke-virtual {v3, v4}, Landroid/widget/ImageView;->setImageResource(I)V
    const v4, 0x3f19999a
    invoke-virtual {v3, v4}, Landroid/view/View;->setAlpha(F)V
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v5, 0x28
    invoke-direct {v4, v5, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-void
.end method

# the listed apps that have a media session which is playing right now
.method private playing()[Ljava/lang/String;
    .locals 7
    new-instance v0, Ljava/util/ArrayList;
    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V
    :try_start_0
    iget-object v1, p0, Luz/carhelper/passenger/CloseDialog;->act:Luz/carhelper/passenger/MainActivity;
    invoke-static {v1}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v1
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v1
    :loop
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z
    move-result v2
    if-eqz v2, :done
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Landroid/media/session/MediaController;
    invoke-static {v2}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v3
    if-eqz v3, :loop
    invoke-virtual {v2}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v2
    iget-object v3, p0, Luz/carhelper/passenger/CloseDialog;->pkgs:[Ljava/lang/String;
    array-length v4, v3
    const/4 v5, 0x0
    :find
    if-ge v5, v4, :loop
    aget-object v6, v3, v5
    add-int/lit8 v5, v5, 0x1
    invoke-virtual {v6, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v6
    if-eqz v6, :find
    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    goto :loop
    :done
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I
    move-result v1
    new-array v1, v1, [Ljava/lang/String;
    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v1
    check-cast v1, [Ljava/lang/String;
    return-object v1
.end method

# the listed apps that are NOT playing music right now
.method private others()[Ljava/lang/String;
    .locals 8
    invoke-direct {p0}, Luz/carhelper/passenger/CloseDialog;->playing()[Ljava/lang/String;
    move-result-object v0
    new-instance v1, Ljava/util/ArrayList;
    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V
    iget-object v2, p0, Luz/carhelper/passenger/CloseDialog;->pkgs:[Ljava/lang/String;
    array-length v3, v2
    const/4 v4, 0x0
    :next
    if-ge v4, v3, :done
    aget-object v5, v2, v4
    add-int/lit8 v4, v4, 0x1
    array-length v6, v0
    :check
    add-int/lit8 v6, v6, -0x1
    if-ltz v6, :keep
    aget-object v7, v0, v6
    invoke-virtual {v7, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v7
    if-eqz v7, :check
    goto :next
    :keep
    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    goto :next
    :done
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v2
    new-array v2, v2, [Ljava/lang/String;
    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v2
    check-cast v2, [Ljava/lang/String;
    return-object v2
.end method

.method private dismiss()V
    .locals 1
    iget-object v0, p0, Luz/carhelper/passenger/CloseDialog;->dlg:Landroid/app/Dialog;
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V
    :done
    return-void
.end method

# Cancel closes the popup, Close all closes every app and the popup; tapping one app closes just that app,
# takes its row out and keeps the popup open for the next one.
.method public onClick(Landroid/view/View;)V
    .locals 6
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    const-string v1, "#cancel"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_cancel
    invoke-direct {p0}, Luz/carhelper/passenger/CloseDialog;->dismiss()V
    return-void
    :not_cancel
    iget-object v1, p0, Luz/carhelper/passenger/CloseDialog;->act:Luz/carhelper/passenger/MainActivity;
    iget-object v2, p0, Luz/carhelper/passenger/CloseDialog;->pkgs:[Ljava/lang/String;
    const-string v3, "#keep"
    invoke-virtual {v3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :not_keep
    # close everything that is not playing music right now
    invoke-direct {p0}, Luz/carhelper/passenger/CloseDialog;->others()[Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0}, Luz/carhelper/passenger/CloseDialog;->dismiss()V
    array-length v3, v2
    if-nez v3, :close_others
    return-void
    :close_others
    invoke-virtual {v1, v2}, Luz/carhelper/passenger/MainActivity;->closeApps([Ljava/lang/String;)V
    return-void
    :not_keep
    const-string v3, "#all"
    invoke-virtual {v3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :single
    invoke-direct {p0}, Luz/carhelper/passenger/CloseDialog;->dismiss()V
    invoke-virtual {v1, v2}, Luz/carhelper/passenger/MainActivity;->closeApps([Ljava/lang/String;)V
    return-void
    :single
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v3
    aget-object v4, v2, v3
    const/4 v2, 0x1
    new-array v2, v2, [Ljava/lang/String;
    const/4 v3, 0x0
    aput-object v4, v2, v3
    invoke-virtual {v1, v2}, Luz/carhelper/passenger/MainActivity;->closeAppsKeep([Ljava/lang/String;)V
    iget-object v1, p0, Luz/carhelper/passenger/CloseDialog;->list:Landroid/widget/LinearLayout;
    invoke-virtual {v1, p1}, Landroid/widget/LinearLayout;->removeView(Landroid/view/View;)V
    invoke-virtual {v1}, Landroid/widget/LinearLayout;->getChildCount()I
    move-result v2
    if-nez v2, :resize
    invoke-direct {p0}, Luz/carhelper/passenger/CloseDialog;->dismiss()V
    return-void
    :resize
    mul-int/lit8 v2, v2, 0x54
    const/16 v3, 0x126
    if-le v2, v3, :height_ok
    move v2, v3
    :height_ok
    iget-object v3, p0, Luz/carhelper/passenger/CloseDialog;->scroll:Landroid/widget/ScrollView;
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v4
    iput v2, v4, Landroid/view/ViewGroup$LayoutParams;->height:I
    invoke-virtual {v3, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    return-void
.end method
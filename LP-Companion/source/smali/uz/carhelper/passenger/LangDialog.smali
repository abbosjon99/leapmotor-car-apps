.class public Luz/carhelper/passenger/LangDialog;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# Language picker for Settings: a dark card with the five languages in their own names (Uzbek, Russian, Spanish,
# English, Chinese); the one in use has a tick. Choosing one calls SettingsActivity.setLang, which saves the page,
# switches the language and reopens Settings in it.

.field private final act:Luz/carhelper/passenger/SettingsActivity;
.field private dlg:Landroid/app/Dialog;

.method private constructor <init>(Luz/carhelper/passenger/SettingsActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/LangDialog;->act:Luz/carhelper/passenger/SettingsActivity;
    return-void
.end method

.method public static show(Luz/carhelper/passenger/SettingsActivity;)V
    .locals 1
    new-instance v0, Luz/carhelper/passenger/LangDialog;
    invoke-direct {v0, p0}, Luz/carhelper/passenger/LangDialog;-><init>(Luz/carhelper/passenger/SettingsActivity;)V
    invoke-direct {v0}, Luz/carhelper/passenger/LangDialog;->build()V
    return-void
.end method

.method private build()V
    .locals 12
    iget-object v0, p0, Luz/carhelper/passenger/LangDialog;->act:Luz/carhelper/passenger/SettingsActivity;

    new-instance v1, Landroid/app/Dialog;
    invoke-direct {v1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/app/Dialog;->requestWindowFeature(I)Z
    iput-object v1, p0, Luz/carhelper/passenger/LangDialog;->dlg:Landroid/app/Dialog;

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

    # title
    const-string v3, "Language"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const/high16 v4, 0x41f00000
    const/4 v5, -0x1
    const/4 v6, 0x1
    invoke-static {v0, v3, v4, v5, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v3
    const/4 v4, 0x0
    const/16 v5, 0xc
    invoke-virtual {v3, v4, v4, v4, v5}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # one row per language; a tick marks the one in use
    invoke-static {}, Luz/carhelper/passenger/Lang;->code()Ljava/lang/String;
    move-result-object v10
    invoke-static {}, Luz/carhelper/passenger/Lang;->codes()[Ljava/lang/String;
    move-result-object v3
    array-length v4, v3
    const/4 v5, 0x0
    :row_loop
    if-ge v5, v4, :rows_done
    aget-object v6, v3, v5
    add-int/lit8 v5, v5, 0x1
    invoke-static {v6}, Luz/carhelper/passenger/Lang;->label(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v7
    invoke-virtual {v6, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v8
    if-eqz v8, :no_tick
    const-string v8, "✓  "
    invoke-virtual {v8, v7}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v7
    :no_tick
    const/high16 v8, 0x41c00000
    const/4 v9, -0x1
    const/4 v11, 0x0
    invoke-static {v0, v7, v8, v9, v11}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v7
    const/16 v8, 0x18
    const/16 v9, 0x16
    invoke-virtual {v7, v8, v9, v8, v9}, Landroid/widget/TextView;->setPadding(IIII)V
    const v8, 0x22ffffff
    const/high16 v9, 0x41c00000
    invoke-static {v11, v8, v11, v9}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v8
    invoke-virtual {v7, v8}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v7, v6}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v7, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v9, -0x1
    const/4 v6, -0x2
    invoke-direct {v8, v9, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/4 v9, 0x6
    invoke-virtual {v8, v11, v9, v11, v11}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v2, v7, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    goto :row_loop
    :rows_done

    # show: transparent window so only the rounded card is visible, 560 px wide
    invoke-virtual {v1, v2}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V
    const/4 v3, 0x1
    invoke-virtual {v1, v3}, Landroid/app/Dialog;->setCanceledOnTouchOutside(Z)V
    invoke-virtual {v1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
    move-result-object v3
    new-instance v4, Landroid/graphics/drawable/ColorDrawable;
    const/4 v5, 0x0
    invoke-direct {v4, v5}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v3, v4}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V
    const/16 v4, 0x230
    const/4 v5, -0x2
    invoke-virtual {v3, v4, v5}, Landroid/view/Window;->setLayout(II)V
    invoke-virtual {v1}, Landroid/app/Dialog;->show()V
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    iget-object v1, p0, Luz/carhelper/passenger/LangDialog;->dlg:Landroid/app/Dialog;
    if-eqz v1, :go
    invoke-virtual {v1}, Landroid/app/Dialog;->dismiss()V
    :go
    iget-object v1, p0, Luz/carhelper/passenger/LangDialog;->act:Luz/carhelper/passenger/SettingsActivity;
    invoke-virtual {v1, v0}, Luz/carhelper/passenger/SettingsActivity;->setLang(Ljava/lang/String;)V
    return-void
.end method

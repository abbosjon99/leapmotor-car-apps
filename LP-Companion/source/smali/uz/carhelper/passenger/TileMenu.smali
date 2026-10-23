.class public Luz/carhelper/passenger/TileMenu;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# Long-press menu of a grid tile (same dark card as the Close apps popup):
#   Open on main screen / Open on passenger screen / Add to (Remove from) Kids / Hide from the grid.
# A plain tap on a tile still opens the app on the passenger screen. "Open on main screen" is left out while child
# mode is on (apps stay on the passenger screen then). Kids / Hide write the same sets Settings uses ("kidApps",
# "hidden"); the grids on both screens follow those prefs live (MainActivity's prefs listener).

.field private final act:Luz/carhelper/passenger/MainActivity;
.field private final comp:Ljava/lang/String;
.field private final pkg:Ljava/lang/String;
.field private dlg:Landroid/app/Dialog;

.method private constructor <init>(Luz/carhelper/passenger/MainActivity;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/TileMenu;->act:Luz/carhelper/passenger/MainActivity;
    iput-object p2, p0, Luz/carhelper/passenger/TileMenu;->comp:Ljava/lang/String;
    iput-object p3, p0, Luz/carhelper/passenger/TileMenu;->pkg:Ljava/lang/String;
    return-void
.end method

# p1 = the tile's tag: the flattened component name
.method public static show(Luz/carhelper/passenger/MainActivity;Ljava/lang/String;)V
    .locals 2
    invoke-static {p1}, Landroid/content/ComponentName;->unflattenFromString(Ljava/lang/String;)Landroid/content/ComponentName;
    move-result-object v0
    if-nez v0, :ok
    return-void
    :ok
    invoke-virtual {v0}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;
    move-result-object v0
    new-instance v1, Luz/carhelper/passenger/TileMenu;
    invoke-direct {v1, p0, p1, v0}, Luz/carhelper/passenger/TileMenu;-><init>(Luz/carhelper/passenger/MainActivity;Ljava/lang/String;Ljava/lang/String;)V
    invoke-direct {v1}, Luz/carhelper/passenger/TileMenu;->build()V
    return-void
.end method

# true when `key` (a string set in the "apps" prefs) contains this app
.method private inSet(Ljava/lang/String;)Z
    .locals 3
    iget-object v0, p0, Luz/carhelper/passenger/TileMenu;->act:Luz/carhelper/passenger/MainActivity;
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    new-instance v1, Ljava/util/HashSet;
    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V
    invoke-interface {v0, p1, v1}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v0
    iget-object v1, p0, Luz/carhelper/passenger/TileMenu;->pkg:Ljava/lang/String;
    invoke-interface {v0, v1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z
    move-result v0
    return v0
.end method

# add (or remove) this app to the string set `key`, then back the settings up
.method private edit(Ljava/lang/String;Z)V
    .locals 5
    iget-object v0, p0, Luz/carhelper/passenger/TileMenu;->act:Luz/carhelper/passenger/MainActivity;
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    new-instance v2, Ljava/util/HashSet;
    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V
    invoke-interface {v1, p1, v2}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v2
    new-instance v3, Ljava/util/HashSet;
    invoke-direct {v3, v2}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V
    iget-object v4, p0, Luz/carhelper/passenger/TileMenu;->pkg:Ljava/lang/String;
    if-eqz p2, :remove
    invoke-virtual {v3, v4}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    goto :save
    :remove
    invoke-virtual {v3, v4}, Ljava/util/HashSet;->remove(Ljava/lang/Object;)Z
    :save
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    invoke-interface {v1, p1, v3}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-static {v0}, Luz/carhelper/passenger/Backup;->save(Landroid/content/Context;)V
    return-void
.end method

.method private toast(Ljava/lang/String;)V
    .locals 2
    iget-object v0, p0, Luz/carhelper/passenger/TileMenu;->act:Luz/carhelper/passenger/MainActivity;
    const/4 v1, 0x0
    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    return-void
.end method

# one text row; the tag says what it does
.method private item(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    .locals 6
    iget-object v0, p0, Luz/carhelper/passenger/TileMenu;->act:Luz/carhelper/passenger/MainActivity;
    const/high16 v1, 0x41c00000
    const/4 v2, -0x1
    const/4 v3, 0x0
    invoke-static {v0, p2, v1, v2, v3}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v1
    const/16 v2, 0x18
    const/16 v4, 0x16
    invoke-virtual {v1, v2, v4, v2, v4}, Landroid/widget/TextView;->setPadding(IIII)V
    const v2, 0x22ffffff
    const/high16 v4, 0x41c00000
    invoke-static {v3, v2, v3, v4}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v2
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v1, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v4, -0x1
    const/4 v5, -0x2
    invoke-direct {v2, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/4 v4, 0x6
    invoke-virtual {v2, v3, v4, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-void
.end method

.method private build()V
    .locals 11
    iget-object v0, p0, Luz/carhelper/passenger/TileMenu;->act:Luz/carhelper/passenger/MainActivity;
    iget-object v10, p0, Luz/carhelper/passenger/TileMenu;->pkg:Ljava/lang/String;

    new-instance v1, Landroid/app/Dialog;
    invoke-direct {v1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/app/Dialog;->requestWindowFeature(I)Z
    iput-object v1, p0, Luz/carhelper/passenger/TileMenu;->dlg:Landroid/app/Dialog;

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

    # header: the app's icon and name
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v4, 0x10
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/4 v4, 0x0
    const/16 v5, 0xc
    invoke-virtual {v3, v4, v4, v4, v5}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    invoke-virtual {v0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v5
    move-object v6, v10
    :try_start_0
    invoke-virtual {v5, v10}, Landroid/content/pm/PackageManager;->getApplicationIcon(Ljava/lang/String;)Landroid/graphics/drawable/Drawable;
    move-result-object v7
    new-instance v8, Landroid/widget/ImageView;
    invoke-direct {v8, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v8, v7}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v9, 0x48
    invoke-direct {v7, v9, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v3, v8, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    const/4 v7, 0x0
    invoke-virtual {v5, v10, v7}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;
    move-result-object v7
    invoke-virtual {v5, v7}, Landroid/content/pm/PackageManager;->getApplicationLabel(Landroid/content/pm/ApplicationInfo;)Ljava/lang/CharSequence;
    move-result-object v7
    invoke-interface {v7}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;
    move-result-object v6
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    const/high16 v7, 0x41f00000
    const/4 v8, -0x1
    const/4 v9, 0x1
    invoke-static {v0, v6, v7, v8, v9}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v7
    const/16 v8, 0x16
    const/4 v9, 0x0
    invoke-virtual {v7, v8, v9, v9, v9}, Landroid/widget/TextView;->setPadding(IIII)V
    const/4 v8, 0x1
    invoke-virtual {v7, v8}, Landroid/widget/TextView;->setMaxLines(I)V
    sget-object v8, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;
    invoke-virtual {v7, v8}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V
    invoke-virtual {v3, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # rows. Child mode on: no "Open on main screen".
    const-string v3, "apps"
    const/4 v4, 0x0
    invoke-virtual {v0, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3
    const-string v5, "kid"
    invoke-interface {v3, v5, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3
    if-nez v3, :no_main
    const-string v3, "Open on the main screen"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const-string v4, "#main"
    invoke-direct {p0, v2, v3, v4}, Luz/carhelper/passenger/TileMenu;->item(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    :no_main
    const-string v3, "Open on the passenger screen"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const-string v4, "#pass"
    invoke-direct {p0, v2, v3, v4}, Luz/carhelper/passenger/TileMenu;->item(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v3, "kidApps"
    invoke-direct {p0, v3}, Luz/carhelper/passenger/TileMenu;->inSet(Ljava/lang/String;)Z
    move-result v3
    const-string v4, "Add to Kids (allowed in child mode)"
    invoke-static {v4}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v3, :kid_label
    const-string v4, "Remove from Kids"
    invoke-static {v4}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    :kid_label
    const-string v3, "#kid"
    invoke-direct {p0, v2, v4, v3}, Luz/carhelper/passenger/TileMenu;->item(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v3, "Hide from the grid"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const-string v4, "#hide"
    invoke-direct {p0, v2, v3, v4}, Luz/carhelper/passenger/TileMenu;->item(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V

    # show: transparent window so only the rounded card is visible, 640 px wide
    invoke-virtual {v1, v2}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V
    const/4 v3, 0x1
    invoke-virtual {v1, v3}, Landroid/app/Dialog;->setCanceledOnTouchOutside(Z)V
    invoke-virtual {v1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
    move-result-object v3
    new-instance v4, Landroid/graphics/drawable/ColorDrawable;
    const/4 v5, 0x0
    invoke-direct {v4, v5}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v3, v4}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V
    const/16 v4, 0x280
    const/4 v5, -0x2
    invoke-virtual {v3, v4, v5}, Landroid/view/Window;->setLayout(II)V
    invoke-virtual {v1}, Landroid/app/Dialog;->show()V
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 4
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    iget-object v1, p0, Luz/carhelper/passenger/TileMenu;->dlg:Landroid/app/Dialog;
    if-eqz v1, :go
    invoke-virtual {v1}, Landroid/app/Dialog;->dismiss()V
    :go
    iget-object v1, p0, Luz/carhelper/passenger/TileMenu;->act:Luz/carhelper/passenger/MainActivity;
    iget-object v2, p0, Luz/carhelper/passenger/TileMenu;->pkg:Ljava/lang/String;

    const-string v3, "#main"
    invoke-virtual {v3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :not_main
    const/4 v3, 0x0
    invoke-static {v1, v2, v3}, Luz/carhelper/passenger/Swapper;->openOn(Landroid/content/Context;Ljava/lang/String;I)V
    return-void
    :not_main

    const-string v3, "#pass"
    invoke-virtual {v3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :not_pass
    iget-object v3, p0, Luz/carhelper/passenger/TileMenu;->comp:Ljava/lang/String;
    invoke-virtual {v1, v3}, Luz/carhelper/passenger/MainActivity;->openApp(Ljava/lang/String;)V
    return-void
    :not_pass

    const-string v3, "#kid"
    invoke-virtual {v3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :not_kid
    const-string v3, "kidApps"
    invoke-direct {p0, v3}, Luz/carhelper/passenger/TileMenu;->inSet(Ljava/lang/String;)Z
    move-result v0
    xor-int/lit8 v0, v0, 0x1
    invoke-direct {p0, v3, v0}, Luz/carhelper/passenger/TileMenu;->edit(Ljava/lang/String;Z)V
    const-string v3, "Removed from Kids"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    if-eqz v0, :kid_toast
    const-string v3, "Added to Kids"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    :kid_toast
    invoke-direct {p0, v3}, Luz/carhelper/passenger/TileMenu;->toast(Ljava/lang/String;)V
    return-void
    :not_kid

    # "#hide"
    const-string v3, "hidden"
    const/4 v0, 0x1
    invoke-direct {p0, v3, v0}, Luz/carhelper/passenger/TileMenu;->edit(Ljava/lang/String;Z)V
    const-string v3, "Hidden from the grid. Bring it back in Settings."
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-direct {p0, v3}, Luz/carhelper/passenger/TileMenu;->toast(Ljava/lang/String;)V
    return-void
.end method

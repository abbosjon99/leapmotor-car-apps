.class public Luz/carhelper/passenger/MainActivity;
.super Landroid/app/Activity;
.implements Landroid/view/View$OnClickListener;
.implements Landroid/content/DialogInterface$OnClickListener;
.implements Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;
.implements Landroid/view/View$OnLongClickListener;

.field private runningPkgs:[Ljava/lang/String;
.field private wp:Luz/carhelper/passenger/WallpaperFrame;

# Grid of all non-system launchable apps. Tapping one starts (or moves) it on the passenger
# screen, display 3 (1920x720). Launching a running app toward a display moves its task there.
# Header buttons hide/show the passenger sidebar via copilotshowapp's
# "com.leapmotor.iqiyi.action.nav.visibility" broadcast (extra "visibility": 8 = gone, 0 = visible).
# Opening the app also starts BubbleService (floating button on the passenger screen).

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    return-void
.end method

.method private makeButton(Ljava/lang/String;Ljava/lang/String;)Landroid/widget/TextView;
    .locals 3
    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v1, 0x41e00000
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v1, 0x18
    const/16 v2, 0x30
    invoke-virtual {v0, v2, v1, v2, v1}, Landroid/widget/TextView;->setPadding(IIII)V
    const v1, -0xe1771b
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V
    const/4 v1, -0x1
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    invoke-virtual {v0, p2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    return-object v0
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 14
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    # fresh install / data cleared: bring the settings back from the backup in Settings.Secure; and the adb
    # "forgot the password" switch (both are no-ops in the normal case)
    :try_start_bk
    invoke-static {p0}, Luz/carhelper/passenger/Backup;->restore(Landroid/content/Context;)V
    :try_end_bk
    .catch Ljava/lang/Throwable; {:try_start_bk .. :try_end_bk} :catch_bk
    :catch_bk

    # interface language (after the restore above, which can bring the chosen language back)
    invoke-static {p0}, Luz/carhelper/passenger/Lang;->init(Landroid/content/Context;)V

    # a permission lost after a reboot / firmware update: try to get it back through the car's own adb
    :try_start_hl
    const/4 v0, 0x0
    invoke-static {p0, v0}, Luz/carhelper/passenger/Heal;->start(Landroid/content/Context;Z)V
    :try_end_hl
    .catch Ljava/lang/Throwable; {:try_start_hl .. :try_end_hl} :catch_hl
    :catch_hl

    # the PIN reset toast is shown in that language
    :try_start_pr
    invoke-static {p0}, Luz/carhelper/passenger/Backup;->pinReset(Landroid/content/Context;)V
    :try_end_pr
    .catch Ljava/lang/Throwable; {:try_start_pr .. :try_end_pr} :catch_pr
    :catch_pr

    # follow wallpaper / child-mode changes made from the grid on the other screen
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0, p0}, Landroid/content/SharedPreferences;->registerOnSharedPreferenceChangeListener(Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;)V

    # make sure both bubbles are running (passenger screen + main screen)
    :try_start_bubble
    new-instance v4, Landroid/content/Intent;
    const-class v5, Luz/carhelper/passenger/BubbleService;
    invoke-direct {v4, p0, v5}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v4}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    new-instance v4, Landroid/content/Intent;
    const-class v5, Luz/carhelper/passenger/MainBubbleService;
    invoke-direct {v4, p0, v5}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v4}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_bubble
    .catch Ljava/lang/Exception; {:try_start_bubble .. :try_end_bubble} :catch_bubble
    goto :after_bubble
    :catch_bubble
    move-exception v4
    :after_bubble

    # v0 = PackageManager, v1 = sorted launchable activities
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v0
    new-instance v1, Landroid/content/Intent;
    const-string v2, "android.intent.action.MAIN"
    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v2, "android.intent.category.LAUNCHER"
    invoke-virtual {v1, v2}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/pm/PackageManager;->queryIntentActivities(Landroid/content/Intent;I)Ljava/util/List;
    move-result-object v1
    new-instance v2, Landroid/content/pm/ResolveInfo$DisplayNameComparator;
    invoke-direct {v2, v0}, Landroid/content/pm/ResolveInfo$DisplayNameComparator;-><init>(Landroid/content/pm/PackageManager;)V
    invoke-static {v1, v2}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    # v2 = ScrollView, v3 = vertical grid
    new-instance v2, Landroid/widget/ScrollView;
    invoke-direct {v2, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v4, 0x1
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v4, 0x20
    invoke-virtual {v3, v4, v4, v4, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    invoke-virtual {v2, v3}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    # header: title + Hide sidebar + Show sidebar
    new-instance v4, Landroid/widget/LinearLayout;
    invoke-direct {v4, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v5, 0x10
    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v5, 0x20
    const/4 v6, 0x0
    invoke-virtual {v4, v6, v6, v6, v5}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v5, Landroid/widget/LinearLayout;
    invoke-direct {v5, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v6, 0x1
    invoke-virtual {v5, v6}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const-string v6, "LP Companion"
    const/high16 v7, 0x42100000
    const/4 v8, -0x1
    const/4 v9, 0x1
    invoke-static {p0, v6, v7, v8, v9}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v6
    invoke-virtual {v5, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    const-string v6, "by abbosjon99"
    const/high16 v7, 0x41900000
    sget v8, Luz/carhelper/passenger/Ui;->TEXT3:I
    const/4 v9, 0x0
    invoke-static {p0, v6, v7, v8, v9}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v6
    invoke-virtual {v5, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v7, 0x0
    const/4 v8, -0x2
    const/high16 v9, 0x3f800000
    invoke-direct {v6, v7, v8, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v4, v5, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # RAM / temperature chip (what overload protection watches, coloured green / amber / red); not for the child
    # on the passenger screen
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->kidActive()Z
    move-result v5
    if-nez v5, :no_health
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const/high16 v6, 0x41900000
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v6, 0x1a
    const/16 v7, 0xe
    invoke-virtual {v5, v6, v7, v6, v7}, Landroid/widget/TextView;->setPadding(IIII)V
    const v6, 0x66000000
    const v7, 0x40ffffff
    const/high16 v8, 0x42c80000
    invoke-static {v6, v7, v8}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v6
    invoke-virtual {v5, v6}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    :try_start_ht
    invoke-static {v5}, Luz/carhelper/passenger/HealthTick;->start(Landroid/widget/TextView;)V
    :try_end_ht
    .catch Ljava/lang/Throwable; {:try_start_ht .. :try_end_ht} :catch_ht
    :catch_ht
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v7, -0x2
    invoke-direct {v6, v7, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/4 v7, 0x0
    const/16 v8, 0x10
    invoke-virtual {v6, v7, v7, v8, v7}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v4, v5, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :no_health

    # header pills: Settings (grid only), Close apps, one Hide/Show bar toggle
    instance-of v5, p0, Luz/carhelper/passenger/SettingsActivity;
    if-nez v5, :settings_screen
    const-string v5, "Settings"
    invoke-static {v5}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    const-string v6, "ic_settings"
    const-string v7, "#settings"
    invoke-direct {p0, v4, v5, v6, v7}, Luz/carhelper/passenger/MainActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/TextView;
    # child mode and wallpaper live in the grid as tiles now; Go to car moved to Settings; Exit removed
    goto :pills_common
    :settings_screen
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->readAutoClose()Z
    move-result v5
    const-string v6, "Close previous app: Off"
    invoke-static {v6}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6
    if-eqz v5, :ac_label
    const-string v6, "Close previous app: On"
    invoke-static {v6}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6
    :ac_label
    const-string v7, "ic_apps"
    const-string v8, "#autoclose"
    invoke-direct {p0, v4, v6, v7, v8}, Luz/carhelper/passenger/MainActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/TextView;
    const-string v5, "closeMusic"
    invoke-direct {p0, v5}, Luz/carhelper/passenger/MainActivity;->readBool(Ljava/lang/String;)Z
    move-result v5
    const-string v6, "\u21b3 Also close music apps: Off"
    invoke-static {v6}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6
    if-eqz v5, :cm_label
    const-string v6, "\u21b3 Also close music apps: On"
    invoke-static {v6}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6
    :cm_label
    const-string v7, "ic_music"
    const-string v8, "#closemusic"
    invoke-direct {p0, v4, v6, v7, v8}, Luz/carhelper/passenger/MainActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/TextView;
    :pills_common
    # no Close apps while child mode filters the passenger screen
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->kidActive()Z
    move-result v5
    if-nez v5, :no_closeall
    const-string v5, "Close apps"
    invoke-static {v5}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    const-string v6, "ic_close"
    const-string v7, "#closeall"
    invoke-direct {p0, v4, v5, v6, v7}, Luz/carhelper/passenger/MainActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/TextView;
    :no_closeall
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->readBarHidden()Z
    move-result v5
    const-string v6, "Hide bar"
    invoke-static {v6}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6
    const-string v7, "ic_bar_hide"
    if-eqz v5, :bar_label
    const-string v6, "Show bar"
    invoke-static {v6}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6
    const-string v7, "ic_bar_show"
    :bar_label
    const-string v8, "#bar"
    invoke-direct {p0, v4, v6, v7, v8}, Luz/carhelper/passenger/MainActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/TextView;

    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # now-playing widget (60%) with child mode + change wallpaper beside it (40%) - grid only
    instance-of v5, p0, Luz/carhelper/passenger/SettingsActivity;
    if-nez v5, :skip_np
    new-instance v5, Landroid/widget/LinearLayout;
    invoke-direct {v5, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v6, 0x0
    invoke-virtual {v5, v6}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v6, 0x10
    invoke-virtual {v5, v6}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/high16 v6, 0x40a00000
    invoke-virtual {v5, v6}, Landroid/widget/LinearLayout;->setWeightSum(F)V
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v7, -0x1
    const/4 v8, -0x2
    invoke-direct {v6, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/4 v7, 0x0
    const/16 v9, 0x10
    invoke-virtual {v6, v7, v7, v7, v9}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v3, v5, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # the music widget, weight 3 (60%)
    new-instance v6, Luz/carhelper/passenger/NowPlaying;
    invoke-direct {v6, p0}, Luz/carhelper/passenger/NowPlaying;-><init>(Landroid/app/Activity;)V
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v8, 0x0
    const/4 v9, -0x2
    const/high16 v10, 0x40400000
    invoke-direct {v7, v8, v9, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v5, v6, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    # hide the now-playing widget while child mode is active on the passenger screen
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->kidActive()Z
    move-result v7
    if-eqz v7, :np_shown
    const/16 v7, 0x8
    invoke-virtual {v6, v7}, Landroid/view/View;->setVisibility(I)V
    :np_shown

    # the two buttons container, weight 2 (40%)
    new-instance v6, Landroid/widget/LinearLayout;
    invoke-direct {v6, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v7, 0x0
    invoke-virtual {v6, v7}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v7, 0x11
    invoke-virtual {v6, v7}, Landroid/widget/LinearLayout;->setGravity(I)V
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v8, 0x0
    const/4 v9, -0x2
    const/high16 v10, 0x40000000
    invoke-direct {v7, v8, v9, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v5, v6, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->kidOn()Z
    move-result v7
    const-string v8, "Child mode"
    invoke-static {v8}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v8
    const-string v9, "#childenter"
    if-eqz v7, :np_child
    const-string v8, "Exit child mode"
    invoke-static {v8}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v8
    const-string v9, "#childexit"
    :np_child
    const-string v10, "ic_child"
    invoke-direct {p0, v6, v10, v8, v9}, Luz/carhelper/passenger/MainActivity;->addTile(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/LinearLayout;
    move-result-object v7
    # gray the Child mode tile when entering is blocked (kid off and no PIN set)
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->kidOn()Z
    move-result v8
    if-nez v8, :child_tile_done
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->pinSet()Z
    move-result v8
    if-nez v8, :child_tile_done
    const v8, 0x3e99999a
    invoke-virtual {v7, v8}, Landroid/view/View;->setAlpha(F)V
    :child_tile_done
    const-string v8, "Change wallpaper"
    invoke-static {v8}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v8
    const-string v9, "#wallpaper"
    const-string v10, "ic_image"
    invoke-direct {p0, v6, v10, v8, v9}, Luz/carhelper/passenger/MainActivity;->addTile(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/LinearLayout;
    :skip_np

    # v4 = current row, v5 = item count, v6 = iterator
    const/4 v4, 0x0
    const/4 v5, 0x0
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v6
    # v1 = hidden packages
    const-string v7, "apps"
    const/4 v8, 0x0
    invoke-virtual {p0, v7, v8}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v7
    const-string v8, "hidden"
    new-instance v1, Ljava/util/HashSet;
    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V
    invoke-interface {v7, v8, v1}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v1

    :loop
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z
    move-result v7
    if-eqz v7, :end
    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v7
    check-cast v7, Landroid/content/pm/ResolveInfo;
    iget-object v8, v7, Landroid/content/pm/ResolveInfo;->activityInfo:Landroid/content/pm/ActivityInfo;

    # skip built-in (system) apps and this app itself
    iget-object v9, v8, Landroid/content/pm/ActivityInfo;->applicationInfo:Landroid/content/pm/ApplicationInfo;
    iget v9, v9, Landroid/content/pm/ApplicationInfo;->flags:I
    and-int/lit8 v9, v9, 0x1
    if-nez v9, :loop
    iget-object v9, v8, Landroid/content/pm/ActivityInfo;->packageName:Ljava/lang/String;
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v10
    invoke-virtual {v10, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v10
    if-nez v10, :loop
    # kid mode: exactly the "Kids" apps, whatever the normal hidden list says
    invoke-direct {p0, v9}, Luz/carhelper/passenger/MainActivity;->kidBlocked(Ljava/lang/String;)Z
    move-result v10
    if-nez v10, :loop
    const/4 v12, 0x0
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->kidActive()Z
    move-result v10
    if-nez v10, :not_hidden
    invoke-interface {v1, v9}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z
    move-result v12
    if-eqz v12, :not_hidden
    instance-of v10, p0, Luz/carhelper/passenger/SettingsActivity;
    if-eqz v10, :loop
    :not_hidden

    # new row every 5 items
    rem-int/lit8 v10, v5, 0x5
    if-nez v10, :have_row
    new-instance v4, Landroid/widget/LinearLayout;
    invoke-direct {v4, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/high16 v10, 0x40a00000
    invoke-virtual {v4, v10}, Landroid/widget/LinearLayout;->setWeightSum(F)V
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    :have_row

    # item: vertical icon + label, tag = component
    new-instance v10, Landroid/widget/LinearLayout;
    invoke-direct {v10, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    if-eqz v12, :tile_visible
    const v11, 0x3eb33333
    invoke-virtual {v10, v11}, Landroid/view/View;->setAlpha(F)V
    :tile_visible
    const/4 v11, 0x1
    invoke-virtual {v10, v11}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v11, 0x11
    invoke-virtual {v10, v11}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v11, 0xe
    invoke-virtual {v10, v11, v11, v11, v11}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const/high16 v11, 0x41e00000
    invoke-static {v11}, Luz/carhelper/passenger/Ui;->glass(F)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v11
    invoke-virtual {v10, v11}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    new-instance v11, Landroid/content/ComponentName;
    iget-object v12, v8, Landroid/content/pm/ActivityInfo;->name:Ljava/lang/String;
    invoke-direct {v11, v9, v12}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v11}, Landroid/content/ComponentName;->flattenToString()Ljava/lang/String;
    move-result-object v11
    invoke-virtual {v10, v11}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v10, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    # tap = open on the passenger screen, long press = the tile menu (main / passenger / Kids / hide)
    invoke-virtual {v10, p0}, Landroid/view/View;->setOnLongClickListener(Landroid/view/View$OnLongClickListener;)V

    new-instance v11, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v12, 0x0
    const/4 v13, -0x2
    const/high16 v9, 0x3f800000
    invoke-direct {v11, v12, v13, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    const/16 v12, 0x8
    invoke-virtual {v11, v12, v12, v12, v12}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v4, v10, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v11, Landroid/widget/ImageView;
    invoke-direct {v11, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v7, v0}, Landroid/content/pm/ResolveInfo;->loadIcon(Landroid/content/pm/PackageManager;)Landroid/graphics/drawable/Drawable;
    move-result-object v12
    invoke-virtual {v11, v12}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V
    new-instance v12, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v13, 0x64
    invoke-direct {v12, v13, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v10, v11, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v11, Landroid/widget/TextView;
    invoke-direct {v11, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v7, v0}, Landroid/content/pm/ResolveInfo;->loadLabel(Landroid/content/pm/PackageManager;)Ljava/lang/CharSequence;
    move-result-object v12
    invoke-virtual {v11, v12}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v12, 0x41b00000
    invoke-virtual {v11, v12}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v12, 0x11
    invoke-virtual {v11, v12}, Landroid/widget/TextView;->setGravity(I)V
    const/4 v12, 0x2
    invoke-virtual {v11, v12}, Landroid/widget/TextView;->setMaxLines(I)V
    const/4 v12, -0x1
    invoke-virtual {v11, v12}, Landroid/widget/TextView;->setTextColor(I)V
    const/4 v12, 0x0
    const/16 v13, 0x8
    invoke-virtual {v11, v12, v13, v12, v12}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v10, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    add-int/lit8 v5, v5, 0x1
    goto :loop

    :end
    invoke-direct {p0, v2}, Luz/carhelper/passenger/MainActivity;->wrapWallpaper(Landroid/view/View;)Landroid/view/View;
    move-result-object v2
    invoke-virtual {p0, v2}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V

    # opened by the main bubble's child button while child mode is on: ask for the PIN to leave it.
    # Only on a fresh start (a recreate keeps the intent but has saved state).
    if-nez p1, :no_pin
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;
    move-result-object v0
    const-string v1, "exitPin"
    const/4 v3, 0x0
    invoke-virtual {v0, v1, v3}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z
    move-result v0
    if-eqz v0, :no_pin
    const-string v0, "exit"
    invoke-static {p0, v0}, Luz/carhelper/passenger/PinDialog;->show(Landroid/app/Activity;Ljava/lang/String;)V
    :no_pin
    return-void
.end method

# a grid tile with a vector icon + label and a string tag (child mode, change wallpaper)
.method private addTile(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/LinearLayout;
    .locals 7
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v1, 0x11
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v1, 0xe
    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const/high16 v1, 0x41e00000
    invoke-static {v1}, Luz/carhelper/passenger/Ui;->glass(F)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v0, p4}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v2, 0x0
    const/4 v3, -0x2
    const/high16 v4, 0x3f800000
    invoke-direct {v1, v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    const/16 v2, 0x8
    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/widget/ImageView;
    invoke-direct {v1, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v2
    const-string v3, "drawable"
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v2, p2, v3, v4}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v2
    invoke-virtual {v1, v2}, Landroid/widget/ImageView;->setImageResource(I)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v3, 0x50
    invoke-direct {v2, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v3, 0x6
    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v0, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v1, p3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v2, 0x41a80000
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v2, 0x11
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setGravity(I)V
    const/4 v2, 0x2
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setMaxLines(I)V
    const/4 v2, -0x1
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-object v0
.end method

# ---------- apps-menu wallpaper (tap the Change wallpaper tile to cycle) ----------

.method private wrapWallpaper(Landroid/view/View;)Landroid/view/View;
    .locals 6
    instance-of v0, p0, Luz/carhelper/passenger/SettingsActivity;
    if-eqz v0, :grid
    return-object p1
    :grid
    new-instance v0, Landroid/widget/ImageView;
    invoke-direct {v0, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    sget-object v1, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V
    new-instance v1, Luz/carhelper/passenger/WallpaperFrame;
    invoke-direct {v1, p0, p0, v0}, Luz/carhelper/passenger/WallpaperFrame;-><init>(Landroid/content/Context;Landroid/app/Activity;Landroid/widget/ImageView;)V
    const/4 v2, -0x1
    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;
    invoke-direct {v3, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, v0, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    new-instance v3, Landroid/view/View;
    invoke-direct {v3, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    invoke-static {p0}, Luz/carhelper/passenger/Theme;->scrim(Landroid/content/Context;)I
    move-result v4
    invoke-virtual {v3, v4}, Landroid/view/View;->setBackgroundColor(I)V
    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;
    invoke-direct {v4, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, v3, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;
    invoke-direct {v4, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, p1, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    const-string v3, "apps"
    const/4 v4, 0x0
    invoke-virtual {p0, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3
    const-string v5, "wallpaper"
    invoke-interface {v3, v5, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v3
    invoke-virtual {v1, v3}, Luz/carhelper/passenger/WallpaperFrame;->apply(I)V
    iput-object v1, p0, Luz/carhelper/passenger/MainActivity;->wp:Luz/carhelper/passenger/WallpaperFrame;
    return-object v1
.end method

.method public onClick(Landroid/view/View;)V
    .locals 5
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;

    const-string v1, "#exit"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_exit
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :not_exit
    const-string v1, "#gotocar"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_gotocar
    new-instance v1, Landroid/content/Intent;
    const-string v2, "android.intent.action.MAIN"
    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v2, "android.intent.category.LAUNCHER"
    invoke-virtual {v1, v2}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    const-string v2, "com.leapmotor.copilotshowapp"
    const-string v3, "com.leapmotor.copilotshowapp.mvvm.main.MainActivity"
    invoke-virtual {v1, v2, v3}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
    const/high16 v2, 0x10000000
    invoke-virtual {v1, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_g
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v2
    const/4 v3, 0x3
    invoke-virtual {v2, v3}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v2}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v2
    invoke-virtual {p0, v1, v2}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    :try_end_g
    .catch Ljava/lang/Exception; {:try_start_g .. :try_end_g} :catch_g
    goto :gotocar_done
    :catch_g
    move-exception v1
    :gotocar_done
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :not_gotocar

    # change wallpaper tile: cycle 0..11 (0 = black, 1..11 = wp_N) and re-render
    const-string v1, "#wallpaper"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_wallpaper
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    const-string v2, "wallpaper"
    const/4 v3, 0x0
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v3
    add-int/lit8 v3, v3, 0x1
    rem-int/lit8 v3, v3, 0xc
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void
    :not_wallpaper

    # Close apps: popup of sideloaded apps opened on the passenger screen
    const-string v1, "#closeall"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_closeall
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->showCloseDialog()V
    return-void
    :not_closeall

    # Settings: "Also close music apps" child switch
    const-string v1, "#closemusic"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_closemusic
    const-string v2, "closeMusic"
    invoke-direct {p0, v2}, Luz/carhelper/passenger/MainActivity;->readBool(Ljava/lang/String;)Z
    move-result v1
    xor-int/lit8 v1, v1, 0x1
    invoke-direct {p0, v2, v1}, Luz/carhelper/passenger/MainActivity;->writeBool(Ljava/lang/String;Z)V
    const-string v2, "\u21b3 Also close music apps: Off"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v1, :cm_text
    const-string v2, "\u21b3 Also close music apps: On"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    :cm_text
    check-cast p1, Landroid/widget/TextView;
    invoke-virtual {p1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    return-void
    :not_closemusic

    # Settings: "Close previous app" switch
    const-string v1, "#autoclose"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_autoclose
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->readAutoClose()Z
    move-result v1
    xor-int/lit8 v1, v1, 0x1
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MainActivity;->writeAutoClose(Z)V
    const-string v2, "Close previous app: Off"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v1, :ac_text
    const-string v2, "Close previous app: On"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    :ac_text
    check-cast p1, Landroid/widget/TextView;
    invoke-virtual {p1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    return-void
    :not_autoclose

    # child mode: Enter (needs a PIN set) / Exit (PIN pad)
    const-string v1, "#childenter"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_childenter
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    const-string v3, "pin"
    const-string v4, ""
    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z
    move-result v2
    if-eqz v2, :do_childenter
    const-string v1, "Set a password in Settings first"
    invoke-static {v1}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    const/4 v2, 0x1
    invoke-static {p0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    return-void
    :do_childenter
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const-string v2, "kid"
    const/4 v3, 0x1
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V
    const/4 v1, 0x1
    invoke-static {p0, v1}, Luz/carhelper/passenger/ChildMode;->sync(Landroid/content/Context;Z)V
    # opened from the main screen: lock the passenger screen into child mode right now
    invoke-static {p0}, Luz/carhelper/passenger/ChildMode;->enter(Landroid/content/Context;)V
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void
    :not_childenter
    const-string v1, "#childexit"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_childexit
    const-string v1, "exit"
    invoke-static {p0, v1}, Luz/carhelper/passenger/PinDialog;->show(Landroid/app/Activity;Ljava/lang/String;)V
    return-void
    :not_childexit

    # Settings: hide/show apps screen (locked behind the PIN while in child mode)
    const-string v1, "#settings"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_settings
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->kidActive()Z
    move-result v1
    if-eqz v1, :open_settings
    const-string v1, "settings"
    invoke-static {v1}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-static {p0, v1}, Luz/carhelper/passenger/PinDialog;->show(Landroid/app/Activity;Ljava/lang/String;)V
    return-void
    :open_settings
    new-instance v1, Landroid/content/Intent;
    const-class v2, Luz/carhelper/passenger/SettingsActivity;
    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    return-void
    :not_settings

    # one Hide/Show bar toggle (state shared with the bubble)
    const-string v1, "#bar"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_bar
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->readBarHidden()Z
    move-result v1
    xor-int/lit8 v1, v1, 0x1
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MainActivity;->writeBarHidden(Z)V
    const/4 v2, 0x0
    const-string v3, "Hide bar"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const-string v4, "ic_bar_hide"
    if-eqz v1, :bar_send
    const/16 v2, 0x8
    const-string v3, "Show bar"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const-string v4, "ic_bar_show"
    :bar_send
    check-cast p1, Landroid/widget/TextView;
    invoke-virtual {p1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    invoke-direct {p0, v4, p1}, Luz/carhelper/passenger/MainActivity;->setPillIcon(Ljava/lang/String;Landroid/widget/TextView;)V
    new-instance v1, Landroid/content/Intent;
    const-string v3, "com.leapmotor.iqiyi.action.nav.visibility"
    invoke-direct {v1, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v3, "visibility"
    invoke-virtual {v1, v3, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;
    const-string v3, "package"
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v1, v3, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
    invoke-virtual {p0, v1}, Landroid/app/Activity;->sendBroadcast(Landroid/content/Intent;)V
    return-void
    :not_bar

    # sidebar buttons
    const-string v1, "#hide"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_hide
    const/16 v2, 0x8
    goto :send
    :not_hide
    const-string v1, "#show"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :launch
    const/4 v2, 0x0

    :send
    new-instance v1, Landroid/content/Intent;
    const-string v3, "com.leapmotor.iqiyi.action.nav.visibility"
    invoke-direct {v1, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v3, "visibility"
    invoke-virtual {v1, v3, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;
    const-string v3, "package"
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v1, v3, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
    invoke-virtual {p0, v1}, Landroid/app/Activity;->sendBroadcast(Landroid/content/Intent;)V
    return-void

    # app tile: launch on the passenger screen
    :launch
    instance-of v1, p0, Luz/carhelper/passenger/SettingsActivity;
    if-eqz v1, :do_launch
    invoke-static {v0}, Landroid/content/ComponentName;->unflattenFromString(Ljava/lang/String;)Landroid/content/ComponentName;
    move-result-object v1
    invoke-virtual {v1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;
    move-result-object v1
    const-string v2, "apps"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    new-instance v4, Ljava/util/HashSet;
    invoke-direct {v4}, Ljava/util/HashSet;-><init>()V
    const-string v3, "hidden"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v4
    new-instance v0, Ljava/util/HashSet;
    invoke-direct {v0, v4}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V
    invoke-interface {v0, v1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z
    move-result v4
    const/high16 v3, 0x3f800000
    if-nez v4, :save_hidden
    invoke-interface {v0, v1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z
    const v3, 0x3eb33333
    :save_hidden
    invoke-virtual {p1, v3}, Landroid/view/View;->setAlpha(F)V
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v4, "hidden"
    invoke-interface {v2, v4, v0}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V
    return-void
    :do_launch
    invoke-virtual {p0, v0}, Luz/carhelper/passenger/MainActivity;->openApp(Ljava/lang/String;)V
    return-void
.end method

# Open an app (flattened component name) on the passenger screen: a tile tap, or "Open on the passenger screen" in the
# tile menu. NEW_TASK | RESET_TASK_IF_NEEDED, same as a launcher tap, so a task that is already running somewhere
# (e.g. moved to the main screen) is moved here. The grid closes afterwards.
.method public openApp(Ljava/lang/String;)V
    .locals 6
    # wake the passenger screen first (car screensaver / screen rest / our own cover)
    invoke-static {p0}, Luz/carhelper/passenger/Wake;->passenger(Landroid/content/Context;)V
    invoke-static {p1}, Landroid/content/ComponentName;->unflattenFromString(Ljava/lang/String;)Landroid/content/ComponentName;
    move-result-object v0
    if-nez v0, :comp_ok
    return-void
    :comp_ok
    invoke-virtual {v0}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;
    move-result-object v4
    # v5 = true when LP Companion had this app on the MAIN screen: that screen is covered with Home afterwards
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    const-string v3, "onMain"
    invoke-interface {v1, v3, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v4, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    invoke-direct {p0, v4}, Luz/carhelper/passenger/MainActivity;->onLaunching(Ljava/lang/String;)V
    new-instance v1, Landroid/content/Intent;
    const-string v2, "android.intent.action.MAIN"
    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v2, "android.intent.category.LAUNCHER"
    invoke-virtual {v1, v2}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    invoke-virtual {v1, v0}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;
    const/high16 v2, 0x10200000
    invoke-virtual {v1, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    :try_start_0
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v2
    const/4 v3, 0x3
    invoke-virtual {v2, v3}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v2}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v2
    invoke-virtual {p0, v1, v2}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    if-eqz v5, :no_home
    invoke-static {p0}, Luz/carhelper/passenger/Swapper;->home(Landroid/content/Context;)V
    :no_home
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void

    :catch_0
    move-exception v2
    invoke-virtual {v2}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v2
    const/4 v3, 0x1
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    return-void
.end method

# long press on an app tile: the tile menu. Child mode on the passenger screen: nothing (a child must not change the
# lists or move apps). Tiles carry their component name as the tag; the other buttons use tags that start with "#".
.method public onLongClick(Landroid/view/View;)Z
    .locals 3
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->kidActive()Z
    move-result v0
    if-eqz v0, :allowed
    const/4 v0, 0x1
    return v0
    :allowed
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    instance-of v1, v0, Ljava/lang/String;
    if-nez v1, :is_string
    const/4 v0, 0x0
    return v0
    :is_string
    check-cast v0, Ljava/lang/String;
    const-string v1, "#"
    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :tile
    const/4 v0, 0x0
    return v0
    :tile
    :try_start_0
    invoke-static {p0, v0}, Luz/carhelper/passenger/TileMenu;->show(Luz/carhelper/passenger/MainActivity;Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    const/4 v0, 0x1
    return v0
.end method

# the grid on the other screen changed the wallpaper or child mode: follow it right away
.method public onSharedPreferenceChanged(Landroid/content/SharedPreferences;Ljava/lang/String;)V
    .locals 2
    const-string v0, "wallpaper"
    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :not_wallpaper
    iget-object v0, p0, Luz/carhelper/passenger/MainActivity;->wp:Luz/carhelper/passenger/WallpaperFrame;
    if-eqz v0, :done
    const/4 v1, 0x0
    invoke-interface {p1, p2, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v1
    invoke-virtual {v0, v1}, Luz/carhelper/passenger/WallpaperFrame;->apply(I)V
    return-void
    :not_wallpaper
    # child mode switched, or the Kids / hidden lists changed (Settings, or the tile menu on the other screen)
    const-string v0, "kid"
    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-nez v0, :refresh
    const-string v0, "kidApps"
    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-nez v0, :refresh
    const-string v0, "hidden"
    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-nez v0, :refresh
    # the interface language was switched in Settings: rebuild this grid in it
    const-string v0, "lang"
    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :done
    :refresh
    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z
    move-result v0
    if-nez v0, :done
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    :done
    return-void
.end method

# keep the Settings.Secure backup of the settings current (only writes when something changed)
.method protected onStop()V
    .locals 0
    invoke-super {p0}, Landroid/app/Activity;->onStop()V
    :try_start_0
    invoke-static {p0}, Luz/carhelper/passenger/Backup;->save(Landroid/content/Context;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

.method protected onDestroy()V
    .locals 2
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0, p0}, Landroid/content/SharedPreferences;->unregisterOnSharedPreferenceChangeListener(Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;)V
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V
    return-void
.end method

# ---------- "Close apps" ----------

.method private runningSet()Ljava/util/HashSet;
    .locals 4
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    new-instance v1, Ljava/util/HashSet;
    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V
    const-string v2, "running"
    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v1
    new-instance v3, Ljava/util/HashSet;
    invoke-direct {v3, v1}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V
    return-object v3
.end method

.method private saveRunning(Ljava/util/HashSet;)V
    .locals 3
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v2, "running"
    invoke-interface {v0, v2, p1}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    return-void
.end method

.method private remember(Ljava/lang/String;)V
    .locals 1
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->runningSet()Ljava/util/HashSet;
    move-result-object v0
    invoke-virtual {v0, p1}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    invoke-direct {p0, v0}, Luz/carhelper/passenger/MainActivity;->saveRunning(Ljava/util/HashSet;)V
    return-void
.end method

# every sideloaded (non-system) launchable package except this one
.method private allSideloaded()Ljava/util/HashSet;
    .locals 4
    new-instance v0, Ljava/util/HashSet;
    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v1
    new-instance v2, Landroid/content/Intent;
    const-string v3, "android.intent.action.MAIN"
    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v3, "android.intent.category.LAUNCHER"
    invoke-virtual {v2, v3}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/content/pm/PackageManager;->queryIntentActivities(Landroid/content/Intent;I)Ljava/util/List;
    move-result-object v1
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v1
    :loop
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z
    move-result v2
    if-eqz v2, :end
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Landroid/content/pm/ResolveInfo;
    iget-object v2, v2, Landroid/content/pm/ResolveInfo;->activityInfo:Landroid/content/pm/ActivityInfo;
    iget-object v3, v2, Landroid/content/pm/ActivityInfo;->applicationInfo:Landroid/content/pm/ApplicationInfo;
    iget v3, v3, Landroid/content/pm/ApplicationInfo;->flags:I
    and-int/lit8 v3, v3, 0x1
    if-nez v3, :loop
    iget-object v2, v2, Landroid/content/pm/ActivityInfo;->packageName:Ljava/lang/String;
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :loop
    invoke-virtual {v0, v2}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    goto :loop
    :end
    return-object v0
.end method

# the sideloaded apps that are really running: every one that has a process (ActivityManager) plus every one with an
# active media session, so an app the car launcher / LP Music / the wheel started shows up too. If this build only
# lets us see our own process, fall back to what LP Companion opened (passenger set + the app moved to main).
.method private runningOnMain()Ljava/util/HashSet;
    .locals 10
    new-instance v0, Ljava/util/HashSet;
    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->allSideloaded()Ljava/util/HashSet;
    move-result-object v1
    # v8 = 1 once the process list showed a package other than ours
    const/4 v8, 0x0
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v9

    :try_start_p
    const-string v2, "activity"
    invoke-virtual {p0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Landroid/app/ActivityManager;
    invoke-virtual {v2}, Landroid/app/ActivityManager;->getRunningAppProcesses()Ljava/util/List;
    move-result-object v2
    if-eqz v2, :procs_done
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v2
    :proc_loop
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z
    move-result v3
    if-eqz v3, :procs_done
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Landroid/app/ActivityManager$RunningAppProcessInfo;
    iget-object v3, v3, Landroid/app/ActivityManager$RunningAppProcessInfo;->pkgList:[Ljava/lang/String;
    if-eqz v3, :proc_loop
    array-length v4, v3
    const/4 v5, 0x0
    :pkg_loop
    if-ge v5, v4, :proc_loop
    aget-object v6, v3, v5
    add-int/lit8 v5, v5, 0x1
    invoke-virtual {v6, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v7
    if-nez v7, :pkg_loop
    const/4 v8, 0x1
    invoke-virtual {v1, v6}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z
    move-result v7
    if-eqz v7, :pkg_loop
    invoke-virtual {v0, v6}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    goto :pkg_loop
    :procs_done
    :try_end_p
    .catch Ljava/lang/Exception; {:try_start_p .. :try_end_p} :catch_p
    :catch_p

    :try_start_m
    invoke-static {p0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v2
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v2
    :sess_loop
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z
    move-result v3
    if-eqz v3, :sess_done
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Landroid/media/session/MediaController;
    invoke-virtual {v3}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z
    move-result v4
    if-eqz v4, :sess_loop
    invoke-virtual {v0, v3}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    goto :sess_loop
    :sess_done
    :try_end_m
    .catch Ljava/lang/Exception; {:try_start_m .. :try_end_m} :catch_m
    :catch_m

    if-nez v8, :have_procs
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->runningSet()Ljava/util/HashSet;
    move-result-object v2
    invoke-virtual {v0, v2}, Ljava/util/HashSet;->addAll(Ljava/util/Collection;)Z
    const-string v2, "apps"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    const-string v3, "onMain"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :have_procs
    invoke-virtual {v0, v2}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    :have_procs
    # not the apps the grid hides (Settings "shown on the grid" unticked) and not LP Music, our own helper
    const-string v2, "apps"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    const-string v3, "hidden"
    new-instance v4, Ljava/util/HashSet;
    invoke-direct {v4}, Ljava/util/HashSet;-><init>()V
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v2
    invoke-virtual {v0, v2}, Ljava/util/HashSet;->removeAll(Ljava/util/Collection;)Z
    const-string v2, "uz.carhelper.music"
    invoke-virtual {v0, v2}, Ljava/util/HashSet;->remove(Ljava/lang/Object;)Z
    const-string v2, "LPCompanion"
    invoke-static {v8}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
    move-result-object v3
    const-string v4, "close list: process list shows other apps = "
    invoke-virtual {v4, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-object v0
.end method

.method private showCloseDialog()V
    .locals 9
    # main screen lists the running sideloaded apps (passenger's plus the one moved to main); passenger lists only what it opened
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->onMain()Z
    move-result v0
    if-eqz v0, :pass_set
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->runningOnMain()Ljava/util/HashSet;
    move-result-object v1
    goto :set_ready
    :pass_set
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->runningSet()Ljava/util/HashSet;
    move-result-object v1
    :set_ready
    invoke-virtual {v1}, Ljava/util/HashSet;->isEmpty()Z
    move-result v2
    if-eqz v2, :have
    const-string v2, "No running apps to close"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/4 v3, 0x0
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    return-void

    :have
    invoke-virtual {v1}, Ljava/util/HashSet;->size()I
    move-result v2
    new-array v3, v2, [Ljava/lang/String;
    invoke-virtual {v1, v3}, Ljava/util/HashSet;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v3
    check-cast v3, [Ljava/lang/String;
    iput-object v3, p0, Luz/carhelper/passenger/MainActivity;->runningPkgs:[Ljava/lang/String;

    # app names for the list
    new-array v4, v2, [Ljava/lang/String;
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v5
    const/4 v6, 0x0
    :label_loop
    if-ge v6, v2, :label_end
    aget-object v7, v3, v6
    :try_start_l
    const/4 v8, 0x0
    invoke-virtual {v5, v7, v8}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;
    move-result-object v8
    invoke-virtual {v5, v8}, Landroid/content/pm/PackageManager;->getApplicationLabel(Landroid/content/pm/ApplicationInfo;)Ljava/lang/CharSequence;
    move-result-object v8
    invoke-interface {v8}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;
    move-result-object v7
    :try_end_l
    .catch Ljava/lang/Exception; {:try_start_l .. :try_end_l} :catch_l
    :catch_l
    aput-object v7, v4, v6
    add-int/lit8 v6, v6, 0x1
    goto :label_loop
    :label_end

    # custom dark popup (package names v3, app labels v4)
    invoke-static {p0, v3, v4}, Luz/carhelper/passenger/CloseDialog;->show(Luz/carhelper/passenger/MainActivity;[Ljava/lang/String;[Ljava/lang/String;)V
    return-void
.end method

# popup: an item closes that app, "Close all" closes every listed app
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 3
    iget-object v0, p0, Luz/carhelper/passenger/MainActivity;->runningPkgs:[Ljava/lang/String;
    if-eqz v0, :done
    const/4 v1, -0x1
    if-ne p2, v1, :single
    invoke-virtual {p0, v0}, Luz/carhelper/passenger/MainActivity;->closeApps([Ljava/lang/String;)V
    return-void
    :single
    if-ltz p2, :done
    array-length v1, v0
    if-ge p2, v1, :done
    aget-object v2, v0, p2
    const/4 v1, 0x1
    new-array v1, v1, [Ljava/lang/String;
    const/4 v0, 0x0
    aput-object v2, v1, v0
    invoke-virtual {p0, v1}, Luz/carhelper/passenger/MainActivity;->closeApps([Ljava/lang/String;)V
    :done
    return-void
.end method

# passenger screen Home (like the sidebar), then kill those apps' background processes after 800 ms
# drop pkg from the "lastPassenger" / "onMain" records; true when it was the app LP Companion put on the passenger screen
.method private forgetLast(Ljava/lang/String;)Z
    .locals 5
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const/4 v4, 0x0
    const-string v2, "lastPassenger"
    const/4 v3, 0x0
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {p1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :check_main
    invoke-interface {v1, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const/4 v4, 0x1
    :check_main
    const-string v2, "onMain"
    const/4 v3, 0x0
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {p1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :commit
    invoke-interface {v1, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    :commit
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V
    return v4
.end method

.method public closeAppsKeep([Ljava/lang/String;)V
    .locals 6
    # LP Companion's own grid stays in front; just stop + kill the chosen apps behind it.
    # From the main screen the grid is not in front of the app that is on the passenger screen, and Android will not
    # kill an app that is still showing, so that screen gets the LP grid first (below).
    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    new-instance v1, Luz/carhelper/passenger/Closer;
    invoke-virtual {p0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;
    move-result-object v2
    invoke-direct {v1, v2, p1}, Luz/carhelper/passenger/Closer;-><init>(Landroid/content/Context;[Ljava/lang/String;)V
    const-wide/16 v2, 0x320
    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    # forget the closed apps
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->runningSet()Ljava/util/HashSet;
    move-result-object v0
    array-length v1, p1
    const/4 v2, 0x0
    # v4 = 1 when one of the closed apps is the one LP Companion put on the passenger screen
    const/4 v4, 0x0
    :forget_loop
    if-ge v2, v1, :forget_end
    aget-object v3, p1, v2
    invoke-virtual {v0, v3}, Ljava/util/HashSet;->remove(Ljava/lang/Object;)Z
    invoke-direct {p0, v3}, Luz/carhelper/passenger/MainActivity;->forgetLast(Ljava/lang/String;)Z
    move-result v5
    if-eqz v5, :forget_next
    const/4 v4, 0x1
    :forget_next
    add-int/lit8 v2, v2, 0x1
    goto :forget_loop
    :forget_end
    invoke-direct {p0, v0}, Luz/carhelper/passenger/MainActivity;->saveRunning(Ljava/util/HashSet;)V
    if-eqz v4, :keep_done
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->onMain()Z
    move-result v0
    if-eqz v0, :keep_done
    invoke-static {p0}, Luz/carhelper/passenger/Swapper;->grid(Landroid/content/Context;)V
    :keep_done
    return-void
.end method

# close the given apps and refresh the grid (Close all)
.method public closeApps([Ljava/lang/String;)V
    .locals 0
    invoke-virtual {p0, p1}, Luz/carhelper/passenger/MainActivity;->closeAppsKeep([Ljava/lang/String;)V
    # do NOT finish: keep the LP Companion launcher on screen
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void
.end method

# ---------- header pills ----------

# rounded translucent pill: 40 px white icon + label
.method private addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/TextView;
    .locals 4
    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v1, 0x41d00000
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v1, -0x1
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v1, 0x10
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setGravity(I)V
    const/16 v1, 0x24
    const/16 v2, 0x14
    invoke-virtual {v0, v1, v2, v1, v2}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-static {}, Luz/carhelper/passenger/Ui;->pillBg()Landroid/graphics/drawable/StateListDrawable;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-direct {p0, p3, v0}, Luz/carhelper/passenger/MainActivity;->setPillIcon(Ljava/lang/String;Landroid/widget/TextView;)V
    const/16 v1, 0x10
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setCompoundDrawablePadding(I)V
    invoke-virtual {v0, p4}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v2, -0x2
    invoke-direct {v1, v2, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v2, 0x18
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-object v0
.end method

.method private setPillIcon(Ljava/lang/String;Landroid/widget/TextView;)V
    .locals 5
    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    const-string v1, "drawable"
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    invoke-virtual {p0, v1}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;
    move-result-object v1
    const/4 v2, 0x0
    const/16 v3, 0x28
    invoke-virtual {v1, v2, v2, v3, v3}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V
    const/4 v4, 0x0
    invoke-virtual {p2, v1, v4, v4, v4}, Landroid/widget/TextView;->setCompoundDrawables(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;)V
    return-void
.end method

# sidebar state shared with the bubble (prefs "apps" / "barHidden")
.method private readBarHidden()Z
    .locals 3
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "barHidden"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
.end method

.method private writeBarHidden(Z)V
    .locals 3
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v1, "barHidden"
    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    return-void
.end method

# ---------- "Close previous app" ----------

.method private readAutoClose()Z
    .locals 3
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "autoClose"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
.end method

.method private writeAutoClose(Z)V
    .locals 3
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v1, "autoClose"
    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    return-void
.end method

# Called when an app is opened on the passenger screen. With "Close previous app" on, the
# sideloaded apps opened there before are closed 1.5 s later (once they're behind the new one).
.method private onLaunching(Ljava/lang/String;)V
    .locals 8
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->runningSet()Ljava/util/HashSet;
    move-result-object v0
    invoke-virtual {v0, p1}, Ljava/util/HashSet;->remove(Ljava/lang/Object;)Z
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->readAutoClose()Z
    move-result v1
    if-eqz v1, :keep
    const-string v1, "closeMusic"
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MainActivity;->readBool(Ljava/lang/String;)Z
    move-result v1
    # v2 = apps to close; music apps stay unless "Also close music apps" is on
    new-instance v2, Ljava/util/ArrayList;
    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V
    new-instance v3, Ljava/util/ArrayList;
    invoke-direct {v3, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V
    invoke-virtual {v3}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;
    move-result-object v4
    :it
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z
    move-result v5
    if-eqz v5, :it_end
    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v5
    check-cast v5, Ljava/lang/String;
    if-nez v1, :close_it
    invoke-direct {p0, v5}, Luz/carhelper/passenger/MainActivity;->isMusicApp(Ljava/lang/String;)Z
    move-result v6
    if-nez v6, :it
    :close_it
    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    invoke-virtual {v0, v5}, Ljava/util/HashSet;->remove(Ljava/lang/Object;)Z
    goto :it
    :it_end
    invoke-virtual {v2}, Ljava/util/ArrayList;->isEmpty()Z
    move-result v5
    if-nez v5, :keep
    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I
    move-result v5
    new-array v5, v5, [Ljava/lang/String;
    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v5
    check-cast v5, [Ljava/lang/String;
    new-instance v6, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v7
    invoke-direct {v6, v7}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    new-instance v7, Luz/carhelper/passenger/Closer;
    invoke-virtual {p0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;
    move-result-object v4
    invoke-direct {v7, v4, v5}, Luz/carhelper/passenger/Closer;-><init>(Landroid/content/Context;[Ljava/lang/String;)V
    const-wide/16 v3, 0x5dc
    invoke-virtual {v6, v7, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :keep
    invoke-virtual {v0, p1}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    invoke-direct {p0, v0}, Luz/carhelper/passenger/MainActivity;->saveRunning(Ljava/util/HashSet;)V
    # for the bubble's swap button: this app is now the one on the passenger screen
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    const-string v3, "onMain"
    invoke-interface {v1, v3, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const-string v4, "lastPassenger"
    invoke-interface {v1, v4, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :apply_last
    invoke-interface {v1, v3}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    :apply_last
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V
    return-void
.end method

# kid mode (set in Settings, PIN-protected)
.method private kidOn()Z
    .locals 1
    const-string v0, "kid"
    invoke-direct {p0, v0}, Luz/carhelper/passenger/MainActivity;->readBool(Ljava/lang/String;)Z
    move-result v0
    return v0
.end method

# true when this grid is on the car's MAIN screen (display 0)
.method private onMain()Z
    .locals 2
    :try_start_0
    invoke-virtual {p0}, Landroid/app/Activity;->getDisplay()Landroid/view/Display;
    move-result-object v0
    if-eqz v0, :no
    invoke-virtual {v0}, Landroid/view/Display;->getDisplayId()I
    move-result v0
    if-nez v0, :no
    const/4 v0, 0x1
    return v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :no
    const/4 v0, 0x0
    return v0
.end method

# child mode filters apps only on the passenger screen; the main screen always shows all
.method private kidActive()Z
    .locals 1
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->kidOn()Z
    move-result v0
    if-eqz v0, :off
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->onMain()Z
    move-result v0
    if-nez v0, :off
    const/4 v0, 0x1
    return v0
    :off
    const/4 v0, 0x0
    return v0
.end method

# true when a child-mode PIN has been set
.method private pinSet()Z
    .locals 4
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v2, "pin"
    const-string v3, ""
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z
    move-result v0
    xor-int/lit8 v0, v0, 0x1
    return v0
.end method

# true = kid mode is active (passenger screen) and this package isn't ticked "Kids"
.method private kidBlocked(Ljava/lang/String;)Z
    .locals 3
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;->kidActive()Z
    move-result v0
    if-eqz v0, :allowed
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    new-instance v1, Ljava/util/HashSet;
    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V
    const-string v2, "kidApps"
    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v0
    invoke-interface {v0, p1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z
    move-result v0
    xor-int/lit8 v0, v0, 0x1
    return v0
    :allowed
    const/4 v0, 0x0
    return v0
.end method

.method private readBool(Ljava/lang/String;)Z
    .locals 3
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const/4 v2, 0x0
    invoke-interface {v0, p1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
.end method

.method private writeBool(Ljava/lang/String;Z)V
    .locals 2
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    return-void
.end method

# music app = declares the "audio" app category, or offers a MediaBrowserService (how players expose playback to cars)
.method private isMusicApp(Ljava/lang/String;)Z
    .locals 4
    :try_start_0
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v0
    const/4 v1, 0x0
    invoke-virtual {v0, p1, v1}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;
    move-result-object v1
    iget v2, v1, Landroid/content/pm/ApplicationInfo;->category:I
    const/4 v3, 0x1
    if-eq v2, v3, :yes
    new-instance v1, Landroid/content/Intent;
    const-string v2, "android.media.browse.MediaBrowserService"
    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    invoke-virtual {v1, p1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/pm/PackageManager;->queryIntentServices(Landroid/content/Intent;I)Ljava/util/List;
    move-result-object v1
    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z
    move-result v1
    if-eqz v1, :yes
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    const/4 v0, 0x0
    return v0
    :yes
    const/4 v0, 0x1
    return v0
.end method

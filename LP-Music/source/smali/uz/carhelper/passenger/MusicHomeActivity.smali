.class public Luz/carhelper/passenger/MusicHomeActivity;
.super Landroid/app/Activity;
.implements Landroid/view/View$OnClickListener;
.implements Ljava/lang/Runnable;

# LP Music's home screen and its launcher activity (the app-list icon and the car's dock-card tap both open it):
#   header   "LP Music by abbosjon99" on the left, the Settings button on the right
#   widget   the now-playing card (NowPlaying): cover, title, artist, progress, prev / play-pause / next
#   button   "Open playing app"
#   warning  shown while the notification access is off; a tap opens the car's Notification access page
# On a faint music backdrop (res/drawable/bg_music). All text comes from Lang. Opening the page starts the media
# service when LP Music is on but the service is down. Child mode (shared with LP Companion) locks it like Settings.

.field private lang:Ljava/lang/String;
.field private handler:Landroid/os/Handler;
.field private now:Luz/carhelper/passenger/NowPlaying;
.field private openBtn:Landroid/widget/TextView;
.field private warn:Landroid/widget/TextView;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    return-void
.end method

.method private drawableId(Ljava/lang/String;)I
    .locals 3
    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    const-string v1, "drawable"
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v0
    return v0
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 8
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    # child mode is shared with LP Companion: when it is on, LP Music is locked too
    invoke-static {p0}, Luz/carhelper/passenger/ChildMode;->locked(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :not_child_locked
    const-string v0, "toast_child"
    invoke-static {p0, v0}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    const/4 v1, 0x1
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :not_child_locked

    invoke-static {p0}, Luz/carhelper/passenger/Lang;->chosen(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v0
    iput-object v0, p0, Luz/carhelper/passenger/MusicHomeActivity;->lang:Ljava/lang/String;
    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v0, p0, Luz/carhelper/passenger/MusicHomeActivity;->handler:Landroid/os/Handler;

    # the music backdrop is the window background, so it also fills behind the car's bars
    const-string v0, "bg_music"
    invoke-direct {p0, v0}, Luz/carhelper/passenger/MusicHomeActivity;->drawableId(Ljava/lang/String;)I
    move-result v0
    if-eqz v0, :no_bg
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v1
    invoke-virtual {v1, v0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V
    :no_bg

    # v0 = page
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v1, 0x40
    const/16 v2, 0x28
    const/16 v3, 0x30
    invoke-virtual {v0, v1, v2, v1, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # header: title row (weight 1) + Settings button
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const-string v2, "LP Music"
    const/high16 v4, 0x42200000
    const/4 v5, -0x1
    const/4 v6, 0x1
    invoke-static {p0, v2, v4, v5, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    invoke-virtual {v3, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    const-string v2, "by abbosjon99"
    const/high16 v4, 0x41c00000
    sget v5, Luz/carhelper/passenger/Ui;->TEXT2:I
    const/4 v6, 0x0
    invoke-static {p0, v2, v4, v5, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    const/16 v4, 0x12
    invoke-virtual {v2, v4, v6, v6, v6}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v3, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/high16 v4, 0x3f800000
    const/4 v5, -0x2
    invoke-direct {v2, v6, v5, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v1, v3, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const-string v2, "st_title"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const v3, 0x2effffff
    const v4, 0x44ffffff
    sget v5, Luz/carhelper/passenger/Ui;->STROKE:I
    invoke-static {p0, v2, v3, v4, v5}, Luz/carhelper/passenger/Ui;->pill(Landroid/content/Context;Ljava/lang/CharSequence;III)Landroid/widget/TextView;
    move-result-object v2
    const-string v3, "#settings"
    invoke-virtual {v2, v3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v2, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # body: takes the free height and centres the column (1280 px wide) in it
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v2, 0x11
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v3, -0x1
    const/4 v4, 0x0
    const/high16 v5, 0x3f800000
    invoke-direct {v2, v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v0, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    new-instance v2, Landroid/widget/LinearLayout;
    invoke-direct {v2, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v3, 0x1
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v4, 0x640
    const/4 v5, -0x2
    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # the widget
    new-instance v3, Luz/carhelper/passenger/NowPlaying;
    invoke-direct {v3, p0}, Luz/carhelper/passenger/NowPlaying;-><init>(Landroid/app/Activity;)V
    iput-object v3, p0, Luz/carhelper/passenger/MusicHomeActivity;->now:Luz/carhelper/passenger/NowPlaying;
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Open playing app
    const-string v3, "btn_open_player"
    invoke-static {p0, v3}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    sget v4, Luz/carhelper/passenger/Ui;->ACCENT:I
    sget v5, Luz/carhelper/passenger/Ui;->ACCENT_PRESSED:I
    const/4 v6, 0x0
    invoke-static {p0, v3, v4, v5, v6}, Luz/carhelper/passenger/Ui;->pill(Landroid/content/Context;Ljava/lang/CharSequence;III)Landroid/widget/TextView;
    move-result-object v3
    const/high16 v4, 0x41e00000
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v4, 0x11
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setGravity(I)V
    const/16 v4, 0x28
    const/16 v5, 0x1e
    invoke-virtual {v3, v4, v5, v4, v5}, Landroid/widget/TextView;->setPadding(IIII)V
    const-string v4, "#open"
    invoke-virtual {v3, v4}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v3, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v3, p0, Luz/carhelper/passenger/MusicHomeActivity;->openBtn:Landroid/widget/TextView;
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x1
    const/4 v7, -0x2
    invoke-direct {v4, v5, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v5, 0x1c
    invoke-virtual {v4, v6, v5, v6, v6}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # warning while the notification access is off (hidden until run() finds it missing)
    const-string v3, "warn_perm"
    invoke-static {p0, v3}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const v4, 0x33ff6b6b
    const v5, 0x55ff6b6b
    const v7, 0x66ff6b6b
    invoke-static {p0, v3, v4, v5, v7}, Luz/carhelper/passenger/Ui;->pill(Landroid/content/Context;Ljava/lang/CharSequence;III)Landroid/widget/TextView;
    move-result-object v3
    const/high16 v4, 0x41b00000
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v4, 0x11
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setGravity(I)V
    const-string v4, "#perm"
    invoke-virtual {v3, v4}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v3, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    const/16 v4, 0x8
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V
    iput-object v3, p0, Luz/carhelper/passenger/MusicHomeActivity;->warn:Landroid/widget/TextView;
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x1
    const/4 v7, -0x2
    invoke-direct {v4, v5, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v5, 0x14
    invoke-virtual {v4, v6, v5, v6, v6}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V
    return-void
.end method

.method protected onResume()V
    .locals 3
    invoke-super {p0}, Landroid/app/Activity;->onResume()V
    iget-object v0, p0, Luz/carhelper/passenger/MusicHomeActivity;->handler:Landroid/os/Handler;
    if-nez v0, :built
    return-void
    :built
    # a language picked in Settings while this page was behind: rebuild in that language
    invoke-static {p0}, Luz/carhelper/passenger/Lang;->chosen(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v1
    iget-object v2, p0, Luz/carhelper/passenger/MusicHomeActivity;->lang:Ljava/lang/String;
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :same_lang
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void
    :same_lang
    # the media service: start it when LP Music is on but the service is down
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->enabled(Landroid/content/Context;)Z
    move-result v1
    if-eqz v1, :poll
    sget-boolean v1, Luz/carhelper/passenger/MediaBrowser;->running:Z
    if-nez v1, :poll
    new-instance v1, Landroid/content/Intent;
    const-class v2, Luz/carhelper/passenger/MediaBrowser;
    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    :try_start_0
    invoke-virtual {p0, v1}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :poll
    invoke-virtual {v0, p0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V
    invoke-virtual {v0, p0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    return-void
.end method

.method protected onPause()V
    .locals 1
    invoke-super {p0}, Landroid/app/Activity;->onPause()V
    iget-object v0, p0, Luz/carhelper/passenger/MusicHomeActivity;->handler:Landroid/os/Handler;
    if-eqz v0, :done
    invoke-virtual {v0, p0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V
    :done
    return-void
.end method

# once a second: dim the Open button when no player is known, show the warning while the notification access is off
.method public run()V
    .locals 3
    :try_start_0
    iget-object v0, p0, Luz/carhelper/passenger/MusicHomeActivity;->now:Luz/carhelper/passenger/NowPlaying;
    invoke-virtual {v0}, Luz/carhelper/passenger/NowPlaying;->hasPlayer()Z
    move-result v0
    iget-object v1, p0, Luz/carhelper/passenger/MusicHomeActivity;->openBtn:Landroid/widget/TextView;
    const/high16 v2, 0x3f800000
    if-nez v0, :bright
    const v2, 0x3ecccccd
    :bright
    invoke-virtual {v1, v2}, Landroid/view/View;->setAlpha(F)V
    invoke-static {p0}, Luz/carhelper/passenger/Perm;->missing(Landroid/content/Context;)Z
    move-result v0
    iget-object v1, p0, Luz/carhelper/passenger/MusicHomeActivity;->warn:Landroid/widget/TextView;
    const/16 v2, 0x8
    if-eqz v0, :hidden
    const/4 v2, 0x0
    :hidden
    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    iget-object v0, p0, Luz/carhelper/passenger/MusicHomeActivity;->handler:Landroid/os/Handler;
    const-wide/16 v1, 0x3e8
    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
.end method

.method private toast(Ljava/lang/String;)V
    .locals 2
    invoke-static {p0, p1}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    const/4 v1, 0x0
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 3
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    if-nez v0, :has_tag
    return-void
    :has_tag
    check-cast v0, Ljava/lang/String;
    const-string v1, "#settings"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_settings
    new-instance v1, Landroid/content/Intent;
    const-class v2, Luz/carhelper/passenger/MusicSettingsActivity;
    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    :try_start_0
    invoke-virtual {p0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
    :not_settings
    const-string v1, "#open"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_open
    iget-object v1, p0, Luz/carhelper/passenger/MusicHomeActivity;->now:Luz/carhelper/passenger/NowPlaying;
    invoke-virtual {v1}, Luz/carhelper/passenger/NowPlaying;->openPlayer()Z
    move-result v1
    if-nez v1, :done
    const-string v1, "toast_no_player"
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MusicHomeActivity;->toast(Ljava/lang/String;)V
    :done
    return-void
    :not_open
    const-string v1, "#perm"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :end
    invoke-static {p0}, Luz/carhelper/passenger/Perm;->open(Landroid/content/Context;)Z
    move-result v1
    if-nez v1, :end
    const-string v1, "toast_no_page"
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MusicHomeActivity;->toast(Ljava/lang/String;)V
    :end
    return-void
.end method

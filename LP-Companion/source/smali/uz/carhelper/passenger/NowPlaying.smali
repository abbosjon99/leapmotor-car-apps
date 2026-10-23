.class public Luz/carhelper/passenger/NowPlaying;
.super Landroid/widget/LinearLayout;
.implements Landroid/view/View$OnClickListener;
.implements Ljava/lang/Runnable;

# A now-playing bar for the passenger grid. Shows whatever MediaSession is active on the car
# from ANY source (car radio/Bluetooth/the main screen or a sideloaded player) and controls it.
# Needs the notification-listener access that WheelListener already grants (getActiveSessions).
# Hidden when nothing is playing. Refreshes every second while attached.

.field private final act:Landroid/app/Activity;
.field private art:Landroid/widget/ImageView;
.field private title:Landroid/widget/TextView;
.field private artist:Landroid/widget/TextView;
.field private playBtn:Landroid/widget/ImageView;
.field private handler:Landroid/os/Handler;

.method public constructor <init>(Landroid/app/Activity;)V
    .locals 9
    invoke-direct {p0, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    iput-object p1, p0, Luz/carhelper/passenger/NowPlaying;->act:Landroid/app/Activity;
    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v0, p0, Luz/carhelper/passenger/NowPlaying;->handler:Landroid/os/Handler;
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v0, 0x10
    invoke-virtual {p0, v0}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v0, 0x14
    invoke-virtual {p0, v0, v0, v0, v0}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    const v1, 0x33ffffff
    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    const/high16 v1, 0x41c00000
    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {p0, v0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # album art
    new-instance v0, Landroid/widget/ImageView;
    invoke-direct {v0, p1}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    sget-object v1, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V
    iput-object v0, p0, Luz/carhelper/passenger/NowPlaying;->art:Landroid/widget/ImageView;
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v2, 0x60
    invoke-direct {v1, v2, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v3, 0xd
    const/4 v4, 0x0
    invoke-virtual {v1, v4, v4, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p0, v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # text column (title + artist), weight 1
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const/high16 v3, 0x41b00000
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v3, -0x1
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V
    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setMaxLines(I)V
    iput-object v2, p0, Luz/carhelper/passenger/NowPlaying;->title:Landroid/widget/TextView;
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const/high16 v3, 0x41600000
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V
    const v3, -0x555556
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V
    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setMaxLines(I)V
    iput-object v2, p0, Luz/carhelper/passenger/NowPlaying;->artist:Landroid/widget/TextView;
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v3, 0x0
    const/4 v5, -0x2
    const/high16 v6, 0x3f800000
    invoke-direct {v2, v3, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {p0, v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # controls
    const-string v0, "ic_prev"
    const-string v1, "prev"
    invoke-direct {p0, v0, v1}, Luz/carhelper/passenger/NowPlaying;->ctl(Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    const-string v0, "ic_play"
    const-string v1, "play"
    invoke-direct {p0, v0, v1}, Luz/carhelper/passenger/NowPlaying;->ctl(Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    move-result-object v0
    iput-object v0, p0, Luz/carhelper/passenger/NowPlaying;->playBtn:Landroid/widget/ImageView;
    const-string v0, "ic_next"
    const-string v1, "next"
    invoke-direct {p0, v0, v1}, Luz/carhelper/passenger/NowPlaying;->ctl(Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    return-void
.end method

.method private ctl(Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    .locals 6
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->act:Landroid/app/Activity;
    new-instance v1, Landroid/widget/ImageView;
    invoke-direct {v1, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;
    move-result-object v2
    const-string v3, "drawable"
    invoke-virtual {v0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v2, p1, v3, v4}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v2
    invoke-virtual {v1, v2}, Landroid/widget/ImageView;->setImageResource(I)V
    const/16 v2, 0xe
    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/ImageView;->setPadding(IIII)V
    invoke-virtual {v1, p2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v3, 0x50
    invoke-direct {v2, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {p0, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-object v1
.end method

# the active controller from any source: first playing session, else the most recent one
.method private controller()Landroid/media/session/MediaController;
    .locals 5
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->act:Landroid/app/Activity;
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->getSessions(Landroid/content/Context;)Ljava/util/List;
    move-result-object v0
    const/4 v1, 0x0
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v0
    :loop
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z
    move-result v2
    if-eqz v2, :end
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Landroid/media/session/MediaController;
    invoke-static {v2}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v3
    if-eqz v3, :keep
    return-object v2
    :keep
    if-nez v1, :loop
    move-object v1, v2
    goto :loop
    :end
    return-object v1
.end method

.method private str(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    if-eqz p1, :empty
    invoke-virtual {p1, p2}, Landroid/media/MediaMetadata;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :empty
    return-object v0
    :empty
    const-string v0, ""
    return-object v0
.end method

.method private refresh()V
    .locals 5
    invoke-direct {p0}, Luz/carhelper/passenger/NowPlaying;->controller()Landroid/media/session/MediaController;
    move-result-object v0
    if-nez v0, :have
    const/16 v1, 0x8
    invoke-virtual {p0, v1}, Landroid/view/View;->setVisibility(I)V
    return-void
    :have
    const/4 v1, 0x0
    invoke-virtual {p0, v1}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {v0}, Landroid/media/session/MediaController;->getMetadata()Landroid/media/MediaMetadata;
    move-result-object v1
    iget-object v2, p0, Luz/carhelper/passenger/NowPlaying;->title:Landroid/widget/TextView;
    const-string v3, "android.media.metadata.TITLE"
    invoke-direct {p0, v1, v3}, Luz/carhelper/passenger/NowPlaying;->str(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    iget-object v2, p0, Luz/carhelper/passenger/NowPlaying;->artist:Landroid/widget/TextView;
    const-string v3, "android.media.metadata.ARTIST"
    invoke-direct {p0, v1, v3}, Luz/carhelper/passenger/NowPlaying;->str(Landroid/media/MediaMetadata;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    # album art
    iget-object v2, p0, Luz/carhelper/passenger/NowPlaying;->art:Landroid/widget/ImageView;
    const/4 v3, 0x0
    if-eqz v1, :no_art
    const-string v4, "android.media.metadata.ALBUM_ART"
    invoke-virtual {v1, v4}, Landroid/media/MediaMetadata;->getBitmap(Ljava/lang/String;)Landroid/graphics/Bitmap;
    move-result-object v3
    if-nez v3, :no_art
    const-string v4, "android.media.metadata.ART"
    invoke-virtual {v1, v4}, Landroid/media/MediaMetadata;->getBitmap(Ljava/lang/String;)Landroid/graphics/Bitmap;
    move-result-object v3
    :no_art
    if-eqz v3, :art_fallback
    invoke-virtual {v2, v3}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V
    goto :art_done
    :art_fallback
    const-string v4, "ic_music"
    invoke-direct {p0, v4}, Luz/carhelper/passenger/NowPlaying;->resId(Ljava/lang/String;)I
    move-result v4
    invoke-virtual {v2, v4}, Landroid/widget/ImageView;->setImageResource(I)V
    :art_done
    # play/pause icon
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v0
    iget-object v2, p0, Luz/carhelper/passenger/NowPlaying;->playBtn:Landroid/widget/ImageView;
    const-string v3, "ic_play"
    if-eqz v0, :icon
    const-string v3, "ic_pause"
    :icon
    invoke-direct {p0, v3}, Luz/carhelper/passenger/NowPlaying;->resId(Ljava/lang/String;)I
    move-result v3
    invoke-virtual {v2, v3}, Landroid/widget/ImageView;->setImageResource(I)V
    return-void
.end method

.method private resId(Ljava/lang/String;)I
    .locals 4
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->act:Landroid/app/Activity;
    invoke-virtual {v0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;
    move-result-object v1
    const-string v2, "drawable"
    invoke-virtual {v0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v1, p1, v2, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v0
    return v0
.end method

.method public onClick(Landroid/view/View;)V
    .locals 4
    invoke-direct {p0}, Luz/carhelper/passenger/NowPlaying;->controller()Landroid/media/session/MediaController;
    move-result-object v0
    if-nez v0, :have
    return-void
    :have
    invoke-virtual {v0}, Landroid/media/session/MediaController;->getTransportControls()Landroid/media/session/MediaController$TransportControls;
    move-result-object v1
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Ljava/lang/String;
    const-string v3, "prev"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :not_prev
    invoke-virtual {v1}, Landroid/media/session/MediaController$TransportControls;->skipToPrevious()V
    goto :after
    :not_prev
    const-string v3, "next"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :toggle
    invoke-virtual {v1}, Landroid/media/session/MediaController$TransportControls;->skipToNext()V
    goto :after
    :toggle
    invoke-static {v0}, Luz/carhelper/passenger/WheelReceiver;->isPlaying(Landroid/media/session/MediaController;)Z
    move-result v3
    if-eqz v3, :do_play
    invoke-virtual {v1}, Landroid/media/session/MediaController$TransportControls;->pause()V
    goto :after
    :do_play
    invoke-virtual {v1}, Landroid/media/session/MediaController$TransportControls;->play()V
    :after
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->handler:Landroid/os/Handler;
    const-wide/16 v1, 0x12c
    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
.end method

.method public run()V
    .locals 3
    :try_start_0
    invoke-direct {p0}, Luz/carhelper/passenger/NowPlaying;->refresh()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->handler:Landroid/os/Handler;
    const-wide/16 v1, 0x3e8
    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
.end method

.method protected onAttachedToWindow()V
    .locals 2
    invoke-super {p0}, Landroid/widget/LinearLayout;->onAttachedToWindow()V
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->handler:Landroid/os/Handler;
    invoke-virtual {v0, p0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->handler:Landroid/os/Handler;
    invoke-virtual {v0, p0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    return-void
.end method

.method protected onDetachedFromWindow()V
    .locals 1
    invoke-super {p0}, Landroid/widget/LinearLayout;->onDetachedFromWindow()V
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->handler:Landroid/os/Handler;
    invoke-virtual {v0, p0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V
    return-void
.end method

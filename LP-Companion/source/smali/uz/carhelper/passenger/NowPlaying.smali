.class public Luz/carhelper/passenger/NowPlaying;
.super Landroid/widget/LinearLayout;
.implements Landroid/view/View$OnClickListener;
.implements Ljava/lang/Runnable;

# Now-playing card for the grid. Shows whatever MediaSession is active on the car from ANY source
# (car radio/Bluetooth/the main screen or a sideloaded player) and controls it:
#   rounded cover, bold title, artist, a thin progress bar, prev / play-pause / next.
# The card is tinted with the cover's average colour (cover squeezed to one pixel, shown at low
# opacity over a dark base so the text stays readable on any cover).
# Needs the notification-listener access that MediaListener already grants (getActiveSessions).
# Hidden when nothing is playing, and always hidden in child mode on the passenger screen (no music
# controls and no way into the music app). Refreshes every second while attached.

.field private final act:Landroid/app/Activity;
.field private art:Landroid/widget/ImageView;
.field private title:Landroid/widget/TextView;
.field private artist:Landroid/widget/TextView;
.field private playBtn:Landroid/widget/ImageView;
.field private handler:Landroid/os/Handler;
.field private bar:Landroid/widget/LinearLayout;
.field private barFill:Landroid/view/View;
.field private barGap:Landroid/view/View;
.field private lastKey:Ljava/lang/String;

.method public constructor <init>(Landroid/app/Activity;)V
    .locals 10
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
    const/16 v1, 0x12
    invoke-virtual {p0, v0, v1, v0, v1}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const/high16 v0, 0x42000000
    invoke-static {v0}, Luz/carhelper/passenger/Ui;->dark(F)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v0
    invoke-virtual {p0, v0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # cover, 112 px with rounded corners
    new-instance v0, Landroid/widget/ImageView;
    invoke-direct {v0, p1}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    sget-object v1, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V
    iput-object v0, p0, Luz/carhelper/passenger/NowPlaying;->art:Landroid/widget/ImageView;
    const v1, 0x22ffffff
    const/4 v2, 0x0
    const/high16 v3, 0x41b00000
    invoke-static {v1, v2, v3}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/view/View;->setClipToOutline(Z)V
    const-string v1, "open"
    invoke-virtual {v0, v1}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v2, 0x70
    invoke-direct {v1, v2, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v3, 0x14
    const/4 v4, 0x0
    invoke-virtual {v1, v4, v4, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p0, v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # text column (title, artist, progress), takes the free width
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const-string v1, "open"
    invoke-virtual {v0, v1}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const-string v1, ""
    const/high16 v2, 0x41e00000
    const/4 v3, -0x1
    const/4 v4, 0x1
    invoke-static {p1, v1, v2, v3, v4}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v1
    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setMaxLines(I)V
    sget-object v2, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V
    iput-object v1, p0, Luz/carhelper/passenger/NowPlaying;->title:Landroid/widget/TextView;
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const-string v1, ""
    const/high16 v2, 0x41a00000
    sget v3, Luz/carhelper/passenger/Ui;->TEXT2:I
    const/4 v4, 0x0
    invoke-static {p1, v1, v2, v3, v4}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v1
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setMaxLines(I)V
    sget-object v2, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V
    iput-object v1, p0, Luz/carhelper/passenger/NowPlaying;->artist:Landroid/widget/TextView;
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # progress: a thin rounded track with a bright fill; the fill and gap weights are set by progress()
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/high16 v2, 0x3f800000
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setWeightSum(F)V
    const v2, 0x33ffffff
    const/4 v3, 0x0
    const/high16 v4, 0x40400000
    invoke-static {v2, v3, v4}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v2
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    new-instance v2, Landroid/view/View;
    invoke-direct {v2, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    const v5, 0xf2ffffff
    invoke-static {v5, v3, v4}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v5
    invoke-virtual {v2, v5}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    iput-object v2, p0, Luz/carhelper/passenger/NowPlaying;->barFill:Landroid/view/View;
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v6, -0x1
    const/4 v7, 0x0
    invoke-direct {v5, v3, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v1, v2, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    new-instance v2, Landroid/view/View;
    invoke-direct {v2, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    iput-object v2, p0, Luz/carhelper/passenger/NowPlaying;->barGap:Landroid/view/View;
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    const/high16 v7, 0x3f800000
    invoke-direct {v5, v3, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v1, v2, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    iput-object v1, p0, Luz/carhelper/passenger/NowPlaying;->bar:Landroid/widget/LinearLayout;
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, 0x6
    invoke-direct {v2, v6, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v5, 0x10
    invoke-virtual {v2, v3, v5, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v0, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v2, -0x2
    const/high16 v3, 0x3f800000
    const/4 v4, 0x0
    invoke-direct {v1, v4, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {p0, v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # controls: ghost prev / filled play-pause / ghost next
    const-string v0, "ic_prev"
    const-string v1, "prev"
    const/16 v2, 0x50
    const/4 v3, 0x0
    invoke-direct {p0, v0, v1, v2, v3}, Luz/carhelper/passenger/NowPlaying;->ctl(Ljava/lang/String;Ljava/lang/String;IZ)Landroid/widget/ImageView;
    const-string v0, "ic_play"
    const-string v1, "play"
    const/16 v2, 0x5c
    const/4 v3, 0x1
    invoke-direct {p0, v0, v1, v2, v3}, Luz/carhelper/passenger/NowPlaying;->ctl(Ljava/lang/String;Ljava/lang/String;IZ)Landroid/widget/ImageView;
    move-result-object v0
    iput-object v0, p0, Luz/carhelper/passenger/NowPlaying;->playBtn:Landroid/widget/ImageView;
    const-string v0, "ic_next"
    const-string v1, "next"
    const/16 v2, 0x50
    const/4 v3, 0x0
    invoke-direct {p0, v0, v1, v2, v3}, Luz/carhelper/passenger/NowPlaying;->ctl(Ljava/lang/String;Ljava/lang/String;IZ)Landroid/widget/ImageView;
    return-void
.end method

# round control button of p3 px; p4 = filled white with a dark glyph, otherwise a ghost glass circle
.method private ctl(Ljava/lang/String;Ljava/lang/String;IZ)Landroid/widget/ImageView;
    .locals 8
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
    div-int/lit8 v2, p3, 0x6
    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/ImageView;->setPadding(IIII)V
    int-to-float v6, p3
    const/high16 v7, 0x3f000000
    mul-float/2addr v6, v7
    const/4 v5, 0x0
    if-eqz p4, :ghost
    const/4 v3, -0x1
    const v4, 0xffd5dbe6
    invoke-static {v3, v4, v5, v6}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    const v3, 0xff10131a
    invoke-virtual {v1, v3}, Landroid/widget/ImageView;->setColorFilter(I)V
    goto :styled
    :ghost
    const v3, 0x26ffffff
    const v4, 0x59ffffff
    invoke-static {v3, v4, v5, v6}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    :styled
    invoke-virtual {v1, p2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v2, p3, p3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v3, 0xa
    invoke-virtual {v2, v3, v5, v5, v5}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
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

# tint the card with the cover's average colour (p1 = cover, null = plain dark card).
# p2 identifies the track + cover; every getMetadata() hands back fresh objects, so the card is only
# rebuilt when that key changes.
.method private tint(Landroid/graphics/Bitmap;Ljava/lang/String;)V
    .locals 5
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->lastKey:Ljava/lang/String;
    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :changed
    return-void
    :changed
    iput-object p2, p0, Luz/carhelper/passenger/NowPlaying;->lastKey:Ljava/lang/String;
    const/high16 v0, 0x42000000
    invoke-static {v0}, Luz/carhelper/passenger/Ui;->dark(F)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v0
    if-nez p1, :has_art
    invoke-virtual {p0, v0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    return-void
    :has_art
    const/4 v1, 0x1
    invoke-static {p1, v1, v1, v1}, Landroid/graphics/Bitmap;->createScaledBitmap(Landroid/graphics/Bitmap;IIZ)Landroid/graphics/Bitmap;
    move-result-object v1
    const/4 v2, 0x0
    invoke-virtual {v1, v2, v2}, Landroid/graphics/Bitmap;->getPixel(II)I
    move-result v1
    const v2, 0xffffff
    and-int/2addr v1, v2
    const/high16 v2, 0x50000000
    or-int/2addr v2, v1
    const/high16 v3, 0x10000000
    or-int/2addr v1, v3
    const/4 v3, 0x2
    new-array v3, v3, [I
    const/4 v4, 0x0
    aput v2, v3, v4
    const/4 v4, 0x1
    aput v1, v3, v4
    new-instance v1, Landroid/graphics/drawable/GradientDrawable;
    sget-object v2, Landroid/graphics/drawable/GradientDrawable$Orientation;->LEFT_RIGHT:Landroid/graphics/drawable/GradientDrawable$Orientation;
    invoke-direct {v1, v2, v3}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V
    const/high16 v2, 0x42000000
    invoke-virtual {v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    const/4 v2, 0x2
    new-array v2, v2, [Landroid/graphics/drawable/Drawable;
    const/4 v3, 0x0
    aput-object v0, v2, v3
    const/4 v3, 0x1
    aput-object v1, v2, v3
    new-instance v0, Landroid/graphics/drawable/LayerDrawable;
    invoke-direct {v0, v2}, Landroid/graphics/drawable/LayerDrawable;-><init>([Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {p0, v0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    return-void
.end method

# progress bar: position (moved on while playing) over the track's duration; hidden without a duration
.method private progress(Landroid/media/session/MediaController;Landroid/media/MediaMetadata;)V
    .locals 10
    invoke-virtual {p1}, Landroid/media/session/MediaController;->getPlaybackState()Landroid/media/session/PlaybackState;
    move-result-object v0
    if-eqz p2, :hide
    if-eqz v0, :hide
    const-string v1, "android.media.metadata.DURATION"
    invoke-virtual {p2, v1}, Landroid/media/MediaMetadata;->getLong(Ljava/lang/String;)J
    move-result-wide v1
    const-wide/16 v3, 0x0
    cmp-long v5, v1, v3
    if-lez v5, :hide
    invoke-virtual {v0}, Landroid/media/session/PlaybackState;->getPosition()J
    move-result-wide v3
    invoke-virtual {v0}, Landroid/media/session/PlaybackState;->getState()I
    move-result v5
    const/4 v6, 0x3
    if-ne v5, v6, :fraction
    invoke-virtual {v0}, Landroid/media/session/PlaybackState;->getLastPositionUpdateTime()J
    move-result-wide v5
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v7
    sub-long/2addr v7, v5
    invoke-virtual {v0}, Landroid/media/session/PlaybackState;->getPlaybackSpeed()F
    move-result v0
    long-to-float v5, v7
    mul-float/2addr v5, v0
    float-to-long v5, v5
    add-long/2addr v3, v5
    :fraction
    long-to-float v5, v3
    long-to-float v6, v1
    div-float/2addr v5, v6
    const/4 v6, 0x0
    cmpg-float v7, v5, v6
    if-gez v7, :not_negative
    move v5, v6
    :not_negative
    const/high16 v6, 0x3f800000
    cmpl-float v7, v5, v6
    if-lez v7, :not_over
    move v5, v6
    :not_over
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->barFill:Landroid/view/View;
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v1
    check-cast v1, Landroid/widget/LinearLayout$LayoutParams;
    iput v5, v1, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    sub-float/2addr v6, v5
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->barGap:Landroid/view/View;
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v1
    check-cast v1, Landroid/widget/LinearLayout$LayoutParams;
    iput v6, v1, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->bar:Landroid/widget/LinearLayout;
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V
    return-void
    :hide
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->bar:Landroid/widget/LinearLayout;
    const/4 v1, 0x4
    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V
    return-void
.end method

.method private refresh()V
    .locals 6
    # child mode on the passenger screen: no music controls and no way into the music app
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->act:Landroid/app/Activity;
    invoke-static {v0}, Luz/carhelper/passenger/ChildMode;->lockedHere(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :allowed
    const/16 v0, 0x8
    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V
    return-void
    :allowed
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
    iget-object v4, p0, Luz/carhelper/passenger/NowPlaying;->title:Landroid/widget/TextView;
    invoke-virtual {v4}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;
    move-result-object v4
    invoke-interface {v4}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;
    move-result-object v4
    if-eqz v3, :keyed
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    const-string v4, "#art"
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    :keyed
    invoke-direct {p0, v3, v4}, Luz/carhelper/passenger/NowPlaying;->tint(Landroid/graphics/Bitmap;Ljava/lang/String;)V
    invoke-direct {p0, v0, v1}, Luz/carhelper/passenger/NowPlaying;->progress(Landroid/media/session/MediaController;Landroid/media/MediaMetadata;)V
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
    # child mode: the card is hidden, but never act on a stray tap either
    iget-object v0, p0, Luz/carhelper/passenger/NowPlaying;->act:Landroid/app/Activity;
    invoke-static {v0}, Luz/carhelper/passenger/ChildMode;->lockedHere(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :allowed
    return-void
    :allowed
    invoke-direct {p0}, Luz/carhelper/passenger/NowPlaying;->controller()Landroid/media/session/MediaController;
    move-result-object v0
    if-nez v0, :have
    return-void
    :have
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/lang/String;
    const-string v2, "open"
    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :transport
    # tapping the art/title opens the now-playing app on the passenger screen (waking it first)
    iget-object v2, p0, Luz/carhelper/passenger/NowPlaying;->act:Landroid/app/Activity;
    invoke-static {v2}, Luz/carhelper/passenger/Wake;->passenger(Landroid/content/Context;)V
    invoke-virtual {v0}, Landroid/media/session/MediaController;->getPackageName()Ljava/lang/String;
    move-result-object v1
    iget-object v2, p0, Luz/carhelper/passenger/NowPlaying;->act:Landroid/app/Activity;
    invoke-virtual {v2}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v2
    invoke-virtual {v2, v1}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;
    move-result-object v1
    if-eqz v1, :open_done
    const/high16 v2, 0x10000000
    invoke-virtual {v1, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    iget-object v2, p0, Luz/carhelper/passenger/NowPlaying;->act:Landroid/app/Activity;
    :try_start_o
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v3
    const/4 v0, 0x3
    invoke-virtual {v3, v0}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v3}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v3
    invoke-virtual {v2, v1, v3}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    :try_end_o
    .catch Ljava/lang/Exception; {:try_start_o .. :try_end_o} :open_done
    :open_done
    return-void
    :transport
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

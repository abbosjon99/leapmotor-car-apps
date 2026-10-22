.class public Luz/carhelper/passenger/WallpaperFrame;
.super Landroid/widget/FrameLayout;

# Apps-menu root. A medium/long HORIZONTAL swipe cycles the wallpaper (pref "apps"/"wallpaper":
# 0 = solid black, 1..11 = wp_1..wp_11). Taps and vertical scrolling pass through to the grid,
# because only clearly-horizontal swipes (>=150px and >2x the vertical travel) are intercepted.
# It never touches the floating bubble, which lives in a separate overlay window.

.field private final act:Landroid/app/Activity;
.field private final img:Landroid/widget/ImageView;
.field private downX:F
.field private downY:F
.field private handled:Z

.method public constructor <init>(Landroid/content/Context;Landroid/app/Activity;Landroid/widget/ImageView;)V
    .locals 0
    invoke-direct {p0, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V
    iput-object p2, p0, Luz/carhelper/passenger/WallpaperFrame;->act:Landroid/app/Activity;
    iput-object p3, p0, Luz/carhelper/passenger/WallpaperFrame;->img:Landroid/widget/ImageView;
    return-void
.end method

.method public onInterceptTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 7
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I
    move-result v0
    if-nez v0, :not_down
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F
    move-result v1
    iput v1, p0, Luz/carhelper/passenger/WallpaperFrame;->downX:F
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F
    move-result v1
    iput v1, p0, Luz/carhelper/passenger/WallpaperFrame;->downY:F
    const/4 v1, 0x0
    iput-boolean v1, p0, Luz/carhelper/passenger/WallpaperFrame;->handled:Z
    return v1
    :not_down
    const/4 v1, 0x2
    if-eq v0, v1, :move
    const/4 v1, 0x0
    return v1
    :move
    iget-boolean v1, p0, Luz/carhelper/passenger/WallpaperFrame;->handled:Z
    if-eqz v1, :measure
    const/4 v1, 0x1
    return v1
    :measure
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F
    move-result v1
    iget v2, p0, Luz/carhelper/passenger/WallpaperFrame;->downX:F
    sub-float/2addr v1, v2
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F
    move-result v2
    iget v3, p0, Luz/carhelper/passenger/WallpaperFrame;->downY:F
    sub-float/2addr v2, v3
    invoke-static {v1}, Ljava/lang/Math;->abs(F)F
    move-result v3
    invoke-static {v2}, Ljava/lang/Math;->abs(F)F
    move-result v4
    const/high16 v5, 0x43160000
    cmpg-float v6, v3, v5
    if-ltz v6, :no
    const/high16 v5, 0x40000000
    mul-float/2addr v5, v4
    cmpl-float v6, v3, v5
    if-lez v6, :no
    const/4 v6, 0x1
    const/4 v5, 0x0
    cmpg-float v5, v1, v5
    if-ltz v5, :have_step
    const/4 v6, -0x1
    :have_step
    invoke-direct {p0, v6}, Luz/carhelper/passenger/WallpaperFrame;->change(I)V
    const/4 v6, 0x1
    iput-boolean v6, p0, Luz/carhelper/passenger/WallpaperFrame;->handled:Z
    return v6
    :no
    const/4 v1, 0x0
    return v1
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 1
    const/4 v0, 0x1
    return v0
.end method

.method private change(I)V
    .locals 4
    iget-object v0, p0, Luz/carhelper/passenger/WallpaperFrame;->act:Landroid/app/Activity;
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "wallpaper"
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2
    add-int/2addr v2, p1
    const/16 v3, 0xc
    rem-int/2addr v2, v3
    if-gez v2, :ok
    add-int/2addr v2, v3
    :ok
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    invoke-virtual {p0, v2}, Luz/carhelper/passenger/WallpaperFrame;->apply(I)V
    return-void
.end method

.method public apply(I)V
    .locals 5
    iget-object v0, p0, Luz/carhelper/passenger/WallpaperFrame;->img:Landroid/widget/ImageView;
    const/4 v1, 0x0
    if-nez p1, :image
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V
    const/high16 v1, -0x1000000
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V
    return-void
    :image
    iget-object v2, p0, Luz/carhelper/passenger/WallpaperFrame;->act:Landroid/app/Activity;
    invoke-virtual {v2}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;
    move-result-object v3
    new-instance v4, Ljava/lang/StringBuilder;
    const-string v1, "wp_"
    invoke-direct {v4, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    const-string v1, "drawable"
    invoke-virtual {v2}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v3, v4, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    if-nez v1, :has
    const/high16 v1, -0x1000000
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V
    return-void
    :has
    const/4 v2, 0x0
    invoke-virtual {v0, v2}, Landroid/view/View;->setBackgroundColor(I)V
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageResource(I)V
    return-void
.end method

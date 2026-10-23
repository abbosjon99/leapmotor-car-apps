.class public Luz/carhelper/passenger/MainBubbleService;
.super Landroid/app/Service;
.implements Landroid/view/View$OnTouchListener;
.implements Landroid/view/View$OnClickListener;
.implements Ljava/lang/Runnable;

# Second AssistiveTouch bubble, on the car's MAIN screen (display 0).
#            [ turn off passenger screen ]
# [back]  [ LP Companion (menu) ]  [ child mode toggle ]
#            [ swap ]
# Back-off rule (universal): when the Back accessibility service is off, Back is
# dropped, LP Companion shifts left and the centre is blank.

.field private bubble:Landroid/view/View;
.field private wm:Landroid/view/WindowManager;
.field private lp:Landroid/view/WindowManager$LayoutParams;
.field private dctx:Landroid/content/Context;
.field private panel:Landroid/widget/LinearLayout;
.field private panelLp:Landroid/view/WindowManager$LayoutParams;
.field private panelShown:Z
.field private backBtn:Landroid/widget/ImageView;
.field private handler:Landroid/os/Handler;
.field private lastOutsideHide:J
.field private downRawX:F
.field private downRawY:F
.field private startX:I
.field private startY:I
.field private moved:Z
.field private maxX:I
.field private maxY:I
.field private pctx:Landroid/content/Context;
.field private pwm:Landroid/view/WindowManager;
.field private pcover:Landroid/view/View;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Service;-><init>()V
    return-void
.end method

.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 1
    const/4 v0, 0x1
    return v0
.end method

.method public onCreate()V
    .locals 12
    invoke-super {p0}, Landroid/app/Service;->onCreate()V

    # silent foreground notification so the service isn't killed
    const-string v0, "notification"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/app/NotificationManager;
    new-instance v1, Landroid/app/NotificationChannel;
    const-string v2, "mainbubble"
    const-string v3, "LP Companion (main screen)"
    const/4 v4, 0x1
    invoke-direct {v1, v2, v3, v4}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V
    invoke-virtual {v0, v1}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V
    new-instance v1, Landroid/app/Notification$Builder;
    invoke-direct {v1, p0, v2}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;
    move-result-object v3
    iget v3, v3, Landroid/content/pm/ApplicationInfo;->icon:I
    invoke-virtual {v1, v3}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;
    const-string v3, "LP Companion controls on the main screen"
    invoke-virtual {v1, v3}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;
    invoke-virtual {v1}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;
    move-result-object v1
    const/4 v3, 0x2
    invoke-virtual {p0, v3, v1}, Landroid/app/Service;->startForeground(ILandroid/app/Notification;)V

    # main display (0) and its size
    const-string v0, "display"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/hardware/display/DisplayManager;
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/hardware/display/DisplayManager;->getDisplay(I)Landroid/view/Display;
    move-result-object v1
    if-nez v1, :have_display
    invoke-virtual {p0}, Landroid/app/Service;->stopSelf()V
    return-void
    :have_display
    new-instance v9, Landroid/graphics/Point;
    invoke-direct {v9}, Landroid/graphics/Point;-><init>()V
    invoke-virtual {v1, v9}, Landroid/view/Display;->getRealSize(Landroid/graphics/Point;)V
    iget v10, v9, Landroid/graphics/Point;->x:I
    add-int/lit8 v10, v10, -0x50
    iput v10, p0, Luz/carhelper/passenger/MainBubbleService;->maxX:I
    iget v11, v9, Landroid/graphics/Point;->y:I
    add-int/lit8 v11, v11, -0x50
    iput v11, p0, Luz/carhelper/passenger/MainBubbleService;->maxY:I

    invoke-virtual {p0, v1}, Landroid/content/Context;->createDisplayContext(Landroid/view/Display;)Landroid/content/Context;
    move-result-object v1
    iput-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->dctx:Landroid/content/Context;
    const-string v2, "window"
    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Landroid/view/WindowManager;
    iput-object v3, p0, Luz/carhelper/passenger/MainBubbleService;->wm:Landroid/view/WindowManager;

    # passenger display (3) window manager for the "turn off passenger screen" cover (optional)
    const/4 v4, 0x3
    invoke-virtual {v0, v4}, Landroid/hardware/display/DisplayManager;->getDisplay(I)Landroid/view/Display;
    move-result-object v0
    if-eqz v0, :no_passenger
    invoke-virtual {p0, v0}, Landroid/content/Context;->createDisplayContext(Landroid/view/Display;)Landroid/content/Context;
    move-result-object v0
    iput-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->pctx:Landroid/content/Context;
    invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/view/WindowManager;
    iput-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->pwm:Landroid/view/WindowManager;
    :no_passenger

    # main-looper handler (delayed Back)
    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v2
    invoke-direct {v0, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->handler:Landroid/os/Handler;

    # the bubble: res/drawable/bubble, 80 px, 80% opaque while idle
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->dctx:Landroid/content/Context;
    new-instance v2, Landroid/widget/ImageView;
    invoke-direct {v2, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    const-string v4, "bubble"
    invoke-direct {p0, v4}, Luz/carhelper/passenger/MainBubbleService;->icon(Ljava/lang/String;)I
    move-result v4
    invoke-virtual {v2, v4}, Landroid/widget/ImageView;->setImageResource(I)V
    const v4, 0x3f19999a
    invoke-virtual {v2, v4}, Landroid/view/View;->setAlpha(F)V
    invoke-virtual {v2, p0}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V
    iput-object v2, p0, Luz/carhelper/passenger/MainBubbleService;->bubble:Landroid/view/View;

    # LayoutParams(w, h, TYPE_APPLICATION_OVERLAY, FLAG_NOT_FOCUSABLE, TRANSLUCENT), top-left origin
    new-instance v4, Landroid/view/WindowManager$LayoutParams;
    const/16 v5, 0x50
    const/16 v6, 0x50
    const/16 v7, 0x7f6
    const/16 v8, 0x8
    const/4 v9, -0x3
    invoke-direct/range {v4 .. v9}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V
    const/16 v5, 0x33
    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->gravity:I

    # saved position, default top-left
    const-string v5, "mainbubble"
    const/4 v6, 0x0
    invoke-virtual {p0, v5, v6}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v5
    const-string v6, "x"
    const/16 v7, 0x18
    invoke-interface {v5, v6, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v6
    iput v6, v4, Landroid/view/WindowManager$LayoutParams;->x:I
    const-string v6, "y"
    const/16 v7, 0x18
    invoke-interface {v5, v6, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v6
    iput v6, v4, Landroid/view/WindowManager$LayoutParams;->y:I
    iput-object v4, p0, Luz/carhelper/passenger/MainBubbleService;->lp:Landroid/view/WindowManager$LayoutParams;

    iget-object v5, p0, Luz/carhelper/passenger/MainBubbleService;->wm:Landroid/view/WindowManager;
    :try_start_0
    invoke-interface {v5, v2, v4}, Landroid/view/ViewManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void

    :catch_0
    move-exception v5
    const-string v6, "MainBubble"
    invoke-virtual {v5}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static {v6, v5}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    const/4 v5, 0x0
    iput-object v5, p0, Luz/carhelper/passenger/MainBubbleService;->bubble:Landroid/view/View;
    invoke-virtual {p0}, Landroid/app/Service;->stopSelf()V
    return-void
.end method

# ---------- menu panel ----------

.method private icon(Ljava/lang/String;)I
    .locals 3
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    const-string v1, "drawable"
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v0
    return v0
.end method

.method private addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    .locals 6
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->dctx:Landroid/content/Context;
    new-instance v1, Landroid/widget/ImageView;
    invoke-direct {v1, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-direct {p0, p2}, Luz/carhelper/passenger/MainBubbleService;->icon(Ljava/lang/String;)I
    move-result v2
    invoke-virtual {v1, v2}, Landroid/widget/ImageView;->setImageResource(I)V
    const/16 v2, 0x18
    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/ImageView;->setPadding(IIII)V
    new-instance v2, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    const/4 v3, 0x1
    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V
    const v3, 0x33ffffff
    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v1, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v3, 0x60
    invoke-direct {v2, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v3, 0xc
    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-object v1
.end method

.method private addSpacer(Landroid/widget/LinearLayout;)V
    .locals 4
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->dctx:Landroid/content/Context;
    new-instance v1, Landroid/view/View;
    invoke-direct {v1, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v3, 0x60
    invoke-direct {v2, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v3, 0xc
    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-void
.end method

.method private newRow(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    .locals 2
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->dctx:Landroid/content/Context;
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-object v1
.end method

.method private buildPanel()V
    .locals 9
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->dctx:Landroid/content/Context;
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v2, 0x18
    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    new-instance v2, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    const v3, -0x33cfcfd0
    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    const/high16 v3, 0x42400000
    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v1, p0}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V
    iput-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->panel:Landroid/widget/LinearLayout;

    # row 1: turn off passenger screen, in the middle
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MainBubbleService;->newRow(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v4
    invoke-direct {p0, v4}, Luz/carhelper/passenger/MainBubbleService;->addSpacer(Landroid/widget/LinearLayout;)V
    const-string v2, "ic_screen_off"
    const-string v3, "screenoff"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/MainBubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    invoke-direct {p0, v4}, Luz/carhelper/passenger/MainBubbleService;->addSpacer(Landroid/widget/LinearLayout;)V

    # row 2: [back] LP Companion(menu) child-toggle - Back dropped and LP Companion shifts left when the Back service is off
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MainBubbleService;->newRow(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v4
    sget-object v2, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    if-eqz v2, :back_off
    const-string v2, "ic_back"
    const-string v3, "back"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/MainBubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    move-result-object v2
    iput-object v2, p0, Luz/carhelper/passenger/MainBubbleService;->backBtn:Landroid/widget/ImageView;
    const-string v2, "ic_apps"
    const-string v3, "lp"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/MainBubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    goto :row2_end
    :back_off
    const/4 v2, 0x0
    iput-object v2, p0, Luz/carhelper/passenger/MainBubbleService;->backBtn:Landroid/widget/ImageView;
    const-string v2, "ic_apps"
    const-string v3, "lp"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/MainBubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    invoke-direct {p0, v4}, Luz/carhelper/passenger/MainBubbleService;->addSpacer(Landroid/widget/LinearLayout;)V
    :row2_end
    const-string v2, "ic_child"
    const-string v3, "child"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/MainBubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;

    # row 3: swap screens in the middle
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MainBubbleService;->newRow(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v4
    invoke-direct {p0, v4}, Luz/carhelper/passenger/MainBubbleService;->addSpacer(Landroid/widget/LinearLayout;)V
    const-string v2, "ic_swap"
    const-string v3, "swap"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/MainBubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    invoke-direct {p0, v4}, Luz/carhelper/passenger/MainBubbleService;->addSpacer(Landroid/widget/LinearLayout;)V

    new-instance v3, Landroid/view/WindowManager$LayoutParams;
    const/4 v4, -0x2
    const/4 v5, -0x2
    const/16 v6, 0x7f6
    const v7, 0x40020
    const/4 v8, -0x3
    invoke-direct/range {v3 .. v8}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V
    const/16 v4, 0x33
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->gravity:I
    iput-object v3, p0, Luz/carhelper/passenger/MainBubbleService;->panelLp:Landroid/view/WindowManager$LayoutParams;
    return-void
.end method

.method private togglePanel()V
    .locals 9
    iget-boolean v0, p0, Luz/carhelper/passenger/MainBubbleService;->panelShown:Z
    if-eqz v0, :show
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePanel()V
    return-void

    :show
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v0
    iget-wide v2, p0, Luz/carhelper/passenger/MainBubbleService;->lastOutsideHide:J
    sub-long/2addr v0, v2
    const-wide/16 v2, 0x190
    cmp-long v0, v0, v2
    if-ltz v0, :closed_just_now
    # rebuild every time so the Back-off layout tracks the service state
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->buildPanel()V
    # Back greyed out while the Back accessibility service is off
    const/high16 v1, 0x3f800000
    sget-object v2, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    if-nez v2, :back_alpha
    const v1, 0x3eb33333
    :back_alpha
    iget-object v2, p0, Luz/carhelper/passenger/MainBubbleService;->backBtn:Landroid/widget/ImageView;
    if-eqz v2, :back_alpha_done
    invoke-virtual {v2, v1}, Landroid/view/View;->setAlpha(F)V
    :back_alpha_done
    # place the panel beside the bubble, on the side with more room, kept on screen
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->lp:Landroid/view/WindowManager$LayoutParams;
    iget v1, v0, Landroid/view/WindowManager$LayoutParams;->x:I
    iget v2, v0, Landroid/view/WindowManager$LayoutParams;->y:I
    iget v3, p0, Luz/carhelper/passenger/MainBubbleService;->maxX:I
    add-int/lit8 v4, v3, 0x50
    div-int/lit8 v4, v4, 0x2
    if-ge v1, v4, :panel_left
    add-int/lit8 v5, v1, 0x5c
    goto :x_done
    :panel_left
    const/16 v6, 0x1a4
    sub-int v5, v1, v6
    :x_done
    add-int/lit16 v6, v3, -0x148
    if-le v5, v6, :x_max_ok
    move v5, v6
    :x_max_ok
    if-gez v5, :x_min_ok
    const/4 v5, 0x0
    :x_min_ok
    add-int/lit16 v7, v2, -0xa4
    iget v6, p0, Luz/carhelper/passenger/MainBubbleService;->maxY:I
    add-int/lit16 v6, v6, -0x148
    if-le v7, v6, :y_max_ok
    move v7, v6
    :y_max_ok
    if-gez v7, :y_min_ok
    const/4 v7, 0x0
    :y_min_ok
    iget-object v8, p0, Luz/carhelper/passenger/MainBubbleService;->panelLp:Landroid/view/WindowManager$LayoutParams;
    iput v5, v8, Landroid/view/WindowManager$LayoutParams;->x:I
    iput v7, v8, Landroid/view/WindowManager$LayoutParams;->y:I

    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->wm:Landroid/view/WindowManager;
    iget-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->panel:Landroid/widget/LinearLayout;
    :try_start_0
    const/4 v3, 0x0
    invoke-virtual {v1, v3}, Landroid/view/View;->setAlpha(F)V
    invoke-interface {v0, v1, v8}, Landroid/view/ViewManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    const/4 v0, 0x1
    iput-boolean v0, p0, Luz/carhelper/passenger/MainBubbleService;->panelShown:Z
    invoke-virtual {v1}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;
    move-result-object v0
    const/high16 v3, 0x3f800000
    invoke-virtual {v0, v3}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;
    move-result-object v0
    const-wide/16 v2, 0x96
    invoke-virtual {v0, v2, v3}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void
    :catch_0
    move-exception v0
    const-string v1, "MainBubble"
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :closed_just_now
    return-void
.end method

.method private hidePanel()V
    .locals 2
    iget-boolean v0, p0, Luz/carhelper/passenger/MainBubbleService;->panelShown:Z
    if-eqz v0, :done
    const/4 v0, 0x0
    iput-boolean v0, p0, Luz/carhelper/passenger/MainBubbleService;->panelShown:Z
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->wm:Landroid/view/WindowManager;
    iget-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->panel:Landroid/widget/LinearLayout;
    :try_start_0
    invoke-interface {v0, v1}, Landroid/view/ViewManager;->removeView(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :done
    return-void
.end method

.method private startOnPassenger(Landroid/content/Intent;)V
    .locals 3
    # NEW_TASK | MULTIPLE_TASK: fresh instance (applies kid mode at once) that can sit
    # alongside a main-screen instance
    const/high16 v0, 0x18000000
    invoke-virtual {p1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_0
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v0
    const/4 v1, 0x3
    invoke-virtual {v0, v1}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v0}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v0
    invoke-virtual {p0, p1, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void
    :catch_0
    move-exception v0
    const-string v1, "MainBubble"
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

# open LP Companion on the MAIN screen (display 0), able to coexist with the passenger one
.method private startOnMain(Landroid/content/Intent;)V
    .locals 3
    const/high16 v0, 0x18000000
    invoke-virtual {p1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_0
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v0
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v0}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v0
    invoke-virtual {p0, p1, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void
    :catch_0
    move-exception v0
    const-string v1, "MainBubble"
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

# turn the passenger screen off = opaque cover on display 3; tap it to restore
.method private showPassengerCover()V
    .locals 8
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->pcover:Landroid/view/View;
    if-nez v0, :done
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->pwm:Landroid/view/WindowManager;
    iget-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->pctx:Landroid/content/Context;
    if-eqz v0, :no_screen
    if-eqz v1, :no_screen
    new-instance v0, Landroid/view/View;
    invoke-direct {v0, v1}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    const/high16 v1, -0x1000000
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V
    const-string v1, "uncover"
    invoke-virtual {v0, v1}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/view/View;->setSoundEffectsEnabled(Z)V
    new-instance v2, Landroid/view/WindowManager$LayoutParams;
    const/4 v3, -0x1
    const/4 v4, -0x1
    const/16 v5, 0x7f6
    const/16 v6, 0x308
    const/4 v7, -0x1
    invoke-direct/range {v2 .. v7}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V
    iget-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->pwm:Landroid/view/WindowManager;
    :try_start_0
    invoke-interface {v1, v0, v2}, Landroid/view/ViewManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    iput-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->pcover:Landroid/view/View;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
    :no_screen
    const-string v0, "No passenger screen to turn off"
    const/4 v1, 0x0
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    :done
    return-void
.end method

.method private hidePassengerCover()V
    .locals 2
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->pcover:Landroid/view/View;
    if-eqz v0, :done
    const/4 v1, 0x0
    iput-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->pcover:Landroid/view/View;
    iget-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->pwm:Landroid/view/WindowManager;
    :try_start_0
    invoke-interface {v1, v0}, Landroid/view/ViewManager;->removeView(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :done
    return-void
.end method

# delayed Back: fires after the panel is gone so it lands on the main screen
.method public run()V
    .locals 0
    invoke-static {}, Luz/carhelper/passenger/BackService;->back()Z
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 5
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;

    const-string v1, "screenoff"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_screenoff
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePanel()V
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->showPassengerCover()V
    return-void
    :not_screenoff

    const-string v1, "uncover"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_uncover
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePassengerCover()V
    return-void
    :not_uncover

    const-string v1, "swap"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_swap
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePanel()V
    invoke-static {p0}, Luz/carhelper/passenger/Swapper;->swap(Landroid/content/Context;)V
    return-void
    :not_swap

    const-string v1, "lp"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_lp
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePanel()V
    new-instance v1, Landroid/content/Intent;
    const-class v2, Luz/carhelper/passenger/MainActivity;
    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MainBubbleService;->startOnMain(Landroid/content/Intent;)V
    return-void
    :not_lp

    const-string v1, "child"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_child
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePanel()V
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    const-string v3, "kid"
    invoke-interface {v1, v3, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    xor-int/lit8 v2, v2, 0x1
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    invoke-interface {v1, v3, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V
    new-instance v1, Landroid/content/Intent;
    const-class v3, Luz/carhelper/passenger/MainActivity;
    invoke-direct {v1, p0, v3}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MainBubbleService;->startOnPassenger(Landroid/content/Intent;)V
    const/4 v1, 0x1
    const-string v3, "Child mode on"
    if-eqz v2, :child_toast
    goto :child_show
    :child_toast
    const-string v3, "Child mode off"
    :child_show
    invoke-static {p0, v3, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    return-void
    :not_child

    const-string v1, "back"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :done
    sget-object v1, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    if-nez v1, :back_on
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePanel()V
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v1
    invoke-static {v1}, Luz/carhelper/passenger/BackRepair;->ensure(Landroid/content/Context;)Z
    move-result v2
    const-string v3, "Back is starting — tap it again in a moment"
    if-nez v2, :back_toast
    const-string v3, "Back is off — LP Companion needs the WRITE_SECURE_SETTINGS grant over ADB"
    :back_toast
    const/4 v2, 0x1
    invoke-static {v1, v3, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    return-void
    :back_on
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePanel()V
    iget-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->handler:Landroid/os/Handler;
    const-wide/16 v2, 0x1e
    invoke-virtual {v1, p0, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :done
    return-void
.end method

.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 6
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->bubble:Landroid/view/View;
    if-eq p1, v0, :bubble_touch

    # panel: a tap outside closes it
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I
    move-result v0
    const/4 v1, 0x4
    if-ne v0, v1, :panel_pass
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v2
    iput-wide v2, p0, Luz/carhelper/passenger/MainBubbleService;->lastOutsideHide:J
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePanel()V
    goto :ret_true
    :panel_pass
    const/4 v0, 0x0
    return v0

    :bubble_touch
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I
    move-result v0

    if-nez v0, :not_down
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F
    move-result v1
    iput v1, p0, Luz/carhelper/passenger/MainBubbleService;->downRawX:F
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F
    move-result v1
    iput v1, p0, Luz/carhelper/passenger/MainBubbleService;->downRawY:F
    iget-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->lp:Landroid/view/WindowManager$LayoutParams;
    iget v2, v1, Landroid/view/WindowManager$LayoutParams;->x:I
    iput v2, p0, Luz/carhelper/passenger/MainBubbleService;->startX:I
    iget v2, v1, Landroid/view/WindowManager$LayoutParams;->y:I
    iput v2, p0, Luz/carhelper/passenger/MainBubbleService;->startY:I
    const/4 v2, 0x0
    iput-boolean v2, p0, Luz/carhelper/passenger/MainBubbleService;->moved:Z
    const/high16 v2, 0x3f800000
    invoke-virtual {p1, v2}, Landroid/view/View;->setAlpha(F)V
    goto :ret_true

    :not_down
    const/4 v1, 0x2
    if-ne v0, v1, :not_move
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F
    move-result v1
    iget v2, p0, Luz/carhelper/passenger/MainBubbleService;->downRawX:F
    sub-float/2addr v1, v2
    float-to-int v1, v1
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F
    move-result v2
    iget v3, p0, Luz/carhelper/passenger/MainBubbleService;->downRawY:F
    sub-float/2addr v2, v3
    float-to-int v2, v2
    iget-boolean v3, p0, Luz/carhelper/passenger/MainBubbleService;->moved:Z
    if-nez v3, :apply
    const/16 v4, 0xc
    invoke-static {v1}, Ljava/lang/Math;->abs(I)I
    move-result v3
    if-gt v3, v4, :start_move
    invoke-static {v2}, Ljava/lang/Math;->abs(I)I
    move-result v3
    if-gt v3, v4, :start_move
    goto :ret_true
    :start_move
    const/4 v3, 0x1
    iput-boolean v3, p0, Luz/carhelper/passenger/MainBubbleService;->moved:Z
    :apply
    iget v3, p0, Luz/carhelper/passenger/MainBubbleService;->startX:I
    add-int/2addr v3, v1
    iget v4, p0, Luz/carhelper/passenger/MainBubbleService;->startY:I
    add-int/2addr v4, v2
    if-gez v3, :x_min_ok
    const/4 v3, 0x0
    :x_min_ok
    iget v5, p0, Luz/carhelper/passenger/MainBubbleService;->maxX:I
    if-le v3, v5, :x_max_ok
    move v3, v5
    :x_max_ok
    if-gez v4, :y_min_ok
    const/4 v4, 0x0
    :y_min_ok
    iget v5, p0, Luz/carhelper/passenger/MainBubbleService;->maxY:I
    if-le v4, v5, :y_max_ok
    move v4, v5
    :y_max_ok
    iget-object v5, p0, Luz/carhelper/passenger/MainBubbleService;->lp:Landroid/view/WindowManager$LayoutParams;
    iput v3, v5, Landroid/view/WindowManager$LayoutParams;->x:I
    iput v4, v5, Landroid/view/WindowManager$LayoutParams;->y:I
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->wm:Landroid/view/WindowManager;
    invoke-interface {v0, p1, v5}, Landroid/view/ViewManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    goto :ret_true

    :not_move
    const/4 v1, 0x1
    if-eq v0, v1, :up
    const/4 v1, 0x3
    if-ne v0, v1, :ret_true
    :up
    const v2, 0x3f19999a
    invoke-virtual {p1, v2}, Landroid/view/View;->setAlpha(F)V
    const/4 v1, 0x1
    if-ne v0, v1, :ret_true
    iget-boolean v2, p0, Luz/carhelper/passenger/MainBubbleService;->moved:Z
    if-nez v2, :save
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->togglePanel()V
    goto :ret_true
    :save
    const-string v2, "mainbubble"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    iget-object v3, p0, Luz/carhelper/passenger/MainBubbleService;->lp:Landroid/view/WindowManager$LayoutParams;
    const-string v4, "x"
    iget v5, v3, Landroid/view/WindowManager$LayoutParams;->x:I
    invoke-interface {v2, v4, v5}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v4, "y"
    iget v5, v3, Landroid/view/WindowManager$LayoutParams;->y:I
    invoke-interface {v2, v4, v5}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    :ret_true
    const/4 v0, 0x1
    return v0
.end method

.method public onDestroy()V
    .locals 2
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePanel()V
    invoke-direct {p0}, Luz/carhelper/passenger/MainBubbleService;->hidePassengerCover()V
    iget-object v0, p0, Luz/carhelper/passenger/MainBubbleService;->wm:Landroid/view/WindowManager;
    iget-object v1, p0, Luz/carhelper/passenger/MainBubbleService;->bubble:Landroid/view/View;
    if-eqz v0, :done
    if-eqz v1, :done
    :try_start_0
    invoke-interface {v0, v1}, Landroid/view/ViewManager;->removeView(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    goto :done
    :catch_0
    move-exception v0
    :done
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V
    return-void
.end method

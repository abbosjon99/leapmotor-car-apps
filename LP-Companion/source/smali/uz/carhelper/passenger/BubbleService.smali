.class public Luz/carhelper/passenger/BubbleService;
.super Landroid/app/Service;
.implements Landroid/view/View$OnClickListener;
.implements Landroid/view/View$OnTouchListener;
.implements Ljava/lang/Runnable;
.implements Landroid/os/PowerManager$OnThermalStatusChangedListener;

# AssistiveTouch-style button on the passenger screen (display 3).
# Drag to move it (position is saved). Tap opens a menu panel:
#   Home      -> passenger launcher main screen (same as the sidebar's Home)
#   Back      -> global Back through BackService (accessibility)
#   Open app  -> Passenger Apps grid on the passenger screen
#   Hide/Show bar -> passenger sidebar via copilotshowapp's nav.visibility broadcast
# Tapping outside the panel closes it. Needs the SYSTEM_ALERT_WINDOW app-op (granted over ADB).

.field private bubble:Landroid/view/View;
.field private wm:Landroid/view/WindowManager;
.field private lp:Landroid/view/WindowManager$LayoutParams;
.field private dctx:Landroid/content/Context;
.field private panel:Landroid/widget/LinearLayout;
.field private panelLp:Landroid/view/WindowManager$LayoutParams;
.field private panelShown:Z
.field private barBtn:Landroid/widget/ImageView;
.field private backBtn:Landroid/widget/ImageView;
.field private barHidden:Z
.field private cover:Landroid/view/View;
.field private handler:Landroid/os/Handler;
.field private loadStrikes:I
.field private lastProtect:J
.field private lastOutsideHide:J
.field private downRawX:F
.field private downRawY:F
.field private startX:I
.field private startY:I
.field private moved:Z
.field private maxX:I
.field private maxY:I
.field private steer:Landroid/content/BroadcastReceiver;

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
    const-string v2, "bubble"
    const-string v3, "LP Companion"
    const/4 v4, 0x1
    invoke-direct {v1, v2, v3, v4}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V
    invoke-virtual {v0, v1}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V
    new-instance v1, Landroid/app/Notification$Builder;
    invoke-direct {v1, p0, v2}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;
    move-result-object v3
    iget v3, v3, Landroid/content/pm/ApplicationInfo;->icon:I
    invoke-virtual {v1, v3}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;
    const-string v3, "LP Companion is running"
    invoke-virtual {v1, v3}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;
    invoke-virtual {v1}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;
    move-result-object v1
    const/4 v3, 0x1
    invoke-virtual {p0, v3, v1}, Landroid/app/Service;->startForeground(ILandroid/app/Notification;)V

    # auto-hide the car's passenger sidebar on start
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hideBar()V

    # mirror child mode to the shared Settings.Secure flag so LP Music matches on boot
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "kid"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    invoke-static {p0, v0}, Luz/carhelper/passenger/ChildMode;->sync(Landroid/content/Context;Z)V

    # passenger display and its size
    const-string v0, "display"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/hardware/display/DisplayManager;
    const/4 v1, 0x3
    invoke-virtual {v0, v1}, Landroid/hardware/display/DisplayManager;->getDisplay(I)Landroid/view/Display;
    move-result-object v0
    if-nez v0, :have_display
    invoke-virtual {p0}, Landroid/app/Service;->stopSelf()V
    return-void
    :have_display
    new-instance v9, Landroid/graphics/Point;
    invoke-direct {v9}, Landroid/graphics/Point;-><init>()V
    invoke-virtual {v0, v9}, Landroid/view/Display;->getRealSize(Landroid/graphics/Point;)V
    iget v10, v9, Landroid/graphics/Point;->x:I
    add-int/lit8 v10, v10, -0x50
    iput v10, p0, Luz/carhelper/passenger/BubbleService;->maxX:I
    iget v11, v9, Landroid/graphics/Point;->y:I
    add-int/lit8 v11, v11, -0x50
    iput v11, p0, Luz/carhelper/passenger/BubbleService;->maxY:I

    invoke-virtual {p0, v0}, Landroid/content/Context;->createDisplayContext(Landroid/view/Display;)Landroid/content/Context;
    move-result-object v0
    iput-object v0, p0, Luz/carhelper/passenger/BubbleService;->dctx:Landroid/content/Context;
    const-string v1, "window"
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/view/WindowManager;
    iput-object v1, p0, Luz/carhelper/passenger/BubbleService;->wm:Landroid/view/WindowManager;

    # overload protection: check every 30 s, plus Android's thermal status if the host reports it
    new-instance v2, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v3
    invoke-direct {v2, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v2, p0, Luz/carhelper/passenger/BubbleService;->handler:Landroid/os/Handler;
    const-wide/16 v3, 0x7530
    invoke-virtual {v2, p0, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    # auto-open LP Companion when the passenger screen powers on
    const-string v3, "display"
    invoke-virtual {p0, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Landroid/hardware/display/DisplayManager;
    new-instance v5, Luz/carhelper/passenger/PassengerWatcher;
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v6
    invoke-direct {v5, v6, v3}, Luz/carhelper/passenger/PassengerWatcher;-><init>(Landroid/content/Context;Landroid/hardware/display/DisplayManager;)V
    invoke-virtual {v3, v5, v2}, Landroid/hardware/display/DisplayManager;->registerDisplayListener(Landroid/hardware/display/DisplayManager$DisplayListener;Landroid/os/Handler;)V
    # act as Migu (media type 13) toward the car's media app - but not when LP Music is
    # installed, so the wheel keys route to LP Music instead of to us
    invoke-static {p0}, Luz/carhelper/passenger/WheelReceiver;->yieldToMusic(Landroid/content/Context;)Z
    move-result v3
    if-nez v3, :skip_migu
    new-instance v3, Luz/carhelper/passenger/MiguBridge;
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v4
    invoke-direct {v3, v4, v2}, Luz/carhelper/passenger/MiguBridge;-><init>(Landroid/content/Context;Landroid/os/Handler;)V
    invoke-virtual {v2, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :skip_migu
    # put the Back accessibility service back if the car dropped it (e.g. after a restart)
    new-instance v3, Luz/carhelper/passenger/BackRepair;
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v4
    invoke-direct {v3, v4, v2}, Luz/carhelper/passenger/BackRepair;-><init>(Landroid/content/Context;Landroid/os/Handler;)V
    invoke-virtual {v2, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    # second wheel-key channel: com.leapmotor.steerwheelcontrol.media, while this service runs
    :try_start_s
    new-instance v3, Luz/carhelper/passenger/SteerWheelReceiver;
    invoke-direct {v3}, Luz/carhelper/passenger/SteerWheelReceiver;-><init>()V
    new-instance v4, Landroid/content/IntentFilter;
    const-string v5, "com.leapmotor.steerwheelcontrol.media"
    invoke-direct {v4, v5}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V
    invoke-virtual {p0, v3, v4}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;
    iput-object v3, p0, Luz/carhelper/passenger/BubbleService;->steer:Landroid/content/BroadcastReceiver;
    :try_end_s
    .catch Ljava/lang/Exception; {:try_start_s .. :try_end_s} :catch_s
    :catch_s
    :try_start_t
    const-string v3, "power"
    invoke-virtual {p0, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Landroid/os/PowerManager;
    invoke-virtual {v3, p0}, Landroid/os/PowerManager;->addThermalStatusListener(Landroid/os/PowerManager$OnThermalStatusChangedListener;)V
    :try_end_t
    .catch Ljava/lang/Exception; {:try_start_t .. :try_end_t} :catch_t
    :catch_t

    # the bubble: res/drawable/bubble, 96 px, 80% opaque while idle
    new-instance v2, Landroid/widget/ImageView;
    invoke-direct {v2, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v3
    const-string v4, "bubble"
    const-string v5, "drawable"
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v6
    invoke-virtual {v3, v4, v5, v6}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v3
    invoke-virtual {v2, v3}, Landroid/widget/ImageView;->setImageResource(I)V
    const v3, 0x3f19999a
    invoke-virtual {v2, v3}, Landroid/view/View;->setAlpha(F)V
    invoke-virtual {v2, p0}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V
    iput-object v2, p0, Luz/carhelper/passenger/BubbleService;->bubble:Landroid/view/View;

    # LayoutParams(w, h, TYPE_APPLICATION_OVERLAY, FLAG_NOT_FOCUSABLE, TRANSLUCENT), top-left origin
    new-instance v3, Landroid/view/WindowManager$LayoutParams;
    const/16 v4, 0x50
    const/16 v5, 0x50
    const/16 v6, 0x7f6
    const/16 v7, 0x8
    const/4 v8, -0x3
    invoke-direct/range {v3 .. v8}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V
    const/16 v4, 0x33
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->gravity:I

    # saved position, default bottom-left
    const-string v5, "bubble"
    const/4 v6, 0x0
    invoke-virtual {p0, v5, v6}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v4
    const-string v5, "x"
    const/16 v6, 0x18
    invoke-interface {v4, v5, v6}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v5
    iput v5, v3, Landroid/view/WindowManager$LayoutParams;->x:I
    const-string v5, "y"
    add-int/lit8 v6, v11, -0x18
    invoke-interface {v4, v5, v6}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v5
    iput v5, v3, Landroid/view/WindowManager$LayoutParams;->y:I
    iput-object v3, p0, Luz/carhelper/passenger/BubbleService;->lp:Landroid/view/WindowManager$LayoutParams;

    :try_start_0
    invoke-interface {v1, v2, v3}, Landroid/view/ViewManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void

    :catch_0
    move-exception v4
    const-string v5, "PassengerBubble"
    invoke-virtual {v4}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v4
    invoke-static {v5, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    const/4 v4, 0x0
    iput-object v4, p0, Luz/carhelper/passenger/BubbleService;->bubble:Landroid/view/View;
    invoke-virtual {p0}, Landroid/app/Service;->stopSelf()V
    return-void
.end method

# ---------- menu panel ----------

# hide the car's passenger sidebar and remember it hidden (pref "apps"/"barHidden")
.method private hideBar()V
    .locals 4
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v2, "barHidden"
    const/4 v3, 0x1
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    iput-boolean v3, p0, Luz/carhelper/passenger/BubbleService;->barHidden:Z
    :try_start_0
    new-instance v0, Landroid/content/Intent;
    const-string v1, "com.leapmotor.iqiyi.action.nav.visibility"
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v1, "visibility"
    const/16 v2, 0x8
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;
    const-string v1, "package"
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
    invoke-virtual {p0, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

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

# round translucent button with a white vector icon: 96 px + 12 px margin = 120 px cell
.method private addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    .locals 6
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->dctx:Landroid/content/Context;
    new-instance v1, Landroid/widget/ImageView;
    invoke-direct {v1, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-direct {p0, p2}, Luz/carhelper/passenger/BubbleService;->icon(Ljava/lang/String;)I
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

# empty cell, same size as a button
.method private addSpacer(Landroid/widget/LinearLayout;)V
    .locals 4
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->dctx:Landroid/content/Context;
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
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->dctx:Landroid/content/Context;
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-object v1
.end method

# 3x3 square, 24 px padding -> 408 x 408 px:
#            [ screen off ]
# [back] [ home = LP Companion ] [ bar ]
#            [ swap ]
.method private buildPanel()V
    .locals 9
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->dctx:Landroid/content/Context;
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
    iput-object v1, p0, Luz/carhelper/passenger/BubbleService;->panel:Landroid/widget/LinearLayout;

    # row 1: screen off in the middle
    invoke-direct {p0, v1}, Luz/carhelper/passenger/BubbleService;->newRow(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v4
    invoke-direct {p0, v4}, Luz/carhelper/passenger/BubbleService;->addSpacer(Landroid/widget/LinearLayout;)V
    const-string v2, "ic_screen_off"
    const-string v3, "screenoff"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/BubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    invoke-direct {p0, v4}, Luz/carhelper/passenger/BubbleService;->addSpacer(Landroid/widget/LinearLayout;)V

    # row 2: [back] home navbar - when the Back service is off, Back is dropped and Home shifts left
    invoke-direct {p0, v1}, Luz/carhelper/passenger/BubbleService;->newRow(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v4
    sget-object v2, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    if-eqz v2, :back_off
    const-string v2, "ic_back"
    const-string v3, "back"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/BubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    move-result-object v2
    iput-object v2, p0, Luz/carhelper/passenger/BubbleService;->backBtn:Landroid/widget/ImageView;
    const-string v2, "ic_home"
    const-string v3, "home"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/BubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    goto :row2_nav
    :back_off
    const/4 v2, 0x0
    iput-object v2, p0, Luz/carhelper/passenger/BubbleService;->backBtn:Landroid/widget/ImageView;
    const-string v2, "ic_home"
    const-string v3, "home"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/BubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    invoke-direct {p0, v4}, Luz/carhelper/passenger/BubbleService;->addSpacer(Landroid/widget/LinearLayout;)V
    :row2_nav
    iget-boolean v2, p0, Luz/carhelper/passenger/BubbleService;->barHidden:Z
    const-string v3, "bar"
    if-eqz v2, :bar_visible
    const-string v2, "ic_bar_show"
    goto :add_bar
    :bar_visible
    const-string v2, "ic_bar_hide"
    :add_bar
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/BubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    move-result-object v2
    iput-object v2, p0, Luz/carhelper/passenger/BubbleService;->barBtn:Landroid/widget/ImageView;

    # row 3: swap screens in the middle
    invoke-direct {p0, v1}, Luz/carhelper/passenger/BubbleService;->newRow(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v4
    invoke-direct {p0, v4}, Luz/carhelper/passenger/BubbleService;->addSpacer(Landroid/widget/LinearLayout;)V
    const-string v2, "ic_swap"
    const-string v3, "swap"
    invoke-direct {p0, v4, v2, v3}, Luz/carhelper/passenger/BubbleService;->addButton(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/ImageView;
    invoke-direct {p0, v4}, Luz/carhelper/passenger/BubbleService;->addSpacer(Landroid/widget/LinearLayout;)V

    # LayoutParams(wrap, wrap, TYPE_APPLICATION_OVERLAY, NOT_TOUCH_MODAL|WATCH_OUTSIDE_TOUCH, TRANSLUCENT), top-left origin.
    # Focusable on purpose: touching the panel moves input focus to the passenger screen, so Back lands there.
    new-instance v3, Landroid/view/WindowManager$LayoutParams;
    const/4 v4, -0x2
    const/4 v5, -0x2
    const/16 v6, 0x7f6
    const v7, 0x40020
    const/4 v8, -0x3
    invoke-direct/range {v3 .. v8}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V
    const/16 v4, 0x33
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->gravity:I
    iput-object v3, p0, Luz/carhelper/passenger/BubbleService;->panelLp:Landroid/view/WindowManager$LayoutParams;
    return-void
.end method

.method private togglePanel()V
    .locals 9
    iget-boolean v0, p0, Luz/carhelper/passenger/BubbleService;->panelShown:Z
    if-eqz v0, :show
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hidePanel()V
    return-void

    :show
    # this tap's own touch-down just closed the panel (outside tap) -> leave it closed
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v0
    iget-wide v2, p0, Luz/carhelper/passenger/BubbleService;->lastOutsideHide:J
    sub-long/2addr v0, v2
    const-wide/16 v2, 0x190
    cmp-long v0, v0, v2
    if-ltz v0, :closed_just_now
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->panel:Landroid/widget/LinearLayout;
    if-nez v0, :built
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->buildPanel()V
    :built
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->readBarHidden()Z
    move-result v0
    iput-boolean v0, p0, Luz/carhelper/passenger/BubbleService;->barHidden:Z
    const-string v1, "ic_bar_hide"
    if-eqz v0, :bar_icon_set
    const-string v1, "ic_bar_show"
    :bar_icon_set
    invoke-direct {p0, v1}, Luz/carhelper/passenger/BubbleService;->icon(Ljava/lang/String;)I
    move-result v1
    iget-object v2, p0, Luz/carhelper/passenger/BubbleService;->barBtn:Landroid/widget/ImageView;
    invoke-virtual {v2, v1}, Landroid/widget/ImageView;->setImageResource(I)V
    # Back greyed out while the Back accessibility service is off
    const/high16 v1, 0x3f800000
    sget-object v2, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    if-nez v2, :back_alpha
    const v1, 0x3eb33333
    :back_alpha
    iget-object v2, p0, Luz/carhelper/passenger/BubbleService;->backBtn:Landroid/widget/ImageView;
    if-eqz v2, :back_alpha_done
    invoke-virtual {v2, v1}, Landroid/view/View;->setAlpha(F)V
    :back_alpha_done
    # place the 408 px panel beside the bubble (80 px), on the side with more room, kept on screen
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->lp:Landroid/view/WindowManager$LayoutParams;
    iget v1, v0, Landroid/view/WindowManager$LayoutParams;->x:I
    iget v2, v0, Landroid/view/WindowManager$LayoutParams;->y:I
    iget v3, p0, Luz/carhelper/passenger/BubbleService;->maxX:I
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
    iget v6, p0, Luz/carhelper/passenger/BubbleService;->maxY:I
    add-int/lit16 v6, v6, -0x148
    if-le v7, v6, :y_max_ok
    move v7, v6
    :y_max_ok
    if-gez v7, :y_min_ok
    const/4 v7, 0x0
    :y_min_ok
    iget-object v8, p0, Luz/carhelper/passenger/BubbleService;->panelLp:Landroid/view/WindowManager$LayoutParams;
    iput v5, v8, Landroid/view/WindowManager$LayoutParams;->x:I
    iput v7, v8, Landroid/view/WindowManager$LayoutParams;->y:I

    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->wm:Landroid/view/WindowManager;
    iget-object v1, p0, Luz/carhelper/passenger/BubbleService;->panel:Landroid/widget/LinearLayout;
    :try_start_0
    const/4 v3, 0x0
    invoke-virtual {v1, v3}, Landroid/view/View;->setAlpha(F)V
    invoke-interface {v0, v1, v8}, Landroid/view/ViewManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    const/4 v0, 0x1
    iput-boolean v0, p0, Luz/carhelper/passenger/BubbleService;->panelShown:Z
    # fade in over 150 ms
    invoke-virtual {v1}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;
    move-result-object v0
    const/high16 v3, 0x3f800000
    invoke-virtual {v0, v3}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;
    move-result-object v0
    const-wide/16 v2, 0x96
    invoke-virtual {v0, v2, v3}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->bubble:Landroid/view/View;
    check-cast v0, Landroid/widget/ImageView;
    const-string v2, "bubble_close"
    invoke-direct {p0, v2}, Luz/carhelper/passenger/BubbleService;->icon(Ljava/lang/String;)I
    move-result v2
    invoke-virtual {v0, v2}, Landroid/widget/ImageView;->setImageResource(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void
    :catch_0
    move-exception v0
    const-string v1, "PassengerBubble"
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :closed_just_now
    return-void
.end method

.method private hidePanel()V
    .locals 2
    iget-boolean v0, p0, Luz/carhelper/passenger/BubbleService;->panelShown:Z
    if-eqz v0, :done
    const/4 v0, 0x0
    iput-boolean v0, p0, Luz/carhelper/passenger/BubbleService;->panelShown:Z
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->bubble:Landroid/view/View;
    check-cast v0, Landroid/widget/ImageView;
    const-string v1, "bubble"
    invoke-direct {p0, v1}, Luz/carhelper/passenger/BubbleService;->icon(Ljava/lang/String;)I
    move-result v1
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageResource(I)V
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->wm:Landroid/view/WindowManager;
    iget-object v1, p0, Luz/carhelper/passenger/BubbleService;->panel:Landroid/widget/LinearLayout;
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
    const/high16 v0, 0x10000000
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
    const-string v1, "PassengerBubble"
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

# menu buttons. Home, Back and the bar toggle leave the panel open; Open app and X close it.
.method public onClick(Landroid/view/View;)V
    .locals 5
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;

    const-string v1, "screenoff"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_screenoff
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hidePanel()V
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->showCover()V
    return-void
    :not_screenoff
    const-string v1, "uncover"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_uncover
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hideCover()V
    return-void
    :not_uncover

    const-string v1, "close"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_close
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hidePanel()V
    return-void

    :not_close
    const-string v1, "swap"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_swap
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hidePanel()V
    invoke-static {p0}, Luz/carhelper/passenger/Swapper;->swap(Landroid/content/Context;)V
    return-void

    :not_swap
    const-string v1, "apps"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_apps
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hidePanel()V
    new-instance v1, Landroid/content/Intent;
    const-class v2, Luz/carhelper/passenger/MainActivity;
    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/BubbleService;->startOnPassenger(Landroid/content/Intent;)V
    return-void

    # Home: open LP Companion's grid on the passenger screen (display 3)
    :not_apps
    const-string v1, "home"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_home
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hidePanel()V
    new-instance v1, Landroid/content/Intent;
    const-class v2, Luz/carhelper/passenger/MainActivity;
    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/BubbleService;->startOnPassenger(Landroid/content/Intent;)V
    return-void

    :not_home
    const-string v1, "back"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_back
    sget-object v1, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    if-nez v1, :back_on
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hidePanel()V
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->backIsOff()V
    return-void
    :back_on
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hidePanel()V
    iget-object v1, p0, Luz/carhelper/passenger/BubbleService;->handler:Landroid/os/Handler;
    new-instance v2, Luz/carhelper/passenger/PanelAction;
    const/4 v3, 0x0
    invoke-direct {v2, p0, v3}, Luz/carhelper/passenger/PanelAction;-><init>(Luz/carhelper/passenger/BubbleService;I)V
    const-wide/16 v3, 0x1e
    invoke-virtual {v1, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void

    :not_back
    const-string v1, "bar"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :done
    iget-boolean v1, p0, Luz/carhelper/passenger/BubbleService;->barHidden:Z
    xor-int/lit8 v1, v1, 0x1
    iput-boolean v1, p0, Luz/carhelper/passenger/BubbleService;->barHidden:Z
    invoke-direct {p0, v1}, Luz/carhelper/passenger/BubbleService;->writeBarHidden(Z)V
    const/4 v2, 0x0
    const-string v3, "ic_bar_hide"
    if-eqz v1, :send
    const/16 v2, 0x8
    const-string v3, "ic_bar_show"
    :send
    invoke-direct {p0, v3}, Luz/carhelper/passenger/BubbleService;->icon(Ljava/lang/String;)I
    move-result v3
    iget-object v4, p0, Luz/carhelper/passenger/BubbleService;->barBtn:Landroid/widget/ImageView;
    invoke-virtual {v4, v3}, Landroid/widget/ImageView;->setImageResource(I)V
    new-instance v1, Landroid/content/Intent;
    const-string v3, "com.leapmotor.iqiyi.action.nav.visibility"
    invoke-direct {v1, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v3, "visibility"
    invoke-virtual {v1, v3, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;
    const-string v3, "package"
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v1, v3, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
    invoke-virtual {p0, v1}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    :done
    return-void
.end method

# ---------- touch: bubble drag/tap, panel outside-tap ----------

.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 6
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->bubble:Landroid/view/View;
    if-eq p1, v0, :bubble_touch

    # panel: a tap outside closes it
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I
    move-result v0
    const/4 v1, 0x4
    if-ne v0, v1, :panel_pass
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v2
    iput-wide v2, p0, Luz/carhelper/passenger/BubbleService;->lastOutsideHide:J
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hidePanel()V
    goto :ret_true
    :panel_pass
    const/4 v0, 0x0
    return v0

    :bubble_touch
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I
    move-result v0

    # DOWN: remember start, full opacity
    if-nez v0, :not_down
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F
    move-result v1
    iput v1, p0, Luz/carhelper/passenger/BubbleService;->downRawX:F
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F
    move-result v1
    iput v1, p0, Luz/carhelper/passenger/BubbleService;->downRawY:F
    iget-object v1, p0, Luz/carhelper/passenger/BubbleService;->lp:Landroid/view/WindowManager$LayoutParams;
    iget v2, v1, Landroid/view/WindowManager$LayoutParams;->x:I
    iput v2, p0, Luz/carhelper/passenger/BubbleService;->startX:I
    iget v2, v1, Landroid/view/WindowManager$LayoutParams;->y:I
    iput v2, p0, Luz/carhelper/passenger/BubbleService;->startY:I
    const/4 v2, 0x0
    iput-boolean v2, p0, Luz/carhelper/passenger/BubbleService;->moved:Z
    const/high16 v2, 0x3f800000
    invoke-virtual {p1, v2}, Landroid/view/View;->setAlpha(F)V
    goto :ret_true

    # MOVE: drag once past 12 px, clamped to the screen
    :not_down
    const/4 v1, 0x2
    if-ne v0, v1, :not_move
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F
    move-result v1
    iget v2, p0, Luz/carhelper/passenger/BubbleService;->downRawX:F
    sub-float/2addr v1, v2
    float-to-int v1, v1
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F
    move-result v2
    iget v3, p0, Luz/carhelper/passenger/BubbleService;->downRawY:F
    sub-float/2addr v2, v3
    float-to-int v2, v2
    iget-boolean v3, p0, Luz/carhelper/passenger/BubbleService;->moved:Z
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
    iput-boolean v3, p0, Luz/carhelper/passenger/BubbleService;->moved:Z
    :apply
    iget v3, p0, Luz/carhelper/passenger/BubbleService;->startX:I
    add-int/2addr v3, v1
    iget v4, p0, Luz/carhelper/passenger/BubbleService;->startY:I
    add-int/2addr v4, v2
    if-gez v3, :x_min_ok
    const/4 v3, 0x0
    :x_min_ok
    iget v5, p0, Luz/carhelper/passenger/BubbleService;->maxX:I
    if-le v3, v5, :x_max_ok
    move v3, v5
    :x_max_ok
    if-gez v4, :y_min_ok
    const/4 v4, 0x0
    :y_min_ok
    iget v5, p0, Luz/carhelper/passenger/BubbleService;->maxY:I
    if-le v4, v5, :y_max_ok
    move v4, v5
    :y_max_ok
    iget-object v5, p0, Luz/carhelper/passenger/BubbleService;->lp:Landroid/view/WindowManager$LayoutParams;
    iput v3, v5, Landroid/view/WindowManager$LayoutParams;->x:I
    iput v4, v5, Landroid/view/WindowManager$LayoutParams;->y:I
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->wm:Landroid/view/WindowManager;
    invoke-interface {v0, p1, v5}, Landroid/view/ViewManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    goto :ret_true

    # UP: tap -> toggle menu, drag -> save position. CANCEL: just restore opacity.
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
    iget-boolean v2, p0, Luz/carhelper/passenger/BubbleService;->moved:Z
    if-nez v2, :save
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->togglePanel()V
    goto :ret_true
    :save
    const-string v2, "bubble"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    iget-object v3, p0, Luz/carhelper/passenger/BubbleService;->lp:Landroid/view/WindowManager$LayoutParams;
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
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->steer:Landroid/content/BroadcastReceiver;
    if-eqz v0, :no_steer
    :try_start_s
    invoke-virtual {p0, v0}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_s
    .catch Ljava/lang/Exception; {:try_start_s .. :try_end_s} :catch_s
    :catch_s
    const/4 v0, 0x0
    iput-object v0, p0, Luz/carhelper/passenger/BubbleService;->steer:Landroid/content/BroadcastReceiver;
    :no_steer
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->hidePanel()V
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->wm:Landroid/view/WindowManager;
    iget-object v1, p0, Luz/carhelper/passenger/BubbleService;->bubble:Landroid/view/View;
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

# sidebar state shared with the app (prefs "apps" / "barHidden")
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

# "Screen off" like the sidebar's: a full-screen black cover on the passenger screen; tap it to wake
.method private showCover()V
    .locals 8
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->cover:Landroid/view/View;
    if-nez v0, :done
    new-instance v0, Landroid/view/View;
    iget-object v1, p0, Luz/carhelper/passenger/BubbleService;->dctx:Landroid/content/Context;
    invoke-direct {v0, v1}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    const/high16 v1, -0x1000000
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V
    const-string v1, "uncover"
    invoke-virtual {v0, v1}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/view/View;->setSoundEffectsEnabled(Z)V
    # LayoutParams(MATCH, MATCH, TYPE_APPLICATION_OVERLAY, NOT_FOCUSABLE|LAYOUT_IN_SCREEN|LAYOUT_NO_LIMITS, OPAQUE)
    new-instance v2, Landroid/view/WindowManager$LayoutParams;
    const/4 v3, -0x1
    const/4 v4, -0x1
    const/16 v5, 0x7f6
    const/16 v6, 0x308
    const/4 v7, -0x1
    invoke-direct/range {v2 .. v7}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V
    iget-object v1, p0, Luz/carhelper/passenger/BubbleService;->wm:Landroid/view/WindowManager;
    :try_start_0
    invoke-interface {v1, v0, v2}, Landroid/view/ViewManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    iput-object v0, p0, Luz/carhelper/passenger/BubbleService;->cover:Landroid/view/View;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :done
    return-void
.end method

.method private hideCover()V
    .locals 2
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->cover:Landroid/view/View;
    if-eqz v0, :done
    const/4 v1, 0x0
    iput-object v1, p0, Luz/carhelper/passenger/BubbleService;->cover:Landroid/view/View;
    iget-object v1, p0, Luz/carhelper/passenger/BubbleService;->wm:Landroid/view/WindowManager;
    :try_start_0
    invoke-interface {v1, v0}, Landroid/view/ViewManager;->removeView(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    :done
    return-void
.end method

# ---------- overload protection (pref "overheat") ----------

.method private overheatOn()Z
    .locals 3
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "overheat"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
.end method

# 1-minute load average from /proc/loadavg (0 if unreadable)
.method private loadAvg()F
    .locals 3
    :try_start_0
    new-instance v0, Ljava/io/FileReader;
    const-string v1, "/proc/loadavg"
    invoke-direct {v0, v1}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V
    new-instance v1, Ljava/io/BufferedReader;
    invoke-direct {v1, v0}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V
    const-string v0, " "
    invoke-virtual {v2, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v0
    const/4 v1, 0x0
    aget-object v0, v0, v1
    invoke-static {v0}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F
    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return v0
    :catch_0
    const/4 v0, 0x0
    return v0
.end method

# every 30 s: RAM critical (low-memory flag or < 1/16 free) or CPU load > 7.0 twice in a row -> protect
.method public run()V
    .locals 8
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->overheatOn()Z
    move-result v0
    if-eqz v0, :repost
    const-string v0, "activity"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/app/ActivityManager;
    new-instance v1, Landroid/app/ActivityManager$MemoryInfo;
    invoke-direct {v1}, Landroid/app/ActivityManager$MemoryInfo;-><init>()V
    invoke-virtual {v0, v1}, Landroid/app/ActivityManager;->getMemoryInfo(Landroid/app/ActivityManager$MemoryInfo;)V
    iget-boolean v2, v1, Landroid/app/ActivityManager$MemoryInfo;->lowMemory:Z
    if-nez v2, :overload
    iget-wide v2, v1, Landroid/app/ActivityManager$MemoryInfo;->availMem:J
    iget-wide v4, v1, Landroid/app/ActivityManager$MemoryInfo;->totalMem:J
    const/4 v6, 0x4
    shr-long/2addr v4, v6
    cmp-long v6, v2, v4
    if-ltz v6, :overload

    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->loadAvg()F
    move-result v0
    const/high16 v1, 0x40e00000
    cmpl-float v0, v0, v1
    if-gtz v0, :cpu_high
    const/4 v0, 0x0
    iput v0, p0, Luz/carhelper/passenger/BubbleService;->loadStrikes:I
    goto :repost
    :cpu_high
    iget v0, p0, Luz/carhelper/passenger/BubbleService;->loadStrikes:I
    add-int/lit8 v0, v0, 0x1
    iput v0, p0, Luz/carhelper/passenger/BubbleService;->loadStrikes:I
    const/4 v1, 0x2
    if-lt v0, v1, :repost

    :overload
    const/4 v0, 0x0
    iput v0, p0, Luz/carhelper/passenger/BubbleService;->loadStrikes:I
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->protect()V

    :repost
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->handler:Landroid/os/Handler;
    const-wide/16 v1, 0x7530
    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
.end method

# Android thermal status SEVERE (3) or worse
.method public onThermalStatusChanged(I)V
    .locals 1
    const/4 v0, 0x3
    if-lt p1, v0, :done
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->overheatOn()Z
    move-result v0
    if-eqz v0, :done
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->protect()V
    :done
    return-void
.end method

# Android says memory is critically low while we run
.method public onTrimMemory(I)V
    .locals 1
    invoke-super {p0, p1}, Landroid/app/Service;->onTrimMemory(I)V
    const/16 v0, 0xf
    if-ne p1, v0, :done
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->overheatOn()Z
    move-result v0
    if-eqz v0, :done
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->protect()V
    :done
    return-void
.end method

# close passenger-screen apps (Home + kill after 800 ms) and show the warning; at most every 2 min
.method private protect()V
    .locals 8
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v0
    iget-wide v2, p0, Luz/carhelper/passenger/BubbleService;->lastProtect:J
    sub-long v4, v0, v2
    const-wide/32 v2, 0x1d4c0
    cmp-long v4, v4, v2
    if-gez v4, :go
    return-void
    :go
    iput-wide v0, p0, Luz/carhelper/passenger/BubbleService;->lastProtect:J

    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v6
    new-instance v1, Ljava/util/HashSet;
    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V
    const-string v0, "running"
    invoke-interface {v6, v0, v1}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v1
    invoke-interface {v1}, Ljava/util/Set;->size()I
    move-result v2
    if-eqz v2, :warn
    new-array v3, v2, [Ljava/lang/String;
    invoke-interface {v1, v3}, Ljava/util/Set;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v3
    check-cast v3, [Ljava/lang/String;

    # passenger screen Home, like the sidebar
    new-instance v4, Landroid/content/Intent;
    const-string v5, "android.intent.action.MAIN"
    invoke-direct {v4, v5}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v5, "android.intent.category.LAUNCHER"
    invoke-virtual {v4, v5}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    const-string v5, "com.leapmotor.copilotshowapp"
    const-string v7, "com.leapmotor.copilotshowapp.mvvm.main.MainActivity"
    invoke-virtual {v4, v5, v7}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
    const/high16 v5, 0x10000
    invoke-virtual {v4, v5}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    invoke-direct {p0, v4}, Luz/carhelper/passenger/BubbleService;->startOnPassenger(Landroid/content/Intent;)V

    # close them once they are in the background
    new-instance v4, Luz/carhelper/passenger/Closer;
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v5
    invoke-direct {v4, v5, v3}, Luz/carhelper/passenger/Closer;-><init>(Landroid/content/Context;[Ljava/lang/String;)V
    iget-object v5, p0, Luz/carhelper/passenger/BubbleService;->handler:Landroid/os/Handler;
    const-wide/16 v0, 0x320
    invoke-virtual {v5, v4, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    invoke-interface {v6}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v4
    const-string v5, "running"
    new-instance v7, Ljava/util/HashSet;
    invoke-direct {v7}, Ljava/util/HashSet;-><init>()V
    invoke-interface {v4, v5, v7}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    move-result-object v4
    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    :warn
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->showWarning()V
    const-string v0, "LPCompanion"
    const-string v1, "overload protection triggered"
    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

# red pill at the top of the passenger screen for 5 s
.method private showWarning()V
    .locals 8
    iget-object v0, p0, Luz/carhelper/passenger/BubbleService;->dctx:Landroid/content/Context;
    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v2, "\u26a0  System overloaded \u2014 passenger apps closed"
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v2, 0x41d00000
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v2, -0x1
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v2, 0x28
    const/16 v3, 0x14
    invoke-virtual {v1, v2, v3, v2, v3}, Landroid/widget/TextView;->setPadding(IIII)V
    new-instance v2, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    const v3, -0x1939d7d8
    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    const/high16 v3, 0x42c80000
    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    # LayoutParams(wrap, wrap, TYPE_APPLICATION_OVERLAY, NOT_FOCUSABLE|NOT_TOUCHABLE, TRANSLUCENT), top centre
    new-instance v2, Landroid/view/WindowManager$LayoutParams;
    const/4 v3, -0x2
    const/4 v4, -0x2
    const/16 v5, 0x7f6
    const/16 v6, 0x18
    const/4 v7, -0x3
    invoke-direct/range {v2 .. v7}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V
    const/16 v3, 0x31
    iput v3, v2, Landroid/view/WindowManager$LayoutParams;->gravity:I
    const/16 v3, 0x28
    iput v3, v2, Landroid/view/WindowManager$LayoutParams;->y:I
    iget-object v3, p0, Luz/carhelper/passenger/BubbleService;->wm:Landroid/view/WindowManager;
    :try_start_0
    invoke-interface {v3, v1, v2}, Landroid/view/ViewManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    new-instance v4, Luz/carhelper/passenger/HideView;
    invoke-direct {v4, v3, v1}, Luz/carhelper/passenger/HideView;-><init>(Landroid/view/WindowManager;Landroid/view/View;)V
    iget-object v5, p0, Luz/carhelper/passenger/BubbleService;->handler:Landroid/os/Handler;
    const-wide/16 v6, 0x1388
    invoke-virtual {v5, v4, v6, v7}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

# delayed panel steps (PanelAction): 0 = global Back (lands on the passenger screen, now focused), 1 = reopen panel
.method public delayed(I)V
    .locals 2
    if-nez p1, :reopen
    invoke-static {}, Luz/carhelper/passenger/BackService;->back()Z
    move-result v0
    if-nez v0, :done
    const-string v0, "PassengerBubble"
    const-string v1, "Back unavailable: BackService accessibility service not enabled"
    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return-void
    :reopen
    iget-boolean v0, p0, Luz/carhelper/passenger/BubbleService;->panelShown:Z
    if-nez v0, :done
    invoke-direct {p0}, Luz/carhelper/passenger/BubbleService;->togglePanel()V
    :done
    return-void
.end method

# Back service is off: try to switch it back on ourselves, else tell the driver it needs the ADB grant
# (the car has no Accessibility settings screen to send them to)
.method private backIsOff()V
    .locals 3
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v0
    invoke-static {v0}, Luz/carhelper/passenger/BackRepair;->ensure(Landroid/content/Context;)Z
    move-result v1
    const-string v2, "Back is starting \u2014 tap it again in a moment"
    if-nez v1, :show
    const-string v2, "Back is off \u2014 LP Companion needs the WRITE_SECURE_SETTINGS grant over ADB"
    :show
    const/4 v1, 0x1
    invoke-static {v0, v2, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    return-void
.end method

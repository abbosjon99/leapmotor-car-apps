.class public final Luz/carhelper/passenger/boot/Boot;
.super Ljava/lang/Object;
.source "Boot.java"

# interfaces
.implements Ljava/lang/Runnable;


# static fields
.field private static final FIRST_MS:J = 0x1388L

.field private static final FRESH_MS:J = 0x493e0L

.field private static final MAX_STARTS:I = 0x6

.field private static final PASSENGER:I = 0x3

.field private static final SAME_BOOT_MS:J = 0x1d4c0L

.field private static final SETTLE_MS:J = 0x4e20L

.field private static final TAG:Ljava/lang/String; = "LPBoot"

.field private static final TICK_MS:J = 0xbb8L

.field private static final WINDOW_MS:J = 0x2bf20L

.field private static current:Luz/carhelper/passenger/boot/Boot;

.field private static lastBoot:J

.field private static opened:Z


# instance fields
.field private final app:Landroid/content/Context;

.field private bubbleStarts:I

.field private final handler:Landroid/os/Handler;

.field private mainStarts:I

.field private shownSince:J

.field private until:J

.field private wantOpen:Z


# direct methods
.method private constructor <init>(Landroid/content/Context;)V
    .locals 2

    .line 57
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 50
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Luz/carhelper/passenger/boot/Boot;->handler:Landroid/os/Handler;

    .line 58
    iput-object p1, p0, Luz/carhelper/passenger/boot/Boot;->app:Landroid/content/Context;

    return-void
.end method

.method public static kick(Landroid/content/Context;Ljava/lang/String;Z)V
    .locals 10

    .line 68
    const-string v0, "LPBoot"

    .line 0
    const-string v1, "kick by "

    .line 68
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v2

    if-nez v2, :cond_0

    goto :goto_0

    :cond_0
    move-object p0, v2

    .line 72
    :goto_0
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    const/4 v4, 0x0

    const/4 v5, 0x1

    if-eqz p2, :cond_2

    .line 75
    sget-wide v6, Luz/carhelper/passenger/boot/Boot;->lastBoot:J

    const-wide/16 v8, 0x0

    cmp-long p2, v6, v8

    if-eqz p2, :cond_1

    sub-long v6, v2, v6

    const-wide/32 v8, 0x1d4c0

    cmp-long p2, v6, v8

    if-lez p2, :cond_1

    .line 76
    sput-boolean v4, Luz/carhelper/passenger/boot/Boot;->opened:Z

    .line 78
    :cond_1
    sput-wide v2, Luz/carhelper/passenger/boot/Boot;->lastBoot:J

    :goto_1
    move v4, v5

    goto :goto_2

    :cond_2
    const-wide/32 v6, 0x493e0

    cmp-long p2, v2, v6

    if-gez p2, :cond_3

    goto :goto_1

    .line 83
    :cond_3
    :goto_2
    sget-object p2, Luz/carhelper/passenger/boot/Boot;->current:Luz/carhelper/passenger/boot/Boot;

    if-nez p2, :cond_4

    .line 85
    new-instance p2, Luz/carhelper/passenger/boot/Boot;

    invoke-direct {p2, p0}, Luz/carhelper/passenger/boot/Boot;-><init>(Landroid/content/Context;)V

    .line 86
    sput-object p2, Luz/carhelper/passenger/boot/Boot;->current:Luz/carhelper/passenger/boot/Boot;

    .line 87
    iget-object p0, p2, Luz/carhelper/passenger/boot/Boot;->handler:Landroid/os/Handler;

    const-wide/16 v6, 0x1388

    invoke-virtual {p0, p2, v6, v7}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :cond_4
    const-wide/32 v6, 0x2bf20

    add-long/2addr v6, v2

    .line 89
    iput-wide v6, p2, Luz/carhelper/passenger/boot/Boot;->until:J

    if-eqz v4, :cond_5

    .line 90
    sget-boolean p0, Luz/carhelper/passenger/boot/Boot;->opened:Z

    if-nez p0, :cond_5

    .line 91
    iput-boolean v5, p2, Luz/carhelper/passenger/boot/Boot;->wantOpen:Z

    .line 93
    :cond_5
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " (up "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-wide/16 v4, 0x3e8

    div-long/2addr v2, v4

    invoke-virtual {p0, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, " s, open="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p1, p2, Luz/carhelper/passenger/boot/Boot;->wantOpen:Z

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, ")"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_3

    :catchall_0
    move-exception p0

    .line 95
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "kick failed: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :goto_3
    return-void
.end method

.method private start(Ljava/lang/Class;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)V"
        }
    .end annotation

    .line 173
    const-string v0, "LPBoot"

    .line 0
    const-string v1, "started "

    .line 173
    :try_start_0
    iget-object v2, p0, Luz/carhelper/passenger/boot/Boot;->app:Landroid/content/Context;

    new-instance v3, Landroid/content/Intent;

    iget-object v4, p0, Luz/carhelper/passenger/boot/Boot;->app:Landroid/content/Context;

    invoke-direct {v3, v4, p1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v2, v3}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 174
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v1

    .line 176
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "cannot start "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ": "

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method private step(J)Z
    .locals 9

    .line 122
    iget-object v0, p0, Luz/carhelper/passenger/boot/Boot;->app:Landroid/content/Context;

    invoke-static {v0}, Luz/carhelper/passenger/BackRepair;->ensure(Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x1

    xor-int/2addr v0, v1

    .line 125
    iget-object v2, p0, Luz/carhelper/passenger/boot/Boot;->app:Landroid/content/Context;

    invoke-static {v2}, Luz/carhelper/passenger/boot/ListenerGrant;->ensure(Landroid/content/Context;)Z

    move-result v2

    if-nez v2, :cond_0

    move v0, v1

    .line 128
    :cond_0
    iget-object v2, p0, Luz/carhelper/passenger/boot/Boot;->app:Landroid/content/Context;

    const-string v3, "display"

    invoke-virtual {v2, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/hardware/display/DisplayManager;

    if-nez v2, :cond_1

    const/4 v2, 0x0

    goto :goto_0

    :cond_1
    const/4 v3, 0x3

    .line 129
    invoke-virtual {v2, v3}, Landroid/hardware/display/DisplayManager;->getDisplay(I)Landroid/view/Display;

    move-result-object v2

    :goto_0
    const/4 v3, 0x0

    if-eqz v2, :cond_2

    .line 130
    invoke-virtual {v2}, Landroid/view/Display;->getState()I

    move-result v4

    const/4 v5, 0x2

    if-ne v4, v5, :cond_2

    move v4, v1

    goto :goto_1

    :cond_2
    move v4, v3

    :goto_1
    const-wide/16 v5, 0x0

    if-eqz v4, :cond_3

    .line 132
    iget-wide v7, p0, Luz/carhelper/passenger/boot/Boot;->shownSince:J

    cmp-long v5, v7, v5

    if-nez v5, :cond_4

    .line 133
    iput-wide p1, p0, Luz/carhelper/passenger/boot/Boot;->shownSince:J

    goto :goto_2

    .line 136
    :cond_3
    iput-wide v5, p0, Luz/carhelper/passenger/boot/Boot;->shownSince:J

    .line 139
    :cond_4
    :goto_2
    sget-object v5, Luz/carhelper/passenger/BubbleService;->instance:Luz/carhelper/passenger/BubbleService;

    const/4 v6, 0x6

    if-nez v5, :cond_6

    .line 140
    iget v5, p0, Luz/carhelper/passenger/boot/Boot;->bubbleStarts:I

    if-ge v5, v6, :cond_6

    if-eqz v2, :cond_5

    add-int/2addr v5, v1

    .line 143
    iput v5, p0, Luz/carhelper/passenger/boot/Boot;->bubbleStarts:I

    .line 144
    const-class v0, Luz/carhelper/passenger/BubbleService;

    invoke-direct {p0, v0}, Luz/carhelper/passenger/boot/Boot;->start(Ljava/lang/Class;)V

    :cond_5
    move v0, v1

    .line 148
    :cond_6
    sget-object v2, Luz/carhelper/passenger/MainBubbleService;->instance:Luz/carhelper/passenger/MainBubbleService;

    if-nez v2, :cond_7

    .line 149
    iget v2, p0, Luz/carhelper/passenger/boot/Boot;->mainStarts:I

    if-ge v2, v6, :cond_7

    add-int/2addr v2, v1

    .line 151
    iput v2, p0, Luz/carhelper/passenger/boot/Boot;->mainStarts:I

    .line 152
    const-class v0, Luz/carhelper/passenger/MainBubbleService;

    invoke-direct {p0, v0}, Luz/carhelper/passenger/boot/Boot;->start(Ljava/lang/Class;)V

    move v0, v1

    .line 156
    :cond_7
    iget-boolean v2, p0, Luz/carhelper/passenger/boot/Boot;->wantOpen:Z

    if-eqz v2, :cond_9

    sget-boolean v2, Luz/carhelper/passenger/boot/Boot;->opened:Z

    if-nez v2, :cond_9

    .line 157
    iget-object v2, p0, Luz/carhelper/passenger/boot/Boot;->app:Landroid/content/Context;

    const-string v5, "apps"

    invoke-virtual {v2, v5, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    const-string v5, "autoOpen"

    invoke-interface {v2, v5, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v2

    if-nez v2, :cond_8

    .line 158
    iput-boolean v3, p0, Luz/carhelper/passenger/boot/Boot;->wantOpen:Z

    goto :goto_3

    :cond_8
    if-eqz v4, :cond_a

    .line 159
    iget-wide v4, p0, Luz/carhelper/passenger/boot/Boot;->shownSince:J

    sub-long/2addr p1, v4

    const-wide/16 v4, 0x4e20

    cmp-long p1, p1, v4

    if-ltz p1, :cond_a

    .line 160
    sput-boolean v1, Luz/carhelper/passenger/boot/Boot;->opened:Z

    .line 161
    iput-boolean v3, p0, Luz/carhelper/passenger/boot/Boot;->wantOpen:Z

    .line 162
    const-string p1, "LPBoot"

    const-string p2, "opening the grid on the passenger screen"

    invoke-static {p1, p2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 163
    iget-object p1, p0, Luz/carhelper/passenger/boot/Boot;->app:Landroid/content/Context;

    invoke-static {p1}, Luz/carhelper/passenger/Swapper;->grid(Landroid/content/Context;)V

    :cond_9
    :goto_3
    move v1, v0

    :cond_a
    return v1
.end method


# virtual methods
.method public run()V
    .locals 6

    .line 101
    const-string v0, "LPBoot"

    sget-object v1, Luz/carhelper/passenger/boot/Boot;->current:Luz/carhelper/passenger/boot/Boot;

    if-eq v1, p0, :cond_0

    return-void

    .line 104
    :cond_0
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v1

    .line 107
    :try_start_0
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/boot/Boot;->step(J)Z

    move-result v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v3

    .line 109
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "tick failed: "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v3, 0x0

    :goto_0
    if-eqz v3, :cond_1

    .line 111
    iget-wide v4, p0, Luz/carhelper/passenger/boot/Boot;->until:J

    cmp-long v1, v1, v4

    if-gez v1, :cond_1

    .line 112
    iget-object v0, p0, Luz/carhelper/passenger/boot/Boot;->handler:Landroid/os/Handler;

    const-wide/16 v1, 0xbb8

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_1

    :cond_1
    const/4 v1, 0x0

    .line 114
    sput-object v1, Luz/carhelper/passenger/boot/Boot;->current:Luz/carhelper/passenger/boot/Boot;

    .line 115
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "done (pending="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", opened="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v2, Luz/carhelper/passenger/boot/Boot;->opened:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ")"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    return-void
.end method

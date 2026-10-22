.class public Luz/carhelper/passenger/WheelGuard;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# After a wheel press: the car's own media app also reacts (e.g. resumes Kugou). Every 500 ms,
# 3 times, pause any playing com.leapmotor.* session and resume the target if it should play.
# Holds the receiver's goAsync() result and finishes it after the last run.

.field private final ctx:Landroid/content/Context;
.field private final target:Landroid/media/session/MediaController;
.field private final want:Z
.field private final pending:Landroid/content/BroadcastReceiver$PendingResult;
.field private final handler:Landroid/os/Handler;
.field private remaining:I

.method public constructor <init>(Landroid/content/Context;Landroid/media/session/MediaController;ZLandroid/content/BroadcastReceiver$PendingResult;Landroid/os/Handler;)V
    .locals 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/WheelGuard;->ctx:Landroid/content/Context;
    iput-object p2, p0, Luz/carhelper/passenger/WheelGuard;->target:Landroid/media/session/MediaController;
    iput-boolean p3, p0, Luz/carhelper/passenger/WheelGuard;->want:Z
    iput-object p4, p0, Luz/carhelper/passenger/WheelGuard;->pending:Landroid/content/BroadcastReceiver$PendingResult;
    iput-object p5, p0, Luz/carhelper/passenger/WheelGuard;->handler:Landroid/os/Handler;
    const/4 v0, 0x3
    iput v0, p0, Luz/carhelper/passenger/WheelGuard;->remaining:I
    return-void
.end method

.method public run()V
    .locals 4
    :try_start_0
    iget-object v0, p0, Luz/carhelper/passenger/WheelGuard;->ctx:Landroid/content/Context;
    iget-object v1, p0, Luz/carhelper/passenger/WheelGuard;->target:Landroid/media/session/MediaController;
    iget-boolean v2, p0, Luz/carhelper/passenger/WheelGuard;->want:Z
    invoke-static {v0, v1, v2}, Luz/carhelper/passenger/WheelReceiver;->guard(Landroid/content/Context;Landroid/media/session/MediaController;Z)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    iget v0, p0, Luz/carhelper/passenger/WheelGuard;->remaining:I
    add-int/lit8 v0, v0, -0x1
    iput v0, p0, Luz/carhelper/passenger/WheelGuard;->remaining:I
    if-lez v0, :finish
    iget-object v0, p0, Luz/carhelper/passenger/WheelGuard;->handler:Landroid/os/Handler;
    const-wide/16 v2, 0x1f4
    invoke-virtual {v0, p0, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
    :finish
    iget-object v0, p0, Luz/carhelper/passenger/WheelGuard;->pending:Landroid/content/BroadcastReceiver$PendingResult;
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/content/BroadcastReceiver$PendingResult;->finish()V
    :done
    return-void
.end method

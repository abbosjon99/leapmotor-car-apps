.class public Luz/carhelper/passenger/KeyDedup;
.super Ljava/lang/Object;

# One physical wheel press can arrive on two channels:
#   "meter" = com.leapmotor.action.METER.CTRL (Migu type-13 bridge, MiguCtrlReceiver)
#   "steer" = com.leapmotor.steerwheelcontrol.media (SteerWheelReceiver)
# Both pass through accept(): the same button within 350 ms of the last accepted press is dropped.
# Buttons: 1 = previous, 2 = next, 3 = play/pause. Every decision is logged under tag "LPWheelKeys":
#   adb logcat -s LPWheelKeys
# Both receivers run on the main thread, so no locking is needed.

.field private static lastKey:I
.field private static lastTime:J

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static accept(Ljava/lang/String;I)Z
    .locals 7
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v0
    new-instance v2, Ljava/lang/StringBuilder;
    const-string v3, "channel="
    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v3, " button="
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    sget v3, Luz/carhelper/passenger/KeyDedup;->lastKey:I
    if-ne v3, p1, :accept
    sget-wide v3, Luz/carhelper/passenger/KeyDedup;->lastTime:J
    sub-long v3, v0, v3
    const-wide/16 v5, 0x15e
    cmp-long v3, v3, v5
    if-gez v3, :accept
    const-string v3, " -> dropped (duplicate within 350 ms)"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v3, "LPWheelKeys"
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    const/4 v0, 0x0
    return v0

    :accept
    sput p1, Luz/carhelper/passenger/KeyDedup;->lastKey:I
    sput-wide v0, Luz/carhelper/passenger/KeyDedup;->lastTime:J
    const-string v3, " -> accepted"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v3, "LPWheelKeys"
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    const/4 v0, 0x1
    return v0
.end method

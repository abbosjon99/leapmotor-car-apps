.class public Luz/carhelper/passenger/Health;
.super Ljava/lang/Object;

# Live readout of what overload protection (BubbleService.run) watches, so the numbers and the colour agree with when
# it acts. read() returns { RAM used %, free MB, temperature in C or -1, Android thermal status or -1, level, load x10 }.
# level: 0 = fine, 1 = high, 2 = overloaded. Overloaded means what the protection reacts to: low-memory flag or less than
# 1/16 RAM free, thermal status SEVERE or worse, or a sensor at 95 C or more. "High" is the early warning: less than
# 1/8 RAM free, thermal MODERATE, 85 C or more, or a 1-minute load above 7.0.
#
# Temperature: Android does not give apps a Celsius value, so this tries the thermal zone files
# (/sys/class/thermal/thermal_zone*/temp). If the firmware does not let apps read them, only Android's own thermal
# status is shown (temp OK / warm / hot / overheating).

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# 1-minute load average x10 from /proc/loadavg (0 if unreadable)
.method private static load10()I
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
    const/high16 v1, 0x41200000
    mul-float/2addr v0, v1
    float-to-int v0, v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return v0
    :catch_0
    const/4 v0, 0x0
    return v0
.end method

# hottest thermal zone in C, or -1 when the files are not readable by apps (stops after 3 failed zones)
.method private static zoneTemp()I
    .locals 5
    const/4 v0, -0x1
    const/4 v1, 0x0
    const/4 v2, 0x0
    :next
    const/16 v3, 0x3c
    if-ge v1, v3, :done
    :try_start_0
    new-instance v3, Ljava/lang/StringBuilder;
    const-string v4, "/sys/class/thermal/thermal_zone"
    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v4, "/temp"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Ljava/io/FileReader;
    invoke-direct {v4, v3}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V
    new-instance v3, Ljava/io/BufferedReader;
    invoke-direct {v3, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    invoke-virtual {v3}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v4
    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v4
    const/16 v3, 0x3e8
    if-lt v4, v3, :unit_ok
    div-int/2addr v4, v3
    :unit_ok
    const/4 v3, 0x5
    if-lt v4, v3, :skip
    const/16 v3, 0x96
    if-gt v4, v3, :skip
    if-le v4, v0, :skip
    move v0, v4
    :skip
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    goto :step
    :catch_0
    add-int/lit8 v2, v2, 0x1
    :step
    add-int/lit8 v1, v1, 0x1
    if-gez v0, :next
    const/4 v3, 0x3
    if-lt v2, v3, :next
    :done
    return v0
.end method

# Android's thermal status: 0 none, 1 light, 2 moderate, 3 severe, 4 critical ... or -1
.method private static thermal(Landroid/content/Context;)I
    .locals 1
    :try_start_0
    const-string v0, "power"
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/os/PowerManager;
    invoke-virtual {v0}, Landroid/os/PowerManager;->getCurrentThermalStatus()I
    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return v0
    :catch_0
    const/4 v0, -0x1
    return v0
.end method

.method public static read(Landroid/content/Context;)[I
    .locals 13
    const/4 v0, 0x6
    new-array v0, v0, [I
    const/4 v12, 0x0

    # RAM: v3:v4 = available, v5:v6 = total
    const-string v1, "activity"
    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/app/ActivityManager;
    new-instance v2, Landroid/app/ActivityManager$MemoryInfo;
    invoke-direct {v2}, Landroid/app/ActivityManager$MemoryInfo;-><init>()V
    invoke-virtual {v1, v2}, Landroid/app/ActivityManager;->getMemoryInfo(Landroid/app/ActivityManager$MemoryInfo;)V
    iget-wide v3, v2, Landroid/app/ActivityManager$MemoryInfo;->availMem:J
    iget-wide v5, v2, Landroid/app/ActivityManager$MemoryInfo;->totalMem:J
    iget-boolean v9, v2, Landroid/app/ActivityManager$MemoryInfo;->lowMemory:Z
    if-eqz v9, :ram_a
    const/4 v12, 0x2
    :ram_a
    const-wide/16 v7, 0x0
    cmp-long v9, v5, v7
    if-eqz v9, :ram_c
    const/4 v10, 0x4
    shr-long v7, v5, v10
    cmp-long v9, v3, v7
    if-gez v9, :ram_b
    const/4 v12, 0x2
    :ram_b
    const/4 v10, 0x3
    shr-long v7, v5, v10
    cmp-long v9, v3, v7
    if-gez v9, :ram_pct
    const/4 v10, 0x1
    if-ge v12, v10, :ram_pct
    move v12, v10
    :ram_pct
    const-wide/16 v7, 0x64
    mul-long/2addr v7, v3
    div-long/2addr v7, v5
    long-to-int v9, v7
    rsub-int/lit8 v9, v9, 0x64
    const/4 v10, 0x0
    aput v9, v0, v10
    const/16 v10, 0x14
    shr-long/2addr v3, v10
    long-to-int v9, v3
    const/4 v10, 0x1
    aput v9, v0, v10
    :ram_c

    # CPU load (protection reacts above 7.0 twice in a row; here it is the early warning)
    invoke-static {}, Luz/carhelper/passenger/Health;->load10()I
    move-result v9
    const/4 v10, 0x5
    aput v9, v0, v10
    const/16 v10, 0x46
    if-le v9, v10, :load_ok
    const/4 v10, 0x1
    if-ge v12, v10, :load_ok
    move v12, v10
    :load_ok

    # temperature from the thermal zones
    invoke-static {}, Luz/carhelper/passenger/Health;->zoneTemp()I
    move-result v9
    const/4 v10, 0x2
    aput v9, v0, v10
    const/16 v10, 0x5f
    if-lt v9, v10, :t_a
    const/4 v12, 0x2
    goto :t_done
    :t_a
    const/16 v10, 0x55
    if-lt v9, v10, :t_done
    const/4 v10, 0x1
    if-ge v12, v10, :t_done
    move v12, v10
    :t_done

    # Android's own thermal status (protection acts at SEVERE = 3)
    invoke-static {p0}, Luz/carhelper/passenger/Health;->thermal(Landroid/content/Context;)I
    move-result v9
    const/4 v10, 0x3
    aput v9, v0, v10
    if-lt v9, v10, :th_a
    const/4 v12, 0x2
    goto :th_done
    :th_a
    const/4 v10, 0x2
    if-ne v9, v10, :th_done
    const/4 v10, 0x1
    if-ge v12, v10, :th_done
    move v12, v10
    :th_done
    const/4 v10, 0x4
    aput v12, v0, v10
    return-object v0
.end method

# "RAM 62%  .  54 C"; without a temperature reading the thermal status word instead (or nothing)
.method public static text([I)Ljava/lang/String;
    .locals 4
    new-instance v0, Ljava/lang/StringBuilder;
    const-string v1, "RAM "
    invoke-static {v1}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    const/4 v1, 0x0
    aget v1, p0, v1
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v1, "%"
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const/4 v1, 0x2
    aget v1, p0, v1
    if-ltz v1, :no_temp
    const-string v2, "  ·  "
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v1, " °C"
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :done
    :no_temp
    const/4 v1, 0x3
    aget v1, p0, v1
    if-ltz v1, :done
    const-string v2, "  ·  "
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v2, "temp OK"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v1, :word
    const-string v2, "temp warm"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/4 v3, 0x1
    if-eq v1, v3, :word
    const-string v2, "temp hot"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/4 v3, 0x2
    if-eq v1, v3, :word
    const-string v2, "overheating"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    :word
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :done
    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

# colour for the level: green, amber, red
.method public static color(I)I
    .locals 1
    if-nez p0, :not_ok
    sget v0, Luz/carhelper/passenger/Ui;->OK:I
    return v0
    :not_ok
    const/4 v0, 0x1
    if-ne p0, v0, :bad
    const v0, 0xffffc857
    return v0
    :bad
    sget v0, Luz/carhelper/passenger/Ui;->BAD:I
    return v0
.end method

# one line for the warning and for Settings
.method public static summary(Landroid/content/Context;)Ljava/lang/String;
    .locals 1
    invoke-static {p0}, Luz/carhelper/passenger/Health;->read(Landroid/content/Context;)[I
    move-result-object v0
    invoke-static {v0}, Luz/carhelper/passenger/Health;->text([I)Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

# "RAM 62%  .  54 C  .  1.4 GB free  .  OK" (Settings > Protection)
.method public static detail(Landroid/content/Context;)Ljava/lang/String;
    .locals 5
    invoke-static {p0}, Luz/carhelper/passenger/Health;->read(Landroid/content/Context;)[I
    move-result-object v0
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-static {v0}, Luz/carhelper/passenger/Health;->text([I)Ljava/lang/String;
    move-result-object v2
    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    const-string v2, "  ·  "
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    # free RAM in GB with one decimal
    const/4 v3, 0x1
    aget v3, v0, v3
    mul-int/lit8 v3, v3, 0xa
    div-int/lit16 v3, v3, 0x400
    const/16 v4, 0xa
    div-int v2, v3, v4
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v2, "."
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    rem-int/2addr v3, v4
    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v2, " GB free  ·  "
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const/4 v3, 0x4
    aget v3, v0, v3
    const-string v2, "level OK"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v3, :word_done
    const-string v2, "high"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/4 v4, 0x1
    if-eq v3, v4, :word_done
    const-string v2, "overloaded"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    :word_done
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    return-object v1
.end method

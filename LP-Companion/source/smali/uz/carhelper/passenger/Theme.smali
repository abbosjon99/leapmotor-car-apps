.class public Luz/carhelper/passenger/Theme;
.super Ljava/lang/Object;

# System day/night helper. night() reads Configuration.uiMode so the app's own solid
# surfaces (PIN pad, wallpaper scrim) follow the car's dark/light theme. The grid itself
# rides on the user's wallpaper, so it stays readable in either mode.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static night(Landroid/content/Context;)Z
    .locals 2
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;
    move-result-object v0
    iget v0, v0, Landroid/content/res/Configuration;->uiMode:I
    and-int/lit8 v0, v0, 0x30
    const/16 v1, 0x20
    if-ne v0, v1, :day
    const/4 v0, 0x1
    return v0
    :day
    const/4 v0, 0x0
    return v0
.end method

# dialog background
.method public static dlgBg(Landroid/content/Context;)I
    .locals 1
    invoke-static {p0}, Luz/carhelper/passenger/Theme;->night(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :day
    const v0, -0xe5e5e6
    return v0
    :day
    const v0, -0xb0b0c
    return v0
.end method

# dialog text / icon
.method public static dlgText(Landroid/content/Context;)I
    .locals 1
    invoke-static {p0}, Luz/carhelper/passenger/Theme;->night(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :day
    const/4 v0, -0x1
    return v0
    :day
    const v0, -0xe5e5e6
    return v0
.end method

# keypad key background
.method public static dlgKey(Landroid/content/Context;)I
    .locals 1
    invoke-static {p0}, Luz/carhelper/passenger/Theme;->night(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :day
    const v0, 0x33ffffff
    return v0
    :day
    const v0, 0x22000000
    return v0
.end method

# wallpaper scrim (over the user's photo)
.method public static scrim(Landroid/content/Context;)I
    .locals 1
    invoke-static {p0}, Luz/carhelper/passenger/Theme;->night(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :day
    # light dimming only: the wallpaper is a low-resolution photo and a heavy dim makes it look hazy
    const v0, 0x4d000000
    return v0
    :day
    const v0, 0x26000000
    return v0
.end method

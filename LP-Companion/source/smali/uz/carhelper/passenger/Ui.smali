.class public Luz/carhelper/passenger/Ui;
.super Ljava/lang/Object;

# Shared look for every screen: dark glass surfaces, one blue accent, rounded corners.
# All sizes are px (the car displays run at 160 dpi, so 1 px = 1 dp = 1 sp).

.field public static final ACCENT:I = 0xff3d8bff
.field public static final ACCENT_PRESSED:I = 0xff2f74d9
.field public static final OK:I = 0xff4ade80
.field public static final BAD:I = 0xffff6b6b
.field public static final TEXT2:I = 0xb3ffffff
.field public static final TEXT3:I = 0x80ffffff
.field public static final CARD:I = 0x1affffff
.field public static final STROKE:I = 0x24ffffff

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# rounded rectangle: fill, 2 px stroke colour (0 = no stroke), corner radius
.method public static rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    .locals 2
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    invoke-virtual {v0, p0}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    invoke-virtual {v0, p2}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    if-eqz p1, :done
    const/4 v1, 0x2
    invoke-virtual {v0, v1, p1}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V
    :done
    return-object v0
.end method

# pressable rounded button: normal fill, pressed fill, stroke colour, radius
.method public static btn(IIIF)Landroid/graphics/drawable/StateListDrawable;
    .locals 5
    new-instance v0, Landroid/graphics/drawable/StateListDrawable;
    invoke-direct {v0}, Landroid/graphics/drawable/StateListDrawable;-><init>()V
    invoke-static {p1, p2, p3}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v1
    const/4 v2, 0x1
    new-array v2, v2, [I
    const v3, 0x10100a7
    const/4 v4, 0x0
    aput v3, v2, v4
    invoke-virtual {v0, v2, v1}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V
    invoke-static {p0, p2, p3}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v1
    const/4 v2, 0x0
    new-array v2, v2, [I
    invoke-virtual {v0, v2, v1}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V
    return-object v0
.end method

# smoked card for the grid tiles: dark so the wallpaper stays crisp around them (a white "frost" washed the photo
# out), a thin light edge, lighter when pressed
.method public static glass(F)Landroid/graphics/drawable/StateListDrawable;
    .locals 4
    const v0, 0x66000000
    const v1, 0x59ffffff
    const v2, 0x40ffffff
    invoke-static {v0, v1, v2, p0}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v0
    return-object v0
.end method

# darker card for content that must stay readable on any wallpaper (now playing)
.method public static dark(F)Landroid/graphics/drawable/GradientDrawable;
    .locals 3
    const v0, 0x80000000
    const v1, 0x2effffff
    invoke-static {v0, v1, p0}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v0
    return-object v0
.end method

# header pill background (grid)
.method public static pillBg()Landroid/graphics/drawable/StateListDrawable;
    .locals 4
    const v0, 0x66000000
    const v1, 0x66ffffff
    const v2, 0x40ffffff
    const/high16 v3, 0x42c80000
    invoke-static {v0, v1, v2, v3}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v0
    return-object v0
.end method

# plain text view
.method public static text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    .locals 2
    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v0, p3}, Landroid/widget/TextView;->setTextColor(I)V
    if-eqz p4, :done
    sget-object v1, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V
    :done
    return-object v0
.end method

# rounded button label: text, fill, pressed fill, stroke colour
.method public static pill(Landroid/content/Context;Ljava/lang/CharSequence;III)Landroid/widget/TextView;
    .locals 3
    const/high16 v0, 0x41c00000
    const/4 v1, -0x1
    const/4 v2, 0x1
    invoke-static {p0, p1, v0, v1, v2}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v0
    const/16 v1, 0x28
    const/16 v2, 0x14
    invoke-virtual {v0, v1, v2, v1, v2}, Landroid/widget/TextView;->setPadding(IIII)V
    const/high16 v1, 0x42c80000
    invoke-static {p2, p3, p4, v1}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    return-object v0
.end method

# settings / PIN page background: deep navy fading to near black
.method public static pageBg()Landroid/graphics/drawable/GradientDrawable;
    .locals 3
    const/4 v0, 0x2
    new-array v0, v0, [I
    const/4 v1, 0x0
    const v2, 0xff152036
    aput v2, v0, v1
    const/4 v1, 0x1
    const v2, 0xff06080e
    aput v2, v0, v1
    new-instance v1, Landroid/graphics/drawable/GradientDrawable;
    sget-object v2, Landroid/graphics/drawable/GradientDrawable$Orientation;->TOP_BOTTOM:Landroid/graphics/drawable/GradientDrawable$Orientation;
    invoke-direct {v1, v2, v0}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V
    return-object v1
.end method

# { {checked}, {} } state sets for the tint lists below
.method private static states()[[I
    .locals 4
    const/4 v0, 0x2
    new-array v0, v0, [[I
    const/4 v1, 0x1
    new-array v2, v1, [I
    const/4 v3, 0x0
    const v1, 0x10100a0
    aput v1, v2, v3
    aput-object v2, v0, v3
    const/4 v1, 0x0
    new-array v2, v1, [I
    const/4 v3, 0x1
    aput-object v2, v0, v3
    return-object v0
.end method

# colour when checked, colour otherwise
.method private static csl(II)Landroid/content/res/ColorStateList;
    .locals 3
    invoke-static {}, Luz/carhelper/passenger/Ui;->states()[[I
    move-result-object v0
    const/4 v1, 0x2
    new-array v1, v1, [I
    const/4 v2, 0x0
    aput p0, v1, v2
    const/4 v2, 0x1
    aput p1, v1, v2
    new-instance v2, Landroid/content/res/ColorStateList;
    invoke-direct {v2, v0, v1}, Landroid/content/res/ColorStateList;-><init>([[I[I)V
    return-object v2
.end method

# switch: white thumb + accent track when on, grey when off
.method public static tintSwitch(Landroid/widget/Switch;)V
    .locals 2
    const/4 v0, -0x1
    const v1, 0xffb9c0cc
    invoke-static {v0, v1}, Luz/carhelper/passenger/Ui;->csl(II)Landroid/content/res/ColorStateList;
    move-result-object v0
    invoke-virtual {p0, v0}, Landroid/widget/Switch;->setThumbTintList(Landroid/content/res/ColorStateList;)V
    sget v0, Luz/carhelper/passenger/Ui;->ACCENT:I
    const v1, 0x66ffffff
    invoke-static {v0, v1}, Luz/carhelper/passenger/Ui;->csl(II)Landroid/content/res/ColorStateList;
    move-result-object v0
    invoke-virtual {p0, v0}, Landroid/widget/Switch;->setTrackTintList(Landroid/content/res/ColorStateList;)V
    return-void
.end method

# checkbox: accent when ticked, soft white otherwise
.method public static tintBox(Landroid/widget/CompoundButton;)V
    .locals 2
    sget v0, Luz/carhelper/passenger/Ui;->ACCENT:I
    const v1, 0x99ffffff
    invoke-static {v0, v1}, Luz/carhelper/passenger/Ui;->csl(II)Landroid/content/res/ColorStateList;
    move-result-object v0
    invoke-virtual {p0, v0}, Landroid/widget/CompoundButton;->setButtonTintList(Landroid/content/res/ColorStateList;)V
    return-void
.end method

.class public Luz/carhelper/passenger/SettingsActivity;
.super Landroid/app/Activity;
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;
.implements Landroid/view/View$OnClickListener;
.implements Landroid/content/DialogInterface$OnClickListener;

# LP Companion settings (prefs "apps"). Changes are kept in memory and only written on Save;
# Cancel / Back leaves without saving.
#   Status:           overlay / notification access / WRITE_SECURE_SETTINGS / Back service, green or red
#                     with the ADB fix; opening the page also tries to switch Back on (BackRepair)
#   Steering wheel:   [switch] wheel      - wheel buttons control sideloaded players (default on)
#   Closing apps:     [switch] autoClose  - close the previous app when another one is opened
#                     [switch] closeMusic - also close music apps (enabled only while autoClose is on)
#   Apps shown on the passenger screen: [checkbox per sideloaded app], unticked -> "hidden" set
#                     [Kids checkbox per app] -> "kidApps" set
#   Kid mode:         [switch] kid - grid shows only "kidApps", Close apps and Swap are off
#                     [PIN field] pin - 4+ digits, asked before this page opens while kid mode is on

.field private musicSwitch:Landroid/widget/Switch;
.field private kid:Z
.field private kidApps:Ljava/util/HashSet;
.field private pinEdit:Landroid/widget/EditText;
.field private gateEdit:Landroid/widget/EditText;
.field private storedPin:Ljava/lang/String;
.field private wheel:Z
.field private autoClose:Z
.field private closeMusic:Z
.field private overheat:Z
.field private autoOpen:Z
.field private resumeLast:Z
.field private healAdb:Z
.field private passToMain:Z
.field private passFromMain:Z
.field private bubbleAuto:Z
.field private bubbleSecs:I
.field private secsPill:Landroid/view/View;
.field private hidden:Ljava/util/HashSet;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    return-void
.end method

.method private prefs()Landroid/content/SharedPreferences;
    .locals 2
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    return-object v0
.end method

# small-caps section title in the accent colour
.method private section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    .locals 5
    const/high16 v0, 0x41700000
    sget v1, Luz/carhelper/passenger/Ui;->ACCENT:I
    const/4 v2, 0x1
    invoke-static {p0, p2, v0, v1, v2}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v0
    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setAllCaps(Z)V
    const v1, 0x3df5c28f
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setLetterSpacing(F)V
    const/16 v1, 0x8
    const/16 v3, 0x2c
    const/16 v4, 0xe
    invoke-virtual {v0, v1, v3, v1, v4}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-void
.end method

# rounded glass card; rows are added to the returned container
.method private card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    .locals 4
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V
    sget v1, Luz/carhelper/passenger/Ui;->CARD:I
    sget v2, Luz/carhelper/passenger/Ui;->STROKE:I
    const/high16 v3, 0x41e00000
    invoke-static {v1, v2, v3}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    const/4 v1, 0x6
    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-object v0
.end method

# hairline between two rows of a card
.method private divider(Landroid/widget/LinearLayout;)V
    .locals 4
    new-instance v0, Landroid/view/View;
    invoke-direct {v0, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    const v1, 0x1affffff
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v2, -0x1
    const/4 v3, 0x2
    invoke-direct {v1, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v2, 0x1c
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-void
.end method

# switch row tagged with pref key p3, extra left padding p4; caller sets the checked state
.method private addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    .locals 4
    new-instance v0, Landroid/widget/Switch;
    invoke-direct {v0, p0}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p2}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V
    const/high16 v1, 0x41d00000
    invoke-virtual {v0, v1}, Landroid/widget/Switch;->setTextSize(F)V
    const/4 v1, -0x1
    invoke-virtual {v0, v1}, Landroid/widget/Switch;->setTextColor(I)V
    const/16 v1, 0x1c
    add-int/2addr v1, p4
    const/16 v2, 0x1a
    const/16 v3, 0x1c
    invoke-virtual {v0, v1, v2, v3, v2}, Landroid/widget/Switch;->setPadding(IIII)V
    invoke-static {v0}, Luz/carhelper/passenger/Ui;->tintSwitch(Landroid/widget/Switch;)V
    invoke-virtual {v0, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-object v0
.end method

# status row: coloured dot, label, OK / OFF chip; the ADB fix p4 sits underneath when it is off
.method private healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V
    .locals 9
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v2, 0x1c
    const/16 v3, 0x16
    invoke-virtual {v0, v2, v3, v2, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    # v2 = status colour, v3 = chip text
    sget v2, Luz/carhelper/passenger/Ui;->OK:I
    const-string v3, "status OK"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    if-nez p3, :colour_done
    sget v2, Luz/carhelper/passenger/Ui;->BAD:I
    const-string v3, "OFF"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    :colour_done

    # dot
    const-string v4, "●"
    const/high16 v5, 0x41a00000
    const/4 v6, 0x0
    invoke-static {p0, v4, v5, v2, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v4
    const/16 v5, 0x14
    invoke-virtual {v4, v6, v6, v5, v6}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # label, takes the free width
    const/high16 v5, 0x41d00000
    const/4 v4, -0x1
    invoke-static {p0, p2, v5, v4, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v4
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v7, -0x2
    const/high16 v8, 0x3f800000
    invoke-direct {v5, v6, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v1, v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # chip tinted with the status colour
    const/high16 v5, 0x41900000
    const/4 v7, 0x1
    invoke-static {p0, v3, v5, v2, v7}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v4
    const/16 v5, 0x16
    const/16 v7, 0x8
    invoke-virtual {v4, v5, v7, v5, v7}, Landroid/widget/TextView;->setPadding(IIII)V
    const v5, 0xffffff
    and-int/2addr v5, v2
    const v7, 0x2e000000
    or-int/2addr v5, v7
    const/high16 v8, 0x41a00000
    invoke-static {v5, v6, v8}, Luz/carhelper/passenger/Ui;->rect(IIF)Landroid/graphics/drawable/GradientDrawable;
    move-result-object v5
    invoke-virtual {v4, v5}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # how to fix it
    if-nez p3, :done
    const/high16 v5, 0x41880000
    sget v7, Luz/carhelper/passenger/Ui;->TEXT3:I
    invoke-static {p0, p4, v5, v7, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v4
    const/4 v5, 0x1
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setTextIsSelectable(Z)V
    sget-object v5, Landroid/graphics/Typeface;->MONOSPACE:Landroid/graphics/Typeface;
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V
    const/16 v5, 0x28
    const/16 v7, 0xc
    invoke-virtual {v4, v5, v7, v6, v6}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v0, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    :done
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-void
.end method

# tappable row with a chevron (Re-check, Vehicle settings, Back to car UI)
.method private navRow(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v1, 0x10
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v1, 0x1c
    const/16 v2, 0x1a
    invoke-virtual {v0, v1, v2, v1, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const/4 v1, 0x0
    const v2, 0x22ffffff
    const/high16 v3, 0x41b00000
    invoke-static {v1, v2, v1, v3}, Luz/carhelper/passenger/Ui;->btn(IIIF)Landroid/graphics/drawable/StateListDrawable;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    const/high16 v1, 0x41d00000
    const/4 v2, -0x1
    const/4 v3, 0x0
    invoke-static {p0, p2, v1, v2, v3}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v1
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x2
    const/high16 v6, 0x3f800000
    invoke-direct {v2, v3, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v0, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    const-string v1, "›"
    const/high16 v2, 0x42080000
    sget v4, Luz/carhelper/passenger/Ui;->TEXT3:I
    invoke-static {p0, v1, v2, v4, v3}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-virtual {v0, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-void
.end method

# rounded pill button (Save / Cancel / Set password); p4 = fill, the accent gets a solid look
.method private addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    .locals 4
    const v0, 0x44ffffff
    sget v1, Luz/carhelper/passenger/Ui;->STROKE:I
    sget v2, Luz/carhelper/passenger/Ui;->ACCENT:I
    if-ne p4, v2, :styled
    sget v0, Luz/carhelper/passenger/Ui;->ACCENT_PRESSED:I
    const/4 v1, 0x0
    :styled
    invoke-static {p0, p2, p4, v0, v1}, Luz/carhelper/passenger/Ui;->pill(Landroid/content/Context;Ljava/lang/CharSequence;III)Landroid/widget/TextView;
    move-result-object v0
    invoke-virtual {v0, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v2, -0x2
    invoke-direct {v1, v2, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v2, 0x10
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-object v0
.end method

# the next menu timer value: 3 -> 5 -> 8 -> 10 -> 15 -> 20 -> 30 -> 60 -> 3
.method private static nextSecs(I)I
    .locals 1
    const/4 v0, 0x5
    if-lt p0, v0, :r5
    const/16 v0, 0x8
    if-lt p0, v0, :r8
    const/16 v0, 0xa
    if-lt p0, v0, :r10
    const/16 v0, 0xf
    if-lt p0, v0, :r15
    const/16 v0, 0x14
    if-lt p0, v0, :r20
    const/16 v0, 0x1e
    if-lt p0, v0, :r30
    const/16 v0, 0x3c
    if-lt p0, v0, :r60
    const/4 v0, 0x3
    return v0
    :r5
    const/4 v0, 0x5
    return v0
    :r8
    const/16 v0, 0x8
    return v0
    :r10
    const/16 v0, 0xa
    return v0
    :r15
    const/16 v0, 0xf
    return v0
    :r20
    const/16 v0, 0x14
    return v0
    :r30
    const/16 v0, 0x1e
    return v0
    :r60
    const/16 v0, 0x3c
    return v0
.end method

# "8 s"
.method private static secsText(I)Ljava/lang/String;
    .locals 2
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v1, " s"
    invoke-static {v1}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

# one app: icon, "shown on the grid" checkbox with the name, and a "Kids" checkbox
.method private appRow(Landroid/widget/LinearLayout;Landroid/content/pm/ResolveInfo;Landroid/content/pm/PackageManager;)V
    .locals 8
    iget-object v0, p2, Landroid/content/pm/ResolveInfo;->activityInfo:Landroid/content/pm/ActivityInfo;
    iget-object v0, v0, Landroid/content/pm/ActivityInfo;->packageName:Ljava/lang/String;

    # hairline before every row but the first
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v1
    if-eqz v1, :first
    invoke-direct {p0, p1}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    :first

    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v2, 0x18
    const/16 v3, 0x10
    invoke-virtual {v1, v2, v3, v2, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # icon
    new-instance v2, Landroid/widget/ImageView;
    invoke-direct {v2, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-virtual {p2, p3}, Landroid/content/pm/ResolveInfo;->loadIcon(Landroid/content/pm/PackageManager;)Landroid/graphics/drawable/Drawable;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v4, 0x40
    invoke-direct {v3, v4, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # shown checkbox + name (unticked = hidden from the grid)
    new-instance v2, Landroid/widget/CheckBox;
    invoke-direct {v2, p0}, Landroid/widget/CheckBox;-><init>(Landroid/content/Context;)V
    invoke-virtual {p2, p3}, Landroid/content/pm/ResolveInfo;->loadLabel(Landroid/content/pm/PackageManager;)Ljava/lang/CharSequence;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/CheckBox;->setText(Ljava/lang/CharSequence;)V
    const/high16 v3, 0x41d00000
    invoke-virtual {v2, v3}, Landroid/widget/CheckBox;->setTextSize(F)V
    const/4 v3, -0x1
    invoke-virtual {v2, v3}, Landroid/widget/CheckBox;->setTextColor(I)V
    const/16 v3, 0x14
    const/4 v4, 0x0
    invoke-virtual {v2, v3, v4, v4, v4}, Landroid/widget/CheckBox;->setPadding(IIII)V
    iget-object v3, p0, Luz/carhelper/passenger/SettingsActivity;->hidden:Ljava/util/HashSet;
    invoke-virtual {v3, v0}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z
    move-result v3
    xor-int/lit8 v3, v3, 0x1
    invoke-virtual {v2, v3}, Landroid/widget/CheckBox;->setChecked(Z)V
    invoke-static {v2}, Luz/carhelper/passenger/Ui;->tintBox(Landroid/widget/CompoundButton;)V
    invoke-virtual {v2, v0}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v2, p0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x2
    const/high16 v6, 0x3f800000
    invoke-direct {v3, v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # "Kids" checkbox, tag "kid:<package>"
    new-instance v2, Landroid/widget/CheckBox;
    invoke-direct {v2, p0}, Landroid/widget/CheckBox;-><init>(Landroid/content/Context;)V
    const-string v3, "Kids"
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/CheckBox;->setText(Ljava/lang/CharSequence;)V
    const/high16 v3, 0x41b00000
    invoke-virtual {v2, v3}, Landroid/widget/CheckBox;->setTextSize(F)V
    sget v3, Luz/carhelper/passenger/Ui;->TEXT2:I
    invoke-virtual {v2, v3}, Landroid/widget/CheckBox;->setTextColor(I)V
    iget-object v3, p0, Luz/carhelper/passenger/SettingsActivity;->kidApps:Ljava/util/HashSet;
    invoke-virtual {v3, v0}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z
    move-result v3
    invoke-virtual {v2, v3}, Landroid/widget/CheckBox;->setChecked(Z)V
    invoke-static {v2}, Luz/carhelper/passenger/Ui;->tintBox(Landroid/widget/CompoundButton;)V
    new-instance v3, Ljava/lang/StringBuilder;
    const-string v4, "kid:"
    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v2, p0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 14
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
    invoke-static {p0}, Luz/carhelper/passenger/Lang;->init(Landroid/content/Context;)V

    # load current settings into memory
    invoke-direct {p0}, Luz/carhelper/passenger/SettingsActivity;->prefs()Landroid/content/SharedPreferences;
    move-result-object v5
    const-string v2, "wheel"
    const/4 v3, 0x1
    invoke-interface {v5, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->wheel:Z
    const-string v2, "autoClose"
    const/4 v3, 0x0
    invoke-interface {v5, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->autoClose:Z
    const-string v2, "closeMusic"
    invoke-interface {v5, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->closeMusic:Z
    const-string v2, "overheat"
    invoke-interface {v5, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->overheat:Z
    const-string v2, "autoOpen"
    const/4 v4, 0x1
    invoke-interface {v5, v2, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->autoOpen:Z
    # go back to the app that was in front when the passenger screen turns on again: on by default (v4 = true here)
    const-string v2, "resumeLast"
    invoke-interface {v5, v2, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->resumeLast:Z
    # fix missing permissions through the car's own adb: on by default (v4 = true here)
    const-string v2, "healAdb"
    invoke-interface {v5, v2, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->healAdb:Z
    # passenger move buttons: "<-" push to main defaults on, "->" bring over defaults off (v4 = true, v3 = false here)
    const-string v2, "passToMain"
    invoke-interface {v5, v2, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->passToMain:Z
    const-string v2, "passFromMain"
    invoke-interface {v5, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->passFromMain:Z
    # bubble menu auto-close: on by default, 8 s (v4 = true here)
    const-string v2, "bubbleAuto"
    invoke-interface {v5, v2, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->bubbleAuto:Z
    const-string v2, "bubbleSecs"
    const/16 v4, 0x8
    invoke-interface {v5, v2, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2
    iput v2, p0, Luz/carhelper/passenger/SettingsActivity;->bubbleSecs:I
    const-string v2, "kid"
    invoke-interface {v5, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->kid:Z
    const-string v2, "pin"
    const-string v4, ""
    invoke-interface {v5, v2, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    iput-object v2, p0, Luz/carhelper/passenger/SettingsActivity;->storedPin:Ljava/lang/String;
    new-instance v2, Ljava/util/HashSet;
    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V
    const-string v4, "kidApps"
    invoke-interface {v5, v4, v2}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v2
    new-instance v4, Ljava/util/HashSet;
    invoke-direct {v4, v2}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V
    iput-object v4, p0, Luz/carhelper/passenger/SettingsActivity;->kidApps:Ljava/util/HashSet;
    new-instance v2, Ljava/util/HashSet;
    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V
    const-string v3, "hidden"
    invoke-interface {v5, v3, v2}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v2
    new-instance v5, Ljava/util/HashSet;
    invoke-direct {v5, v2}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V
    iput-object v5, p0, Luz/carhelper/passenger/SettingsActivity;->hidden:Ljava/util/HashSet;

    # v0 = ScrollView on a navy gradient, v1 = page (centred, max 1200 px wide)
    new-instance v0, Landroid/widget/ScrollView;
    invoke-direct {v0, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V
    invoke-static {}, Luz/carhelper/passenger/Ui;->pageBg()Landroid/graphics/drawable/GradientDrawable;
    move-result-object v2
    invoke-virtual {v0, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    const/4 v2, 0x0
    invoke-virtual {v0, v2}, Landroid/view/View;->setVerticalScrollBarEnabled(Z)V
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v2, 0x30
    const/16 v3, 0x28
    const/16 v4, 0x48
    invoke-virtual {v1, v2, v3, v2, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;
    const/16 v3, 0x4b0
    const/4 v4, -0x2
    invoke-direct {v2, v3, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V
    const/4 v3, 0x1
    iput v3, v2, Landroid/widget/FrameLayout$LayoutParams;->gravity:I
    invoke-virtual {v0, v1, v2}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # header: title block + Cancel + Save
    new-instance v4, Landroid/widget/LinearLayout;
    invoke-direct {v4, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v4, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    new-instance v5, Landroid/widget/LinearLayout;
    invoke-direct {v5, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v5, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const-string v2, "Settings"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x42200000
    const/4 v6, -0x1
    const/4 v7, 0x1
    invoke-static {p0, v2, v3, v6, v7}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    invoke-virtual {v5, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    const-string v2, "LP Companion"
    const/high16 v3, 0x41900000
    sget v6, Luz/carhelper/passenger/Ui;->TEXT3:I
    const/4 v7, 0x0
    invoke-static {p0, v2, v3, v6, v7}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    invoke-virtual {v5, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v3, 0x0
    const/4 v6, -0x2
    const/high16 v7, 0x3f800000
    invoke-direct {v2, v3, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v4, v5, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    const-string v2, "Cancel"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#cancel"
    const v6, 0x2effffff
    invoke-direct {p0, v4, v2, v3, v6}, Luz/carhelper/passenger/SettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    const-string v2, "Save"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#save"
    sget v6, Luz/carhelper/passenger/Ui;->ACCENT:I
    invoke-direct {p0, v4, v2, v3, v6}, Luz/carhelper/passenger/SettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Language: the row shows the language in use, a tap opens the picker (Uzbek, Russian, Spanish, English, Chinese)
    const-string v2, "Language"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/SettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    new-instance v5, Landroid/widget/LinearLayout;
    invoke-direct {v5, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v5, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v2, 0x1c
    const/16 v3, 0x12
    const/16 v4, 0x14
    invoke-virtual {v5, v2, v3, v4, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const-string v2, "Language"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x41d00000
    const/4 v4, -0x1
    const/4 v6, 0x0
    invoke-static {p0, v2, v3, v4, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v4, -0x2
    const/high16 v7, 0x3f800000
    invoke-direct {v3, v6, v4, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v5, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    invoke-static {}, Luz/carhelper/passenger/Lang;->code()Ljava/lang/String;
    move-result-object v2
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->label(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#lang"
    const v4, 0x2effffff
    invoke-direct {p0, v5, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    invoke-virtual {v8, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Status: one row per grant, green = on, red = off + the ADB command that fixes it.
    # Re-evaluated every time Settings opens; "Re-check" reopens it to refresh now.
    const-string v2, "Status"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/SettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z
    move-result v6
    const-string v2, "Bubble (overlay)"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v4, "adb shell appops set --user 10 uz.carhelper.passenger SYSTEM_ALERT_WINDOW allow"
    invoke-direct {p0, v8, v2, v6, v4}, Luz/carhelper/passenger/SettingsActivity;->healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V

    const-string v2, "notification"
    invoke-virtual {p0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Landroid/app/NotificationManager;
    new-instance v3, Landroid/content/ComponentName;
    const-class v4, Luz/carhelper/passenger/WheelListener;
    invoke-direct {v3, p0, v4}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {v2, v3}, Landroid/app/NotificationManager;->isNotificationListenerAccessGranted(Landroid/content/ComponentName;)Z
    move-result v6
    const-string v2, "Now playing (notification access)"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v4, "adb shell cmd notification allow_listener uz.carhelper.passenger/uz.carhelper.passenger.WheelListener 10"
    invoke-direct {p0, v8, v2, v6, v4}, Luz/carhelper/passenger/SettingsActivity;->healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V

    const-string v2, "android.permission.WRITE_SECURE_SETTINGS"
    invoke-virtual {p0, v2}, Landroid/content/Context;->checkSelfPermission(Ljava/lang/String;)I
    move-result v3
    const/4 v6, 0x0
    if-nez v3, :wss_row
    const/4 v6, 0x1
    :wss_row
    const-string v2, "Self-repair after restart"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v4, "adb shell pm grant --user 10 uz.carhelper.passenger android.permission.WRITE_SECURE_SETTINGS"
    invoke-direct {p0, v8, v2, v6, v4}, Luz/carhelper/passenger/SettingsActivity;->healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V

    # Back: if it's off, try to switch it on right now
    sget-object v3, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    const/4 v6, 0x1
    const-string v4, ""
    if-nez v3, :back_row
    const/4 v6, 0x0
    const-string v4, "Needs the self-repair permission above"
    invoke-static {v4}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    invoke-static {p0}, Luz/carhelper/passenger/BackRepair;->ensure(Landroid/content/Context;)Z
    move-result v3
    if-eqz v3, :back_row
    const-string v4, "Switching on now — reopen this page in a few seconds"
    invoke-static {v4}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    :back_row
    const-string v2, "Back button (accessibility)"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v8, v2, v6, v4}, Luz/carhelper/passenger/SettingsActivity;->healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V
    # Fix missing permissions through the car's own adb (see Heal)
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "Fix missing permissions automatically using the car's own ADB"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "healAdb"
    const/4 v4, 0x0
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->healAdb:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    const-string v2, "The first time, the car may ask to allow USB debugging for this app: choose Always allow. Wi-Fi ADB has to be on; the app switches it on itself when it can."
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x41900000
    sget v4, Luz/carhelper/passenger/Ui;->TEXT3:I
    const/4 v6, 0x0
    invoke-static {p0, v2, v3, v4, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    const/16 v3, 0x1c
    const/4 v4, 0x0
    const/16 v6, 0x12
    invoke-virtual {v2, v3, v4, v3, v6}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v8, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "No attempt yet"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    :try_start_ds
    invoke-static {p0}, Luz/carhelper/passenger/Heal;->describe(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v2
    :try_end_ds
    .catch Ljava/lang/Throwable; {:try_start_ds .. :try_end_ds} :catch_ds
    :catch_ds
    const-string v3, "Last attempt: "
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v3, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x41900000
    sget v4, Luz/carhelper/passenger/Ui;->TEXT2:I
    const/4 v6, 0x0
    invoke-static {p0, v2, v3, v4, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    const/16 v3, 0x1c
    const/16 v4, 0x16
    invoke-virtual {v2, v3, v4, v3, v4}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v8, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # the two buttons at the bottom of the Status card, side by side
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    new-instance v5, Landroid/widget/LinearLayout;
    invoke-direct {v5, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v5, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v2, 0xc
    const/16 v3, 0x12
    const/16 v4, 0x14
    invoke-virtual {v5, v2, v3, v4, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const-string v2, "Re-check status"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#recheck"
    const v4, 0x2effffff
    invoke-direct {p0, v5, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    const-string v2, "Fix permissions now"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#heal"
    const v4, 0x2effffff
    invoke-direct {p0, v5, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    invoke-virtual {v8, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Vehicle: the car's own settings, back to the car UI, install apps from storage, uninstall what was installed from here
    const-string v2, "Vehicle"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/SettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    const-string v2, "Vehicle settings"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#vehset"
    invoke-direct {p0, v8, v2, v3}, Luz/carhelper/passenger/SettingsActivity;->navRow(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "Back to car UI"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#gotocar"
    invoke-direct {p0, v8, v2, v3}, Luz/carhelper/passenger/SettingsActivity;->navRow(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "Install apps from storage"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#files"
    invoke-direct {p0, v8, v2, v3}, Luz/carhelper/passenger/SettingsActivity;->navRow(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "Uninstall apps"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#uninstall"
    invoke-direct {p0, v8, v2, v3}, Luz/carhelper/passenger/SettingsActivity;->navRow(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V

    # Passenger screen
    const-string v2, "Passenger screen"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/SettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    const-string v2, "Open LP Companion automatically when the passenger screen turns on"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "autoOpen"
    const/4 v4, 0x0
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->autoOpen:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "When it turns on, go back to the app that was open (instead of the grid)"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "resumeLast"
    const/4 v4, 0x0
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->resumeLast:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "Passenger bubble: push its app to the main screen  ←"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "passToMain"
    const/4 v4, 0x0
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->passToMain:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "Passenger bubble: bring the main screen's app over  →"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "passFromMain"
    const/4 v4, 0x0
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->passFromMain:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    # Bubble menu: closes itself after a few seconds (both bubbles); the button steps through 3 / 5 / 8 / 10 / 15 / 20 / 30 / 60 s
    const-string v2, "Bubble menu"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/SettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    const-string v2, "Close the bubble menu automatically"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "bubbleAuto"
    const/4 v4, 0x0
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->bubbleAuto:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    new-instance v5, Landroid/widget/LinearLayout;
    invoke-direct {v5, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v5, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v2, 0x1c
    const/16 v3, 0x12
    const/16 v4, 0x14
    invoke-virtual {v5, v2, v3, v4, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const-string v2, "Close it after"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x41d00000
    const/4 v4, -0x1
    const/4 v6, 0x0
    invoke-static {p0, v2, v3, v4, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v4, -0x2
    const/high16 v7, 0x3f800000
    invoke-direct {v3, v6, v4, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v5, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    iget v2, p0, Luz/carhelper/passenger/SettingsActivity;->bubbleSecs:I
    invoke-static {v2}, Luz/carhelper/passenger/SettingsActivity;->secsText(I)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#bubbleSecs"
    const v4, 0x2effffff
    invoke-direct {p0, v5, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    move-result-object v6
    iput-object v6, p0, Luz/carhelper/passenger/SettingsActivity;->secsPill:Landroid/view/View;
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->bubbleAuto:Z
    if-nez v2, :pill_on
    const v2, 0x3eb33333
    invoke-virtual {v6, v2}, Landroid/view/View;->setAlpha(F)V
    :pill_on
    invoke-virtual {v8, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Closing apps
    const-string v2, "Closing apps"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/SettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    const-string v2, "Close the previous app when another one is opened"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "autoClose"
    const/4 v4, 0x0
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->autoClose:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "Also close music apps"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "closeMusic"
    const/16 v4, 0x28
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v6
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->closeMusic:Z
    invoke-virtual {v6, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v6, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    iput-object v6, p0, Luz/carhelper/passenger/SettingsActivity;->musicSwitch:Landroid/widget/Switch;
    iget-boolean v4, p0, Luz/carhelper/passenger/SettingsActivity;->autoClose:Z
    invoke-virtual {v6, v4}, Landroid/view/View;->setEnabled(Z)V

    # Protection
    const-string v2, "Protection"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/SettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    const-string v2, "Overload protection: close passenger apps if CPU or RAM is overloaded"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "overheat"
    const/4 v4, 0x0
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->overheat:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    # what the protection sees right now (the same numbers as the chip in the grid header)
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "not available"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    :try_start_hd
    invoke-static {p0}, Luz/carhelper/passenger/Health;->detail(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v2
    :try_end_hd
    .catch Ljava/lang/Throwable; {:try_start_hd .. :try_end_hd} :catch_hd
    :catch_hd
    const-string v3, "Right now:   "
    invoke-static {v3}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v3, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x41b00000
    sget v4, Luz/carhelper/passenger/Ui;->TEXT2:I
    const/4 v6, 0x0
    invoke-static {p0, v2, v3, v4, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    const/16 v3, 0x1c
    const/16 v4, 0x16
    invoke-virtual {v2, v3, v4, v3, v4}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v8, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Child mode: entering/leaving is done from the grid; here you only set the PIN
    const-string v2, "Child mode"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/SettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    new-instance v5, Landroid/widget/LinearLayout;
    invoke-direct {v5, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v5, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v2, 0x1c
    const/16 v3, 0x12
    const/16 v4, 0x14
    invoke-virtual {v5, v2, v3, v4, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const-string v2, "Password to leave child mode"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x41d00000
    const/4 v4, -0x1
    const/4 v6, 0x0
    invoke-static {p0, v2, v3, v4, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v4, -0x2
    const/high16 v7, 0x3f800000
    invoke-direct {v3, v6, v4, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v5, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    const-string v2, "Set password"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#setpin"
    sget v4, Luz/carhelper/passenger/Ui;->ACCENT:I
    invoke-direct {p0, v5, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    invoke-virtual {v8, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Backup and recovery: info only (all of it works through Settings.Secure, see Backup)
    const-string v2, "Backup and recovery"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/SettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    const-string v2, "Your settings are backed up automatically and come back after a reset or a reinstall. The password and child mode are not included. Needs the self-repair permission in Status."
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x41b00000
    sget v4, Luz/carhelper/passenger/Ui;->TEXT2:I
    const/4 v6, 0x0
    invoke-static {p0, v2, v3, v4, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    const/16 v3, 0x1c
    const/16 v4, 0x16
    invoke-virtual {v2, v3, v4, v3, v4}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v8, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/SettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "Forgot the password? On the PC run:  adb shell settings put secure lp_companion_pin_reset 1  then open LP Companion. The password is cleared and child mode is switched off; everything else stays."
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x41b00000
    sget v4, Luz/carhelper/passenger/Ui;->TEXT2:I
    const/4 v6, 0x0
    invoke-static {p0, v2, v3, v4, v6}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    const/16 v3, 0x1c
    const/16 v4, 0x16
    invoke-virtual {v2, v3, v4, v3, v4}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v8, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Apps shown on the passenger screen
    const-string v2, "Apps shown on the passenger screen"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    const-string v2, "Untick an app to hide it from the grid. Tick Kids to allow it in child mode."
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x41900000
    sget v4, Luz/carhelper/passenger/Ui;->TEXT3:I
    const/4 v5, 0x0
    invoke-static {p0, v2, v3, v4, v5}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    const/16 v3, 0x8
    const/16 v4, 0x10
    invoke-virtual {v2, v3, v5, v3, v4}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/SettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v4

    # v6 = PackageManager, v7 = sorted launchable activities, v8 = iterator
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v6
    new-instance v2, Landroid/content/Intent;
    const-string v3, "android.intent.action.MAIN"
    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v3, "android.intent.category.LAUNCHER"
    invoke-virtual {v2, v3}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    const/4 v3, 0x0
    invoke-virtual {v6, v2, v3}, Landroid/content/pm/PackageManager;->queryIntentActivities(Landroid/content/Intent;I)Ljava/util/List;
    move-result-object v7
    new-instance v2, Landroid/content/pm/ResolveInfo$DisplayNameComparator;
    invoke-direct {v2, v6}, Landroid/content/pm/ResolveInfo$DisplayNameComparator;-><init>(Landroid/content/pm/PackageManager;)V
    invoke-static {v7, v2}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V
    invoke-interface {v7}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v8

    :loop
    invoke-interface {v8}, Ljava/util/Iterator;->hasNext()Z
    move-result v9
    if-eqz v9, :end
    invoke-interface {v8}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v9
    check-cast v9, Landroid/content/pm/ResolveInfo;
    iget-object v10, v9, Landroid/content/pm/ResolveInfo;->activityInfo:Landroid/content/pm/ActivityInfo;
    iget-object v11, v10, Landroid/content/pm/ActivityInfo;->applicationInfo:Landroid/content/pm/ApplicationInfo;
    iget v11, v11, Landroid/content/pm/ApplicationInfo;->flags:I
    and-int/lit8 v11, v11, 0x1
    if-nez v11, :loop
    iget-object v10, v10, Landroid/content/pm/ActivityInfo;->packageName:Ljava/lang/String;
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v11
    invoke-virtual {v11, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v11
    if-nez v11, :loop
    invoke-direct {p0, v4, v9, v6}, Luz/carhelper/passenger/SettingsActivity;->appRow(Landroid/widget/LinearLayout;Landroid/content/pm/ResolveInfo;Landroid/content/pm/PackageManager;)V
    goto :loop

    :end
    invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V
    # grey out Install / Uninstall while the car's adb cannot be reached (checked in the background)
    :try_start_gate
    invoke-static {p0, v0}, Luz/carhelper/passenger/apk/AdbGate;->apply(Landroid/app/Activity;Landroid/view/View;)V
    :try_end_gate
    .catch Ljava/lang/Throwable; {:try_start_gate .. :try_end_gate} :catch_gate
    :catch_gate
    return-void
.end method


# PIN dialog: Unlock with the right PIN keeps the page open; anything else leaves
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 3
    const/4 v0, -0x1
    if-ne p2, v0, :leave
    iget-object v0, p0, Luz/carhelper/passenger/SettingsActivity;->gateEdit:Landroid/widget/EditText;
    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;
    move-result-object v0
    iget-object v1, p0, Luz/carhelper/passenger/SettingsActivity;->storedPin:Ljava/lang/String;
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :wrong
    return-void
    :wrong
    const-string v1, "Wrong PIN"
    invoke-static {v1}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    const/4 v2, 0x0
    invoke-static {p0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    :leave
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
.end method

# switches and checkboxes only change the in-memory copy
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 2
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;

    const-string v1, "wheel"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_wheel
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->wheel:Z
    return-void
    :not_wheel

    const-string v1, "autoClose"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_auto
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->autoClose:Z
    iget-object v1, p0, Luz/carhelper/passenger/SettingsActivity;->musicSwitch:Landroid/widget/Switch;
    if-eqz v1, :done
    invoke-virtual {v1, p2}, Landroid/view/View;->setEnabled(Z)V
    :done
    return-void
    :not_auto

    const-string v1, "overheat"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_overheat
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->overheat:Z
    return-void
    :not_overheat

    const-string v1, "autoOpen"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_autoopen
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->autoOpen:Z
    return-void
    :not_autoopen

    const-string v1, "resumeLast"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_resume
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->resumeLast:Z
    return-void
    :not_resume

    const-string v1, "healAdb"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_heal
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->healAdb:Z
    return-void
    :not_heal

    const-string v1, "bubbleAuto"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_bubble_auto
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->bubbleAuto:Z
    iget-object v1, p0, Luz/carhelper/passenger/SettingsActivity;->secsPill:Landroid/view/View;
    if-eqz v1, :ba_done
    const/high16 v0, 0x3f800000
    if-nez p2, :ba_alpha
    const v0, 0x3eb33333
    :ba_alpha
    invoke-virtual {v1, v0}, Landroid/view/View;->setAlpha(F)V
    :ba_done
    return-void
    :not_bubble_auto

    const-string v1, "passToMain"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_pass_to_main
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->passToMain:Z
    return-void
    :not_pass_to_main

    const-string v1, "passFromMain"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_pass_from_main
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->passFromMain:Z
    return-void
    :not_pass_from_main

    const-string v1, "closeMusic"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_music
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->closeMusic:Z
    return-void
    :not_music

    const-string v1, "kid"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_kid
    iput-boolean p2, p0, Luz/carhelper/passenger/SettingsActivity;->kid:Z
    return-void
    :not_kid

    # "Kids" checkbox: ticked = shown in kid mode
    const-string v1, "kid:"
    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :app_box
    const/4 v1, 0x4
    invoke-virtual {v0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v0
    iget-object v1, p0, Luz/carhelper/passenger/SettingsActivity;->kidApps:Ljava/util/HashSet;
    if-eqz p2, :kid_off
    invoke-virtual {v1, v0}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    return-void
    :kid_off
    invoke-virtual {v1, v0}, Ljava/util/HashSet;->remove(Ljava/lang/Object;)Z
    return-void

    # app checkbox: unticked = hidden from the passenger grid
    :app_box
    iget-object v1, p0, Luz/carhelper/passenger/SettingsActivity;->hidden:Ljava/util/HashSet;
    if-eqz p2, :hide
    invoke-virtual {v1, v0}, Ljava/util/HashSet;->remove(Ljava/lang/Object;)Z
    return-void
    :hide
    invoke-virtual {v1, v0}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    return-void
.end method

# write every setting that is held in memory, then refresh the Settings.Secure backup
.method private saveAll()V
    .locals 4
    invoke-direct {p0}, Luz/carhelper/passenger/SettingsActivity;->prefs()Landroid/content/SharedPreferences;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const-string v2, "wheel"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->wheel:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "autoClose"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->autoClose:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "closeMusic"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->closeMusic:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "overheat"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->overheat:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "autoOpen"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->autoOpen:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "resumeLast"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->resumeLast:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "healAdb"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->healAdb:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "passToMain"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->passToMain:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "passFromMain"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->passFromMain:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "bubbleAuto"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->bubbleAuto:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "bubbleSecs"
    iget v3, p0, Luz/carhelper/passenger/SettingsActivity;->bubbleSecs:I
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    const-string v2, "hidden"
    iget-object v3, p0, Luz/carhelper/passenger/SettingsActivity;->hidden:Ljava/util/HashSet;
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    const-string v2, "kidApps"
    iget-object v3, p0, Luz/carhelper/passenger/SettingsActivity;->kidApps:Ljava/util/HashSet;
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z
    # keep the Settings.Secure backup current (settings survive a reset)
    :try_start_bs
    invoke-static {p0}, Luz/carhelper/passenger/Backup;->save(Landroid/content/Context;)V
    :try_end_bs
    .catch Ljava/lang/Throwable; {:try_start_bs .. :try_end_bs} :catch_bs
    :catch_bs
    return-void
.end method

# a language was picked in the language dialog: keep the page's unsaved changes, switch the language and reopen
# Settings in it
.method public setLang(Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Luz/carhelper/passenger/SettingsActivity;->saveAll()V
    invoke-static {p0, p1}, Luz/carhelper/passenger/Lang;->choose(Landroid/content/Context;Ljava/lang/String;)V
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void
.end method

# Save writes everything and leaves; Cancel just leaves
.method public onClick(Landroid/view/View;)V
    .locals 4
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    const-string v1, "#lang"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_lang
    invoke-static {p0}, Luz/carhelper/passenger/LangDialog;->show(Luz/carhelper/passenger/SettingsActivity;)V
    return-void
    :not_lang
    const-string v1, "#heal"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_heal_click
    :try_start_hc
    const/4 v1, 0x1
    invoke-static {p0, v1}, Luz/carhelper/passenger/Heal;->start(Landroid/content/Context;Z)V
    :try_end_hc
    .catch Ljava/lang/Throwable; {:try_start_hc .. :try_end_hc} :catch_hc
    :catch_hc
    return-void
    :not_heal_click
    # a row greyed out by AdbGate: the car's adb cannot be reached
    const-string v1, "#adboff"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_adboff_click
    const-string v1, "The car's ADB is off or not reachable. Turn on wireless ADB in the car's backend page, then tap Re-check status."
    invoke-static {v1}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    const/4 v2, 0x1
    invoke-static {p0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    return-void
    :not_adboff_click
    const-string v1, "#files"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_files_click
    :try_start_fm
    new-instance v1, Landroid/content/Intent;
    const-class v2, Luz/carhelper/passenger/apk/ApkManagerActivity;
    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_fm
    .catch Ljava/lang/Throwable; {:try_start_fm .. :try_end_fm} :catch_fm
    :catch_fm
    return-void
    :not_files_click
    const-string v1, "#uninstall"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_uninstall_click
    :try_start_un
    invoke-static {p0}, Luz/carhelper/passenger/apk/UninstallDialog;->show(Landroid/app/Activity;)V
    :try_end_un
    .catch Ljava/lang/Throwable; {:try_start_un .. :try_end_un} :catch_un
    :catch_un
    return-void
    :not_uninstall_click
    const-string v1, "#bubbleSecs"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_bubble_secs
    iget v1, p0, Luz/carhelper/passenger/SettingsActivity;->bubbleSecs:I
    invoke-static {v1}, Luz/carhelper/passenger/SettingsActivity;->nextSecs(I)I
    move-result v1
    iput v1, p0, Luz/carhelper/passenger/SettingsActivity;->bubbleSecs:I
    invoke-static {v1}, Luz/carhelper/passenger/SettingsActivity;->secsText(I)Ljava/lang/String;
    move-result-object v1
    check-cast p1, Landroid/widget/TextView;
    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    return-void
    :not_bubble_secs
    const-string v1, "#setpin"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_setpin
    const-string v1, "set"
    invoke-static {p0, v1}, Luz/carhelper/passenger/PinDialog;->show(Landroid/app/Activity;Ljava/lang/String;)V
    return-void
    :not_setpin
    const-string v1, "#recheck"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_recheck
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void
    :not_recheck

    const-string v1, "#gotocar"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_gotocar
    new-instance v1, Landroid/content/Intent;
    const-string v2, "android.intent.action.MAIN"
    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v2, "android.intent.category.LAUNCHER"
    invoke-virtual {v1, v2}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    const-string v2, "com.leapmotor.copilotshowapp"
    const-string v3, "com.leapmotor.copilotshowapp.mvvm.main.MainActivity"
    invoke-virtual {v1, v2, v3}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
    const/high16 v2, 0x10000000
    invoke-virtual {v1, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_gtc
    invoke-static {}, Landroid/app/ActivityOptions;->makeBasic()Landroid/app/ActivityOptions;
    move-result-object v2
    const/4 v3, 0x3
    invoke-virtual {v2, v3}, Landroid/app/ActivityOptions;->setLaunchDisplayId(I)Landroid/app/ActivityOptions;
    invoke-virtual {v2}, Landroid/app/ActivityOptions;->toBundle()Landroid/os/Bundle;
    move-result-object v2
    invoke-virtual {p0, v1, v2}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;Landroid/os/Bundle;)V
    :try_end_gtc
    .catch Ljava/lang/Exception; {:try_start_gtc .. :try_end_gtc} :gtc_fail
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :gtc_fail
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :not_gotocar

    const-string v1, "#vehset"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_vehset
    new-instance v1, Landroid/content/Intent;
    const-string v2, "android.settings.SETTINGS"
    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const/high16 v2, 0x10000000
    invoke-virtual {v1, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    :try_start_veh
    invoke-virtual {p0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_veh
    .catch Ljava/lang/Exception; {:try_start_veh .. :try_end_veh} :veh_fail
    return-void
    :veh_fail
    return-void
    :not_vehset
    const-string v1, "#save"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :leave
    invoke-direct {p0}, Luz/carhelper/passenger/SettingsActivity;->saveAll()V
    const-string v2, "Saved"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/4 v3, 0x0
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    :leave
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
.end method

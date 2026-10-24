.class public Luz/carhelper/passenger/MusicSettingsActivity;
.super Landroid/app/Activity;
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;
.implements Landroid/view/View$OnClickListener;

# LP Music's Settings page (opened from the home screen's Settings button, MusicHomeActivity), styled like LP
# Companion's Settings tab (shared Ui helper).
# All text comes from Lang (English / Russian / Spanish / Uzbek / Chinese), see Lang.smali.
#   Status:   one row per requirement, green OK / red OFF + the ADB command that fixes it
#             - notification access (getActiveSessions, without it LP Music sees no player)
#             - the LP Music service running (opening this page starts it when it is enabled but down)
#             and two buttons: Re-check status, and Fix permissions (opens the car's Notification access page;
#             dimmed while nothing is missing)
#   Playback: [switch] enabled - master on/off; Save starts or stops the media service
#             [switch] yield   - give the wheel keys to DiPlay while it is playing (only when DiPlay is installed)
#   Language: five chips; a tap applies at once (prefs "music"/"lang") and reopens the page, keeping the
#             unsaved switch positions through onSaveInstanceState
#   Vehicle:  Vehicle settings
# Switch changes are held in memory until Save (prefs "music"); Cancel / Back leaves without saving.

.field private enabled:Z
.field private yield:Z

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    return-void
.end method

# language chip: native name, accent fill when it is the current language; tag "#lang:<code>"
.method private chip(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    .locals 8
    invoke-static {p2}, Luz/carhelper/passenger/Lang;->name(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {p2, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    const v2, 0x2effffff
    const v3, 0x44ffffff
    sget v4, Luz/carhelper/passenger/Ui;->STROKE:I
    if-eqz v1, :styled
    sget v2, Luz/carhelper/passenger/Ui;->ACCENT:I
    sget v3, Luz/carhelper/passenger/Ui;->ACCENT_PRESSED:I
    const/4 v4, 0x0
    :styled
    invoke-static {p0, v0, v2, v3, v4}, Luz/carhelper/passenger/Ui;->pill(Landroid/content/Context;Ljava/lang/CharSequence;III)Landroid/widget/TextView;
    move-result-object v0
    const/16 v5, 0x1c
    const/16 v6, 0x12
    invoke-virtual {v0, v5, v6, v5, v6}, Landroid/widget/TextView;->setPadding(IIII)V
    new-instance v5, Ljava/lang/StringBuilder;
    const-string v6, "#lang:"
    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v5, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v0, v5}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x2
    invoke-direct {v7, v5, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/4 v5, 0x0
    const/16 v6, 0xe
    invoke-virtual {v7, v5, v5, v6, v5}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, v0, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-void
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
    const-string v3, "st_ok"
    invoke-static {p0, v3}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    if-nez p3, :colour_done
    sget v2, Luz/carhelper/passenger/Ui;->BAD:I
    const-string v3, "st_off"
    invoke-static {p0, v3}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
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


.method protected onCreate(Landroid/os/Bundle;)V
    .locals 14
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    # child mode is shared with LP Companion: when it is on, LP Music is locked too
    invoke-static {p0}, Luz/carhelper/passenger/ChildMode;->locked(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :not_child_locked
    const-string v0, "toast_child"
    invoke-static {p0, v0}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    const/4 v1, 0x1
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :not_child_locked

    # load current settings into memory
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->enabled(Landroid/content/Context;)Z
    move-result v0
    iput-boolean v0, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->yieldDiplay(Landroid/content/Context;)Z
    move-result v0
    iput-boolean v0, p0, Luz/carhelper/passenger/MusicSettingsActivity;->yield:Z

    # after a language change the page is recreated: keep the switch positions that were not saved yet
    if-eqz p1, :no_state
    const-string v2, "en"
    iget-boolean v3, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    invoke-virtual {p1, v2, v3}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3
    iput-boolean v3, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    const-string v2, "yd"
    iget-boolean v3, p0, Luz/carhelper/passenger/MusicSettingsActivity;->yield:Z
    invoke-virtual {p1, v2, v3}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3
    iput-boolean v3, p0, Luz/carhelper/passenger/MusicSettingsActivity;->yield:Z
    :no_state

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
    const-string v2, "st_title"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/high16 v3, 0x42200000
    const/4 v6, -0x1
    const/4 v7, 0x1
    invoke-static {p0, v2, v3, v6, v7}, Luz/carhelper/passenger/Ui;->text(Landroid/content/Context;Ljava/lang/CharSequence;FIZ)Landroid/widget/TextView;
    move-result-object v2
    invoke-virtual {v5, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    const-string v2, "LP Music"
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
    const-string v2, "st_cancel"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#cancel"
    const v6, 0x2effffff
    invoke-direct {p0, v4, v2, v3, v6}, Luz/carhelper/passenger/MusicSettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    const-string v2, "st_save"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#save"
    sget v6, Luz/carhelper/passenger/Ui;->ACCENT:I
    invoke-direct {p0, v4, v2, v3, v6}, Luz/carhelper/passenger/MusicSettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V


    # Status: one row per requirement, green = ok, red = off + the ADB command that fixes it.
    # Re-evaluated every time this page opens; "Re-check" reopens it to refresh now.
    const-string v2, "sec_status"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/MusicSettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MusicSettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8

    # notification access for WheelListener (getActiveSessions)
    const-string v2, "notification"
    invoke-virtual {p0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Landroid/app/NotificationManager;
    new-instance v3, Landroid/content/ComponentName;
    const-class v4, Luz/carhelper/passenger/WheelListener;
    invoke-direct {v3, p0, v4}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {v2, v3}, Landroid/app/NotificationManager;->isNotificationListenerAccessGranted(Landroid/content/ComponentName;)Z
    move-result v6
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "adb shell cmd notification allow_listener "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v5, "/uz.carhelper.passenger.WheelListener 10"
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    const-string v2, "row_listener"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v8, v2, v6, v4}, Luz/carhelper/passenger/MusicSettingsActivity;->healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/MusicSettingsActivity;->divider(Landroid/widget/LinearLayout;)V

    # the LP Music service: if it is enabled but down, start it now
    sget-boolean v6, Luz/carhelper/passenger/MediaBrowser;->running:Z
    const-string v4, ""
    if-nez v6, :svc_row
    const-string v4, "fix_svc_off"
    invoke-static {p0, v4}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    iget-boolean v2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    if-eqz v2, :svc_row
    const-string v4, "fix_svc_start"
    invoke-static {p0, v4}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    new-instance v3, Landroid/content/Intent;
    const-class v5, Luz/carhelper/passenger/MediaBrowser;
    invoke-direct {v3, p0, v5}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    :try_start_svc
    invoke-virtual {p0, v3}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_svc
    .catch Ljava/lang/Exception; {:try_start_svc .. :try_end_svc} :svc_caught
    :svc_caught
    :svc_row
    const-string v2, "row_service"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v8, v2, v6, v4}, Luz/carhelper/passenger/MusicSettingsActivity;->healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V
    invoke-direct {p0, v8}, Luz/carhelper/passenger/MusicSettingsActivity;->divider(Landroid/widget/LinearLayout;)V

    # the two buttons at the bottom of the Status card, side by side: Re-check status, and Fix permissions, which
    # opens the car's Notification access page (dimmed, and only a toast, while nothing is missing)
    new-instance v5, Landroid/widget/LinearLayout;
    invoke-direct {v5, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v5, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v2, 0xc
    const/16 v3, 0x12
    const/16 v4, 0x14
    invoke-virtual {v5, v2, v3, v4, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const-string v2, "st_recheck"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#recheck"
    const v4, 0x2effffff
    invoke-direct {p0, v5, v2, v3, v4}, Luz/carhelper/passenger/MusicSettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    invoke-static {p0}, Luz/carhelper/passenger/Perm;->missing(Landroid/content/Context;)Z
    move-result v3
    const-string v2, "btn_fix"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v4, "#perm"
    if-nez v3, :fix_tag
    const-string v4, "#permdone"
    :fix_tag
    const v7, 0x2effffff
    invoke-direct {p0, v5, v2, v4, v7}, Luz/carhelper/passenger/MusicSettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;
    move-result-object v6
    if-nez v3, :fix_lit
    const v4, 0x3eb33333
    invoke-virtual {v6, v4}, Landroid/view/View;->setAlpha(F)V
    :fix_lit
    invoke-virtual {v8, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Playback
    const-string v2, "sec_playback"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/MusicSettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MusicSettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    const-string v2, "sw_enabled"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "enabled"
    const/4 v4, 0x0
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/MusicSettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    # the DiPlay yield switch is only shown when DiPlay is actually installed
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->diplayInstalled(Landroid/content/Context;)Z
    move-result v2
    if-eqz v2, :after_diplay
    invoke-direct {p0, v8}, Luz/carhelper/passenger/MusicSettingsActivity;->divider(Landroid/widget/LinearLayout;)V
    const-string v2, "sw_yield"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "yield"
    const/4 v4, 0x0
    invoke-direct {p0, v8, v2, v3, v4}, Luz/carhelper/passenger/MusicSettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->yield:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    :after_diplay

    # Language: one chip per language, the current one in the accent colour
    const-string v2, "sec_language"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/MusicSettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MusicSettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    new-instance v9, Landroid/widget/LinearLayout;
    invoke-direct {v9, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v9, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/16 v2, 0x1c
    const/16 v3, 0x18
    invoke-virtual {v9, v2, v3, v2, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    invoke-static {p0}, Luz/carhelper/passenger/Lang;->chosen(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v10
    const-string v2, "en"
    invoke-direct {p0, v9, v2, v10}, Luz/carhelper/passenger/MusicSettingsActivity;->chip(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v2, "ru"
    invoke-direct {p0, v9, v2, v10}, Luz/carhelper/passenger/MusicSettingsActivity;->chip(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v2, "es"
    invoke-direct {p0, v9, v2, v10}, Luz/carhelper/passenger/MusicSettingsActivity;->chip(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v2, "uz"
    invoke-direct {p0, v9, v2, v10}, Luz/carhelper/passenger/MusicSettingsActivity;->chip(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v2, "zh"
    invoke-direct {p0, v9, v2, v10}, Luz/carhelper/passenger/MusicSettingsActivity;->chip(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v8, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Vehicle
    const-string v2, "sec_vehicle"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/MusicSettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MusicSettingsActivity;->card(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v8
    const-string v2, "nav_vehicle"
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "#vehset"
    invoke-direct {p0, v8, v2, v3}, Luz/carhelper/passenger/MusicSettingsActivity;->navRow(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V
    return-void
.end method

# keep the unsaved switch positions through recreate() (language change, Re-check)
.method protected onSaveInstanceState(Landroid/os/Bundle;)V
    .locals 3
    invoke-super {p0, p1}, Landroid/app/Activity;->onSaveInstanceState(Landroid/os/Bundle;)V
    const-string v0, "en"
    iget-boolean v1, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    invoke-virtual {p1, v0, v1}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
    const-string v0, "yd"
    iget-boolean v1, p0, Luz/carhelper/passenger/MusicSettingsActivity;->yield:Z
    invoke-virtual {p1, v0, v1}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
    return-void
.end method

.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 2
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    const-string v1, "enabled"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_en
    iput-boolean p2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    return-void
    :not_en
    const-string v1, "yield"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :done
    iput-boolean p2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->yield:Z
    :done
    return-void
.end method

.method private toast(Ljava/lang/String;)V
    .locals 2
    invoke-static {p0, p1}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    const/4 v1, 0x0
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 4
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    if-nez v0, :has_tag
    return-void
    :has_tag
    # language chip: "#lang:<code>"
    move-object v2, v0
    check-cast v2, Ljava/lang/String;
    const-string v3, "#lang:"
    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v3
    if-eqz v3, :not_lang
    const/4 v3, 0x6
    invoke-virtual {v2, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2
    invoke-static {p0, v2}, Luz/carhelper/passenger/Lang;->set(Landroid/content/Context;Ljava/lang/String;)V
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void
    :not_lang
    const-string v1, "#recheck"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_recheck
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void
    :not_recheck
    const-string v1, "#perm"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_perm
    invoke-static {p0}, Luz/carhelper/passenger/Perm;->open(Landroid/content/Context;)Z
    move-result v1
    if-nez v1, :perm_done
    const-string v1, "toast_no_page"
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MusicSettingsActivity;->toast(Ljava/lang/String;)V
    :perm_done
    return-void
    :not_perm
    const-string v1, "#permdone"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_permdone
    const-string v1, "perm_ok"
    invoke-direct {p0, v1}, Luz/carhelper/passenger/MusicSettingsActivity;->toast(Ljava/lang/String;)V
    return-void
    :not_permdone
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
    const-string v1, "music"
    const/4 v2, 0x0
    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const-string v2, "enabled"
    iget-boolean v3, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "yieldDiplay"
    iget-boolean v3, p0, Luz/carhelper/passenger/MusicSettingsActivity;->yield:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    # restart the service so new settings take effect
    new-instance v1, Landroid/content/Intent;
    const-class v2, Luz/carhelper/passenger/MediaBrowser;
    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    :try_start_0
    invoke-virtual {p0, v1}, Landroid/content/Context;->stopService(Landroid/content/Intent;)Z
    iget-boolean v2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    if-eqz v2, :toast
    invoke-virtual {p0, v1}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    goto :toast
    :catch_0
    move-exception v2
    :toast
    const-string v1, "toast_saved"
    invoke-static {p0, v1}, Luz/carhelper/passenger/Lang;->s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    const/4 v2, 0x0
    invoke-static {p0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    :leave
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
.end method

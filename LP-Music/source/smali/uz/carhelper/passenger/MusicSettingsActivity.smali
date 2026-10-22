.class public Luz/carhelper/passenger/MusicSettingsActivity;
.super Landroid/app/Activity;
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;
.implements Landroid/view/View$OnClickListener;

# LP Music's screen (also the launcher activity). Two switches, held in memory until Save:
#   enabled  - master on/off; Save starts or stops the media service accordingly
#   yield    - give the steering-wheel keys to DiPlay while it is playing
# Save writes prefs "music" and applies; Exit leaves without saving.

.field private enabled:Z
.field private yield:Z
.field private releaseButtons:Z

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    return-void
.end method

.method private section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    .locals 3
    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v1, 0x41b00000
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const v1, -0x616162
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const/4 v1, 0x0
    const/16 v2, 0x28
    invoke-virtual {v0, v1, v2, v1, v1}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-void
.end method

.method private hint(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    .locals 3
    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v1, 0x41800000
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const v1, -0x777778
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const/4 v1, 0x0
    const/16 v2, 0x8
    invoke-virtual {v0, v1, v1, v1, v2}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-void
.end method

.method private addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/Switch;
    .locals 3
    new-instance v0, Landroid/widget/Switch;
    invoke-direct {v0, p0}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p2}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V
    const/high16 v1, 0x41d00000
    invoke-virtual {v0, v1}, Landroid/widget/Switch;->setTextSize(F)V
    const/4 v1, 0x0
    const/16 v2, 0x14
    invoke-virtual {v0, v1, v2, v1, v1}, Landroid/widget/Switch;->setPadding(IIII)V
    invoke-virtual {v0, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-object v0
.end method

.method private addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 4
    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v1, 0x41d00000
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v1, -0x1
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v1, 0x30
    const/16 v2, 0x14
    invoke-virtual {v0, v1, v2, v1, v2}, Landroid/widget/TextView;->setPadding(IIII)V
    new-instance v1, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v1}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    invoke-virtual {v1, p4}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    const/high16 v2, 0x42c80000
    invoke-virtual {v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v0, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v2, -0x2
    invoke-direct {v1, v2, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v2, 0x18
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 8
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->enabled(Landroid/content/Context;)Z
    move-result v0
    iput-boolean v0, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->yieldDiplay(Landroid/content/Context;)Z
    move-result v0
    iput-boolean v0, p0, Luz/carhelper/passenger/MusicSettingsActivity;->yield:Z
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->releaseButtons(Landroid/content/Context;)Z
    move-result v0
    iput-boolean v0, p0, Luz/carhelper/passenger/MusicSettingsActivity;->releaseButtons:Z

    new-instance v0, Landroid/widget/ScrollView;
    invoke-direct {v0, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v2, 0x30
    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    # header: title + Exit + Save
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v3, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v4, "LP Music"
    invoke-virtual {v2, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v4, 0x42080000
    invoke-virtual {v2, v4}, Landroid/widget/TextView;->setTextSize(F)V
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, 0x0
    const/4 v6, -0x2
    const/high16 v7, 0x3f800000
    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v3, v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    const-string v4, "Exit"
    const-string v5, "#exit"
    const v6, 0x2effffff
    invoke-direct {p0, v3, v4, v5, v6}, Luz/carhelper/passenger/MusicSettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)V
    const-string v4, "Save"
    const-string v5, "#save"
    const v6, -0xe1771b
    invoke-direct {p0, v3, v4, v5, v6}, Luz/carhelper/passenger/MusicSettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)V
    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const-string v2, "Playback"
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/MusicSettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V

    const-string v2, "LP Music enabled"
    const-string v3, "enabled"
    invoke-direct {p0, v1, v2, v3}, Luz/carhelper/passenger/MusicSettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/Switch;
    move-result-object v4
    iget-boolean v2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->enabled:Z
    invoke-virtual {v4, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v4, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    const-string v2, "Mirrors the playing app to the car and handles the wheel buttons."
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/MusicSettingsActivity;->hint(Landroid/widget/LinearLayout;Ljava/lang/String;)V

    # the DiPlay yield switch is only shown when DiPlay is actually installed
    invoke-static {p0}, Luz/carhelper/passenger/MusicGate;->diplayInstalled(Landroid/content/Context;)Z
    move-result v2
    if-eqz v2, :no_diplay
    const-string v2, "Give the wheel buttons to DiPlay while it’s playing"
    const-string v3, "yield"
    invoke-direct {p0, v1, v2, v3}, Luz/carhelper/passenger/MusicSettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/Switch;
    move-result-object v4
    iget-boolean v2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->yield:Z
    invoke-virtual {v4, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v4, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    const-string v2, "While CarPlay (DiPlay) is playing, LP Music stops controlling so the wheel buttons drive DiPlay."
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/MusicSettingsActivity;->hint(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    goto :after_yield
    :no_diplay
    const-string v2, "DiPlay is not installed — nothing to hand the wheel buttons to."
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/MusicSettingsActivity;->hint(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    :after_yield

    const-string v2, "Don’t grab the hardware media buttons"
    const-string v3, "releaseButtons"
    invoke-direct {p0, v1, v2, v3}, Luz/carhelper/passenger/MusicSettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)Landroid/widget/Switch;
    move-result-object v4
    iget-boolean v2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->releaseButtons:Z
    invoke-virtual {v4, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v4, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    const-string v2, "Lets Android Auto or the playing app keep the wheel’s media keys. LP Music still controls music through the car’s own wheel signal. Leave on unless the wheel buttons stop working."
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/MusicSettingsActivity;->hint(Landroid/widget/LinearLayout;Ljava/lang/String;)V

    const-string v2, "Vehicle"
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/MusicSettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    const-string v2, "Vehicle settings"
    const-string v3, "#vehset"
    const v4, -0xbd7a89
    invoke-direct {p0, v1, v2, v3, v4}, Luz/carhelper/passenger/MusicSettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V
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
    if-eqz v1, :not_yield
    iput-boolean p2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->yield:Z
    return-void
    :not_yield
    const-string v1, "releaseButtons"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :done
    iput-boolean p2, p0, Luz/carhelper/passenger/MusicSettingsActivity;->releaseButtons:Z
    :done
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 4
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
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
    const-string v2, "releaseButtons"
    iget-boolean v3, p0, Luz/carhelper/passenger/MusicSettingsActivity;->releaseButtons:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    # restart the service so new settings (incl. the media-button flag) take effect
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
    const-string v1, "Saved"
    const/4 v2, 0x0
    invoke-static {p0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    :leave
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
.end method

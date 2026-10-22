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

# switch tagged with pref key p3, left padding p4; caller sets the checked state
.method private addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    .locals 3
    new-instance v0, Landroid/widget/Switch;
    invoke-direct {v0, p0}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p2}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V
    const/high16 v1, 0x41d00000
    invoke-virtual {v0, v1}, Landroid/widget/Switch;->setTextSize(F)V
    const/16 v1, 0x14
    const/4 v2, 0x0
    invoke-virtual {v0, p4, v1, v2, v1}, Landroid/widget/Switch;->setPadding(IIII)V
    invoke-virtual {v0, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-object v0
.end method

# status row: green "● label — OK", or red "● label — OFF" with the fix text p4 underneath
.method private healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V
    .locals 4
    new-instance v0, Ljava/lang/StringBuilder;
    const-string v1, "●  "
    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const v2, -0xb350b0
    const-string v1, " — OK"
    if-nez p3, :off
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :text
    :off
    const v2, -0xbbcca
    const-string v1, " — OFF\n     "
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :text
    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v0, 0x41a00000
    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v0, 0x0
    const/16 v3, 0x8
    invoke-virtual {v1, v0, v3, v0, v3}, Landroid/widget/TextView;->setPadding(IIII)V
    const/4 v0, 0x1
    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setTextIsSelectable(Z)V
    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-void
.end method

# rounded pill button (Save / Cancel)
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
    .locals 14
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

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

    # v0 = ScrollView, v1 = page
    new-instance v0, Landroid/widget/ScrollView;
    invoke-direct {v0, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v2, 0x30
    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    # header: title + Cancel + Save
    new-instance v4, Landroid/widget/LinearLayout;
    invoke-direct {v4, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x10
    invoke-virtual {v4, v2}, Landroid/widget/LinearLayout;->setGravity(I)V
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v3, "LP Companion settings"
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v3, 0x42080000
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v6, 0x0
    const/4 v7, -0x2
    const/high16 v8, 0x3f800000
    invoke-direct {v3, v6, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v4, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    const-string v2, "Cancel"
    const-string v3, "#cancel"
    const v6, 0x2effffff
    invoke-direct {p0, v4, v2, v3, v6}, Luz/carhelper/passenger/SettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)V
    const-string v2, "Save"
    const-string v3, "#save"
    const v6, -0xe1771b
    invoke-direct {p0, v4, v2, v3, v6}, Luz/carhelper/passenger/SettingsActivity;->addPill(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)V
    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Status: one row per grant, green = on, red = off + the ADB command that fixes it
    const-string v2, "Status"
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z
    move-result v6
    const-string v2, "Bubble (overlay)"
    const-string v4, "adb shell appops set --user 10 uz.carhelper.passenger SYSTEM_ALERT_WINDOW allow"
    invoke-direct {p0, v1, v2, v6, v4}, Luz/carhelper/passenger/SettingsActivity;->healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V

    const-string v2, "notification"
    invoke-virtual {p0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Landroid/app/NotificationManager;
    new-instance v3, Landroid/content/ComponentName;
    const-class v4, Luz/carhelper/passenger/WheelListener;
    invoke-direct {v3, p0, v4}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {v2, v3}, Landroid/app/NotificationManager;->isNotificationListenerAccessGranted(Landroid/content/ComponentName;)Z
    move-result v6
    const-string v2, "Wheel buttons (notification access)"
    const-string v4, "adb shell cmd notification allow_listener uz.carhelper.passenger/uz.carhelper.passenger.WheelListener 10"
    invoke-direct {p0, v1, v2, v6, v4}, Luz/carhelper/passenger/SettingsActivity;->healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V

    const-string v2, "android.permission.WRITE_SECURE_SETTINGS"
    invoke-virtual {p0, v2}, Landroid/content/Context;->checkSelfPermission(Ljava/lang/String;)I
    move-result v3
    const/4 v6, 0x0
    if-nez v3, :wss_row
    const/4 v6, 0x1
    :wss_row
    const-string v2, "Self-repair after restart"
    const-string v4, "adb shell pm grant --user 10 uz.carhelper.passenger android.permission.WRITE_SECURE_SETTINGS"
    invoke-direct {p0, v1, v2, v6, v4}, Luz/carhelper/passenger/SettingsActivity;->healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V

    # Back: if it's off, try to switch it on right now
    sget-object v3, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    const/4 v6, 0x1
    const-string v4, ""
    if-nez v3, :back_row
    const/4 v6, 0x0
    const-string v4, "Needs the self-repair permission above"
    invoke-static {p0}, Luz/carhelper/passenger/BackRepair;->ensure(Landroid/content/Context;)Z
    move-result v3
    if-eqz v3, :back_row
    const-string v4, "Switching on now — reopen this page in a few seconds"
    :back_row
    const-string v2, "Back button (accessibility)"
    invoke-direct {p0, v1, v2, v6, v4}, Luz/carhelper/passenger/SettingsActivity;->healthRow(Landroid/widget/LinearLayout;Ljava/lang/String;ZLjava/lang/String;)V

    # Steering wheel
    const-string v2, "Steering wheel"
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    const-string v2, "Wheel buttons control sideloaded music players"
    const-string v3, "wheel"
    const/4 v4, 0x0
    invoke-direct {p0, v1, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->wheel:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    # Closing apps
    const-string v2, "Closing apps"
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    const-string v2, "Close the previous app when another one is opened"
    const-string v3, "autoClose"
    const/4 v4, 0x0
    invoke-direct {p0, v1, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->autoClose:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    const-string v2, "Also close music apps"
    const-string v3, "closeMusic"
    const/16 v4, 0x40
    invoke-direct {p0, v1, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v6
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->closeMusic:Z
    invoke-virtual {v6, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v6, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    iput-object v6, p0, Luz/carhelper/passenger/SettingsActivity;->musicSwitch:Landroid/widget/Switch;
    iget-boolean v4, p0, Luz/carhelper/passenger/SettingsActivity;->autoClose:Z
    invoke-virtual {v6, v4}, Landroid/view/View;->setEnabled(Z)V

    # Protection
    const-string v2, "Protection"
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    const-string v2, "Overload protection: close passenger apps if CPU or RAM is overloaded"
    const-string v3, "overheat"
    const/4 v4, 0x0
    invoke-direct {p0, v1, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->overheat:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    # Kid mode: switch + PIN
    const-string v2, "Kid mode"
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    const-string v2, "Kid mode: passenger grid shows only apps ticked \"Kids\"; Close apps and Swap are off"
    const-string v3, "kid"
    const/4 v4, 0x0
    invoke-direct {p0, v1, v2, v3, v4}, Luz/carhelper/passenger/SettingsActivity;->addSwitch(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/Switch;
    move-result-object v5
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->kid:Z
    invoke-virtual {v5, v2}, Landroid/widget/Switch;->setChecked(Z)V
    invoke-virtual {v5, p0}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    # numberPassword (TYPE_CLASS_NUMBER | TYPE_NUMBER_VARIATION_PASSWORD)
    new-instance v5, Landroid/widget/EditText;
    invoke-direct {v5, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V
    const/16 v2, 0x12
    invoke-virtual {v5, v2}, Landroid/widget/EditText;->setInputType(I)V
    const-string v2, "PIN to leave kid mode (at least 4 digits)"
    invoke-virtual {v5, v2}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V
    iget-object v2, p0, Luz/carhelper/passenger/SettingsActivity;->storedPin:Ljava/lang/String;
    invoke-virtual {v5, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V
    const/high16 v2, 0x41d00000
    invoke-virtual {v5, v2}, Landroid/widget/EditText;->setTextSize(F)V
    invoke-virtual {v1, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    iput-object v5, p0, Luz/carhelper/passenger/SettingsActivity;->pinEdit:Landroid/widget/EditText;

    # Apps shown on the passenger screen
    const-string v2, "Apps shown on the passenger screen"
    invoke-direct {p0, v1, v2}, Luz/carhelper/passenger/SettingsActivity;->section(Landroid/widget/LinearLayout;Ljava/lang/String;)V

    # v5 = hidden packages, v6 = PackageManager, v7 = sorted launchable activities, v8 = iterator
    iget-object v5, p0, Luz/carhelper/passenger/SettingsActivity;->hidden:Ljava/util/HashSet;
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

    # row: icon + checkbox (checked = shown)
    new-instance v11, Landroid/widget/LinearLayout;
    invoke-direct {v11, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/16 v12, 0x10
    invoke-virtual {v11, v12}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/4 v12, 0x0
    const/16 v13, 0xc
    invoke-virtual {v11, v12, v13, v12, v13}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v12, Landroid/widget/ImageView;
    invoke-direct {v12, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v9, v6}, Landroid/content/pm/ResolveInfo;->loadIcon(Landroid/content/pm/PackageManager;)Landroid/graphics/drawable/Drawable;
    move-result-object v13
    invoke-virtual {v12, v13}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V
    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    const/16 v2, 0x48
    invoke-direct {v13, v2, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v11, v12, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v12, Landroid/widget/CheckBox;
    invoke-direct {v12, p0}, Landroid/widget/CheckBox;-><init>(Landroid/content/Context;)V
    invoke-virtual {v9, v6}, Landroid/content/pm/ResolveInfo;->loadLabel(Landroid/content/pm/PackageManager;)Ljava/lang/CharSequence;
    move-result-object v13
    invoke-virtual {v12, v13}, Landroid/widget/CheckBox;->setText(Ljava/lang/CharSequence;)V
    const/high16 v13, 0x41d00000
    invoke-virtual {v12, v13}, Landroid/widget/CheckBox;->setTextSize(F)V
    const/16 v13, 0x18
    const/4 v2, 0x0
    invoke-virtual {v12, v13, v2, v2, v2}, Landroid/widget/CheckBox;->setPadding(IIII)V
    invoke-virtual {v5, v10}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z
    move-result v13
    xor-int/lit8 v13, v13, 0x1
    invoke-virtual {v12, v13}, Landroid/widget/CheckBox;->setChecked(Z)V
    invoke-virtual {v12, v10}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v12, p0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v2, 0x0
    const/4 v3, -0x2
    const/high16 v4, 0x3f800000
    invoke-direct {v13, v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v11, v12, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # "Kids" checkbox on the right, tag "kid:<package>"
    new-instance v12, Landroid/widget/CheckBox;
    invoke-direct {v12, p0}, Landroid/widget/CheckBox;-><init>(Landroid/content/Context;)V
    const-string v13, "Kids"
    invoke-virtual {v12, v13}, Landroid/widget/CheckBox;->setText(Ljava/lang/CharSequence;)V
    const/high16 v13, 0x41b00000
    invoke-virtual {v12, v13}, Landroid/widget/CheckBox;->setTextSize(F)V
    iget-object v13, p0, Luz/carhelper/passenger/SettingsActivity;->kidApps:Ljava/util/HashSet;
    invoke-virtual {v13, v10}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z
    move-result v13
    invoke-virtual {v12, v13}, Landroid/widget/CheckBox;->setChecked(Z)V
    new-instance v13, Ljava/lang/StringBuilder;
    const-string v2, "kid:"
    invoke-direct {v13, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v13, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v13
    invoke-virtual {v12, v13}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v12, p0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    invoke-virtual {v11, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-virtual {v1, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    goto :loop

    :end
    invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V

    # kid mode on: ask the PIN before anything can be changed
    iget-boolean v2, p0, Luz/carhelper/passenger/SettingsActivity;->kid:Z
    if-eqz v2, :no_gate
    iget-object v2, p0, Luz/carhelper/passenger/SettingsActivity;->storedPin:Ljava/lang/String;
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z
    move-result v2
    if-nez v2, :no_gate
    new-instance v2, Landroid/widget/EditText;
    invoke-direct {v2, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V
    const/16 v3, 0x12
    invoke-virtual {v2, v3}, Landroid/widget/EditText;->setInputType(I)V
    iput-object v2, p0, Luz/carhelper/passenger/SettingsActivity;->gateEdit:Landroid/widget/EditText;
    new-instance v3, Landroid/app/AlertDialog$Builder;
    invoke-direct {v3, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    const-string v4, "Kid mode is on — enter PIN"
    invoke-virtual {v3, v4}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    invoke-virtual {v3, v2}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;
    const/4 v4, 0x0
    invoke-virtual {v3, v4}, Landroid/app/AlertDialog$Builder;->setCancelable(Z)Landroid/app/AlertDialog$Builder;
    const-string v4, "Unlock"
    invoke-virtual {v3, v4, p0}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    const-string v4, "Cancel"
    invoke-virtual {v3, v4, p0}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    invoke-virtual {v3}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    :no_gate
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

# Save writes everything and leaves; Cancel just leaves
.method public onClick(Landroid/view/View;)V
    .locals 4
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    const-string v1, "#save"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :leave
    # kid mode needs a PIN of 4+ digits, otherwise stay on the page
    iget-object v1, p0, Luz/carhelper/passenger/SettingsActivity;->pinEdit:Landroid/widget/EditText;
    invoke-virtual {v1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;
    move-result-object v1
    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;
    move-result-object v0
    iget-boolean v1, p0, Luz/carhelper/passenger/SettingsActivity;->kid:Z
    if-eqz v1, :pin_ok
    invoke-virtual {v0}, Ljava/lang/String;->length()I
    move-result v1
    const/4 v2, 0x4
    if-ge v1, v2, :pin_ok
    const-string v2, "Kid mode needs a PIN of at least 4 digits"
    const/4 v3, 0x1
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    return-void
    :pin_ok
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
    const-string v2, "hidden"
    iget-object v3, p0, Luz/carhelper/passenger/SettingsActivity;->hidden:Ljava/util/HashSet;
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    const-string v2, "kid"
    iget-boolean v3, p0, Luz/carhelper/passenger/SettingsActivity;->kid:Z
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    const-string v2, "kidApps"
    iget-object v3, p0, Luz/carhelper/passenger/SettingsActivity;->kidApps:Ljava/util/HashSet;
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    const-string v2, "pin"
    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V
    const-string v2, "Saved"
    const/4 v3, 0x0
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    :leave
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
.end method

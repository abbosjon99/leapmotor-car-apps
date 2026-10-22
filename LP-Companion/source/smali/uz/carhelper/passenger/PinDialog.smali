.class public Luz/carhelper/passenger/PinDialog;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# Custom numeric PIN pad (1-9, 0, backspace, OK). No system keyboard. Compact for the 720px
# passenger screen. Prefs file "apps", key "pin". purpose:
#   "set"      - save a new PIN (>= 4 digits)
#   "exit"     - correct PIN turns child mode off (kid=false) and recreates the screen
#   "settings" - correct PIN opens Settings

.field private final act:Landroid/app/Activity;
.field private final purpose:Ljava/lang/String;
.field private final sb:Ljava/lang/StringBuilder;
.field private dots:Landroid/widget/TextView;
.field private dialog:Landroid/app/AlertDialog;

.method public static show(Landroid/app/Activity;Ljava/lang/String;)V
    .locals 1
    new-instance v0, Luz/carhelper/passenger/PinDialog;
    invoke-direct {v0, p0, p1}, Luz/carhelper/passenger/PinDialog;-><init>(Landroid/app/Activity;Ljava/lang/String;)V
    invoke-direct {v0}, Luz/carhelper/passenger/PinDialog;->build()V
    return-void
.end method

.method public constructor <init>(Landroid/app/Activity;Ljava/lang/String;)V
    .locals 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/PinDialog;->act:Landroid/app/Activity;
    iput-object p2, p0, Luz/carhelper/passenger/PinDialog;->purpose:Ljava/lang/String;
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    iput-object v0, p0, Luz/carhelper/passenger/PinDialog;->sb:Ljava/lang/StringBuilder;
    return-void
.end method

.method private prefs()Landroid/content/SharedPreferences;
    .locals 3
    iget-object v0, p0, Luz/carhelper/passenger/PinDialog;->act:Landroid/app/Activity;
    const-string v1, "apps"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    return-object v0
.end method

.method private toast(Ljava/lang/String;)V
    .locals 2
    iget-object v0, p0, Luz/carhelper/passenger/PinDialog;->act:Landroid/app/Activity;
    const/4 v1, 0x0
    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    return-void
.end method

.method private dismiss()V
    .locals 1
    iget-object v0, p0, Luz/carhelper/passenger/PinDialog;->dialog:Landroid/app/AlertDialog;
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/app/AlertDialog;->dismiss()V
    :done
    return-void
.end method

.method private row(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    .locals 3
    iget-object v0, p0, Luz/carhelper/passenger/PinDialog;->act:Landroid/app/Activity;
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/high16 v2, 0x40400000
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setWeightSum(F)V
    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    return-object v1
.end method

.method private key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    .locals 6
    iget-object v0, p0, Luz/carhelper/passenger/PinDialog;->act:Landroid/app/Activity;
    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v2, 0x41d00000
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v2, -0x1
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v2, 0x11
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setGravity(I)V
    new-instance v2, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    const v3, 0x33ffffff
    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    const/high16 v3, 0x41800000
    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v1, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v3, 0x0
    const/16 v4, 0x58
    const/high16 v5, 0x3f800000
    invoke-direct {v2, v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    const/16 v3, 0x8
    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {p1, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-void
.end method

.method private updateDots()V
    .locals 4
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    const/4 v1, 0x0
    :loop
    iget-object v2, p0, Luz/carhelper/passenger/PinDialog;->sb:Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I
    move-result v2
    if-ge v1, v2, :done
    const-string v2, "• "
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    add-int/lit8 v1, v1, 0x1
    goto :loop
    :done
    iget-object v1, p0, Luz/carhelper/passenger/PinDialog;->dots:Landroid/widget/TextView;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    return-void
.end method

.method private build()V
    .locals 6
    iget-object v0, p0, Luz/carhelper/passenger/PinDialog;->act:Landroid/app/Activity;
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v2, 0x28
    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const v2, -0xe5e5e6
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackgroundColor(I)V

    # title
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    iget-object v3, p0, Luz/carhelper/passenger/PinDialog;->purpose:Ljava/lang/String;
    const-string v4, "set"
    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    const-string v3, "Enter PIN"
    if-eqz v4, :title_ready
    const-string v3, "Set a PIN (4+ digits)"
    :title_ready
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v3, 0x41c00000
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v3, -0x1
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v3, 0x11
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # dots display
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const/high16 v3, 0x42000000
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v3, -0x1
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v3, 0x11
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V
    const/4 v3, 0x0
    const/16 v4, 0x18
    invoke-virtual {v2, v3, v4, v3, v4}, Landroid/widget/TextView;->setPadding(IIII)V
    iput-object v2, p0, Luz/carhelper/passenger/PinDialog;->dots:Landroid/widget/TextView;
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # rows 1-9
    invoke-direct {p0, v1}, Luz/carhelper/passenger/PinDialog;->row(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v2
    const-string v3, "1"
    invoke-direct {p0, v2, v3, v3}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v3, "2"
    invoke-direct {p0, v2, v3, v3}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v3, "3"
    invoke-direct {p0, v2, v3, v3}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/PinDialog;->row(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v2
    const-string v3, "4"
    invoke-direct {p0, v2, v3, v3}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v3, "5"
    invoke-direct {p0, v2, v3, v3}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v3, "6"
    invoke-direct {p0, v2, v3, v3}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    invoke-direct {p0, v1}, Luz/carhelper/passenger/PinDialog;->row(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v2
    const-string v3, "7"
    invoke-direct {p0, v2, v3, v3}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v3, "8"
    invoke-direct {p0, v2, v3, v3}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v3, "9"
    invoke-direct {p0, v2, v3, v3}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    # row: backspace, 0, OK
    invoke-direct {p0, v1}, Luz/carhelper/passenger/PinDialog;->row(Landroid/widget/LinearLayout;)Landroid/widget/LinearLayout;
    move-result-object v2
    const-string v3, "⌫"
    const-string v4, "del"
    invoke-direct {p0, v2, v3, v4}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v3, "0"
    invoke-direct {p0, v2, v3, v3}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V
    const-string v3, "OK"
    const-string v4, "ok"
    invoke-direct {p0, v2, v3, v4}, Luz/carhelper/passenger/PinDialog;->key(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;)V

    new-instance v2, Landroid/app/AlertDialog$Builder;
    invoke-direct {v2, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    invoke-virtual {v2, v1}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;
    move-result-object v2
    const/4 v3, 0x1
    invoke-virtual {v2, v3}, Landroid/app/AlertDialog$Builder;->setCancelable(Z)Landroid/app/AlertDialog$Builder;
    move-result-object v2
    const-string v3, "Cancel"
    const/4 v4, 0x0
    invoke-virtual {v2, v3, v4}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v2
    invoke-virtual {v2}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    move-result-object v2
    iput-object v2, p0, Luz/carhelper/passenger/PinDialog;->dialog:Landroid/app/AlertDialog;
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 4
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    const-string v1, "del"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_del
    iget-object v1, p0, Luz/carhelper/passenger/PinDialog;->sb:Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->length()I
    move-result v2
    if-lez v2, :ret
    add-int/lit8 v2, v2, -0x1
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->deleteCharAt(I)Ljava/lang/StringBuilder;
    invoke-direct {p0}, Luz/carhelper/passenger/PinDialog;->updateDots()V
    :ret
    return-void
    :not_del
    const-string v1, "ok"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :digit
    invoke-direct {p0}, Luz/carhelper/passenger/PinDialog;->handleOk()V
    return-void
    :digit
    iget-object v1, p0, Luz/carhelper/passenger/PinDialog;->sb:Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->length()I
    move-result v2
    const/16 v3, 0x8
    if-ge v2, v3, :ret2
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-direct {p0}, Luz/carhelper/passenger/PinDialog;->updateDots()V
    :ret2
    return-void
.end method

.method private handleOk()V
    .locals 5
    iget-object v0, p0, Luz/carhelper/passenger/PinDialog;->sb:Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    iget-object v1, p0, Luz/carhelper/passenger/PinDialog;->purpose:Ljava/lang/String;
    const-string v2, "set"
    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :not_set
    invoke-virtual {v0}, Ljava/lang/String;->length()I
    move-result v2
    const/4 v3, 0x4
    if-ge v2, v3, :do_set
    const-string v2, "Need at least 4 digits"
    invoke-direct {p0, v2}, Luz/carhelper/passenger/PinDialog;->toast(Ljava/lang/String;)V
    return-void
    :do_set
    invoke-direct {p0}, Luz/carhelper/passenger/PinDialog;->prefs()Landroid/content/SharedPreferences;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v3, "pin"
    invoke-interface {v2, v3, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V
    invoke-direct {p0}, Luz/carhelper/passenger/PinDialog;->dismiss()V
    const-string v2, "PIN set"
    invoke-direct {p0, v2}, Luz/carhelper/passenger/PinDialog;->toast(Ljava/lang/String;)V
    return-void
    :not_set
    invoke-direct {p0}, Luz/carhelper/passenger/PinDialog;->prefs()Landroid/content/SharedPreferences;
    move-result-object v2
    const-string v3, "pin"
    const-string v4, ""
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :match
    const-string v2, "Wrong PIN"
    invoke-direct {p0, v2}, Luz/carhelper/passenger/PinDialog;->toast(Ljava/lang/String;)V
    iget-object v2, p0, Luz/carhelper/passenger/PinDialog;->sb:Ljava/lang/StringBuilder;
    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->setLength(I)V
    invoke-direct {p0}, Luz/carhelper/passenger/PinDialog;->updateDots()V
    return-void
    :match
    invoke-direct {p0}, Luz/carhelper/passenger/PinDialog;->dismiss()V
    iget-object v2, p0, Luz/carhelper/passenger/PinDialog;->purpose:Ljava/lang/String;
    const-string v3, "exit"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :open_settings
    invoke-direct {p0}, Luz/carhelper/passenger/PinDialog;->prefs()Landroid/content/SharedPreferences;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v3, "kid"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V
    iget-object v2, p0, Luz/carhelper/passenger/PinDialog;->act:Landroid/app/Activity;
    invoke-virtual {v2}, Landroid/app/Activity;->recreate()V
    return-void
    :open_settings
    iget-object v2, p0, Luz/carhelper/passenger/PinDialog;->act:Landroid/app/Activity;
    new-instance v3, Landroid/content/Intent;
    const-class v4, Luz/carhelper/passenger/SettingsActivity;
    invoke-direct {v3, v2, v4}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {v2, v3}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    return-void
.end method

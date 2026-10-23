.class public Luz/carhelper/passenger/Lang;
.super Ljava/lang/Object;

# Language of LP Music's own screen: English, Russian, Spanish, Uzbek, Chinese (codes en ru es uz zh).
# Strings live in res/values (English, the default) and res/values-ru / -es / -uz / -zh; s() looks one up by
# name in the chosen language, whatever the system language is.
# Choice: prefs "music" / "lang" when the user picked one in Settings; otherwise the system language if it is
# Russian, Spanish, Uzbek or English; anything else (the car's default system language is Chinese) opens in
# English. Chinese is only ever selected by hand.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# one of the five codes?
.method public static known(Ljava/lang/String;)Z
    .locals 2
    const-string v0, "en"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :yes
    const-string v0, "ru"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :yes
    const-string v0, "es"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :yes
    const-string v0, "uz"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :yes
    const-string v0, "zh"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    return v1
    :yes
    const/4 v1, 0x1
    return v1
.end method

# name of a language in that language (never translated)
.method public static name(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    const-string v0, "ru"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_ru
    const-string v0, "Русский"
    return-object v0
    :not_ru
    const-string v0, "es"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_es
    const-string v0, "Español"
    return-object v0
    :not_es
    const-string v0, "uz"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_uz
    const-string v0, "Oʻzbekcha"
    return-object v0
    :not_uz
    const-string v0, "zh"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_zh
    const-string v0, "中文"
    return-object v0
    :not_zh
    const-string v0, "English"
    return-object v0
.end method

# the language in use: the saved choice, else the system language if supported, else English
.method public static chosen(Landroid/content/Context;)Ljava/lang/String;
    .locals 3
    :try_start_0
    const-string v0, "music"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "lang"
    const-string v2, ""
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :auto
    invoke-static {v0}, Luz/carhelper/passenger/Lang;->known(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :auto
    return-object v0
    :auto
    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;
    move-result-object v0
    invoke-virtual {v0}, Ljava/util/Locale;->getLanguage()Ljava/lang/String;
    move-result-object v0
    const-string v1, "ru"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :ret_system
    const-string v1, "es"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :ret_system
    const-string v1, "uz"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :ret_system
    const-string v0, "en"
    :ret_system
    return-object v0
.end method

# remember the user's choice
.method public static set(Landroid/content/Context;Ljava/lang/String;)V
    .locals 3
    const-string v0, "music"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v1, "lang"
    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    return-void
.end method

# a Context whose resources use the chosen language
.method public static ctx(Landroid/content/Context;)Landroid/content/Context;
    .locals 4
    invoke-static {p0}, Luz/carhelper/passenger/Lang;->chosen(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v0
    new-instance v1, Ljava/util/Locale;
    invoke-direct {v1, v0}, Ljava/util/Locale;-><init>(Ljava/lang/String;)V
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v3
    invoke-virtual {v3}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;
    move-result-object v3
    new-instance v2, Landroid/content/res/Configuration;
    invoke-direct {v2, v3}, Landroid/content/res/Configuration;-><init>(Landroid/content/res/Configuration;)V
    invoke-virtual {v2, v1}, Landroid/content/res/Configuration;->setLocale(Ljava/util/Locale;)V
    invoke-virtual {p0, v2}, Landroid/content/Context;->createConfigurationContext(Landroid/content/res/Configuration;)Landroid/content/Context;
    move-result-object v0
    return-object v0
.end method

# the string called p1 (res/values*/strings.xml) in the chosen language; the name itself if it is missing
.method public static s(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .locals 4
    :try_start_0
    invoke-static {p0}, Luz/carhelper/passenger/Lang;->ctx(Landroid/content/Context;)Landroid/content/Context;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v1
    const-string v2, "string"
    invoke-virtual {v0, p1, v2, v1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v2
    if-eqz v2, :miss
    invoke-virtual {v0, v2}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;
    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :miss
    return-object v0
    :miss
    return-object p1
.end method

.class public Luz/carhelper/passenger/Lang;
.super Ljava/lang/Object;

# Interface language. Every user-visible string in the code is its English text; Lang.t(english) returns the text in the
# chosen language (or the English text itself when there is no entry), so a missing translation just shows English.
# Translations are plain UTF-8 files in assets/lang/<code>.tsv: one "english<TAB>translation" per line.
#
# Which language: pref "lang" (uz, ru, es, en, zh) if the user picked one in Settings. Otherwise the system language
# when it is Uzbek, Russian, Spanish or English; anything else, including the car's default Chinese, starts in English.
# Everything runs in one process, so the static state is shared by the grid, Settings, the bubbles and the toasts.

.field private static cur:Ljava/lang/String;
.field private static map:Ljava/util/HashMap;
.field private static app:Landroid/content/Context;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# the languages in Settings order: Uzbek, Russian, Spanish, English, Chinese
.method public static codes()[Ljava/lang/String;
    .locals 3
    const/4 v0, 0x5
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "uz"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "ru"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    const-string v2, "es"
    aput-object v2, v0, v1
    const/4 v1, 0x3
    const-string v2, "en"
    aput-object v2, v0, v1
    const/4 v1, 0x4
    const-string v2, "zh"
    aput-object v2, v0, v1
    return-object v0
.end method

# the language's own name
.method public static label(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    const-string v0, "uz"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :not_uz
    const-string v0, "O'zbekcha"
    return-object v0
    :not_uz
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

# the code in use right now
.method public static code()Ljava/lang/String;
    .locals 1
    sget-object v0, Luz/carhelper/passenger/Lang;->cur:Ljava/lang/String;
    if-nez v0, :have
    const-string v0, "en"
    :have
    return-object v0
.end method

# the code chosen in Settings, or the automatic one
.method private static pick(Landroid/content/Context;)Ljava/lang/String;
    .locals 5
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v2, "lang"
    const/4 v3, 0x0
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :auto
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z
    move-result v2
    if-nez v2, :auto
    return-object v0
    :auto
    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;
    move-result-object v0
    invoke-virtual {v0}, Ljava/util/Locale;->getLanguage()Ljava/lang/String;
    move-result-object v0
    invoke-static {}, Luz/carhelper/passenger/Lang;->codes()[Ljava/lang/String;
    move-result-object v1
    array-length v2, v1
    const/4 v3, 0x0
    :next
    if-ge v3, v2, :none
    aget-object v4, v1, v3
    add-int/lit8 v3, v3, 0x1
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-eqz v4, :next
    # a Chinese system starts in English: Chinese has to be picked in Settings
    const-string v1, "zh"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :none
    return-object v0
    :none
    const-string v0, "en"
    return-object v0
.end method

# read assets/lang/<code>.tsv into the lookup table (a missing or unreadable file leaves English)
.method private static load(Ljava/lang/String;)V
    .locals 6
    const/4 v0, 0x0
    sput-object v0, Luz/carhelper/passenger/Lang;->map:Ljava/util/HashMap;
    sput-object p0, Luz/carhelper/passenger/Lang;->cur:Ljava/lang/String;
    sget-object v0, Luz/carhelper/passenger/Lang;->app:Landroid/content/Context;
    if-nez v0, :ready
    return-void
    :ready
    :try_start_0
    invoke-virtual {v0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;
    move-result-object v0
    new-instance v1, Ljava/lang/StringBuilder;
    const-string v2, "lang/"
    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v2, ".tsv"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;
    move-result-object v0
    new-instance v1, Ljava/io/BufferedReader;
    new-instance v2, Ljava/io/InputStreamReader;
    const-string v3, "UTF-8"
    invoke-direct {v2, v0, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    invoke-direct {v1, v2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v2, Ljava/util/HashMap;
    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V
    :line
    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v3
    if-eqz v3, :eof
    const/16 v4, 0x9
    invoke-virtual {v3, v4}, Ljava/lang/String;->indexOf(I)I
    move-result v4
    if-lez v4, :line
    const/4 v5, 0x0
    invoke-virtual {v3, v5, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v5
    add-int/lit8 v4, v4, 0x1
    invoke-virtual {v3, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v2, v5, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    goto :line
    :eof
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V
    sput-object v2, Luz/carhelper/passenger/Lang;->map:Ljava/util/HashMap;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

# call first thing in every entry point (grid, Settings, both bubble services)
.method public static init(Landroid/content/Context;)V
    .locals 2
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v0
    if-nez v0, :have_app
    move-object v0, p0
    :have_app
    sput-object v0, Luz/carhelper/passenger/Lang;->app:Landroid/content/Context;
    invoke-static {p0}, Luz/carhelper/passenger/Lang;->pick(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v0
    sget-object v1, Luz/carhelper/passenger/Lang;->cur:Ljava/lang/String;
    sget-object v1, Luz/carhelper/passenger/Lang;->map:Ljava/util/HashMap;
    if-eqz v1, :reload
    sget-object v1, Luz/carhelper/passenger/Lang;->cur:Ljava/lang/String;
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :done
    :reload
    invoke-static {v0}, Luz/carhelper/passenger/Lang;->load(Ljava/lang/String;)V
    :done
    return-void
.end method

# the user picked a language in Settings: remember it (now, not on Save) and switch
.method public static choose(Landroid/content/Context;Ljava/lang/String;)V
    .locals 3
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v2, "lang"
    invoke-interface {v0, v2, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-static {p1}, Luz/carhelper/passenger/Lang;->load(Ljava/lang/String;)V
    return-void
.end method

# the text in the chosen language; the English text itself when there is no translation
.method public static t(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    sget-object v0, Luz/carhelper/passenger/Lang;->map:Ljava/util/HashMap;
    if-nez v0, :have
    return-object p0
    :have
    invoke-virtual {v0, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    if-nez v0, :found
    return-object p0
    :found
    return-object v0
.end method

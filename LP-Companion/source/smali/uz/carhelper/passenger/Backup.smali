.class public Luz/carhelper/passenger/Backup;
.super Ljava/lang/Object;

# Settings backup and PIN recovery, both through Settings.Secure (needs the WRITE_SECURE_SETTINGS grant that LP Companion
# already asks for; without it everything here quietly does nothing).
#
# save():    after Settings, the tile menu and whenever a grid stops, the settings are written as one small JSON string to
#            Settings.Secure "lp_companion_backup". That key survives "pm clear" and an uninstall.
#            NOT in the backup: the password (pin), child mode on/off (kid) and the running/lastPassenger/onMain records.
# restore(): on the first start with empty data (no "setup" marker) and a backup present, the settings come back.
#            An update from an older version has no backup yet, so it only sets the marker.
# pinReset(): "adb shell settings put secure lp_companion_pin_reset 1", then open LP Companion: the password is cleared,
#            child mode is switched off, everything else stays. The key is set back to 0.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method private static bools()[Ljava/lang/String;
    .locals 3
    const/16 v0, 0xc
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "wheel"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "autoOpen"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    const-string v2, "resumeLast"
    aput-object v2, v0, v1
    const/4 v1, 0x3
    const-string v2, "passToMain"
    aput-object v2, v0, v1
    const/4 v1, 0x4
    const-string v2, "passFromMain"
    aput-object v2, v0, v1
    const/4 v1, 0x5
    const-string v2, "bubbleAuto"
    aput-object v2, v0, v1
    const/4 v1, 0x6
    const-string v2, "autoClose"
    aput-object v2, v0, v1
    const/4 v1, 0x7
    const-string v2, "closeMusic"
    aput-object v2, v0, v1
    const/16 v1, 0x8
    const-string v2, "overheat"
    aput-object v2, v0, v1
    const/16 v1, 0x9
    const-string v2, "healAdb"
    aput-object v2, v0, v1
    const/16 v1, 0xa
    const-string v2, "showStatus"
    aput-object v2, v0, v1
    const/16 v1, 0xb
    const-string v2, "moveRestart"
    aput-object v2, v0, v1
    return-object v0
.end method

.method private static ints()[Ljava/lang/String;
    .locals 3
    const/4 v0, 0x2
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "bubbleSecs"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "wallpaper"
    aput-object v2, v0, v1
    return-object v0
.end method

.method private static sets()[Ljava/lang/String;
    .locals 3
    const/4 v0, 0x2
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "kidApps"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "hidden"
    aput-object v2, v0, v1
    return-object v0
.end method

# the settings as a JSON string
.method private static json(Landroid/content/SharedPreferences;)Ljava/lang/String;
    .locals 6
    new-instance v0, Lorg/json/JSONObject;
    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V
    :try_start_0
    invoke-static {}, Luz/carhelper/passenger/Backup;->bools()[Ljava/lang/String;
    move-result-object v1
    const/4 v2, 0x0
    :bool_loop
    array-length v3, v1
    if-ge v2, v3, :bool_end
    aget-object v3, v1, v2
    add-int/lit8 v2, v2, 0x1
    invoke-interface {p0, v3}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z
    move-result v4
    if-eqz v4, :bool_loop
    const/4 v4, 0x0
    invoke-interface {p0, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v4
    invoke-virtual {v0, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    goto :bool_loop
    :bool_end

    invoke-static {}, Luz/carhelper/passenger/Backup;->ints()[Ljava/lang/String;
    move-result-object v1
    const/4 v2, 0x0
    :int_loop
    array-length v3, v1
    if-ge v2, v3, :int_end
    aget-object v3, v1, v2
    add-int/lit8 v2, v2, 0x1
    invoke-interface {p0, v3}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z
    move-result v4
    if-eqz v4, :int_loop
    const/4 v4, 0x0
    invoke-interface {p0, v3, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v4
    invoke-virtual {v0, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    goto :int_loop
    :int_end

    invoke-static {}, Luz/carhelper/passenger/Backup;->sets()[Ljava/lang/String;
    move-result-object v1
    const/4 v2, 0x0
    :set_loop
    array-length v3, v1
    if-ge v2, v3, :set_end
    aget-object v3, v1, v2
    add-int/lit8 v2, v2, 0x1
    const/4 v4, 0x0
    invoke-interface {p0, v3, v4}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;
    move-result-object v4
    if-eqz v4, :set_loop
    new-instance v5, Lorg/json/JSONArray;
    invoke-direct {v5, v4}, Lorg/json/JSONArray;-><init>(Ljava/util/Collection;)V
    invoke-virtual {v0, v3, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    goto :set_loop
    :set_end

    # the interface language, if one was picked
    const-string v3, "lang"
    const/4 v4, 0x0
    invoke-interface {p0, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :no_lang
    invoke-virtual {v0, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :no_lang

    # the record of apps installed from the file manager (the only ones Uninstall may remove)
    const-string v3, "installed"
    const/4 v4, 0x0
    invoke-interface {p0, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :no_installed
    invoke-virtual {v0, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :no_installed
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

# write the backup (only when it changed)
.method public static save(Landroid/content/Context;)V
    .locals 4
    :try_start_0
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-static {v0}, Luz/carhelper/passenger/Backup;->json(Landroid/content/SharedPreferences;)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v1
    const-string v2, "lp_companion_backup"
    invoke-static {v1, v2}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :done
    invoke-static {v1, v2, v0}, Landroid/provider/Settings$Secure;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z
    :done
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

# first start with empty data: bring the settings back from the backup
.method public static restore(Landroid/content/Context;)V
    .locals 9
    :try_start_0
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v2, "setup"
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z
    move-result v3
    if-nez v3, :done
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v3
    const/4 v4, 0x1
    invoke-interface {v3, v2, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v4
    const-string v5, "lp_companion_backup"
    invoke-static {v4, v5}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :commit
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z
    move-result v5
    if-nez v5, :commit
    new-instance v5, Lorg/json/JSONObject;
    invoke-direct {v5, v4}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    # booleans
    invoke-static {}, Luz/carhelper/passenger/Backup;->bools()[Ljava/lang/String;
    move-result-object v4
    const/4 v6, 0x0
    :bool_loop
    array-length v7, v4
    if-ge v6, v7, :bool_end
    aget-object v7, v4, v6
    add-int/lit8 v6, v6, 0x1
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :bool_loop
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->getBoolean(Ljava/lang/String;)Z
    move-result v1
    invoke-interface {v3, v7, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    goto :bool_loop
    :bool_end

    # integers
    invoke-static {}, Luz/carhelper/passenger/Backup;->ints()[Ljava/lang/String;
    move-result-object v4
    const/4 v6, 0x0
    :int_loop
    array-length v7, v4
    if-ge v6, v7, :int_end
    aget-object v7, v4, v6
    add-int/lit8 v6, v6, 0x1
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :int_loop
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I
    move-result v1
    invoke-interface {v3, v7, v1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    goto :int_loop
    :int_end

    # string sets (Kids, hidden)
    invoke-static {}, Luz/carhelper/passenger/Backup;->sets()[Ljava/lang/String;
    move-result-object v4
    const/4 v6, 0x0
    :set_loop
    array-length v7, v4
    if-ge v6, v7, :set_end
    aget-object v7, v4, v6
    add-int/lit8 v6, v6, 0x1
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :set_loop
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v1
    new-instance v2, Ljava/util/HashSet;
    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V
    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I
    move-result v0
    :arr_loop
    add-int/lit8 v0, v0, -0x1
    if-ltz v0, :arr_end
    invoke-virtual {v1, v0}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;
    move-result-object v8
    invoke-virtual {v2, v8}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    goto :arr_loop
    :arr_end
    invoke-interface {v3, v7, v2}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;
    goto :set_loop
    :set_end

    # the interface language, if one was backed up
    const-string v7, "lang"
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :no_lang_back
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-interface {v3, v7, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    :no_lang_back

    # the record of apps installed from the file manager
    const-string v7, "installed"
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :commit
    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-interface {v3, v7, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    :commit
    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V
    # data was empty: make the Settings.Secure child-mode flag (read by LP Music) agree with the real, now empty, state
    const-string v0, "apps"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v2, "kid"
    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    invoke-static {p0, v0}, Luz/carhelper/passenger/ChildMode;->sync(Landroid/content/Context;Z)V
    :done
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

# "adb shell settings put secure lp_companion_pin_reset 1" and open LP Companion: forget the password, leave child mode
.method public static pinReset(Landroid/content/Context;)V
    .locals 5
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    const-string v1, "lp_companion_pin_reset"
    invoke-static {v0, v1}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const-string v3, "1"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :done
    const-string v2, "apps"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v3, "pin"
    invoke-interface {v2, v3}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const-string v3, "kid"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-static {p0, v4}, Luz/carhelper/passenger/ChildMode;->sync(Landroid/content/Context;Z)V
    const-string v2, "0"
    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Secure;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z
    const-string v2, "LP Companion: password cleared, child mode is off"
    invoke-static {v2}, Luz/carhelper/passenger/Lang;->t(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    const/4 v3, 0x1
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    :done
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

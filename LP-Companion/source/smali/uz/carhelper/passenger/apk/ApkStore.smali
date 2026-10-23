.class final Luz/carhelper/passenger/apk/ApkStore;
.super Ljava/lang/Object;
.source "ApkStore.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Luz/carhelper/passenger/apk/ApkStore$Entry;
    }
.end annotation


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static add(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 3

    .line 70
    invoke-static {p0}, Luz/carhelper/passenger/apk/ApkStore;->all(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    .line 71
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    :goto_0
    if-ltz v1, :cond_1

    .line 72
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Luz/carhelper/passenger/apk/ApkStore$Entry;

    iget-object v2, v2, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 73
    invoke-interface {v0, v1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    :cond_0
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    .line 76
    :cond_1
    new-instance v1, Luz/carhelper/passenger/apk/ApkStore$Entry;

    invoke-direct {v1}, Luz/carhelper/passenger/apk/ApkStore$Entry;-><init>()V

    .line 77
    iput-object p1, v1, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    .line 78
    iput-object p2, v1, Luz/carhelper/passenger/apk/ApkStore$Entry;->label:Ljava/lang/String;

    if-nez p3, :cond_2

    .line 79
    const-string p3, ""

    :cond_2
    iput-object p3, v1, Luz/carhelper/passenger/apk/ApkStore$Entry;->version:Ljava/lang/String;

    .line 80
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p1

    iput-wide p1, v1, Luz/carhelper/passenger/apk/ApkStore$Entry;->time:J

    .line 81
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 82
    invoke-static {p0, v0}, Luz/carhelper/passenger/apk/ApkStore;->save(Landroid/content/Context;Ljava/util/List;)V

    return-void
.end method

.method static all(Landroid/content/Context;)Ljava/util/List;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/List<",
            "Luz/carhelper/passenger/apk/ApkStore$Entry;",
            ">;"
        }
    .end annotation

    .line 35
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 37
    :try_start_0
    new-instance v1, Lorg/json/JSONArray;

    invoke-static {p0}, Luz/carhelper/passenger/apk/ApkStore;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v2, "installed"

    const-string v3, "[]"

    invoke-interface {p0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v1, p0}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    const/4 p0, 0x0

    .line 38
    :goto_0
    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge p0, v2, :cond_0

    .line 39
    invoke-virtual {v1, p0}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    .line 40
    new-instance v3, Luz/carhelper/passenger/apk/ApkStore$Entry;

    invoke-direct {v3}, Luz/carhelper/passenger/apk/ApkStore$Entry;-><init>()V

    .line 41
    const-string v4, "p"

    invoke-virtual {v2, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iput-object v4, v3, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    .line 42
    const-string v4, "l"

    iget-object v5, v3, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    invoke-virtual {v2, v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iput-object v4, v3, Luz/carhelper/passenger/apk/ApkStore$Entry;->label:Ljava/lang/String;

    .line 43
    const-string v4, "v"

    const-string v5, ""

    invoke-virtual {v2, v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iput-object v4, v3, Luz/carhelper/passenger/apk/ApkStore$Entry;->version:Ljava/lang/String;

    .line 44
    const-string v4, "t"

    const-wide/16 v5, 0x0

    invoke-virtual {v2, v4, v5, v6}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v4

    iput-wide v4, v3, Luz/carhelper/passenger/apk/ApkStore$Entry;->time:J

    .line 45
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    add-int/lit8 p0, p0, 0x1

    goto :goto_0

    :catch_0
    :cond_0
    return-object v0
.end method

.method private static prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 31
    const-string v0, "apps"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method static remove(Landroid/content/Context;Ljava/lang/String;)V
    .locals 3

    .line 86
    invoke-static {p0}, Luz/carhelper/passenger/apk/ApkStore;->all(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    .line 87
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    :goto_0
    if-ltz v1, :cond_1

    .line 88
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Luz/carhelper/passenger/apk/ApkStore$Entry;

    iget-object v2, v2, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 89
    invoke-interface {v0, v1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    :cond_0
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    .line 92
    :cond_1
    invoke-static {p0, v0}, Luz/carhelper/passenger/apk/ApkStore;->save(Landroid/content/Context;Ljava/util/List;)V

    return-void
.end method

.method private static save(Landroid/content/Context;Ljava/util/List;)V
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/List<",
            "Luz/carhelper/passenger/apk/ApkStore$Entry;",
            ">;)V"
        }
    .end annotation

    .line 54
    :try_start_0
    new-instance v0, Lorg/json/JSONArray;

    invoke-direct {v0}, Lorg/json/JSONArray;-><init>()V

    .line 55
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Luz/carhelper/passenger/apk/ApkStore$Entry;

    .line 56
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    .line 57
    const-string v3, "p"

    iget-object v4, v1, Luz/carhelper/passenger/apk/ApkStore$Entry;->pkg:Ljava/lang/String;

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 58
    const-string v3, "l"

    iget-object v4, v1, Luz/carhelper/passenger/apk/ApkStore$Entry;->label:Ljava/lang/String;

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 59
    const-string v3, "v"

    iget-object v4, v1, Luz/carhelper/passenger/apk/ApkStore$Entry;->version:Ljava/lang/String;

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 60
    const-string v3, "t"

    iget-wide v4, v1, Luz/carhelper/passenger/apk/ApkStore$Entry;->time:J

    invoke-virtual {v2, v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    .line 61
    invoke-virtual {v0, v2}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    goto :goto_0

    .line 63
    :cond_0
    invoke-static {p0}, Luz/carhelper/passenger/apk/ApkStore;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string v1, "installed"

    invoke-virtual {v0}, Lorg/json/JSONArray;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-interface {p1, v1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 64
    invoke-static {p0}, Luz/carhelper/passenger/Backup;->save(Landroid/content/Context;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :catchall_0
    return-void
.end method

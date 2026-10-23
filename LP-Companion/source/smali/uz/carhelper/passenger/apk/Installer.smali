.class final Luz/carhelper/passenger/apk/Installer;
.super Ljava/lang/Object;
.source "Installer.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Luz/carhelper/passenger/apk/Installer$Done;
    }
.end annotation


# static fields
.field static final APPROVE_SECONDS:I = 0x5a

.field static final HOST:Ljava/lang/String; = "127.0.0.1"

.field static final PORT:I = 0x15b3


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;)V
    .locals 0

    .line 13
    invoke-static {p0}, Luz/carhelper/passenger/apk/Installer;->link(Landroid/content/Context;)V

    return-void
.end method

.method static allFiles()Z
    .locals 1

    .line 43
    :try_start_0
    invoke-static {}, Landroid/os/Environment;->isExternalStorageManager()Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return v0

    :catchall_0
    const/4 v0, 0x0

    return v0
.end method

.method static explain(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    const/16 v0, 0x7c

    .line 51
    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    if-gez v0, :cond_0

    .line 52
    const-string v1, "FAIL"

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    :goto_0
    if-gez v0, :cond_1

    goto :goto_1

    :cond_1
    add-int/lit8 v0, v0, 0x1

    .line 53
    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    .line 54
    :goto_1
    const-string v0, "NOCONN"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 55
    const-string p0, "Could not reach the car\'s ADB (port 5555)"

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 57
    :cond_2
    const-string v0, "AUTH"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 58
    const-string p0, "Allow the connection on the car\'s screen (Always allow), then try again"

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 60
    :cond_3
    const-string v0, "TLS"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 61
    const-string p0, "The car\'s ADB is in wireless-debugging mode (TLS). Classic network ADB on port 5555 is needed."

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 63
    :cond_4
    invoke-static {p0}, Luz/carhelper/passenger/apk/Installer;->reason(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_5

    return-object p0

    :cond_5
    return-object p1
.end method

.method static grantAllFiles(Landroid/app/Activity;Luz/carhelper/passenger/apk/Installer$Done;)V
    .locals 2

    .line 135
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Luz/carhelper/passenger/apk/Installer$3;

    invoke-direct {v1, p0, p1}, Luz/carhelper/passenger/apk/Installer$3;-><init>(Landroid/app/Activity;Luz/carhelper/passenger/apk/Installer$Done;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 148
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method static install(Landroid/app/Activity;Ljava/io/File;ZLuz/carhelper/passenger/adb/AdbProgress;Luz/carhelper/passenger/apk/Installer$Done;)V
    .locals 8

    .line 101
    new-instance v0, Ljava/lang/Thread;

    new-instance v7, Luz/carhelper/passenger/apk/Installer$1;

    move-object v1, v7

    move-object v2, p0

    move-object v3, p1

    move v4, p2

    move-object v5, p3

    move-object v6, p4

    invoke-direct/range {v1 .. v6}, Luz/carhelper/passenger/apk/Installer$1;-><init>(Landroid/app/Activity;Ljava/io/File;ZLuz/carhelper/passenger/adb/AdbProgress;Luz/carhelper/passenger/apk/Installer$Done;)V

    invoke-direct {v0, v7}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 113
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method static keyPath(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 28
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    const-string v1, "adbkey"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static link(Landroid/content/Context;)V
    .locals 3

    .line 33
    const-string v0, "apps"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "healAdb"

    const/4 v2, 0x1

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    const-string v1, "127.0.0.1"

    const/16 v2, 0x15b3

    invoke-static {p0, v1, v2, v0}, Luz/carhelper/passenger/apk/AdbLink;->ensure(Landroid/content/Context;Ljava/lang/String;IZ)Z

    return-void
.end method

.method private static reason(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 72
    const-string v0, "INSTALL_FAILED_VERSION_DOWNGRADE"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 73
    const-string p0, "A newer version is already installed. Downgrading is not allowed."

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 75
    :cond_0
    const-string v0, "INSTALL_FAILED_UPDATE_INCOMPATIBLE"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_a

    const-string v0, "INSTALL_FAILED_SHARED_USER_INCOMPATIBLE"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_2

    .line 78
    :cond_1
    const-string v0, "INSTALL_FAILED_INSUFFICIENT_STORAGE"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 79
    const-string p0, "Not enough free storage on the car."

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 81
    :cond_2
    const-string v0, "INSTALL_FAILED_NO_MATCHING_ABIS"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 82
    const-string p0, "The app is built for a different processor type."

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 84
    :cond_3
    const-string v0, "INSTALL_FAILED_OLDER_SDK"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 85
    const-string p0, "The app needs a newer Android version than this car has."

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 87
    :cond_4
    const-string v0, "INSTALL_PARSE_FAILED"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_9

    const-string v0, "INSTALL_FAILED_INVALID_APK"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_5

    goto :goto_1

    .line 90
    :cond_5
    const-string v0, "INSTALL_FAILED_USER_RESTRICTED"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_8

    const-string v0, "INSTALL_FAILED_VERIFICATION_FAILURE"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_6

    goto :goto_0

    .line 93
    :cond_6
    const-string v0, "DELETE_FAILED_DEVICE_POLICY_MANAGER"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_7

    .line 94
    const-string p0, "The car does not allow removing this app."

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_7
    const/4 p0, 0x0

    return-object p0

    .line 91
    :cond_8
    :goto_0
    const-string p0, "The car refused this install."

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 88
    :cond_9
    :goto_1
    const-string p0, "The file is not a valid app."

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 76
    :cond_a
    :goto_2
    const-string p0, "The installed copy was signed with a different key. Uninstall it first (its data is lost)."

    invoke-static {p0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static uninstall(Landroid/app/Activity;Ljava/lang/String;Luz/carhelper/passenger/apk/Installer$Done;)V
    .locals 2

    .line 118
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Luz/carhelper/passenger/apk/Installer$2;

    invoke-direct {v1, p0, p1, p2}, Luz/carhelper/passenger/apk/Installer$2;-><init>(Landroid/app/Activity;Ljava/lang/String;Luz/carhelper/passenger/apk/Installer$Done;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 130
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method static userId()I
    .locals 2

    .line 37
    invoke-static {}, Landroid/os/Process;->myUid()I

    move-result v0

    const v1, 0x186a0

    div-int/2addr v0, v1

    return v0
.end method

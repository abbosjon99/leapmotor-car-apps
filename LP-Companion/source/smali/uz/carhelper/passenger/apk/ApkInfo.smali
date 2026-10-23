.class final Luz/carhelper/passenger/apk/ApkInfo;
.super Ljava/lang/Object;
.source "ApkInfo.java"


# static fields
.field private static final SENSITIVE:[[Ljava/lang/String;


# instance fields
.field icon:Landroid/graphics/drawable/Drawable;

.field installed:Z

.field installedVersionCode:J

.field installedVersionName:Ljava/lang/String;

.field label:Ljava/lang/String;

.field permissionCount:I

.field pkg:Ljava/lang/String;

.field sameSigner:Z

.field self:Z

.field sensitive:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field size:J

.field versionCode:J

.field versionName:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 26

    .line 37
    const-string v0, "android.permission.CAMERA"

    const-string v1, "Camera"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v2

    const-string v0, "android.permission.RECORD_AUDIO"

    const-string v1, "Microphone"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v3

    const-string v0, "android.permission.ACCESS_FINE_LOCATION"

    const-string v1, "Location"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v4

    const-string v0, "android.permission.ACCESS_COARSE_LOCATION"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v5

    const-string v0, "android.permission.ACCESS_BACKGROUND_LOCATION"

    const-string v1, "Location in the background"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v6

    const-string v0, "android.permission.READ_CONTACTS"

    const-string v1, "Contacts"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v7

    const-string v0, "android.permission.WRITE_CONTACTS"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v8

    const-string v0, "android.permission.READ_SMS"

    const-string v1, "SMS"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v9

    const-string v0, "android.permission.SEND_SMS"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v10

    const-string v0, "android.permission.RECEIVE_SMS"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v11

    const-string v0, "android.permission.READ_CALL_LOG"

    const-string v1, "Call log"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v12

    const-string v0, "android.permission.CALL_PHONE"

    const-string v1, "Phone calls"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v13

    const-string v0, "android.permission.READ_PHONE_STATE"

    const-string v1, "Phone state"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v14

    const-string v0, "android.permission.READ_EXTERNAL_STORAGE"

    const-string v1, "Files"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v15

    const-string v0, "android.permission.WRITE_EXTERNAL_STORAGE"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v16

    const-string v0, "android.permission.MANAGE_EXTERNAL_STORAGE"

    const-string v1, "All files"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v17

    const-string v0, "android.permission.SYSTEM_ALERT_WINDOW"

    const-string v1, "Draw over other apps"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v18

    const-string v0, "android.permission.REQUEST_INSTALL_PACKAGES"

    const-string v1, "Install other apps"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v19

    const-string v0, "android.permission.BIND_ACCESSIBILITY_SERVICE"

    const-string v1, "Accessibility"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v20

    const-string v0, "android.permission.BIND_DEVICE_ADMIN"

    const-string v1, "Device admin"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v21

    const-string v0, "android.permission.QUERY_ALL_PACKAGES"

    const-string v1, "See all installed apps"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v22

    const-string v0, "android.permission.WRITE_SETTINGS"

    const-string v1, "Change system settings"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v23

    const-string v0, "android.permission.BODY_SENSORS"

    const-string v1, "Body sensors"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v24

    const-string v0, "android.permission.READ_CALENDAR"

    const-string v1, "Calendar"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v25

    filled-new-array/range {v2 .. v25}, [[Ljava/lang/String;

    move-result-object v0

    sput-object v0, Luz/carhelper/passenger/apk/ApkInfo;->SENSITIVE:[[Ljava/lang/String;

    return-void
.end method

.method constructor <init>()V
    .locals 2

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 22
    const-string v0, ""

    iput-object v0, p0, Luz/carhelper/passenger/apk/ApkInfo;->versionName:Ljava/lang/String;

    .line 28
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Luz/carhelper/passenger/apk/ApkInfo;->sensitive:Ljava/util/List;

    .line 30
    iput-object v0, p0, Luz/carhelper/passenger/apk/ApkInfo;->installedVersionName:Ljava/lang/String;

    const/4 v0, 0x1

    .line 33
    iput-boolean v0, p0, Luz/carhelper/passenger/apk/ApkInfo;->sameSigner:Z

    return-void
.end method

.method static read(Landroid/content/Context;Ljava/io/File;)Luz/carhelper/passenger/apk/ApkInfo;
    .locals 16

    .line 67
    :try_start_0
    invoke-virtual/range {p0 .. p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    .line 68
    invoke-virtual/range {p1 .. p1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v2

    const v3, 0x8001000

    .line 69
    invoke-virtual {v1, v2, v3}, Landroid/content/pm/PackageManager;->getPackageArchiveInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v3

    if-eqz v3, :cond_9

    .line 71
    iget-object v4, v3, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    if-nez v4, :cond_0

    goto/16 :goto_7

    .line 74
    :cond_0
    new-instance v4, Luz/carhelper/passenger/apk/ApkInfo;

    invoke-direct {v4}, Luz/carhelper/passenger/apk/ApkInfo;-><init>()V

    .line 75
    iget-object v5, v3, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    iput-object v5, v4, Luz/carhelper/passenger/apk/ApkInfo;->pkg:Ljava/lang/String;

    .line 76
    invoke-virtual/range {p1 .. p1}, Ljava/io/File;->length()J

    move-result-wide v5

    iput-wide v5, v4, Luz/carhelper/passenger/apk/ApkInfo;->size:J

    .line 77
    iget-object v5, v3, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const-string v6, ""

    if-nez v5, :cond_1

    move-object v5, v6

    goto :goto_0

    :cond_1
    :try_start_1
    iget-object v5, v3, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    :goto_0
    iput-object v5, v4, Luz/carhelper/passenger/apk/ApkInfo;->versionName:Ljava/lang/String;

    .line 78
    invoke-virtual {v3}, Landroid/content/pm/PackageInfo;->getLongVersionCode()J

    move-result-wide v7

    iput-wide v7, v4, Luz/carhelper/passenger/apk/ApkInfo;->versionCode:J

    .line 79
    iget-object v5, v3, Landroid/content/pm/PackageInfo;->applicationInfo:Landroid/content/pm/ApplicationInfo;

    if-eqz v5, :cond_3

    .line 81
    iput-object v2, v5, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    .line 82
    iput-object v2, v5, Landroid/content/pm/ApplicationInfo;->publicSourceDir:Ljava/lang/String;

    .line 83
    invoke-virtual {v5, v1}, Landroid/content/pm/ApplicationInfo;->loadLabel(Landroid/content/pm/PackageManager;)Ljava/lang/CharSequence;

    move-result-object v2

    if-nez v2, :cond_2

    .line 84
    iget-object v2, v4, Luz/carhelper/passenger/apk/ApkInfo;->pkg:Ljava/lang/String;

    goto :goto_1

    :cond_2
    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    :goto_1
    iput-object v2, v4, Luz/carhelper/passenger/apk/ApkInfo;->label:Ljava/lang/String;

    .line 85
    invoke-virtual {v5, v1}, Landroid/content/pm/ApplicationInfo;->loadIcon(Landroid/content/pm/PackageManager;)Landroid/graphics/drawable/Drawable;

    move-result-object v2

    iput-object v2, v4, Luz/carhelper/passenger/apk/ApkInfo;->icon:Landroid/graphics/drawable/Drawable;

    goto :goto_2

    .line 87
    :cond_3
    iget-object v2, v4, Luz/carhelper/passenger/apk/ApkInfo;->pkg:Ljava/lang/String;

    iput-object v2, v4, Luz/carhelper/passenger/apk/ApkInfo;->label:Ljava/lang/String;

    .line 89
    :goto_2
    iget-object v2, v3, Landroid/content/pm/PackageInfo;->requestedPermissions:[Ljava/lang/String;

    const/4 v5, 0x1

    const/4 v7, 0x0

    if-eqz v2, :cond_6

    .line 90
    iget-object v2, v3, Landroid/content/pm/PackageInfo;->requestedPermissions:[Ljava/lang/String;

    array-length v2, v2

    iput v2, v4, Luz/carhelper/passenger/apk/ApkInfo;->permissionCount:I

    .line 91
    new-instance v2, Ljava/util/HashSet;

    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V

    .line 92
    iget-object v8, v3, Landroid/content/pm/PackageInfo;->requestedPermissions:[Ljava/lang/String;

    array-length v9, v8

    move v10, v7

    :goto_3
    if-ge v10, v9, :cond_6

    aget-object v11, v8, v10

    .line 93
    sget-object v12, Luz/carhelper/passenger/apk/ApkInfo;->SENSITIVE:[[Ljava/lang/String;

    array-length v13, v12

    move v14, v7

    :goto_4
    if-ge v14, v13, :cond_5

    aget-object v15, v12, v14

    .line 94
    aget-object v0, v15, v7

    invoke-virtual {v0, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    aget-object v0, v15, v5

    invoke-interface {v2, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 95
    iget-object v0, v4, Luz/carhelper/passenger/apk/ApkInfo;->sensitive:Ljava/util/List;

    aget-object v15, v15, v5

    invoke-interface {v0, v15}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_4
    add-int/lit8 v14, v14, 0x1

    goto :goto_4

    :cond_5
    add-int/lit8 v10, v10, 0x1

    goto :goto_3

    .line 100
    :cond_6
    iget-object v0, v4, Luz/carhelper/passenger/apk/ApkInfo;->pkg:Ljava/lang/String;

    invoke-virtual/range {p0 .. p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    iput-boolean v0, v4, Luz/carhelper/passenger/apk/ApkInfo;->self:Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 102
    :try_start_2
    iget-object v0, v4, Luz/carhelper/passenger/apk/ApkInfo;->pkg:Ljava/lang/String;

    const/high16 v2, 0x8000000

    invoke-virtual {v1, v0, v2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v0

    .line 103
    iput-boolean v5, v4, Luz/carhelper/passenger/apk/ApkInfo;->installed:Z

    .line 104
    iget-object v1, v0, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    if-nez v1, :cond_7

    goto :goto_5

    :cond_7
    iget-object v6, v0, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    :goto_5
    iput-object v6, v4, Luz/carhelper/passenger/apk/ApkInfo;->installedVersionName:Ljava/lang/String;

    .line 105
    invoke-virtual {v0}, Landroid/content/pm/PackageInfo;->getLongVersionCode()J

    move-result-wide v1

    iput-wide v1, v4, Luz/carhelper/passenger/apk/ApkInfo;->installedVersionCode:J

    .line 106
    iget-object v1, v3, Landroid/content/pm/PackageInfo;->signingInfo:Landroid/content/pm/SigningInfo;

    invoke-static {v1}, Luz/carhelper/passenger/apk/ApkInfo;->signers(Landroid/content/pm/SigningInfo;)Ljava/util/Set;

    move-result-object v1

    .line 107
    iget-object v0, v0, Landroid/content/pm/PackageInfo;->signingInfo:Landroid/content/pm/SigningInfo;

    invoke-static {v0}, Luz/carhelper/passenger/apk/ApkInfo;->signers(Landroid/content/pm/SigningInfo;)Ljava/util/Set;

    move-result-object v0

    if-eqz v1, :cond_8

    if-eqz v0, :cond_8

    .line 108
    invoke-interface {v1, v0}, Ljava/util/Set;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_8

    .line 109
    iput-boolean v7, v4, Luz/carhelper/passenger/apk/ApkInfo;->sameSigner:Z
    :try_end_2
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_6

    .line 112
    :catch_0
    :try_start_3
    iput-boolean v7, v4, Luz/carhelper/passenger/apk/ApkInfo;->installed:Z
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :cond_8
    :goto_6
    return-object v4

    :cond_9
    :goto_7
    const/4 v0, 0x0

    return-object v0

    :catchall_0
    const/4 v0, 0x0

    return-object v0
.end method

.method private static signers(Landroid/content/pm/SigningInfo;)Ljava/util/Set;
    .locals 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/pm/SigningInfo;",
            ")",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 126
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Landroid/content/pm/SigningInfo;->getApkContentsSigners()[Landroid/content/pm/Signature;

    move-result-object p0

    if-eqz p0, :cond_4

    .line 127
    array-length v1, p0

    if-nez v1, :cond_1

    goto :goto_2

    .line 130
    :cond_1
    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    .line 131
    array-length v2, p0

    const/4 v3, 0x0

    move v4, v3

    :goto_0
    if-ge v4, v2, :cond_3

    aget-object v5, p0, v4

    .line 132
    const-string v6, "SHA-256"

    invoke-static {v6}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v6

    invoke-virtual {v5}, Landroid/content/pm/Signature;->toByteArray()[B

    move-result-object v5

    invoke-virtual {v6, v5}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object v5

    .line 133
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    .line 134
    array-length v7, v5

    move v8, v3

    :goto_1
    if-ge v8, v7, :cond_2

    aget-byte v9, v5, v8

    .line 135
    const-string v10, "%02x"

    invoke-static {v9}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v9

    filled-new-array {v9}, [Ljava/lang/Object;

    move-result-object v9

    invoke-static {v10, v9}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v6, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v8, v8, 0x1

    goto :goto_1

    .line 137
    :cond_2
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-interface {v1, v5}, Ljava/util/Set;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_3
    return-object v1

    :catch_0
    :cond_4
    :goto_2
    return-object v0
.end method

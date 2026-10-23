.class final Luz/carhelper/passenger/adb/AdbConnection$Msg;
.super Ljava/lang/Object;
.source "AdbConnection.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Luz/carhelper/passenger/adb/AdbConnection;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Msg"
.end annotation


# instance fields
.field arg0:I

.field arg1:I

.field cmd:I

.field data:[B


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Luz/carhelper/passenger/adb/AdbConnection$1;)V
    .locals 0

    .line 30
    invoke-direct {p0}, Luz/carhelper/passenger/adb/AdbConnection$Msg;-><init>()V

    return-void
.end method

.class public final Luz/carhelper/passenger/adb/AdbException;
.super Ljava/lang/Exception;
.source "AdbException.java"


# instance fields
.field public final code:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 8
    invoke-direct {p0, p2}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    .line 9
    iput-object p1, p0, Luz/carhelper/passenger/adb/AdbException;->code:Ljava/lang/String;

    return-void
.end method

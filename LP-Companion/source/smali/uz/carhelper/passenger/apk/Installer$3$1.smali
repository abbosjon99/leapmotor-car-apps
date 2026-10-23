.class Luz/carhelper/passenger/apk/Installer$3$1;
.super Ljava/lang/Object;
.source "Installer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/Installer$3;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Luz/carhelper/passenger/apk/Installer$3;

.field final synthetic val$r:Ljava/lang/String;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/Installer$3;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010
        }
        names = {
            null,
            null
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 140
    iput-object p1, p0, Luz/carhelper/passenger/apk/Installer$3$1;->this$0:Luz/carhelper/passenger/apk/Installer$3;

    iput-object p2, p0, Luz/carhelper/passenger/apk/Installer$3$1;->val$r:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 142
    iget-object v0, p0, Luz/carhelper/passenger/apk/Installer$3$1;->this$0:Luz/carhelper/passenger/apk/Installer$3;

    iget-object v0, v0, Luz/carhelper/passenger/apk/Installer$3;->val$done:Luz/carhelper/passenger/apk/Installer$Done;

    iget-object v1, p0, Luz/carhelper/passenger/apk/Installer$3$1;->val$r:Ljava/lang/String;

    const-string v2, "OK|"

    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    iget-object v3, p0, Luz/carhelper/passenger/apk/Installer$3$1;->val$r:Ljava/lang/String;

    invoke-virtual {v3, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    const-string v2, "Permissions granted through the car\'s ADB"

    invoke-static {v2}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    goto :goto_0

    .line 143
    :cond_0
    iget-object v2, p0, Luz/carhelper/passenger/apk/Installer$3$1;->val$r:Ljava/lang/String;

    const-string v3, "Could not grant the permissions"

    invoke-static {v3}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Luz/carhelper/passenger/apk/Installer;->explain(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    :goto_0
    iget-object v3, p0, Luz/carhelper/passenger/apk/Installer$3$1;->val$r:Ljava/lang/String;

    .line 142
    invoke-interface {v0, v1, v2, v3}, Luz/carhelper/passenger/apk/Installer$Done;->done(ZLjava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.class Luz/carhelper/passenger/apk/ApkManagerActivity$2;
.super Ljava/lang/Object;
.source "ApkManagerActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/ApkManagerActivity;->refresh()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/ApkManagerActivity;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 108
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$2;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 110
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$2;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-virtual {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    const-string v0, "Trying to grant the permissions\u2026"

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {p1, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 111
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$2;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    new-instance v0, Luz/carhelper/passenger/apk/ApkManagerActivity$2$1;

    invoke-direct {v0, p0}, Luz/carhelper/passenger/apk/ApkManagerActivity$2$1;-><init>(Luz/carhelper/passenger/apk/ApkManagerActivity$2;)V

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/Installer;->grantAllFiles(Landroid/app/Activity;Luz/carhelper/passenger/apk/Installer$Done;)V

    return-void
.end method

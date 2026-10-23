.class Luz/carhelper/passenger/apk/ApkManagerActivity$2$1;
.super Ljava/lang/Object;
.source "ApkManagerActivity.java"

# interfaces
.implements Luz/carhelper/passenger/apk/Installer$Done;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/ApkManagerActivity$2;->onClick(Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Luz/carhelper/passenger/apk/ApkManagerActivity$2;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/ApkManagerActivity$2;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 111
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$2$1;->this$1:Luz/carhelper/passenger/apk/ApkManagerActivity$2;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public done(ZLjava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 113
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$2$1;->this$1:Luz/carhelper/passenger/apk/ApkManagerActivity$2;

    iget-object p1, p1, Luz/carhelper/passenger/apk/ApkManagerActivity$2;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-virtual {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    const/4 p3, 0x1

    invoke-static {p1, p2, p3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 114
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$2$1;->this$1:Luz/carhelper/passenger/apk/ApkManagerActivity$2;

    iget-object p1, p1, Luz/carhelper/passenger/apk/ApkManagerActivity$2;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$000(Luz/carhelper/passenger/apk/ApkManagerActivity;)V

    return-void
.end method

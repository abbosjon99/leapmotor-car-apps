.class Luz/carhelper/passenger/apk/ApkManagerActivity$6$1;
.super Ljava/lang/Object;
.source "ApkManagerActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/ApkManagerActivity$6;->onClick(Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Luz/carhelper/passenger/apk/ApkManagerActivity$6;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/ApkManagerActivity$6;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 220
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$6$1;->this$1:Luz/carhelper/passenger/apk/ApkManagerActivity$6;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 222
    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$6$1;->this$1:Luz/carhelper/passenger/apk/ApkManagerActivity$6;

    iget-object v0, v0, Luz/carhelper/passenger/apk/ApkManagerActivity$6;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {v0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$000(Luz/carhelper/passenger/apk/ApkManagerActivity;)V

    return-void
.end method

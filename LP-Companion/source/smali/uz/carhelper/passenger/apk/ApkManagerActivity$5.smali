.class Luz/carhelper/passenger/apk/ApkManagerActivity$5;
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

    .line 175
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$5;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 1

    .line 177
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$5;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$200(Luz/carhelper/passenger/apk/ApkManagerActivity;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v0

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$202(Luz/carhelper/passenger/apk/ApkManagerActivity;Ljava/io/File;)Ljava/io/File;

    .line 178
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$5;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$000(Luz/carhelper/passenger/apk/ApkManagerActivity;)V

    return-void
.end method

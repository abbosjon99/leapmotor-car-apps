.class Luz/carhelper/passenger/apk/ApkManagerActivity$1;
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

    .line 94
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$1;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    .line 96
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$1;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-virtual {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->finish()V

    return-void
.end method

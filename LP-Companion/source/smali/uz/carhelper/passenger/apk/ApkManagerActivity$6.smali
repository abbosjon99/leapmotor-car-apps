.class Luz/carhelper/passenger/apk/ApkManagerActivity$6;
.super Ljava/lang/Object;
.source "ApkManagerActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/ApkManagerActivity;->row(Luz/carhelper/passenger/apk/Roots$Root;Luz/carhelper/passenger/apk/Roots$Entry;)Landroid/view/View;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

.field final synthetic val$e:Luz/carhelper/passenger/apk/Roots$Entry;

.field final synthetic val$root:Luz/carhelper/passenger/apk/Roots$Root;


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/ApkManagerActivity;Luz/carhelper/passenger/apk/Roots$Root;Luz/carhelper/passenger/apk/Roots$Entry;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010,
            0x1010
        }
        names = {
            null,
            null,
            null
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 218
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$6;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    iput-object p2, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$6;->val$root:Luz/carhelper/passenger/apk/Roots$Root;

    iput-object p3, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$6;->val$e:Luz/carhelper/passenger/apk/Roots$Entry;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 3

    .line 220
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$6;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$6;->val$root:Luz/carhelper/passenger/apk/Roots$Root;

    iget-object v1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$6;->val$e:Luz/carhelper/passenger/apk/Roots$Entry;

    iget-object v1, v1, Luz/carhelper/passenger/apk/Roots$Entry;->file:Ljava/io/File;

    new-instance v2, Luz/carhelper/passenger/apk/ApkManagerActivity$6$1;

    invoke-direct {v2, p0}, Luz/carhelper/passenger/apk/ApkManagerActivity$6$1;-><init>(Luz/carhelper/passenger/apk/ApkManagerActivity$6;)V

    invoke-static {p1, v0, v1, v2}, Luz/carhelper/passenger/apk/DeleteDialog;->show(Landroid/app/Activity;Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;Ljava/lang/Runnable;)V

    return-void
.end method

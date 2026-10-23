.class Luz/carhelper/passenger/apk/ApkManagerActivity$3;
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

.field final synthetic val$idx:I


# direct methods
.method constructor <init>(Luz/carhelper/passenger/apk/ApkManagerActivity;I)V
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

    .line 134
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$3;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    iput p2, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$3;->val$idx:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 136
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$3;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    iget v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$3;->val$idx:I

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$102(Luz/carhelper/passenger/apk/ApkManagerActivity;I)I

    .line 137
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$3;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$300(Luz/carhelper/passenger/apk/ApkManagerActivity;)Ljava/util/List;

    move-result-object v0

    iget v1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$3;->val$idx:I

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Luz/carhelper/passenger/apk/Roots$Root;

    iget-object v0, v0, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$202(Luz/carhelper/passenger/apk/ApkManagerActivity;Ljava/io/File;)Ljava/io/File;

    .line 138
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$3;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$000(Luz/carhelper/passenger/apk/ApkManagerActivity;)V

    return-void
.end method

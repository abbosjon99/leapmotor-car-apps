.class Luz/carhelper/passenger/apk/ApkManagerActivity$4;
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

    .line 147
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$4;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 149
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$4;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {p1}, Luz/carhelper/passenger/apk/Roots;->list(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$302(Luz/carhelper/passenger/apk/ApkManagerActivity;Ljava/util/List;)Ljava/util/List;

    .line 150
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$4;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$100(Luz/carhelper/passenger/apk/ApkManagerActivity;)I

    move-result p1

    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$4;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {v0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$300(Luz/carhelper/passenger/apk/ApkManagerActivity;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lt p1, v0, :cond_0

    .line 151
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$4;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    const/4 v0, 0x0

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$102(Luz/carhelper/passenger/apk/ApkManagerActivity;I)I

    .line 152
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$4;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$300(Luz/carhelper/passenger/apk/ApkManagerActivity;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Luz/carhelper/passenger/apk/Roots$Root;

    iget-object v0, v0, Luz/carhelper/passenger/apk/Roots$Root;->dir:Ljava/io/File;

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$202(Luz/carhelper/passenger/apk/ApkManagerActivity;Ljava/io/File;)Ljava/io/File;

    .line 154
    :cond_0
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$4;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$000(Luz/carhelper/passenger/apk/ApkManagerActivity;)V

    return-void
.end method

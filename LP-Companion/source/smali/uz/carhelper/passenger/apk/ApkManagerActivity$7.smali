.class Luz/carhelper/passenger/apk/ApkManagerActivity$7;
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
.method constructor <init>(Luz/carhelper/passenger/apk/ApkManagerActivity;Luz/carhelper/passenger/apk/Roots$Entry;Luz/carhelper/passenger/apk/Roots$Root;)V
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

    .line 229
    iput-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    iput-object p2, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->val$e:Luz/carhelper/passenger/apk/Roots$Entry;

    iput-object p3, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->val$root:Luz/carhelper/passenger/apk/Roots$Root;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 231
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->val$e:Luz/carhelper/passenger/apk/Roots$Entry;

    iget-boolean p1, p1, Luz/carhelper/passenger/apk/Roots$Entry;->dir:Z

    if-eqz p1, :cond_0

    .line 232
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->val$e:Luz/carhelper/passenger/apk/Roots$Entry;

    iget-object v0, v0, Luz/carhelper/passenger/apk/Roots$Entry;->file:Ljava/io/File;

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$202(Luz/carhelper/passenger/apk/ApkManagerActivity;Ljava/io/File;)Ljava/io/File;

    .line 233
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-static {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->access$000(Luz/carhelper/passenger/apk/ApkManagerActivity;)V

    goto :goto_0

    .line 234
    :cond_0
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->val$e:Luz/carhelper/passenger/apk/Roots$Entry;

    iget-boolean p1, p1, Luz/carhelper/passenger/apk/Roots$Entry;->apk:Z

    if-eqz p1, :cond_1

    .line 235
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->val$root:Luz/carhelper/passenger/apk/Roots$Root;

    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->val$e:Luz/carhelper/passenger/apk/Roots$Entry;

    iget-object v0, v0, Luz/carhelper/passenger/apk/Roots$Entry;->file:Ljava/io/File;

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/Roots;->allowed(Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 236
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    iget-object v0, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->val$e:Luz/carhelper/passenger/apk/Roots$Entry;

    iget-object v0, v0, Luz/carhelper/passenger/apk/Roots$Entry;->file:Ljava/io/File;

    invoke-static {p1, v0}, Luz/carhelper/passenger/apk/InstallDialog;->show(Landroid/app/Activity;Ljava/io/File;)V

    goto :goto_0

    .line 239
    :cond_1
    iget-object p1, p0, Luz/carhelper/passenger/apk/ApkManagerActivity$7;->this$0:Luz/carhelper/passenger/apk/ApkManagerActivity;

    invoke-virtual {p1}, Luz/carhelper/passenger/apk/ApkManagerActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    const-string v0, "Bundles (.xapk, .apks, .apkm) are not supported. Only plain .apk files can be installed."

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {p1, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    :cond_2
    :goto_0
    return-void
.end method

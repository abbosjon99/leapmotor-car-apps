.class public Luz/carhelper/passenger/HealToast;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Shows a toast from the main thread (Heal runs on a background thread).

.field private final ctx:Landroid/content/Context;
.field private final msg:Ljava/lang/String;

.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/HealToast;->ctx:Landroid/content/Context;
    iput-object p2, p0, Luz/carhelper/passenger/HealToast;->msg:Ljava/lang/String;
    return-void
.end method

.method public run()V
    .locals 3
    iget-object v0, p0, Luz/carhelper/passenger/HealToast;->ctx:Landroid/content/Context;
    iget-object v1, p0, Luz/carhelper/passenger/HealToast;->msg:Ljava/lang/String;
    const/4 v2, 0x1
    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    return-void
.end method

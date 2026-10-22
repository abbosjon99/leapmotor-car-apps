.class public Luz/carhelper/passenger/HideView;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Removes an overlay view later (used for the timed overload warning).

.field private final wm:Landroid/view/WindowManager;
.field private final view:Landroid/view/View;

.method public constructor <init>(Landroid/view/WindowManager;Landroid/view/View;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/HideView;->wm:Landroid/view/WindowManager;
    iput-object p2, p0, Luz/carhelper/passenger/HideView;->view:Landroid/view/View;
    return-void
.end method

.method public run()V
    .locals 2
    :try_start_0
    iget-object v0, p0, Luz/carhelper/passenger/HideView;->wm:Landroid/view/WindowManager;
    iget-object v1, p0, Luz/carhelper/passenger/HideView;->view:Landroid/view/View;
    invoke-interface {v0, v1}, Landroid/view/ViewManager;->removeView(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    return-void
.end method

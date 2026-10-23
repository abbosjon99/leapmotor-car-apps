.class public Luz/carhelper/passenger/HealthTick;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Keeps the RAM / temperature chip in the grid header current: updates it now, then every 5 s for as long as the
# view is attached to a window (it stops by itself when the grid is destroyed).

.field private final view:Landroid/widget/TextView;

.method private constructor <init>(Landroid/widget/TextView;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/HealthTick;->view:Landroid/widget/TextView;
    return-void
.end method

.method public static start(Landroid/widget/TextView;)V
    .locals 3
    new-instance v0, Luz/carhelper/passenger/HealthTick;
    invoke-direct {v0, p0}, Luz/carhelper/passenger/HealthTick;-><init>(Landroid/widget/TextView;)V
    invoke-direct {v0}, Luz/carhelper/passenger/HealthTick;->update()V
    const-wide/16 v1, 0x1388
    invoke-virtual {p0, v0, v1, v2}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
.end method

.method private update()V
    .locals 3
    iget-object v0, p0, Luz/carhelper/passenger/HealthTick;->view:Landroid/widget/TextView;
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v1
    invoke-static {v1}, Luz/carhelper/passenger/Health;->read(Landroid/content/Context;)[I
    move-result-object v1
    invoke-static {v1}, Luz/carhelper/passenger/Health;->text([I)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/4 v2, 0x4
    aget v1, v1, v2
    invoke-static {v1}, Luz/carhelper/passenger/Health;->color(I)I
    move-result v1
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    return-void
.end method

.method public run()V
    .locals 3
    iget-object v0, p0, Luz/carhelper/passenger/HealthTick;->view:Landroid/widget/TextView;
    invoke-virtual {v0}, Landroid/view/View;->isAttachedToWindow()Z
    move-result v1
    if-nez v1, :go
    return-void
    :go
    invoke-direct {p0}, Luz/carhelper/passenger/HealthTick;->update()V
    const-wide/16 v1, 0x1388
    invoke-virtual {v0, p0, v1, v2}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z
    return-void
.end method

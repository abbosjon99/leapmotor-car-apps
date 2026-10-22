.class public Luz/carhelper/passenger/PanelAction;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Delayed bubble-panel step (see BubbleService.delayed): 0 = press Back, 1 = reopen the panel.

.field private final svc:Luz/carhelper/passenger/BubbleService;
.field private final what:I

.method public constructor <init>(Luz/carhelper/passenger/BubbleService;I)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Luz/carhelper/passenger/PanelAction;->svc:Luz/carhelper/passenger/BubbleService;
    iput p2, p0, Luz/carhelper/passenger/PanelAction;->what:I
    return-void
.end method

.method public run()V
    .locals 2
    iget-object v0, p0, Luz/carhelper/passenger/PanelAction;->svc:Luz/carhelper/passenger/BubbleService;
    iget v1, p0, Luz/carhelper/passenger/PanelAction;->what:I
    invoke-virtual {v0, v1}, Luz/carhelper/passenger/BubbleService;->delayed(I)V
    return-void
.end method

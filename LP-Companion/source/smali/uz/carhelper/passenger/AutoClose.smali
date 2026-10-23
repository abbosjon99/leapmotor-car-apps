.class public Luz/carhelper/passenger/AutoClose;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Timer callback that closes a bubble's open menu panel (Settings: bubbleAuto, bubbleSecs).
# which: 0 = passenger bubble (BubbleService), 1 = main bubble (MainBubbleService).

.field private final which:I

.method public constructor <init>(I)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput p1, p0, Luz/carhelper/passenger/AutoClose;->which:I
    return-void
.end method

.method public run()V
    .locals 1
    iget v0, p0, Luz/carhelper/passenger/AutoClose;->which:I
    if-nez v0, :main_bubble
    invoke-static {}, Luz/carhelper/passenger/BubbleService;->closePanel()V
    return-void
    :main_bubble
    invoke-static {}, Luz/carhelper/passenger/MainBubbleService;->closePanel()V
    return-void
.end method

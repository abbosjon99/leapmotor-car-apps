.class public Luz/carhelper/passenger/BackService;
.super Landroid/accessibilityservice/AccessibilityService;

# Minimal accessibility service: its only job is the bubble's Back button
# (performGlobalAction(GLOBAL_ACTION_BACK)). It listens to no events and reads no screen content.

.field public static instance:Luz/carhelper/passenger/BackService;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/accessibilityservice/AccessibilityService;-><init>()V
    return-void
.end method

.method protected onServiceConnected()V
    .locals 0
    invoke-super {p0}, Landroid/accessibilityservice/AccessibilityService;->onServiceConnected()V
    sput-object p0, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    return-void
.end method

.method public onUnbind(Landroid/content/Intent;)Z
    .locals 1
    const/4 v0, 0x0
    sput-object v0, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    invoke-super {p0, p1}, Landroid/accessibilityservice/AccessibilityService;->onUnbind(Landroid/content/Intent;)Z
    move-result v0
    return v0
.end method

.method public onAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V
    .locals 0
    return-void
.end method

.method public onInterrupt()V
    .locals 0
    return-void
.end method

.method public static back()Z
    .locals 2
    sget-object v0, Luz/carhelper/passenger/BackService;->instance:Luz/carhelper/passenger/BackService;
    if-eqz v0, :none
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/accessibilityservice/AccessibilityService;->performGlobalAction(I)Z
    move-result v0
    return v0
    :none
    const/4 v0, 0x0
    return v0
.end method

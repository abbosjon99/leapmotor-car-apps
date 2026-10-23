.class public Luz/carhelper/passenger/MainScreenActivity;
.super Luz/carhelper/passenger/MainActivity;

# Same grid as MainActivity, but a distinct task affinity (set in the manifest) so a
# main-screen instance and a passenger-screen instance can live at the same time without
# one stealing the other's task.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Luz/carhelper/passenger/MainActivity;-><init>()V
    return-void
.end method

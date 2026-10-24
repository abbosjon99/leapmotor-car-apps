.class public Lcom/migu/car/music/launcher/SourceService;
.super Landroid/app/Service;

# The service the car's media app (MultiMedia, ah.e "Launcher") binds to for media type 13:
#   ComponentName("com.migu.car.music", "com.migu.car.music.launcher.SourceService"), BIND_AUTO_CREATE.
# MultiMedia only answers the dock's favourite lookup (and so the dock refreshes its music card) once
# this bind succeeds, and it lists type 13 as a source only while the package is installed.
# It exposes the AIDL "com.migu.car.music.ISourceController" (see Ctl). LP Music has no favourites, so
# every lookup is answered "not a favourite, logged in".
# Only works because LP Music installs under the package name com.migu.car.music. See FINDINGS.md.

.field private ctl:Lcom/migu/car/music/launcher/SourceService$Ctl;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Service;-><init>()V
    return-void
.end method

.method public onCreate()V
    .locals 1
    invoke-super {p0}, Landroid/app/Service;->onCreate()V
    new-instance v0, Lcom/migu/car/music/launcher/SourceService$Ctl;
    invoke-direct {v0, p0}, Lcom/migu/car/music/launcher/SourceService$Ctl;-><init>(Landroid/content/Context;)V
    iput-object v0, p0, Lcom/migu/car/music/launcher/SourceService;->ctl:Lcom/migu/car/music/launcher/SourceService$Ctl;
    return-void
.end method

.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 1
    iget-object v0, p0, Lcom/migu/car/music/launcher/SourceService;->ctl:Lcom/migu/car/music/launcher/SourceService$Ctl;
    return-object v0
.end method

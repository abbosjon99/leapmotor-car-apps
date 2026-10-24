.class Lcom/migu/car/music/launcher/SourceService$Ctl;
.super Landroid/os/Binder;

# Hand-written server side of com.migu.car.music.ISourceController, as the car's client uses it
# (codes taken from the car's wg.b Stub in MultiMedia):
#   1 request()                       -> nothing to do
#   2 registerCallback(ISourceCallBack)  keep the binder
#   3 unregisterCallback()
#   4 getCollectionStutas(String id)  -> reply through the callback (Reply)
#   5 collectionAction(String id, boolean collect) -> the dock card's heart button: used as "previous track"
#                                      (MiguCtrlReceiver.previous), reply "success, not a favourite"
# Replies go to ISourceCallBack code 1 (onSuccess(String json)) as a ResponseFavBean JSON.

.field private cb:Landroid/os/IBinder;
.field private final ctx:Landroid/content/Context;
.field private final main:Landroid/os/Handler;

.method constructor <init>(Landroid/content/Context;)V
    .locals 2
    invoke-direct {p0}, Landroid/os/Binder;-><init>()V
    iput-object p1, p0, Lcom/migu/car/music/launcher/SourceService$Ctl;->ctx:Landroid/content/Context;
    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v0, p0, Lcom/migu/car/music/launcher/SourceService$Ctl;->main:Landroid/os/Handler;
    return-void
.end method

.method private answer(Ljava/lang/String;ZZ)V
    .locals 3
    iget-object v0, p0, Lcom/migu/car/music/launcher/SourceService$Ctl;->cb:Landroid/os/IBinder;
    if-eqz v0, :none
    new-instance v1, Lcom/migu/car/music/launcher/SourceService$Reply;
    invoke-direct {v1, v0, p1, p2, p3}, Lcom/migu/car/music/launcher/SourceService$Reply;-><init>(Landroid/os/IBinder;Ljava/lang/String;ZZ)V
    iget-object v2, p0, Lcom/migu/car/music/launcher/SourceService$Ctl;->main:Landroid/os/Handler;
    invoke-virtual {v2, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :none
    return-void
.end method

.method protected onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z
    .locals 4
    const-string v0, "com.migu.car.music.ISourceController"
    const v1, 0x5f4e5446
    if-ne p1, v1, :not_iface
    invoke-virtual {p3, v0}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V
    const/4 v1, 0x1
    return v1
    :not_iface
    const/4 v1, 0x1
    if-eq p1, v1, :c_request
    const/4 v1, 0x2
    if-eq p1, v1, :c_register
    const/4 v1, 0x3
    if-eq p1, v1, :c_unregister
    const/4 v1, 0x4
    if-eq p1, v1, :c_status
    const/4 v1, 0x5
    if-eq p1, v1, :c_collect
    invoke-super {p0, p1, p2, p3, p4}, Landroid/os/Binder;->onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z
    move-result v1
    return v1

    :c_request
    invoke-virtual {p2, v0}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V
    const/4 v1, 0x1
    return v1

    :c_register
    invoke-virtual {p2, v0}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V
    invoke-virtual {p2}, Landroid/os/Parcel;->readStrongBinder()Landroid/os/IBinder;
    move-result-object v1
    iput-object v1, p0, Lcom/migu/car/music/launcher/SourceService$Ctl;->cb:Landroid/os/IBinder;
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V
    const/4 v1, 0x1
    return v1

    :c_unregister
    invoke-virtual {p2, v0}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V
    const/4 v1, 0x0
    iput-object v1, p0, Lcom/migu/car/music/launcher/SourceService$Ctl;->cb:Landroid/os/IBinder;
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V
    const/4 v1, 0x1
    return v1

    :c_status
    invoke-virtual {p2, v0}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V
    invoke-virtual {p2}, Landroid/os/Parcel;->readString()Ljava/lang/String;
    move-result-object v1
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V
    const/4 v2, 0x1
    const/4 v3, 0x0
    invoke-direct {p0, v1, v2, v3}, Lcom/migu/car/music/launcher/SourceService$Ctl;->answer(Ljava/lang/String;ZZ)V
    const/4 v1, 0x1
    return v1

    :c_collect
    invoke-virtual {p2, v0}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V
    invoke-virtual {p2}, Landroid/os/Parcel;->readString()Ljava/lang/String;
    move-result-object v1
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V
    # the heart on the dock card is used as "previous track"; the answer says success and "not a favourite", so the
    # heart never fills in
    iget-object v2, p0, Lcom/migu/car/music/launcher/SourceService$Ctl;->ctx:Landroid/content/Context;
    invoke-static {v2}, Luz/carhelper/passenger/MiguCtrlReceiver;->previous(Landroid/content/Context;)V
    const/4 v2, 0x1
    const/4 v3, 0x0
    invoke-direct {p0, v1, v2, v3}, Lcom/migu/car/music/launcher/SourceService$Ctl;->answer(Ljava/lang/String;ZZ)V
    const/4 v1, 0x1
    return v1
.end method

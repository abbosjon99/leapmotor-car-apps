.class Lcom/migu/car/music/launcher/SourceService$Reply;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# One answer to the car's ISourceCallBack.onSuccess(String) (transaction code 1, one-way), posted to
# the main thread so it never runs inside the car's own call:
#   {"contentId":id,"isCollection":<fav>,"isLogin":true,"isSuccess":<ok>,"mediaType":13,"msg":""}
# (the fields of the car's ResponseFavBean; the car sets mediaType itself anyway).

.field private final cb:Landroid/os/IBinder;
.field private final id:Ljava/lang/String;
.field private final ok:Z
.field private final fav:Z

.method constructor <init>(Landroid/os/IBinder;Ljava/lang/String;ZZ)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/migu/car/music/launcher/SourceService$Reply;->cb:Landroid/os/IBinder;
    iput-object p2, p0, Lcom/migu/car/music/launcher/SourceService$Reply;->id:Ljava/lang/String;
    iput-boolean p3, p0, Lcom/migu/car/music/launcher/SourceService$Reply;->ok:Z
    iput-boolean p4, p0, Lcom/migu/car/music/launcher/SourceService$Reply;->fav:Z
    return-void
.end method

.method public run()V
    .locals 6
    :try_start_0
    new-instance v0, Lorg/json/JSONObject;
    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V
    const-string v1, "contentId"
    iget-object v2, p0, Lcom/migu/car/music/launcher/SourceService$Reply;->id:Ljava/lang/String;
    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    const-string v1, "isCollection"
    iget-boolean v2, p0, Lcom/migu/car/music/launcher/SourceService$Reply;->fav:Z
    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    const-string v1, "isLogin"
    const/4 v2, 0x1
    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    const-string v1, "isSuccess"
    iget-boolean v2, p0, Lcom/migu/car/music/launcher/SourceService$Reply;->ok:Z
    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    const-string v1, "mediaType"
    const/16 v2, 0xd
    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    const-string v1, "msg"
    const-string v2, ""
    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;
    move-result-object v1
    const-string v2, "com.migu.car.music.ISourceCallBack"
    invoke-virtual {v1, v2}, Landroid/os/Parcel;->writeInterfaceToken(Ljava/lang/String;)V
    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v1, v2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V
    iget-object v2, p0, Lcom/migu/car/music/launcher/SourceService$Reply;->cb:Landroid/os/IBinder;
    const/4 v3, 0x1
    const/4 v4, 0x0
    const/4 v5, 0x1
    invoke-interface {v2, v3, v1, v4, v5}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z
    invoke-virtual {v1}, Landroid/os/Parcel;->recycle()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void
    :catch_0
    move-exception v0
    const-string v1, "LPMigu"
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

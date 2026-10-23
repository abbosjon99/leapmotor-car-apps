.class Luz/carhelper/passenger/apk/Roots$1;
.super Ljava/lang/Object;
.source "Roots.java"

# interfaces
.implements Ljava/util/Comparator;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/Roots;->children(Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;)Ljava/util/List;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Comparator<",
        "Luz/carhelper/passenger/apk/Roots$Entry;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 150
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x1000,
            0x1000
        }
        names = {
            null,
            null
        }
    .end annotation

    .line 150
    check-cast p1, Luz/carhelper/passenger/apk/Roots$Entry;

    check-cast p2, Luz/carhelper/passenger/apk/Roots$Entry;

    invoke-virtual {p0, p1, p2}, Luz/carhelper/passenger/apk/Roots$1;->compare(Luz/carhelper/passenger/apk/Roots$Entry;Luz/carhelper/passenger/apk/Roots$Entry;)I

    move-result p1

    return p1
.end method

.method public compare(Luz/carhelper/passenger/apk/Roots$Entry;Luz/carhelper/passenger/apk/Roots$Entry;)I
    .locals 2

    .line 152
    iget-boolean v0, p1, Luz/carhelper/passenger/apk/Roots$Entry;->dir:Z

    iget-boolean v1, p2, Luz/carhelper/passenger/apk/Roots$Entry;->dir:Z

    if-eq v0, v1, :cond_1

    .line 153
    iget-boolean p1, p1, Luz/carhelper/passenger/apk/Roots$Entry;->dir:Z

    if-eqz p1, :cond_0

    const/4 p1, -0x1

    goto :goto_0

    :cond_0
    const/4 p1, 0x1

    :goto_0
    return p1

    .line 155
    :cond_1
    iget-object p1, p1, Luz/carhelper/passenger/apk/Roots$Entry;->file:Ljava/io/File;

    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p1

    iget-object p2, p2, Luz/carhelper/passenger/apk/Roots$Entry;->file:Ljava/io/File;

    invoke-virtual {p2}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/String;->compareToIgnoreCase(Ljava/lang/String;)I

    move-result p1

    return p1
.end method

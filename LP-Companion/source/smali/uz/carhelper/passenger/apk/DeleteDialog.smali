.class final Luz/carhelper/passenger/apk/DeleteDialog;
.super Ljava/lang/Object;
.source "DeleteDialog.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 16
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static show(Landroid/app/Activity;Luz/carhelper/passenger/apk/Roots$Root;Ljava/io/File;Ljava/lang/Runnable;)V
    .locals 10

    .line 20
    new-instance v6, Luz/carhelper/passenger/apk/Cards$Card;

    const/16 v0, 0x35c

    invoke-static {p0, v0}, Luz/carhelper/passenger/apk/Cards;->width(Landroid/app/Activity;I)I

    move-result v0

    invoke-direct {v6, p0, v0}, Luz/carhelper/passenger/apk/Cards$Card;-><init>(Landroid/app/Activity;I)V

    .line 21
    const-string v0, "Delete this file?"

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v6, v0}, Luz/carhelper/passenger/apk/Cards$Card;->title(Ljava/lang/String;)Landroid/widget/TextView;

    .line 22
    invoke-virtual {p2}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v0

    const/high16 v1, 0x41b00000    # 22.0f

    const/4 v2, 0x0

    const/4 v3, -0x1

    invoke-virtual {v6, v0, v3, v1, v2}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 23
    invoke-virtual {p2}, Ljava/io/File;->length()J

    move-result-wide v0

    invoke-static {v0, v1}, Luz/carhelper/passenger/apk/Cards;->size(J)Ljava/lang/String;

    move-result-object v0

    const/high16 v1, 0x41900000    # 18.0f

    const/4 v2, 0x4

    const v3, -0x7f000001

    invoke-virtual {v6, v0, v3, v1, v2}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 24
    const-string v0, "The file is removed from the storage. This cannot be undone."

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/high16 v1, 0x41a00000    # 20.0f

    const/16 v2, 0xc

    const v3, -0x9495

    invoke-virtual {v6, v0, v3, v1, v2}, Luz/carhelper/passenger/apk/Cards$Card;->line(Ljava/lang/String;IFI)Landroid/widget/TextView;

    .line 25
    const-string v0, "Cancel"

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Luz/carhelper/passenger/apk/DeleteDialog$1;

    invoke-direct {v1, v6}, Luz/carhelper/passenger/apk/DeleteDialog$1;-><init>(Luz/carhelper/passenger/apk/Cards$Card;)V

    invoke-static {p0, v0, v1}, Luz/carhelper/passenger/apk/Cards;->grey(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v7

    .line 30
    const-string v0, "Delete"

    invoke-static {v0}, Luz/carhelper/passenger/apk/Cards;->T(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    new-instance v9, Luz/carhelper/passenger/apk/DeleteDialog$2;

    move-object v0, v9

    move-object v1, v6

    move-object v2, p2

    move-object v3, p1

    move-object v4, p0

    move-object v5, p3

    invoke-direct/range {v0 .. v5}, Luz/carhelper/passenger/apk/DeleteDialog$2;-><init>(Luz/carhelper/passenger/apk/Cards$Card;Ljava/io/File;Luz/carhelper/passenger/apk/Roots$Root;Landroid/app/Activity;Ljava/lang/Runnable;)V

    invoke-static {p0, v8, v9}, Luz/carhelper/passenger/apk/Cards;->red(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object p1

    .line 42
    iget-object p2, v6, Luz/carhelper/passenger/apk/Cards$Card;->box:Landroid/widget/LinearLayout;

    invoke-static {p0, v7, p1}, Luz/carhelper/passenger/apk/Cards;->buttons(Landroid/app/Activity;Landroid/view/View;Landroid/view/View;)Landroid/widget/LinearLayout;

    move-result-object p0

    invoke-virtual {p2, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 43
    invoke-virtual {v6}, Luz/carhelper/passenger/apk/Cards$Card;->show()V

    return-void
.end method

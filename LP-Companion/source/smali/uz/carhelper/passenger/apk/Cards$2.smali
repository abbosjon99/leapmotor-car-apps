.class Luz/carhelper/passenger/apk/Cards$2;
.super Ljava/lang/Object;
.source "Cards.java"

# interfaces
.implements Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Luz/carhelper/passenger/apk/Cards;->capHeight(Landroid/widget/ScrollView;I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$max:I

.field final synthetic val$sv:Landroid/widget/ScrollView;


# direct methods
.method constructor <init>(Landroid/widget/ScrollView;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 137
    iput-object p1, p0, Luz/carhelper/passenger/apk/Cards$2;->val$sv:Landroid/widget/ScrollView;

    iput p2, p0, Luz/carhelper/passenger/apk/Cards$2;->val$max:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onGlobalLayout()V
    .locals 2

    .line 139
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$2;->val$sv:Landroid/widget/ScrollView;

    invoke-virtual {v0}, Landroid/widget/ScrollView;->getHeight()I

    move-result v0

    iget v1, p0, Luz/carhelper/passenger/apk/Cards$2;->val$max:I

    if-le v0, v1, :cond_0

    .line 140
    iget-object v0, p0, Luz/carhelper/passenger/apk/Cards$2;->val$sv:Landroid/widget/ScrollView;

    invoke-virtual {v0}, Landroid/widget/ScrollView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    .line 141
    iget v1, p0, Luz/carhelper/passenger/apk/Cards$2;->val$max:I

    iput v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 142
    iget-object v1, p0, Luz/carhelper/passenger/apk/Cards$2;->val$sv:Landroid/widget/ScrollView;

    invoke-virtual {v1, v0}, Landroid/widget/ScrollView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_0
    return-void
.end method

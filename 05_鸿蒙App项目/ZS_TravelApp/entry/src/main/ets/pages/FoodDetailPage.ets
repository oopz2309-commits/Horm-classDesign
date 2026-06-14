import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { AppState } from '../common/AppState';
import { BLUE, BLUE_LIGHT, CommentVO, FavoriteVO, Food, PAGE_BG, TEXT_DARK, TEXT_GRAY } from '../common/Models';
import { ApiService } from '../services/ApiService';

@Entry
@Component
struct FoodDetailPage {
  @State foodId: number = 1;
  @State name: string = '美食详情';
  @State recommendShop: string = '推荐店铺';
  @State address: string = '暂无地址';
  @State priceText: string = '0';
  @State description: string = '暂无介绍';
  @State comments: CommentVO[] = [];
  @State commentText: string = '';
  @State favored: boolean = false;

  async aboutToAppear() {
    this.foodId = AppState.selectedFoodId;
    this.applyFood(this.findLocal(this.foodId));
    if (AppState.isLoggedIn()) {
      await this.loadFavorites();
    }
    try {
      const result = await ApiService.foodDetail(this.foodId);
      if (result.code === 200 && result.data !== null) {
        this.applyFood(result.data);
      }
    } catch (error) {
    }
    await this.loadComments();
  }

  applyFood(item: Food) {
    this.foodId = item.id;
    this.name = item.name || '美食详情';
    this.recommendShop = item.recommendShop || '推荐店铺';
    this.address = item.address || '暂无地址';
    this.priceText = `${item.price || 0}`;
    this.description = item.description || '暂无介绍';
    this.favored = this.isFavorite(this.foodId);
  }

  findLocal(id: number): Food {
    const found = AppState.foodList.find((food: Food) => food.id === id);
    return found || AppState.foodList[0];
  }

  toast(message: string) {
    promptAction.showToast({ message: message, duration: 1800 });
  }

  isFavorite(id: number): boolean {
    return AppState.favoriteList.some((favorite: FavoriteVO) => {
      return favorite.targetId === id && favorite.type === 'food';
    });
  }

  async toggleFavorite() {
    if (!AppState.isLoggedIn()) {
      this.toast('请先登录后再收藏');
      return;
    }

    const targetFavored = !this.favored;
    try {
      if (targetFavored) {
        await ApiService.addFavorite(AppState.userId(), this.foodId, 'food');
      } else {
        await ApiService.cancelFavorite(AppState.userId(), this.foodId, 'food');
      }
      await this.loadFavorites();
    } catch (error) {
      if (targetFavored) {
        const favorite: FavoriteVO = { id: new Date().getTime(), targetId: this.foodId, type: 'food', name: this.name };
        AppState.favoriteList = [favorite].concat(AppState.favoriteList);
      } else {
        AppState.favoriteList = AppState.favoriteList.filter((favorite: FavoriteVO) => {
          return !(favorite.targetId === this.foodId && favorite.type === 'food');
        });
      }
      this.favored = targetFavored;
    }
    this.favored = targetFavored;
    this.toast(this.favored ? '收藏成功' : '已取消收藏');
  }

  async loadFavorites() {
    try {
      const result = await ApiService.favoriteList(AppState.userId());
      if (result.code === 200 && result.data !== null) {
        AppState.favoriteList = result.data;
      }
    } catch (error) {
    }
    this.favored = this.isFavorite(this.foodId);
  }

  async loadComments() {
    try {
      const result = await ApiService.commentList(this.foodId, 'food');
      if (result.code === 200 && result.data !== null) {
        this.comments = result.data;
      }
    } catch (error) {
      const demo: CommentVO = {
        id: 1,
        userId: 2,
        nickname: '张三',
        content: '味道很好，皮脆肉嫩，值得推荐。',
        createTime: '2026-06-12 10:00:00'
      };
      this.comments = [demo];
    }
  }

  async addComment() {
    if (!AppState.isLoggedIn()) {
      this.toast('请先登录后再评论');
      return;
    }
    if (this.commentText.trim().length === 0) {
      this.toast('请输入评论内容');
      return;
    }
    try {
      await ApiService.addComment(AppState.userId(), this.foodId, 'food', this.commentText);
      this.commentText = '';
      await this.loadComments();
    } catch (error) {
      const comment: CommentVO = {
        id: new Date().getTime(),
        userId: AppState.userId(),
        nickname: AppState.userName(),
        content: this.commentText,
        createTime: '刚刚'
      };
      this.comments = [comment].concat(this.comments);
      this.commentText = '';
    }
    this.toast('评论成功');
  }

  build() {
    Column() {
      this.TopBar()
      Scroll() {
        Column() {
          this.CoverBlock()
          this.InfoBlock()
          Button(this.favored ? '取消收藏' : '收藏')
            .width('100%')
            .height(44)
            .fontSize(15)
            .backgroundColor(this.favored ? '#9CA3AF' : BLUE)
            .borderRadius(12)
            .margin({ bottom: 12 })
            .onClick(() => {
              this.toggleFavorite();
            })
          this.CommentBlock()
        }
        .padding({ left: 18, right: 18, bottom: 24 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  TopBar() {
    Row() {
      Text('<')
        .fontSize(24)
        .fontColor(TEXT_DARK)
        .width(40)
        .height(40)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          router.back();
        })
      Text('美食详情')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(TEXT_DARK)
      Blank()
    }
    .width('100%')
    .height(60)
    .padding({ left: 12, right: 18 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  CoverBlock() {
    Column() {
      Text('美食')
        .fontSize(14)
        .fontColor('#EAF3FF')
      Text(this.name)
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .margin({ top: 8 })
    }
    .width('100%')
    .height(188)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(18)
    .backgroundColor(BLUE)
    .margin({ top: 14, bottom: 14 })
  }

  @Builder
  InfoBlock() {
    Column() {
      Text(this.name)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(TEXT_DARK)
      Text(`推荐店铺：${this.recommendShop}`)
        .fontSize(13)
        .fontColor(BLUE)
        .margin({ top: 8 })
      Text(`地址：${this.address}    人均：${this.priceText} 元`)
        .fontSize(14)
        .fontColor(TEXT_GRAY)
        .margin({ top: 10 })
      Text(this.description)
        .fontSize(14)
        .fontColor(TEXT_GRAY)
        .lineHeight(22)
        .margin({ top: 10 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding(16)
    .borderRadius(14)
    .backgroundColor('#FFFFFF')
    .margin({ bottom: 12 })
  }

  @Builder
  CommentBlock() {
    Column() {
      Text('用户评论')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(TEXT_DARK)
      Row() {
        TextInput({ placeholder: '写下你的体验...', text: this.commentText })
          .layoutWeight(1)
          .height(42)
          .backgroundColor(PAGE_BG)
          .borderRadius(12)
          .onChange((value: string) => {
            this.commentText = value;
          })
        Button('发布')
          .height(42)
          .fontSize(14)
          .backgroundColor(BLUE)
          .borderRadius(12)
          .margin({ left: 8 })
          .onClick(() => {
            this.addComment();
          })
      }
      .width('100%')
      .margin({ top: 12, bottom: 8 })
      ForEach(this.comments, (comment: CommentVO) => {
        Text(`${comment.nickname}：${comment.content}`)
          .fontSize(13)
          .fontColor(TEXT_GRAY)
          .width('100%')
          .padding(12)
          .borderRadius(12)
          .backgroundColor(BLUE_LIGHT)
          .margin({ top: 8 })
      }, (comment: CommentVO) => comment.id.toString())
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding(16)
    .borderRadius(14)
    .backgroundColor('#FFFFFF')
  }
}

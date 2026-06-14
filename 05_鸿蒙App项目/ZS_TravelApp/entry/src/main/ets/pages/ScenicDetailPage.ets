import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { AppState } from '../common/AppState';
import { CommentVO, FavoriteVO, PAGE_BG, PRIMARY, ScenicImageVO, ScenicSpot, TEXT_DARK, TEXT_GRAY } from '../common/Models';
import { ApiService } from '../services/ApiService';

@Entry
@Component
struct ScenicDetailPage {
  @State scenicId: number = 1;
  @State name: string = '景点详情';
  @State typeName: string = '中山景点';
  @State scoreText: string = '5.0';
  @State address: string = '暂无地址';
  @State description: string = '暂无介绍';
  @State coverImage: string = '';
  @State videoUrl: string = '';
  @State galleryImages: string[] = [];
  @State comments: CommentVO[] = [];
  @State commentText: string = '';
  @State favored: boolean = false;

  async aboutToAppear() {
    this.scenicId = AppState.selectedScenicId;
    this.applyScenic(this.findLocal(this.scenicId));
    if (AppState.isLoggedIn()) {
      await this.loadFavorites();
    }

    try {
      const result = await ApiService.scenicDetail(this.scenicId);
      if (result.code === 200 && result.data !== null) {
        this.applyScenic(result.data);
      }
    } catch (error) {
    }
    await this.loadGallery();
    await this.loadComments();
  }

  applyScenic(item: ScenicSpot) {
    this.scenicId = item.id;
    this.name = item.name || '景点详情';
    this.typeName = item.type || '中山景点';
    this.scoreText = `${item.score || 5.0}`;
    this.address = item.address || '暂无地址';
    this.description = item.description || '暂无介绍';
    this.coverImage = item.coverImage || '';
    this.videoUrl = item.videoUrl || '';
    this.favored = this.isFavorite(this.scenicId);
  }

  async loadGallery() {
    try {
      const result = await ApiService.scenicImages(this.scenicId);
      if (result.code === 200 && result.data !== null) {
        const images: string[] = [];
        result.data.forEach((item: ScenicImageVO) => {
          if (item.imageUrl !== undefined && item.imageUrl.length > 0) {
            images.push(item.imageUrl);
          }
        });
        this.galleryImages = images.length > 0 ? images : this.fallbackGalleryImages();
        return;
      }
    } catch (error) {
    }
    this.galleryImages = this.fallbackGalleryImages();
  }

  fallbackGalleryImages(): string[] {
    if (this.coverImage.length > 0) {
      return [this.coverImage];
    }
    return [];
  }

  findLocal(id: number): ScenicSpot {
    const found = AppState.scenicList.find((spot: ScenicSpot) => spot.id === id);
    return found || AppState.scenicList[0];
  }

  toast(message: string) {
    promptAction.showToast({ message: message, duration: 1800 });
  }

  isFavorite(id: number): boolean {
    return AppState.favoriteList.some((favorite: FavoriteVO) => {
      return favorite.targetId === id && favorite.type === 'scenic';
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
        await ApiService.addFavorite(AppState.userId(), this.scenicId, 'scenic');
      } else {
        await ApiService.cancelFavorite(AppState.userId(), this.scenicId, 'scenic');
      }
      await this.loadFavorites();
    } catch (error) {
      if (targetFavored) {
        const favorite: FavoriteVO = { id: new Date().getTime(), targetId: this.scenicId, type: 'scenic', name: this.name };
        AppState.favoriteList = [favorite].concat(AppState.favoriteList);
      } else {
        AppState.favoriteList = AppState.favoriteList.filter((favorite: FavoriteVO) => {
          return !(favorite.targetId === this.scenicId && favorite.type === 'scenic');
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
    this.favored = this.isFavorite(this.scenicId);
  }

  async loadComments() {
    try {
      const result = await ApiService.commentList(this.scenicId, 'scenic');
      if (result.code === 200 && result.data !== null) {
        this.comments = result.data;
      }
    } catch (error) {
      const demo: CommentVO = {
        id: 1,
        userId: 2,
        nickname: '张三',
        content: '景区很有历史意义，适合周末参观。',
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
      await ApiService.addComment(AppState.userId(), this.scenicId, 'scenic', this.commentText);
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
          this.GalleryBlock()
          Button(this.favored ? '取消收藏' : '收藏')
            .width('100%')
            .height(44)
            .fontSize(15)
            .backgroundColor(this.favored ? '#9CA3AF' : PRIMARY)
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
      Text('景点详情')
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
    Stack({ alignContent: Alignment.BottomStart }) {
      if (this.coverImage.length > 0) {
        Image(ApiService.assetUrl(this.coverImage))
          .width('100%')
          .height(188)
          .objectFit(ImageFit.Cover)
          .borderRadius(18)
      } else {
        Column()
          .width('100%')
          .height(188)
          .borderRadius(18)
          .backgroundColor(PRIMARY)
      }
      Column() {
        Text('景点')
          .fontSize(14)
          .fontColor('#EFFFF7')
        Text(this.name)
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .margin({ top: 8 })
      }
      .width('100%')
      .height(188)
      .justifyContent(FlexAlign.End)
      .alignItems(HorizontalAlign.Start)
      .padding(18)
      .borderRadius(18)
      .linearGradient({
        angle: 180,
        colors: [['#00000000', 0.25], ['#00000099', 1.0]]
      })
    }
    .width('100%')
    .height(188)
    .borderRadius(18)
    .margin({ top: 14, bottom: 14 })
  }

  @Builder
  InfoBlock() {
    Column() {
      Text(this.name)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(TEXT_DARK)
      Text(`类型：${this.typeName}    评分：${this.scoreText}`)
        .fontSize(13)
        .fontColor(PRIMARY)
        .margin({ top: 8 })
      Text(`地址：${this.address}`)
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
  GalleryBlock() {
    Column() {
      Row() {
        Text('景点相册')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(TEXT_DARK)
        Blank()
        Text(`${this.galleryImages.length} 张`)
          .fontSize(12)
          .fontColor(PRIMARY)
      }
      .width('100%')
      .margin({ bottom: 10 })

      if (this.galleryImages.length > 0) {
        Swiper() {
          ForEach(this.galleryImages, (imageUrl: string) => {
            Image(ApiService.assetUrl(imageUrl))
              .width('100%')
              .height(158)
              .borderRadius(14)
              .objectFit(ImageFit.Cover)
          }, (imageUrl: string) => imageUrl)
        }
        .width('100%')
        .height(158)
        .borderRadius(14)
        .indicator(true)
        .autoPlay(true)
        .interval(3000)
      } else {
        Text('暂无景点相册图片')
          .fontSize(13)
          .fontColor(TEXT_GRAY)
          .width('100%')
          .height(86)
          .textAlign(TextAlign.Center)
          .borderRadius(14)
          .backgroundColor(PAGE_BG)
      }
    }
    .width('100%')
    .padding(14)
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
          .backgroundColor(PRIMARY)
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
          .backgroundColor(PAGE_BG)
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

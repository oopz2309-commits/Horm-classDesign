import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { AppState } from '../common/AppState';
import { BLUE, FavoriteVO, PAGE_BG, PRIMARY, TEXT_DARK, TEXT_GRAY } from '../common/Models';
import { ApiService } from '../services/ApiService';

@Entry
@Component
struct MinePage {
  @State favorites: FavoriteVO[] = AppState.favoriteList;
  @State favoriteCount: number = AppState.favoriteList.length;
  @State userName: string = AppState.userName();
  @State account: string = AppState.currentUser !== undefined ? AppState.currentUser.username : '未登录';

  async aboutToAppear() {
    this.userName = AppState.userName();
    this.account = AppState.currentUser !== undefined ? AppState.currentUser.username : '未登录';
    await this.loadFavorites();
  }

  toast(message: string) {
    promptAction.showToast({ message: message, duration: 1800 });
  }

  async loadFavorites() {
    if (!AppState.isLoggedIn()) {
      this.favorites = [];
      this.favoriteCount = 0;
      return;
    }
    try {
      const result = await ApiService.favoriteList(AppState.userId());
      if (result.code === 200 && result.data !== null) {
        AppState.favoriteList = result.data;
      }
    } catch (error) {
    }
    this.favorites = AppState.favoriteList;
    this.favoriteCount = this.favorites.length;
  }

  logout() {
    AppState.logout();
    this.toast('已退出登录');
    router.replaceUrl({ url: 'pages/LoginPage' });
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Column() {
            Text('我的')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(TEXT_DARK)
            Text('个人信息、收藏和系统说明')
              .fontSize(13)
              .fontColor(TEXT_GRAY)
              .margin({ top: 4 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ top: 18, bottom: 16 })

          Column() {
            Text(this.userName.substring(0, 1))
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .width(72)
              .height(72)
              .textAlign(TextAlign.Center)
              .borderRadius(36)
              .backgroundColor(PRIMARY)
            Text(this.userName)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(TEXT_DARK)
              .margin({ top: 12 })
            Text(this.account)
              .fontSize(13)
              .fontColor(TEXT_GRAY)
              .margin({ top: 4 })
          }
          .width('100%')
          .padding(22)
          .borderRadius(16)
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 14 })

          this.FavoriteMenuRow()
          this.MenuRow('关于系统', 'HarmonyOS 课程设计', 'about')
          this.MenuRow('退出登录', '返回登录页', 'logout')

          Text('收藏记录')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(TEXT_DARK)
            .width('100%')
            .margin({ top: 16, bottom: 10 })

          if (this.favorites.length === 0) {
            Text('暂无收藏，去详情页点亮收藏吧')
              .fontSize(14)
              .fontColor(TEXT_GRAY)
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding(24)
              .borderRadius(14)
              .backgroundColor('#FFFFFF')
          } else {
            ForEach(this.favorites, (item: FavoriteVO) => {
              Row() {
                this.FavoriteCover(item)
                Column() {
                  Text(item.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(TEXT_DARK)
                  Text(item.type === 'scenic' ? '景点收藏' : '美食收藏')
                    .fontSize(12)
                    .fontColor(TEXT_GRAY)
                    .margin({ top: 4 })
                }
                .layoutWeight(1)
                .margin({ left: 12 })
              }
              .width('100%')
              .padding(12)
              .borderRadius(14)
              .backgroundColor('#FFFFFF')
              .margin({ bottom: 10 })
              .onClick(() => {
                this.openFavorite(item);
              })
            }, (item: FavoriteVO) => `${item.type}-${item.targetId}`)
          }
        }
        .width('100%')
        .padding(18)
      }
      .layoutWeight(1)
      this.BottomNav()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  openFavorite(item: FavoriteVO) {
    if (item.type === 'scenic') {
      AppState.selectedScenicId = item.targetId;
      router.pushUrl({ url: 'pages/ScenicDetailPage' });
    } else {
      AppState.selectedFoodId = item.targetId;
      router.pushUrl({ url: 'pages/FoodDetailPage' });
    }
  }

  @Builder
  FavoriteCover(item: FavoriteVO) {
    if ((item.coverImage || '').length > 0) {
      Image(ApiService.assetUrl(item.coverImage || ''))
        .width(60)
        .height(60)
        .borderRadius(12)
        .objectFit(ImageFit.Cover)
        .backgroundColor(item.type === 'scenic' ? PRIMARY : BLUE)
    } else {
      Column() {
        Text(item.name.substring(0, 1))
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width(60)
      .height(60)
      .borderRadius(12)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(item.type === 'scenic' ? PRIMARY : BLUE)
    }
  }

  @Builder
  FavoriteMenuRow() {
    Row() {
      Text('我的收藏')
        .fontSize(16)
        .fontColor(TEXT_DARK)
        .fontWeight(FontWeight.Medium)
      Blank()
      Text(`${this.favoriteCount} 条`)
        .fontSize(13)
        .fontColor(TEXT_GRAY)
      Text('>')
        .fontSize(18)
        .fontColor('#9CA3AF')
        .margin({ left: 8 })
    }
    .width('100%')
    .height(54)
    .padding({ left: 16, right: 16 })
    .borderRadius(14)
    .backgroundColor('#FFFFFF')
    .margin({ bottom: 10 })
    .onClick(() => {
      this.loadFavorites();
      this.toast('收藏列表已刷新');
    })
  }

  @Builder
  MenuRow(title: string, value: string, action: string) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontColor(TEXT_DARK)
        .fontWeight(FontWeight.Medium)
      Blank()
      Text(value)
        .fontSize(13)
        .fontColor(TEXT_GRAY)
      Text('>')
        .fontSize(18)
        .fontColor('#9CA3AF')
        .margin({ left: 8 })
    }
    .width('100%')
    .height(54)
    .padding({ left: 16, right: 16 })
    .borderRadius(14)
    .backgroundColor('#FFFFFF')
    .margin({ bottom: 10 })
    .onClick(() => {
      if (action === 'refresh') {
        this.loadFavorites();
        this.toast('收藏列表已刷新');
      } else if (action === 'about') {
        this.toast('中山文旅美食导览 App');
      } else {
        this.logout();
      }
    })
  }

  @Builder
  BottomNav() {
    Row() {
      this.NavItem('首页', false, 'pages/HomePage')
      this.NavItem('景点', false, 'pages/ScenicListPage')
      this.NavItem('美食', false, 'pages/FoodListPage')
      this.NavItem('我的', true, 'pages/MinePage')
    }
    .width('100%')
    .height(64)
    .padding({ left: 8, right: 8 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  NavItem(title: string, active: boolean, targetUrl: string) {
    Column() {
      Text(title)
        .fontSize(14)
        .fontWeight(active ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(active ? PRIMARY : TEXT_GRAY)
    }
    .layoutWeight(1)
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      if (!active) {
        router.replaceUrl({ url: targetUrl });
      }
    })
  }
}

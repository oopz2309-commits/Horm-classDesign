import router from '@ohos.router';
import { AppState } from '../common/AppState';
import { BLUE, BLUE_LIGHT, Food, PAGE_BG, PRIMARY, PRIMARY_LIGHT, ScenicSpot, TEXT_DARK, TEXT_GRAY } from '../common/Models';
import { ApiService } from '../services/ApiService';

@Entry
@Component
struct HomePage {
  @State scenicList: ScenicSpot[] = AppState.scenicList;
  @State foodList: Food[] = AppState.foodList;

  async aboutToAppear() {
    try {
      const scenicResult = await ApiService.scenicList();
      if (scenicResult.code === 200 && scenicResult.data !== null) {
        AppState.scenicList = scenicResult.data;
        this.scenicList = scenicResult.data;
      }
    } catch (error) {
      this.scenicList = AppState.scenicList;
    }

    try {
      const foodResult = await ApiService.foodList();
      if (foodResult.code === 200 && foodResult.data !== null) {
        AppState.foodList = foodResult.data;
        this.foodList = foodResult.data;
      }
    } catch (error) {
      this.foodList = AppState.foodList;
    }
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Row() {
            Column() {
              Text('中山文旅美食导览')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor(TEXT_DARK)
              Text('清爽导览，轻松发现景点与美食')
                .fontSize(13)
                .fontColor(TEXT_GRAY)
                .margin({ top: 4 })
            }
            Blank()
            Text('搜')
              .fontSize(18)
              .fontColor(Color.White)
              .width(42)
              .height(42)
              .textAlign(TextAlign.Center)
              .borderRadius(21)
              .backgroundColor(BLUE)
              .onClick(() => {
                router.pushUrl({ url: 'pages/SearchPage' });
              })
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .padding({ top: 22, bottom: 18 })

          Column() {
            Text('发现中山之美')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
            Text('历史文化、岭南园林、地道风味，一站式导览')
              .fontSize(14)
              .fontColor('#E8FFF5')
              .margin({ top: 8 })
          }
          .width('100%')
          .height(154)
          .padding(22)
          .justifyContent(FlexAlign.Center)
          .borderRadius(18)
          .backgroundColor(PRIMARY)

          Row() {
            this.QuickEntry('景点', '看中山风光', PRIMARY_LIGHT, PRIMARY, 'pages/ScenicListPage')
            this.QuickEntry('美食', '尝本地味道', BLUE_LIGHT, BLUE, 'pages/FoodListPage')
          }
          .width('100%')
          .margin({ top: 16 })

          this.SectionTitle('热门景点', 'pages/ScenicListPage')
          ForEach(this.scenicList.slice(0, 3), (item: ScenicSpot) => {
            this.ScenicCard(item)
          }, (item: ScenicSpot) => item.id.toString())

          this.SectionTitle('推荐美食', 'pages/FoodListPage')
          ForEach(this.foodList.slice(0, 3), (item: Food) => {
            this.FoodCard(item)
          }, (item: Food) => item.id.toString())
        }
        .width('100%')
        .padding({ left: 18, right: 18, bottom: 18 })
      }
      .layoutWeight(1)
      this.BottomNav('home')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BG)
  }

  @Builder
  QuickEntry(title: string, subTitle: string, bg: string, color: string, targetUrl: string) {
    Column() {
      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
      Text(subTitle)
        .fontSize(12)
        .fontColor(TEXT_GRAY)
        .margin({ top: 4 })
    }
    .layoutWeight(1)
    .height(76)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(14)
    .backgroundColor(bg)
    .margin({ right: 8 })
    .onClick(() => {
      router.pushUrl({ url: targetUrl });
    })
  }

  @Builder
  SectionTitle(title: string, targetUrl: string) {
    Row() {
      Text(title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(TEXT_DARK)
      Blank()
      Text('查看全部')
        .fontSize(13)
        .fontColor(PRIMARY)
        .onClick(() => {
          router.pushUrl({ url: targetUrl });
        })
    }
    .width('100%')
    .margin({ top: 22, bottom: 10 })
  }

  @Builder
  ScenicCard(item: ScenicSpot) {
    Row() {
      this.SmallCover(item.name, PRIMARY, item.coverImage || '')
      Column() {
        Text(item.name)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(TEXT_DARK)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(item.description || '暂无介绍')
          .fontSize(13)
          .fontColor(TEXT_GRAY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 6 })
        Text(`评分 ${item.score || 5.0}`)
          .fontSize(12)
          .fontColor(PRIMARY)
          .margin({ top: 8 })
      }
      .layoutWeight(1)
      .margin({ left: 12 })
    }
    .width('100%')
    .padding(12)
    .borderRadius(14)
    .backgroundColor('#FFFFFF')
    .margin({ bottom: 12 })
    .onClick(() => {
      AppState.selectedScenicId = item.id;
      router.pushUrl({ url: 'pages/ScenicDetailPage' });
    })
  }

  @Builder
  FoodCard(item: Food) {
    Row() {
      this.SmallCover(item.name, BLUE, item.coverImage || '')
      Column() {
        Text(item.name)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(TEXT_DARK)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(item.description || '暂无介绍')
          .fontSize(13)
          .fontColor(TEXT_GRAY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 6 })
        Text(item.recommendShop || '推荐店铺')
          .fontSize(12)
          .fontColor(BLUE)
          .margin({ top: 8 })
      }
      .layoutWeight(1)
      .margin({ left: 12 })
    }
    .width('100%')
    .padding(12)
    .borderRadius(14)
    .backgroundColor('#FFFFFF')
    .margin({ bottom: 12 })
    .onClick(() => {
      AppState.selectedFoodId = item.id;
      router.pushUrl({ url: 'pages/FoodDetailPage' });
    })
  }

  @Builder
  SmallCover(name: string, color: string, coverImage: string) {
    if (coverImage.length > 0) {
      Image(ApiService.assetUrl(coverImage))
        .width(78)
        .height(78)
        .borderRadius(14)
        .objectFit(ImageFit.Cover)
        .backgroundColor(color)
    } else {
      Column() {
        Text(name.substring(0, 1))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width(78)
      .height(78)
      .borderRadius(14)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(color)
    }
  }

  @Builder
  BottomNav(active: string) {
    Row() {
      this.NavItem('首页', 'home', 'pages/HomePage', active)
      this.NavItem('景点', 'scenic', 'pages/ScenicListPage', active)
      this.NavItem('美食', 'food', 'pages/FoodListPage', active)
      this.NavItem('我的', 'mine', 'pages/MinePage', active)
    }
    .width('100%')
    .height(64)
    .padding({ left: 8, right: 8 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  NavItem(title: string, key: string, targetUrl: string, active: string) {
    Column() {
      Text(title)
        .fontSize(14)
        .fontWeight(active === key ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(active === key ? PRIMARY : TEXT_GRAY)
    }
    .layoutWeight(1)
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      if (active !== key) {
        router.replaceUrl({ url: targetUrl });
      }
    })
  }
}

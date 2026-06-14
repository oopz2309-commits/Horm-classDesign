import router from '@ohos.router';
import { AppState } from '../common/AppState';
import { BLUE, BLUE_LIGHT, Food, PAGE_BG, PRIMARY, TEXT_DARK, TEXT_GRAY } from '../common/Models';
import { ApiService } from '../services/ApiService';

@Entry
@Component
struct FoodListPage {
  @State list: Food[] = AppState.foodList;

  async aboutToAppear() {
    try {
      const result = await ApiService.foodList();
      if (result.code === 200 && result.data !== null) {
        AppState.foodList = result.data;
        this.list = result.data;
      }
    } catch (error) {
      this.list = AppState.foodList;
    }
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Column() {
            Text('中山美食')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(TEXT_DARK)
            Text('传统名菜、特色小吃、热门推荐')
              .fontSize(13)
              .fontColor(TEXT_GRAY)
              .margin({ top: 4 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ top: 18, bottom: 16 })

          Row() {
            this.Tag('热门', true)
            this.Tag('小吃', false)
            this.Tag('传统名菜', false)
          }
          .width('100%')
          .margin({ bottom: 10 })

          ForEach(this.list, (item: Food) => {
            this.FoodCard(item)
          }, (item: Food) => item.id.toString())
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

  @Builder
  Tag(text: string, active: boolean) {
    Text(text)
      .fontSize(13)
      .fontColor(active ? BLUE : TEXT_GRAY)
      .padding({ left: 14, right: 14, top: 7, bottom: 7 })
      .borderRadius(16)
      .backgroundColor(active ? BLUE_LIGHT : '#FFFFFF')
      .margin({ right: 8 })
  }

  @Builder
  FoodCard(item: Food) {
    Row() {
      if ((item.coverImage || '').length > 0) {
        Image(ApiService.assetUrl(item.coverImage || ''))
          .width(86)
          .height(86)
          .borderRadius(14)
          .objectFit(ImageFit.Cover)
          .backgroundColor(BLUE)
      } else {
        Column() {
          Text(item.name.substring(0, 1))
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width(86)
        .height(86)
        .borderRadius(14)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(BLUE)
      }

      Column() {
        Row() {
          Text(item.name)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor(TEXT_DARK)
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`¥${item.price || 0}`)
            .fontSize(12)
            .fontColor(BLUE)
        }
        .width('100%')
        Text(item.description || '暂无介绍')
          .fontSize(13)
          .fontColor(TEXT_GRAY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 6 })
        Text(item.recommendShop || '推荐店铺')
          .fontSize(12)
          .fontColor('#8A94A6')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
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
  BottomNav() {
    Row() {
      this.NavItem('首页', false, 'pages/HomePage')
      this.NavItem('景点', false, 'pages/ScenicListPage')
      this.NavItem('美食', true, 'pages/FoodListPage')
      this.NavItem('我的', false, 'pages/MinePage')
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

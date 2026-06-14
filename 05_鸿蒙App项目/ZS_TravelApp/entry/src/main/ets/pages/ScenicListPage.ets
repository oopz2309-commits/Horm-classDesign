import router from '@ohos.router';
import { AppState } from '../common/AppState';
import { PAGE_BG, PRIMARY, PRIMARY_LIGHT, ScenicSpot, TEXT_DARK, TEXT_GRAY } from '../common/Models';
import { ApiService } from '../services/ApiService';

@Entry
@Component
struct ScenicListPage {
  @State list: ScenicSpot[] = AppState.scenicList;

  async aboutToAppear() {
    try {
      const result = await ApiService.scenicList();
      if (result.code === 200 && result.data !== null) {
        AppState.scenicList = result.data;
        this.list = result.data;
      }
    } catch (error) {
      this.list = AppState.scenicList;
    }
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          this.TitleBlock()
          Row() {
            this.Tag('热门', true)
            this.Tag('历史文化', false)
            this.Tag('自然风光', false)
          }
          .width('100%')
          .margin({ bottom: 10 })
          ForEach(this.list, (item: ScenicSpot) => {
            this.ScenicCard(item)
          }, (item: ScenicSpot) => item.id.toString())
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
  TitleBlock() {
    Column() {
      Text('中山景点')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(TEXT_DARK)
      Text('历史文化、园林景观、自然风光')
        .fontSize(13)
        .fontColor(TEXT_GRAY)
        .margin({ top: 4 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 18, bottom: 16 })
  }

  @Builder
  Tag(text: string, active: boolean) {
    Text(text)
      .fontSize(13)
      .fontColor(active ? PRIMARY : TEXT_GRAY)
      .padding({ left: 14, right: 14, top: 7, bottom: 7 })
      .borderRadius(16)
      .backgroundColor(active ? PRIMARY_LIGHT : '#FFFFFF')
      .margin({ right: 8 })
  }

  @Builder
  ScenicCard(item: ScenicSpot) {
    Row() {
      Column() {
        Text(item.name.substring(0, 1))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width(78)
      .height(78)
      .borderRadius(14)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(PRIMARY)
      Column() {
        Row() {
          Text(item.name)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor(TEXT_DARK)
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`${item.score || 5.0}`)
            .fontSize(12)
            .fontColor(PRIMARY)
        }
        .width('100%')
        Text(item.description || '暂无介绍')
          .fontSize(13)
          .fontColor(TEXT_GRAY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 6 })
        Text(item.address || '中山市')
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
      AppState.selectedScenicId = item.id;
      router.pushUrl({ url: 'pages/ScenicDetailPage' });
    })
  }

  @Builder
  BottomNav() {
    Row() {
      this.NavItem('首页', false, 'pages/HomePage')
      this.NavItem('景点', true, 'pages/ScenicListPage')
      this.NavItem('美食', false, 'pages/FoodListPage')
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

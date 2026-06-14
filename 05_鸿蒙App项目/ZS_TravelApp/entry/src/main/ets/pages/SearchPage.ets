import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { AppState } from '../common/AppState';
import { BLUE, Food, PAGE_BG, PRIMARY, ScenicSpot, TEXT_DARK, TEXT_GRAY } from '../common/Models';
import { ApiService } from '../services/ApiService';

@Entry
@Component
struct SearchPage {
  @State keyword: string = '';
  @State scenicResults: ScenicSpot[] = [];
  @State foodResults: Food[] = [];

  toast(message: string) {
    promptAction.showToast({ message: message, duration: 1800 });
  }

  async search() {
    const value = this.keyword.trim();
    if (value.length === 0) {
      this.toast('请输入搜索关键词');
      return;
    }
    try {
      const result = await ApiService.search(value);
      if (result.code === 200 && result.data !== null) {
        this.scenicResults = result.data.scenicList;
        this.foodResults = result.data.foodList;
      }
    } catch (error) {
      this.scenicResults = AppState.scenicList.filter((item: ScenicSpot) => {
        return item.name.indexOf(value) >= 0 || (item.description || '').indexOf(value) >= 0;
      });
      this.foodResults = AppState.foodList.filter((item: Food) => {
        return item.name.indexOf(value) >= 0 || (item.description || '').indexOf(value) >= 0;
      });
      this.toast('后端未连接，已使用本地搜索');
    }
  }

  build() {
    Column() {
      this.TopBar()
      Row() {
        TextInput({ placeholder: '输入景点 / 美食关键词', text: this.keyword })
          .layoutWeight(1)
          .height(44)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .onChange((value: string) => {
            this.keyword = value;
          })
        Button('搜索')
          .height(44)
          .fontSize(14)
          .backgroundColor(PRIMARY)
          .borderRadius(12)
          .margin({ left: 10 })
          .onClick(() => {
            this.search();
          })
      }
      .width('100%')
      .padding({ left: 18, right: 18, bottom: 12 })

      Scroll() {
        Column() {
          if (this.scenicResults.length === 0 && this.foodResults.length === 0) {
            Text('输入关键词后，可同时搜索景点和美食')
              .fontSize(14)
              .fontColor(TEXT_GRAY)
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding(24)
              .borderRadius(14)
              .backgroundColor('#FFFFFF')
          } else {
            this.SectionTitle('景点结果')
            ForEach(this.scenicResults, (item: ScenicSpot) => {
              this.ResultCard(item.name, item.description || '暂无介绍', PRIMARY, 'pages/ScenicDetailPage', item.id, item.coverImage || '')
            }, (item: ScenicSpot) => `s-${item.id}`)
            this.SectionTitle('美食结果')
            ForEach(this.foodResults, (item: Food) => {
              this.ResultCard(item.name, item.description || '暂无介绍', BLUE, 'pages/FoodDetailPage', item.id, item.coverImage || '')
            }, (item: Food) => `f-${item.id}`)
          }
        }
        .width('100%')
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
      Text('搜索')
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
  SectionTitle(title: string) {
    Text(title)
      .fontSize(18)
      .fontWeight(FontWeight.Bold)
      .fontColor(TEXT_DARK)
      .width('100%')
      .margin({ top: 16, bottom: 10 })
  }

  @Builder
  ResultCard(title: string, desc: string, color: string, targetUrl: string, id: number, coverImage: string) {
    Row() {
      if (coverImage.length > 0) {
        Image(ApiService.assetUrl(coverImage))
          .width(64)
          .height(64)
          .borderRadius(12)
          .objectFit(ImageFit.Cover)
          .backgroundColor(color)
      } else {
        Column() {
          Text(title.substring(0, 1))
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width(64)
        .height(64)
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(color)
      }
      Column() {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(TEXT_DARK)
        Text(desc)
          .fontSize(13)
          .fontColor(TEXT_GRAY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 6 })
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
      if (targetUrl === 'pages/ScenicDetailPage') {
        AppState.selectedScenicId = id;
      } else {
        AppState.selectedFoodId = id;
      }
      router.pushUrl({ url: targetUrl });
    })
  }
}

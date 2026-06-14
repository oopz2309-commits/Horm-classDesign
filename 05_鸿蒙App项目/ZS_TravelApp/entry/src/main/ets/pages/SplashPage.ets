import router from '@ohos.router';
import { PAGE_BG, PRIMARY, PRIMARY_LIGHT, TEXT_DARK, TEXT_GRAY } from '../common/Models';

@Entry
@Component
struct SplashPage {
  aboutToAppear() {
    setTimeout(() => {
      router.replaceUrl({ url: 'pages/LoginPage' });
    }, 1200);
  }

  build() {
    Column() {
      Blank()
      Column() {
        Text('中')
          .fontSize(42)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width(96)
      .height(96)
      .borderRadius(28)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(PRIMARY)

      Text('中山文旅美食导览')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor(TEXT_DARK)
        .margin({ top: 26 })

      Text('发现中山之美，品味城市烟火')
        .fontSize(16)
        .fontColor(TEXT_GRAY)
        .margin({ top: 10 })

      Text('HarmonyOS 课程设计')
        .fontSize(13)
        .fontColor(PRIMARY)
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .borderRadius(18)
        .backgroundColor(PRIMARY_LIGHT)
        .margin({ top: 28 })
      Blank()
    }
    .width('100%')
    .height('100%')
    .padding(28)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(PAGE_BG)
  }
}

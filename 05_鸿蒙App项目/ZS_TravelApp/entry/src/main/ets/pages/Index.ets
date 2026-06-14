import router from '@ohos.router';
import { PAGE_BG } from '../common/Models';

@Entry
@Component
struct Index {
  aboutToAppear() {
    router.replaceUrl({ url: 'pages/SplashPage' });
  }

  build() {
    Column() {
      Text('中山文旅美食导览')
        .fontSize(20)
        .fontColor('#1F2937')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(PAGE_BG)
  }
}

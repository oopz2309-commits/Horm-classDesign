import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { AppState } from '../common/AppState';
import { BLUE, BLUE_LIGHT, PAGE_BG, PRIMARY, TEXT_DARK, TEXT_GRAY, User } from '../common/Models';
import { ApiService } from '../services/ApiService';

@Entry
@Component
struct LoginPage {
  @State username: string = 'zhangsan';
  @State password: string = '123456';
  @State loading: string = '';

  toast(message: string) {
    promptAction.showToast({ message: message, duration: 1800 });
  }

  async login() {
    if (this.username.trim().length === 0 || this.password.trim().length === 0) {
      this.toast('请输入用户名和密码');
      return;
    }

    this.loading = '正在登录...';
    try {
      const result = await ApiService.login(this.username, this.password);
      if (result.code === 200 && result.data !== null) {
        AppState.currentUser = result.data;
        this.toast('登录成功');
        router.replaceUrl({ url: 'pages/HomePage' });
      } else {
        this.toast(result.message || '登录失败');
      }
    } catch (error) {
      const user: User = {
        id: 2,
        username: this.username,
        nickname: this.username,
        token: 'local-demo-token'
      };
      AppState.currentUser = user;
      this.toast('后端未连接，已进入演示模式');
      router.replaceUrl({ url: 'pages/HomePage' });
    } finally {
      this.loading = '';
    }
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          Text('欢迎登录')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor(TEXT_DARK)
            .margin({ top: 56 })
          Text('中山文旅美食导览')
            .fontSize(16)
            .fontColor(TEXT_GRAY)
            .margin({ top: 8, bottom: 34 })

          Text('用户名')
            .fontSize(14)
            .fontColor(TEXT_DARK)
            .width('100%')
          TextInput({ placeholder: '请输入用户名', text: this.username })
            .height(48)
            .width('100%')
            .borderRadius(12)
            .backgroundColor(PAGE_BG)
            .margin({ top: 8, bottom: 14 })
            .onChange((value: string) => {
              this.username = value;
            })

          Text('密码')
            .fontSize(14)
            .fontColor(TEXT_DARK)
            .width('100%')
          TextInput({ placeholder: '请输入密码', text: this.password })
            .height(48)
            .width('100%')
            .type(InputType.Password)
            .borderRadius(12)
            .backgroundColor(PAGE_BG)
            .margin({ top: 8, bottom: 18 })
            .onChange((value: string) => {
              this.password = value;
            })

          Button('登录')
            .width('100%')
            .height(48)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(PRIMARY)
            .borderRadius(12)
            .onClick(() => {
              this.login();
            })

          Button('没有账号？去注册')
            .width('100%')
            .height(44)
            .fontSize(15)
            .fontColor(BLUE)
            .backgroundColor(Color.Transparent)
            .margin({ top: 12 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/RegisterPage' });
            })

          Text('演示账号：zhangsan / 123456')
            .fontSize(13)
            .fontColor(TEXT_GRAY)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(12)
            .borderRadius(12)
            .backgroundColor(BLUE_LIGHT)
            .margin({ top: 18 })
        }
        .width('100%')
        .padding(24)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')

      if (this.loading.length > 0) {
        Text(this.loading)
          .fontSize(14)
          .fontColor(Color.White)
          .padding({ left: 18, right: 18, top: 10, bottom: 10 })
          .borderRadius(18)
          .backgroundColor('#111827')
      }
    }
  }
}

import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { BLUE, PAGE_BG, PRIMARY, TEXT_DARK, TEXT_GRAY } from '../common/Models';
import { ApiService } from '../services/ApiService';

@Entry
@Component
struct RegisterPage {
  @State username: string = '';
  @State nickname: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State loading: string = '';

  toast(message: string) {
    promptAction.showToast({ message: message, duration: 1800 });
  }

  async register() {
    if (this.username.trim().length === 0 || this.nickname.trim().length === 0 || this.password.trim().length === 0) {
      this.toast('请完整填写注册信息');
      return;
    }
    if (this.password !== this.confirmPassword) {
      this.toast('两次密码不一致');
      return;
    }

    this.loading = '正在注册...';
    try {
      const result = await ApiService.register(this.username, this.password, this.nickname);
      if (result.code === 200) {
        this.toast('注册成功，请登录');
        router.back();
      } else {
        this.toast(result.message || '注册失败');
      }
    } catch (error) {
      this.toast('后端未连接，演示模式下请直接登录');
      router.back();
    } finally {
      this.loading = '';
    }
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
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
            Text('用户注册')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(TEXT_DARK)
              .margin({ left: 12 })
            Blank()
          }
          .width('100%')
          .margin({ top: 36, bottom: 24 })

          this.FormInput('用户名', '请输入注册账号', this.username, false, 'username')
          this.FormInput('昵称', '请输入昵称', this.nickname, false, 'nickname')
          this.FormInput('密码', '请输入密码', this.password, true, 'password')
          this.FormInput('确认密码', '请再次输入密码', this.confirmPassword, true, 'confirm')

          Button('注册')
            .width('100%')
            .height(48)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(PRIMARY)
            .borderRadius(12)
            .margin({ top: 18 })
            .onClick(() => {
              this.register();
            })

          Button('已有账号？去登录')
            .width('100%')
            .height(44)
            .fontSize(15)
            .fontColor(BLUE)
            .backgroundColor(Color.Transparent)
            .margin({ top: 12 })
            .onClick(() => {
              router.back();
            })
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

  @Builder
  FormInput(label: string, placeholder: string, valueText: string, passwordMode: boolean, field: string) {
    Column() {
      Text(label)
        .fontSize(14)
        .fontColor(TEXT_DARK)
        .width('100%')
      TextInput({ placeholder: placeholder, text: valueText })
        .height(48)
        .width('100%')
        .type(passwordMode ? InputType.Password : InputType.Normal)
        .borderRadius(12)
        .backgroundColor(PAGE_BG)
        .margin({ top: 8, bottom: 14 })
        .onChange((value: string) => {
          if (field === 'username') {
            this.username = value;
          } else if (field === 'nickname') {
            this.nickname = value;
          } else if (field === 'password') {
            this.password = value;
          } else {
            this.confirmPassword = value;
          }
        })
    }
    .width('100%')
  }
}

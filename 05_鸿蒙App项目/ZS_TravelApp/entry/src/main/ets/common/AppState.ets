import { CommentVO, FavoriteVO, Food, MOCK_FOOD, MOCK_SCENIC, ScenicSpot, User } from './Models';

export class AppState {
  static currentUser: User | undefined = undefined;
  static scenicList: ScenicSpot[] = MOCK_SCENIC;
  static foodList: Food[] = MOCK_FOOD;
  static favoriteList: FavoriteVO[] = [];
  static comments: CommentVO[] = [];
  static selectedScenicId: number = 1;
  static selectedFoodId: number = 1;

  static isLoggedIn(): boolean {
    return AppState.currentUser !== undefined && AppState.currentUser.id !== undefined;
  }

  static userId(): number {
    if (AppState.currentUser !== undefined && AppState.currentUser.id !== undefined) {
      return AppState.currentUser.id;
    }
    return 0;
  }

  static userName(): string {
    if (AppState.currentUser !== undefined) {
      return AppState.currentUser.nickname || AppState.currentUser.username;
    }
    return '游客';
  }

  static logout() {
    AppState.currentUser = undefined;
    AppState.favoriteList = [];
    AppState.comments = [];
  }
}

import { http } from '@kit.NetworkKit';
import {
  API_BASE_URLS,
  CommentRequest,
  CommentVO,
  FavoriteRequest,
  FavoriteVO,
  Food,
  LoginRequest,
  RegisterRequest,
  Result,
  ScenicSpot,
  SearchResultVO,
  User
} from '../common/Models';

export class ApiService {
  static activeBaseUrl: string = API_BASE_URLS[0];

  static async request<T>(path: string, method: http.RequestMethod, body?: string): Promise<Result<T>> {
    try {
      const result = await ApiService.requestWithBaseUrl<T>(ApiService.activeBaseUrl, path, method, body);
      return result;
    } catch (error) {
    }

    for (let index = 0; index < API_BASE_URLS.length; index++) {
      const baseUrl = API_BASE_URLS[index];
      if (baseUrl === ApiService.activeBaseUrl) {
        continue;
      }

      try {
        const result = await ApiService.requestWithBaseUrl<T>(baseUrl, path, method, body);
        ApiService.activeBaseUrl = baseUrl;
        return result;
      } catch (error) {
      }
    }

    throw new Error('后端接口连接失败');
  }

  static async requestWithBaseUrl<T>(baseUrl: string, path: string, method: http.RequestMethod, body?: string): Promise<Result<T>> {
    const client = http.createHttp();
    const options: http.HttpRequestOptions = {
      method: method,
      header: {
        'Content-Type': 'application/json'
      },
      connectTimeout: 6000,
      readTimeout: 6000
    };

    if (body !== undefined) {
      options.extraData = body;
    }

    try {
      const response = await client.request(baseUrl + path, options);
      return JSON.parse(`${response.result}`) as Result<T>;
    } finally {
      client.destroy();
    }
  }

  static login(username: string, password: string): Promise<Result<User>> {
    const body: LoginRequest = { username: username, password: password };
    return ApiService.request<User>('/api/user/login', http.RequestMethod.POST, JSON.stringify(body));
  }

  static register(username: string, password: string, nickname: string): Promise<Result<null>> {
    const body: RegisterRequest = { username: username, password: password, nickname: nickname };
    return ApiService.request<null>('/api/user/register', http.RequestMethod.POST, JSON.stringify(body));
  }

  static scenicList(): Promise<Result<ScenicSpot[]>> {
    return ApiService.request<ScenicSpot[]>('/api/scenic/list', http.RequestMethod.GET);
  }

  static scenicDetail(id: number): Promise<Result<ScenicSpot>> {
    return ApiService.request<ScenicSpot>(`/api/scenic/detail/${id}`, http.RequestMethod.GET);
  }

  static foodList(): Promise<Result<Food[]>> {
    return ApiService.request<Food[]>('/api/food/list', http.RequestMethod.GET);
  }

  static foodDetail(id: number): Promise<Result<Food>> {
    return ApiService.request<Food>(`/api/food/detail/${id}`, http.RequestMethod.GET);
  }

  static search(keyword: string): Promise<Result<SearchResultVO>> {
    return ApiService.request<SearchResultVO>(`/api/search?keyword=${encodeURIComponent(keyword)}`, http.RequestMethod.GET);
  }

  static favoriteList(userId: number): Promise<Result<FavoriteVO[]>> {
    return ApiService.request<FavoriteVO[]>(`/api/favorite/list/${userId}`, http.RequestMethod.GET);
  }

  static addFavorite(userId: number, targetId: number, type: string): Promise<Result<null>> {
    const body: FavoriteRequest = { userId: userId, targetId: targetId, type: type };
    return ApiService.request<null>('/api/favorite/add', http.RequestMethod.POST, JSON.stringify(body));
  }

  static cancelFavorite(userId: number, targetId: number, type: string): Promise<Result<null>> {
    const body: FavoriteRequest = { userId: userId, targetId: targetId, type: type };
    return ApiService.request<null>('/api/favorite/cancel', http.RequestMethod.POST, JSON.stringify(body));
  }

  static commentList(targetId: number, type: string): Promise<Result<CommentVO[]>> {
    return ApiService.request<CommentVO[]>(`/api/comment/list?targetId=${targetId}&type=${type}`, http.RequestMethod.GET);
  }

  static addComment(userId: number, targetId: number, type: string, content: string): Promise<Result<null>> {
    const body: CommentRequest = { userId: userId, targetId: targetId, type: type, content: content };
    return ApiService.request<null>('/api/comment/add', http.RequestMethod.POST, JSON.stringify(body));
  }
}

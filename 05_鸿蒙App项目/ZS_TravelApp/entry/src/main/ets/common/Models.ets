// HarmonyOS 模拟器中 127.0.0.1 指向模拟器自身，10.0.2.2 通常用于访问电脑宿主机。
export const API_BASE_URLS: string[] = [
  'http://10.0.2.2:8080',
  'http://127.0.0.1:8080',
  'http://localhost:8080'
];
export const PRIMARY: string = '#1E9E72';
export const PRIMARY_LIGHT: string = '#EAF8F2';
export const BLUE: string = '#2F80ED';
export const BLUE_LIGHT: string = '#EAF3FF';
export const TEXT_DARK: string = '#1F2937';
export const TEXT_GRAY: string = '#6B7280';
export const BORDER: string = '#E5E7EB';
export const PAGE_BG: string = '#F7FAF9';

export interface Result<T> {
  code: number;
  message: string;
  data: T | null;
}

export interface User {
  id?: number;
  username: string;
  password?: string;
  nickname?: string;
  avatar?: string;
  token?: string;
}

export interface ScenicSpot {
  id: number;
  name: string;
  coverImage?: string;
  videoUrl?: string;
  address?: string;
  description?: string;
  type?: string;
  score?: number;
}

export interface ScenicImageVO {
  id: number;
  scenicId: number;
  imageUrl: string;
  sortOrder?: number;
}

export interface Food {
  id: number;
  name: string;
  coverImage?: string;
  description?: string;
  recommendShop?: string;
  address?: string;
  price?: number;
}

export interface FavoriteVO {
  id: number;
  targetId: number;
  type: string;
  name: string;
  coverImage?: string;
}

export interface CommentVO {
  id: number;
  userId: number;
  nickname: string;
  content: string;
  createTime?: string;
}

export interface SearchResultVO {
  scenicList: ScenicSpot[];
  foodList: Food[];
}

export interface LoginRequest {
  username: string;
  password: string;
}

export interface RegisterRequest {
  username: string;
  password: string;
  nickname: string;
}

export interface FavoriteRequest {
  userId: number;
  targetId: number;
  type: string;
}

export interface CommentRequest {
  userId: number;
  targetId: number;
  type: string;
  content: string;
}

export interface DetailParams {
  id: number;
}

export const MOCK_SCENIC: ScenicSpot[] = [
  {
    id: 1,
    name: '孙中山故里旅游区',
    coverImage: '/images/scenic/sunzhongshan/1.jpg',
    videoUrl: '/videos/sunzhongshan.mp4',
    address: '广东省中山市南朗街道',
    description: '孙中山故里旅游区是中山市著名的历史文化景区，适合游客参观学习。',
    type: '历史文化',
    score: 4.8
  },
  {
    id: 2,
    name: '中山詹园',
    coverImage: '/images/scenic/zhanyuan/1.jpg',
    address: '广东省中山市南区',
    description: '中山詹园具有岭南园林特色，环境优美，建筑古朴典雅。',
    type: '园林景观',
    score: 4.6
  },
  {
    id: 3,
    name: '岐江公园',
    coverImage: '/images/scenic/qijiang/1.jpg',
    address: '广东省中山市石岐区',
    description: '岐江公园是城市休闲散步和游客观光的好去处。',
    type: '城市公园',
    score: 4.5
  },
  {
    id: 4,
    name: '紫马岭公园',
    coverImage: '/images/scenic/zimaling/1.jpg',
    address: '广东省中山市东区',
    description: '紫马岭公园环境清新，适合亲子游玩和户外活动。',
    type: '自然风光',
    score: 4.4
  },
  {
    id: 5,
    name: '小榄菊花园',
    coverImage: '/images/scenic/xiaolan/1.jpg',
    address: '广东省中山市小榄镇',
    description: '小榄菊花园以菊花文化为特色，是地方文化展示窗口。',
    type: '地方文化',
    score: 4.5
  }
];

export const MOCK_FOOD: Food[] = [
  {
    id: 1,
    name: '石岐乳鸽',
    coverImage: '/images/food/shiqiruge.jpg',
    description: '石岐乳鸽是中山市传统特色美食，以皮脆、肉嫩、味香为主要特点。',
    recommendShop: '石岐佬中山菜馆',
    address: '广东省中山市石岐街道',
    price: 60
  },
  {
    id: 2,
    name: '沙溪扣肉',
    coverImage: '/images/food/shaxikourou.jpg',
    description: '沙溪扣肉口感软糯，肥而不腻，具有鲜明地方特色。',
    recommendShop: '沙溪本地餐馆',
    address: '广东省中山市沙溪镇',
    price: 50
  },
  {
    id: 3,
    name: '三乡濑粉',
    coverImage: '/images/food/sanxianglaifen.jpg',
    description: '三乡濑粉口感爽滑，汤味鲜美，是中山传统特色小吃。',
    recommendShop: '三乡濑粉店',
    address: '广东省中山市三乡镇',
    price: 18
  },
  {
    id: 4,
    name: '中山脆肉鲩',
    coverImage: '/images/food/cuirouwan.jpg',
    description: '中山脆肉鲩肉质爽脆，是中山市具有代表性的水产美食。',
    recommendShop: '中山脆肉鲩餐厅',
    address: '广东省中山市东升镇',
    price: 80
  },
  {
    id: 5,
    name: '小榄菊花宴',
    coverImage: '/images/food/juhuayan.jpg',
    description: '小榄菊花宴融合菊花文化和地方饮食文化，清雅有特色。',
    recommendShop: '小榄特色酒楼',
    address: '广东省中山市小榄镇',
    price: 100
  }
];

-- =============================================
-- 中山文旅美食导览 App 数据库初始化脚本
-- 数据库名称: zs_travel_app
-- =============================================

-- 1. 用户表
CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '用户密码',
    nickname VARCHAR(50) DEFAULT NULL COMMENT '用户昵称',
    avatar VARCHAR(255) DEFAULT NULL COMMENT '用户头像地址',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间'
) COMMENT='用户表';

-- 2. 景点表
CREATE TABLE IF NOT EXISTS scenic_spot (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '景点ID',
    name VARCHAR(100) NOT NULL COMMENT '景点名称',
    cover_image VARCHAR(255) DEFAULT NULL COMMENT '景点封面图',
    video_url VARCHAR(255) DEFAULT NULL COMMENT '景点视频地址',
    address VARCHAR(255) DEFAULT NULL COMMENT '景点地址',
    description TEXT COMMENT '景点介绍',
    type VARCHAR(50) DEFAULT NULL COMMENT '景点类型',
    score DECIMAL(2,1) DEFAULT 5.0 COMMENT '推荐评分',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT='景点表';

-- 3. 美食表
CREATE TABLE IF NOT EXISTS food (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '美食ID',
    name VARCHAR(100) NOT NULL COMMENT '美食名称',
    cover_image VARCHAR(255) DEFAULT NULL COMMENT '美食封面图',
    description TEXT COMMENT '美食介绍',
    recommend_shop VARCHAR(100) DEFAULT NULL COMMENT '推荐店铺',
    address VARCHAR(255) DEFAULT NULL COMMENT '店铺地址',
    price DECIMAL(6,2) DEFAULT NULL COMMENT '人均价格',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT='美食表';

-- 4. 收藏表
CREATE TABLE IF NOT EXISTS favorite (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '收藏ID',
    user_id INT NOT NULL COMMENT '用户ID',
    target_id INT NOT NULL COMMENT '收藏对象ID',
    type VARCHAR(20) NOT NULL COMMENT '收藏类型：scenic或food',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间'
) COMMENT='收藏表';

-- 5. 评论表
CREATE TABLE IF NOT EXISTS comment (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '评论ID',
    user_id INT NOT NULL COMMENT '用户ID',
    target_id INT NOT NULL COMMENT '评论对象ID',
    type VARCHAR(20) NOT NULL COMMENT '评论类型：scenic或food',
    content VARCHAR(500) NOT NULL COMMENT '评论内容',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间'
) COMMENT='评论表';

-- =============================================
-- 测试数据
-- =============================================

-- 用户测试数据
INSERT INTO user (username, password, nickname, avatar) VALUES
('admin', '123456', '管理员', ''),
('zhangsan', '123456', '张三', ''),
('lisi', '123456', '李四', '');

-- 景点测试数据
INSERT INTO scenic_spot
(name, cover_image, video_url, address, description, type, score)
VALUES
('孙中山故里旅游区', '/images/scenic/sunzhongshan.jpg', '/videos/sunzhongshan.mp4', '广东省中山市南朗街道', '孙中山故里旅游区是中山市著名的历史文化景区，具有丰富的历史文化价值，适合游客参观学习。', '历史文化', 4.8),
('中山詹园', '/images/scenic/zhanyuan.jpg', '', '广东省中山市南区', '中山詹园是一座具有岭南园林特色的景区，环境优美，建筑古朴典雅。', '园林景观', 4.6),
('岐江公园', '/images/scenic/qijiang.jpg', '', '广东省中山市石岐区', '岐江公园位于中山市城区，是市民休闲散步和游客观光的好去处。', '城市公园', 4.5),
('紫马岭公园', '/images/scenic/zimaling.jpg', '', '广东省中山市东区', '紫马岭公园环境优美，适合亲子游玩、运动休闲和户外活动。', '自然风光', 4.4),
('小榄菊花园', '/images/scenic/xiaolan.jpg', '', '广东省中山市小榄镇', '小榄菊花园以菊花文化为特色，是中山地方文化的重要展示窗口。', '地方文化', 4.5);

-- 美食测试数据
INSERT INTO food
(name, cover_image, description, recommend_shop, address, price)
VALUES
('石岐乳鸽', '/images/food/shiqiruge.jpg', '石岐乳鸽是中山市传统特色美食，以皮脆、肉嫩、味香为主要特点。', '石岐佬中山菜馆', '广东省中山市石岐街道', 60.00),
('沙溪扣肉', '/images/food/shaxikourou.jpg', '沙溪扣肉是中山沙溪镇的传统名菜，口感软糯，肥而不腻。', '沙溪本地餐馆', '广东省中山市沙溪镇', 50.00),
('三乡濑粉', '/images/food/sanxianglaifen.jpg', '三乡濑粉是中山市三乡镇传统特色小吃，口感爽滑，汤味鲜美。', '三乡濑粉店', '广东省中山市三乡镇', 18.00),
('中山脆肉鲩', '/images/food/cuirouwan.jpg', '中山脆肉鲩肉质爽脆，是中山市具有代表性的特色水产美食。', '中山脆肉鲩餐厅', '广东省中山市东升镇', 80.00),
('小榄菊花宴', '/images/food/juhuayan.jpg', '小榄菊花宴结合菊花文化和地方饮食文化，具有鲜明的地方特色。', '小榄特色酒楼', '广东省中山市小榄镇', 100.00);

-- 收藏测试数据
INSERT INTO favorite (user_id, target_id, type) VALUES
(2, 1, 'scenic'),
(2, 1, 'food'),
(3, 2, 'scenic');

-- 评论测试数据
INSERT INTO comment (user_id, target_id, type, content) VALUES
(2, 1, 'scenic', '景区很有历史意义，适合周末参观。'),
(3, 1, 'scenic', '环境不错，能够了解孙中山先生的故事。'),
(2, 1, 'food', '石岐乳鸽味道很好，皮脆肉嫩。');

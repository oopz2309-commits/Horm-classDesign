package com.zs.travel.entity;

import lombok.Data;

/**
 * 收藏列表视图对象，用于返回收藏列表时包含关联的景点/美食名称和封面图
 */
@Data
public class FavoriteVO {

    private Integer id;
    private Integer targetId;
    private String type;
    private String name;
    private String coverImage;
}

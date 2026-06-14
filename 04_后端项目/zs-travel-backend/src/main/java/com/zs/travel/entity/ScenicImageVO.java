package com.zs.travel.entity;

import lombok.Data;

@Data
public class ScenicImageVO {

    private Integer id;
    private Integer scenicId;
    private String imageUrl;
    private Integer sortOrder;
}

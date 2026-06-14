package com.zs.travel.entity;

import lombok.Data;

import java.util.List;

/**
 * 统一搜索返回视图对象
 */
@Data
public class SearchResultVO {

    private List<ScenicSpot> scenicList;
    private List<Food> foodList;
}

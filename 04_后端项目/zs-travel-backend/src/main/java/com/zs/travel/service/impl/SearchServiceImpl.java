package com.zs.travel.service.impl;

import com.zs.travel.common.Result;
import com.zs.travel.entity.Food;
import com.zs.travel.entity.ScenicSpot;
import com.zs.travel.entity.SearchResultVO;
import com.zs.travel.mapper.FoodMapper;
import com.zs.travel.mapper.ScenicMapper;
import com.zs.travel.service.SearchService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class SearchServiceImpl implements SearchService {

    private final ScenicMapper scenicMapper;
    private final FoodMapper foodMapper;

    public SearchServiceImpl(ScenicMapper scenicMapper, FoodMapper foodMapper) {
        this.scenicMapper = scenicMapper;
        this.foodMapper = foodMapper;
    }

    @Override
    public Result<SearchResultVO> search(String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return Result.error("搜索关键词不能为空");
        }

        String kw = keyword.trim();
        List<ScenicSpot> scenicList = scenicMapper.search(kw);
        List<Food> foodList = foodMapper.search(kw);

        SearchResultVO result = new SearchResultVO();
        result.setScenicList(scenicList);
        result.setFoodList(foodList);

        return Result.success("查询成功", result);
    }
}

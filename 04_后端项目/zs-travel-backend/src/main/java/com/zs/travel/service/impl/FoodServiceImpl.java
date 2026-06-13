package com.zs.travel.service.impl;

import com.zs.travel.common.Result;
import com.zs.travel.entity.Food;
import com.zs.travel.mapper.FoodMapper;
import com.zs.travel.service.FoodService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class FoodServiceImpl implements FoodService {

    private final FoodMapper foodMapper;

    public FoodServiceImpl(FoodMapper foodMapper) {
        this.foodMapper = foodMapper;
    }

    @Override
    public Result<List<Food>> list() {
        return Result.success("查询成功", foodMapper.selectList());
    }

    @Override
    public Result<Food> detail(Integer id) {
        if (id == null || id <= 0) {
            return Result.error("美食ID不能为空");
        }

        Food food = foodMapper.selectById(id);
        if (food == null) {
            return Result.error("美食不存在");
        }

        return Result.success("查询成功", food);
    }

    @Override
    public Result<List<Food>> search(String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return Result.error("关键词不能为空");
        }

        return Result.success("查询成功", foodMapper.search(keyword.trim()));
    }
}

package com.zs.travel.service;

import com.zs.travel.common.Result;
import com.zs.travel.entity.Food;

import java.util.List;

public interface FoodService {

    Result<List<Food>> list();

    Result<Food> detail(Integer id);

    Result<List<Food>> search(String keyword);
}

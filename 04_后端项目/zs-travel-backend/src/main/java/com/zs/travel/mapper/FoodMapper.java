package com.zs.travel.mapper;

import com.zs.travel.entity.Food;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FoodMapper {

    List<Food> selectList();

    Food selectById(@Param("id") Integer id);

    List<Food> search(@Param("keyword") String keyword);
}

package com.zs.travel.controller;

import com.zs.travel.common.Result;
import com.zs.travel.entity.Food;
import com.zs.travel.service.FoodService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/food")
public class FoodController {

    private final FoodService foodService;

    public FoodController(FoodService foodService) {
        this.foodService = foodService;
    }

    @GetMapping("/list")
    public Result<List<Food>> list() {
        return foodService.list();
    }

    @GetMapping("/detail/{id}")
    public Result<Food> detail(@PathVariable Integer id) {
        return foodService.detail(id);
    }

    @GetMapping("/search")
    public Result<List<Food>> search(@RequestParam String keyword) {
        return foodService.search(keyword);
    }
}

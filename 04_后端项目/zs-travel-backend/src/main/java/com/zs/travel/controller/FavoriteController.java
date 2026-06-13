package com.zs.travel.controller;

import com.zs.travel.common.Result;
import com.zs.travel.entity.Favorite;
import com.zs.travel.entity.FavoriteVO;
import com.zs.travel.service.FavoriteService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/favorite")
public class FavoriteController {

    private final FavoriteService favoriteService;

    public FavoriteController(FavoriteService favoriteService) {
        this.favoriteService = favoriteService;
    }

    @PostMapping("/add")
    public Result<Void> add(@RequestBody Favorite favorite) {
        return favoriteService.add(favorite.getUserId(), favorite.getTargetId(), favorite.getType());
    }

    @PostMapping("/cancel")
    public Result<Void> cancel(@RequestBody Favorite favorite) {
        return favoriteService.cancel(favorite.getUserId(), favorite.getTargetId(), favorite.getType());
    }

    @GetMapping("/list/{userId}")
    public Result<List<FavoriteVO>> list(@PathVariable Integer userId) {
        return favoriteService.list(userId);
    }
}

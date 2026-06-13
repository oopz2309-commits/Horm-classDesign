package com.zs.travel.service.impl;

import com.zs.travel.common.Result;
import com.zs.travel.entity.Favorite;
import com.zs.travel.entity.FavoriteVO;
import com.zs.travel.mapper.FavoriteMapper;
import com.zs.travel.service.FavoriteService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FavoriteServiceImpl implements FavoriteService {

    private final FavoriteMapper favoriteMapper;

    public FavoriteServiceImpl(FavoriteMapper favoriteMapper) {
        this.favoriteMapper = favoriteMapper;
    }

    @Override
    public Result<Void> add(Integer userId, Integer targetId, String type) {
        if (userId == null || userId <= 0) {
            return Result.error("用户ID不能为空");
        }
        if (targetId == null || targetId <= 0) {
            return Result.error("收藏对象ID不能为空");
        }
        if (type == null || (!type.equals("scenic") && !type.equals("food"))) {
            return Result.error("收藏类型无效，必须为 scenic 或 food");
        }

        int count = favoriteMapper.countByUserAndTarget(userId, targetId, type);
        if (count > 0) {
            return Result.error("已经收藏过了");
        }

        Favorite favorite = new Favorite();
        favorite.setUserId(userId);
        favorite.setTargetId(targetId);
        favorite.setType(type);
        favoriteMapper.insert(favorite);

        return Result.success("收藏成功", null);
    }

    @Override
    public Result<Void> cancel(Integer userId, Integer targetId, String type) {
        if (userId == null || userId <= 0) {
            return Result.error("用户ID不能为空");
        }
        if (targetId == null || targetId <= 0) {
            return Result.error("收藏对象ID不能为空");
        }
        if (type == null || (!type.equals("scenic") && !type.equals("food"))) {
            return Result.error("收藏类型无效，必须为 scenic 或 food");
        }

        int count = favoriteMapper.countByUserAndTarget(userId, targetId, type);
        if (count == 0) {
            return Result.error("收藏记录不存在");
        }

        favoriteMapper.deleteByUserAndTarget(userId, targetId, type);
        return Result.success("取消收藏成功", null);
    }

    @Override
    public Result<List<FavoriteVO>> list(Integer userId) {
        if (userId == null || userId <= 0) {
            return Result.error("用户ID不能为空");
        }

        return Result.success("查询成功", favoriteMapper.selectListByUserId(userId));
    }
}

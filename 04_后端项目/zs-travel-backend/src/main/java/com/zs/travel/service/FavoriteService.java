package com.zs.travel.service;

import com.zs.travel.common.Result;
import com.zs.travel.entity.FavoriteVO;

import java.util.List;

public interface FavoriteService {

    Result<Void> add(Integer userId, Integer targetId, String type);

    Result<Void> cancel(Integer userId, Integer targetId, String type);

    Result<List<FavoriteVO>> list(Integer userId);
}

package com.zs.travel.service;

import com.zs.travel.common.Result;
import com.zs.travel.entity.ScenicImageVO;
import com.zs.travel.entity.ScenicSpot;

import java.util.List;

public interface ScenicService {

    Result<List<ScenicSpot>> list();

    Result<ScenicSpot> detail(Integer id);

    Result<List<ScenicImageVO>> images(Integer scenicId);

    Result<List<ScenicSpot>> search(String keyword);
}

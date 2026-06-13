package com.zs.travel.service.impl;

import com.zs.travel.common.Result;
import com.zs.travel.entity.ScenicSpot;
import com.zs.travel.mapper.ScenicMapper;
import com.zs.travel.service.ScenicService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ScenicServiceImpl implements ScenicService {

    private final ScenicMapper scenicMapper;

    public ScenicServiceImpl(ScenicMapper scenicMapper) {
        this.scenicMapper = scenicMapper;
    }

    @Override
    public Result<List<ScenicSpot>> list() {
        return Result.success("查询成功", scenicMapper.selectList());
    }
}

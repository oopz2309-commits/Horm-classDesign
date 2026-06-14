package com.zs.travel.service.impl;

import com.zs.travel.common.Result;
import com.zs.travel.entity.ScenicImageVO;
import com.zs.travel.entity.ScenicSpot;
import com.zs.travel.mapper.ScenicMapper;
import com.zs.travel.service.ScenicService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

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

    @Override
    public Result<ScenicSpot> detail(Integer id) {
        if (id == null || id <= 0) {
            return Result.error("景点ID不能为空");
        }

        ScenicSpot scenicSpot = scenicMapper.selectById(id);
        if (scenicSpot == null) {
            return Result.error("景点不存在");
        }

        return Result.success("查询成功", scenicSpot);
    }

    @Override
    public Result<List<ScenicImageVO>> images(Integer scenicId) {
        if (scenicId == null || scenicId <= 0) {
            return Result.error("景点ID不能为空");
        }

        return Result.success("查询成功", scenicMapper.selectImagesByScenicId(scenicId));
    }

    @Override
    public Result<List<ScenicSpot>> search(String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return Result.error("关键词不能为空");
        }

        return Result.success("查询成功", scenicMapper.search(keyword.trim()));
    }
}

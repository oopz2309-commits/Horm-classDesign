package com.zs.travel.mapper;

import com.zs.travel.entity.ScenicImageVO;
import com.zs.travel.entity.ScenicSpot;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ScenicMapper {

    List<ScenicSpot> selectList();

    ScenicSpot selectById(@Param("id") Integer id);

    List<ScenicImageVO> selectImagesByScenicId(@Param("scenicId") Integer scenicId);

    List<ScenicSpot> search(@Param("keyword") String keyword);
}

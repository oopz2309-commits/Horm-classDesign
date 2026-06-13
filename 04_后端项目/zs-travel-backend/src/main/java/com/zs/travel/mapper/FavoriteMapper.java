package com.zs.travel.mapper;

import com.zs.travel.entity.Favorite;
import com.zs.travel.entity.FavoriteVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FavoriteMapper {

    int insert(Favorite favorite);

    int deleteByUserAndTarget(@Param("userId") Integer userId,
                              @Param("targetId") Integer targetId,
                              @Param("type") String type);

    int countByUserAndTarget(@Param("userId") Integer userId,
                             @Param("targetId") Integer targetId,
                             @Param("type") String type);

    List<FavoriteVO> selectListByUserId(@Param("userId") Integer userId);
}

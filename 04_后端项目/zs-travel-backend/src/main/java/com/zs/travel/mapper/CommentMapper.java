package com.zs.travel.mapper;

import com.zs.travel.entity.Comment;
import com.zs.travel.entity.CommentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommentMapper {

    List<CommentVO> selectByTargetAndType(@Param("targetId") Integer targetId,
                                          @Param("type") String type);

    int insert(Comment comment);
}

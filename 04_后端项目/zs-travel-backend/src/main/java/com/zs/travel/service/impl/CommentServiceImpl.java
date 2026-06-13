package com.zs.travel.service.impl;

import com.zs.travel.common.Result;
import com.zs.travel.entity.Comment;
import com.zs.travel.entity.CommentVO;
import com.zs.travel.mapper.CommentMapper;
import com.zs.travel.service.CommentService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class CommentServiceImpl implements CommentService {

    private final CommentMapper commentMapper;

    public CommentServiceImpl(CommentMapper commentMapper) {
        this.commentMapper = commentMapper;
    }

    @Override
    public Result<List<CommentVO>> list(Integer targetId, String type) {
        if (targetId == null || targetId <= 0) {
            return Result.error("评论对象ID不能为空");
        }
        if (!StringUtils.hasText(type)) {
            return Result.error("评论类型不能为空");
        }
        if (!"scenic".equals(type) && !"food".equals(type)) {
            return Result.error("评论类型无效，只能为 scenic 或 food");
        }

        return Result.success("查询成功", commentMapper.selectByTargetAndType(targetId, type));
    }

    @Override
    public Result<Void> add(Integer userId, Integer targetId, String type, String content) {
        if (userId == null || userId <= 0) {
            return Result.error("用户ID不能为空");
        }
        if (targetId == null || targetId <= 0) {
            return Result.error("评论对象ID不能为空");
        }
        if (!StringUtils.hasText(type)) {
            return Result.error("评论类型不能为空");
        }
        if (!"scenic".equals(type) && !"food".equals(type)) {
            return Result.error("评论类型无效，只能为 scenic 或 food");
        }
        if (!StringUtils.hasText(content)) {
            return Result.error("评论内容不能为空");
        }

        Comment comment = new Comment();
        comment.setUserId(userId);
        comment.setTargetId(targetId);
        comment.setType(type);
        comment.setContent(content.trim());
        commentMapper.insert(comment);
        return Result.success("评论成功", null);
    }
}

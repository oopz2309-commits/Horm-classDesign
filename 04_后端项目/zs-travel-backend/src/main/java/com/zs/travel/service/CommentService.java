package com.zs.travel.service;

import com.zs.travel.common.Result;
import com.zs.travel.entity.CommentVO;

import java.util.List;

public interface CommentService {

    Result<List<CommentVO>> list(Integer targetId, String type);

    Result<Void> add(Integer userId, Integer targetId, String type, String content);
}

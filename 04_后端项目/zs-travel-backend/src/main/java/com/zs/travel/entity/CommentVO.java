package com.zs.travel.entity;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 评论列表视图对象，用于返回评论列表时包含关联的用户昵称
 */
@Data
public class CommentVO {

    private Integer id;
    private Integer userId;
    private String nickname;
    private String content;
    private LocalDateTime createTime;
}

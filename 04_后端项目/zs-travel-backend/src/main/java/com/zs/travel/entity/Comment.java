package com.zs.travel.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Comment {

    private Integer id;
    private Integer userId;
    private Integer targetId;
    private String type;
    private String content;
    private LocalDateTime createTime;
}

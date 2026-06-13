package com.zs.travel.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class ScenicSpot {

    private Integer id;
    private String name;
    private String coverImage;
    private String videoUrl;
    private String address;
    private String description;
    private String type;
    private BigDecimal score;
    private LocalDateTime createTime;
}

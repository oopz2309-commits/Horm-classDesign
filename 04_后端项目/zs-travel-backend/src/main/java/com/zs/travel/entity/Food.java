package com.zs.travel.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Food {

    private Integer id;
    private String name;
    private String coverImage;
    private String description;
    private String recommendShop;
    private String address;
    private BigDecimal price;
    private LocalDateTime createTime;
}

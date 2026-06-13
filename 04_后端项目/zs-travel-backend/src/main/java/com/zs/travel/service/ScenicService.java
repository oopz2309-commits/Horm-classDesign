package com.zs.travel.service;

import com.zs.travel.common.Result;
import com.zs.travel.entity.ScenicSpot;

import java.util.List;

public interface ScenicService {

    Result<List<ScenicSpot>> list();
}

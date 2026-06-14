package com.zs.travel.service;

import com.zs.travel.common.Result;
import com.zs.travel.entity.SearchResultVO;

public interface SearchService {

    Result<SearchResultVO> search(String keyword);
}

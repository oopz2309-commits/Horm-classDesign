package com.zs.travel.controller;

import com.zs.travel.common.Result;
import com.zs.travel.entity.SearchResultVO;
import com.zs.travel.service.SearchService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class SearchController {

    private final SearchService searchService;

    public SearchController(SearchService searchService) {
        this.searchService = searchService;
    }

    @GetMapping("/search")
    public Result<SearchResultVO> search(@RequestParam String keyword) {
        return searchService.search(keyword);
    }
}

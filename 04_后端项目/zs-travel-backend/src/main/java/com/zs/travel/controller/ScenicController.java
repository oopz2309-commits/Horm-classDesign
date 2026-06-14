package com.zs.travel.controller;

import com.zs.travel.common.Result;
import com.zs.travel.entity.ScenicImageVO;
import com.zs.travel.entity.ScenicSpot;
import com.zs.travel.service.ScenicService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/scenic")
public class ScenicController {

    private final ScenicService scenicService;

    public ScenicController(ScenicService scenicService) {
        this.scenicService = scenicService;
    }

    @GetMapping("/list")
    public Result<List<ScenicSpot>> list() {
        return scenicService.list();
    }

    @GetMapping("/detail/{id}")
    public Result<ScenicSpot> detail(@PathVariable Integer id) {
        return scenicService.detail(id);
    }

    @GetMapping("/images/{scenicId}")
    public Result<List<ScenicImageVO>> images(@PathVariable Integer scenicId) {
        return scenicService.images(scenicId);
    }

    @GetMapping("/search")
    public Result<List<ScenicSpot>> search(@RequestParam String keyword) {
        return scenicService.search(keyword);
    }
}

package com.zs.travel.controller;

import com.zs.travel.common.Result;
import com.zs.travel.entity.Comment;
import com.zs.travel.entity.CommentVO;
import com.zs.travel.service.CommentService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/comment")
public class CommentController {

    private final CommentService commentService;

    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }

    @GetMapping("/list")
    public Result<List<CommentVO>> list(@RequestParam Integer targetId,
                                         @RequestParam String type) {
        return commentService.list(targetId, type);
    }

    @PostMapping("/add")
    public Result<Void> add(@RequestBody Comment comment) {
        return commentService.add(comment.getUserId(), comment.getTargetId(),
                comment.getType(), comment.getContent());
    }
}

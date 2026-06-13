package com.zs.travel.controller;

import com.zs.travel.common.Result;
import com.zs.travel.entity.User;
import com.zs.travel.service.UserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public Result<Void> register(@RequestBody User user) {
        return userService.register(user);
    }

    @PostMapping("/login")
    public Result<Object> login(@RequestBody User user) {
        return userService.login(user);
    }

    @GetMapping("/info/{id}")
    public Result<Object> info(@PathVariable Integer id) {
        return userService.getUserInfo(id);
    }
}

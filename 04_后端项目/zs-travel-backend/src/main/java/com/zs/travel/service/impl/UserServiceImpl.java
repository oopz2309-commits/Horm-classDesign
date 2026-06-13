package com.zs.travel.service.impl;

import com.zs.travel.common.Result;
import com.zs.travel.entity.User;
import com.zs.travel.mapper.UserMapper;
import com.zs.travel.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;

    public UserServiceImpl(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @Override
    public Result<Void> register(User user) {
        if (user == null) {
            return Result.error("请求参数不能为空");
        }
        if (!StringUtils.hasText(user.getUsername())) {
            return Result.error("用户名不能为空");
        }
        if (!StringUtils.hasText(user.getPassword())) {
            return Result.error("密码不能为空");
        }

        String username = user.getUsername().trim();
        if (userMapper.countByUsername(username) > 0) {
            return Result.error("用户名已存在");
        }

        user.setUsername(username);
        if (StringUtils.hasText(user.getNickname())) {
            user.setNickname(user.getNickname().trim());
        }
        if (user.getAvatar() == null) {
            user.setAvatar("");
        }

        userMapper.insertUser(user);
        return Result.success("注册成功", null);
    }
}

package com.zs.travel.service;

import com.zs.travel.common.Result;
import com.zs.travel.entity.User;

public interface UserService {

    Result<Void> register(User user);
}

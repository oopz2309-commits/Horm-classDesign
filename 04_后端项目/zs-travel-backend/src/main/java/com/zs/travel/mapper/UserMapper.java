package com.zs.travel.mapper;

import com.zs.travel.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserMapper {

    int countByUsername(@Param("username") String username);

    User selectById(@Param("id") Integer id);

    User selectByUsername(@Param("username") String username);

    int insertUser(User user);
}

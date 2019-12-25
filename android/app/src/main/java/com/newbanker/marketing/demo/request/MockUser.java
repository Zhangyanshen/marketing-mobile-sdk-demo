package com.newbanker.marketing.demo.request;

import java.util.List;

public class MockUser {
    public int code;
    public String msg;
    public List<User> param;
    public boolean success;

    public class User{
        public String name;
        public String userId;
        public String token;
    }
}

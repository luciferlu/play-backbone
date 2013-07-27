package me.ezcode.pojo;

import java.util.Map;
import java.util.HashMap;

public class User{
    public final static Map<String, User> USERS = new HashMap<String, User>();

    static{
        USERS.put("0001", new User("tanxianhu"));
    }
    private String name;

    public User(String name){
        this.name = name;
    }

    public User(){}

    public String getName(){
        return name;
    }

    public void setName(String name){
        this.name = name;
    }
}

package com.campusmatching.controller;

import java.util.HashMap;
import java.util.Map;

public class RequestMapping {

    private final Map<String, Controller> mapping = new HashMap<>();

    public void initMapping() {
        mapping.put("/login", new LoginController());
        mapping.put("/registerForm", new RegisterController());
        mapping.put("/logout", new LogoutController());
        mapping.put("/mypage/account-edit", new UpdateUserController());
        mapping.put("/account-edit", new UpdateUserController());
        mapping.put("/mypage/password/edit", new ChangePasswordController());
        mapping.put("/mypage/withdraw", new WithdrawController());
    }

    public Controller findController(String uri) {
        return mapping.get(uri);
    }
}

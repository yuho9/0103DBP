
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
        mapping.put("/portfolios/new", new PortfolioFormController());
        mapping.put("/portfolios/edit", new PortfolioFormController());
        mapping.put("/portfolios/detail", new PortfolioDetailController());
        mapping.put("/portfolios/delete", new PortfolioDeleteController());
        mapping.put("/mypage", new MyPageController());
        mapping.put("/portfolios/main", new PortfolioMainController());
        mapping.put("/portfolios/pdf/view", new PortfolioPdfViewController());
        mapping.put("/profile/edit", new ProfileEditController());
        mapping.put("/profile/image", new ProfileImageViewController());
        mapping.put("/projects/new", new ProjectFormController());
        mapping.put("/projects/edit", new ProjectFormController());
    }

    public Controller findController(String uri) {
        return mapping.get(uri);
    }
}

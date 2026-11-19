
package com.campusmatching.controller;

import java.sql.SQLException;

import com.campusmatching.model.domain.User;
import com.campusmatching.model.service.UserManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginController implements Controller {

    private final UserManager userManager = new UserManager();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        if ("GET".equalsIgnoreCase(request.getMethod())) {
            return "/pages/auth/login.jsp";
        }

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        request.setCharacterEncoding("UTF-8");

        String loginId = request.getParameter("loginId");
        String password = request.getParameter("password");

        if (loginId == null || loginId.isBlank()
                || password == null || password.isBlank()) {
            request.setAttribute("loginError", "아이디와 비밀번호를 입력해 주세요.");
            return "/pages/auth/login.jsp";
        }

        try {
            User user = userManager.login(loginId, password);

            if (user == null) {
                request.setAttribute("loginError",
                        "아이디 또는 비밀번호가 올바르지 않습니다.");
                return "/pages/auth/login.jsp";
            }

            HttpSession session = request.getSession();
            request.changeSessionId();

            session.setAttribute("userId", user.getUserId());
            session.setAttribute("loginId", user.getLoginId());
            session.setAttribute("userName", user.getUserName());

            return "redirect:/";

        } catch (SQLException e) {
            throw new Exception("로그인 중 데이터베이스 오류가 발생했습니다.", e);
        }
    }
}

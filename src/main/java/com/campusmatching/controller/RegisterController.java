
package com.campusmatching.controller;

import java.sql.SQLException;

import com.campusmatching.model.service.UserManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterController implements Controller {

    private final UserManager userManager = new UserManager();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        if ("GET".equalsIgnoreCase(request.getMethod())) {
            return "/pages/auth/registerForm.jsp";
        }

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        request.setCharacterEncoding("UTF-8");

        String loginId = request.getParameter("loginId");
        String password = request.getParameter("password");
        String passwordConfirm = request.getParameter("passwordConfirm");
        String userName = request.getParameter("userName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (password == null || !password.equals(passwordConfirm)) {
            request.setAttribute("registerError", "비밀번호가 일치하지 않습니다.");
            return "/pages/auth/registerForm.jsp";
        }

        try {
            boolean registered = userManager.register(
                    loginId, password, userName, email, phone);

            if (registered) {
                return "redirect:/login";
            }

            request.setAttribute("registerError", "회원가입에 실패했습니다.");
            return "/pages/auth/registerForm.jsp";

        } catch (IllegalArgumentException e) {
            request.setAttribute("registerError", e.getMessage());
            return "/pages/auth/registerForm.jsp";

        } catch (SQLException e) {
            if (e.getErrorCode() == 1) {
                request.setAttribute("registerError",
                        "이미 사용 중인 아이디 또는 이메일입니다.");
                return "/pages/auth/registerForm.jsp";
            }

            throw new Exception("회원가입 중 데이터베이스 오류가 발생했습니다.", e);
        }
    }
}

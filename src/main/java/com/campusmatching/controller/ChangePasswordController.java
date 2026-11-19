
package com.campusmatching.controller;

import java.sql.SQLException;

import com.campusmatching.model.service.UserManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ChangePasswordController implements Controller {

    private final UserManager userManager = new UserManager();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null ||
                !(session.getAttribute("userId") instanceof Long)) {
            return "redirect:/login";
        }

        Long userId = (Long) session.getAttribute("userId");

        if ("GET".equalsIgnoreCase(request.getMethod())) {

            if ("1".equals(request.getParameter("changed"))) {
                request.setAttribute(
                    "successMessage",
                    "비밀번호가 성공적으로 변경되었습니다."
                );
            }

            return "/pages/user/password-edit.jsp";
        }

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        request.setCharacterEncoding("UTF-8");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            boolean changed = userManager.changePassword(
                userId,
                currentPassword,
                newPassword,
                confirmPassword
            );

            if (changed) {
                return "redirect:/mypage/password/edit?changed=1";
            }

            request.setAttribute(
                "passwordError",
                "비밀번호 변경에 실패했습니다. 다시 시도해 주세요."
            );

        } catch (IllegalArgumentException e) {
            request.setAttribute("passwordError", e.getMessage());

        } catch (SQLException e) {
            throw new Exception(
                "비밀번호 변경 중 데이터베이스 오류가 발생했습니다.", e
            );
        }

        return "/pages/user/password-edit.jsp";
    }
}

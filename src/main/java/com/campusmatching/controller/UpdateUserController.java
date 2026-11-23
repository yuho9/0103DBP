
package com.campusmatching.controller;

import java.sql.SQLException;

import com.campusmatching.model.domain.User;
import com.campusmatching.model.service.UserManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UpdateUserController implements Controller {

    private final UserManager userManager = new UserManager();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null || !(session.getAttribute("userId") instanceof Long)) {
            return "redirect:/login";
        }

        Long userId = (Long) session.getAttribute("userId");

        if ("GET".equalsIgnoreCase(request.getMethod())) {
            User user = userManager.findById(userId);

            if (user == null) {
                session.invalidate();
                return "redirect:/login";
            }

            request.setAttribute("user", user);

            if ("1".equals(request.getParameter("updated"))) {
                request.setAttribute("successMessage", "회원정보가 수정되었습니다.");
            }

            return "/pages/user/account-edit.jsp";
        }

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        try {
            boolean updated = userManager.updateUserInfo(userId, email, phone);

            if (updated) {
                return "redirect:/account-edit?updated=1";
            }

            request.setAttribute("updateError", "회원정보 수정에 실패했습니다.");

        } catch (IllegalArgumentException e) {
            request.setAttribute("updateError", e.getMessage());

        } catch (SQLException e) {
            if (e.getErrorCode() == 1) {
                request.setAttribute("updateError", "이미 사용 중인 이메일입니다.");
            } else {
                throw new Exception("회원정보 수정 중 DB 오류가 발생했습니다.", e);
            }
        }

        User user = userManager.findById(userId);

        if (user == null) {
            session.invalidate();
            return "redirect:/login";
        }

        request.setAttribute("user", user);
        return "/pages/user/account-edit.jsp";
    }
}

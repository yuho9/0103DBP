
package com.campusmatching.controller;

import java.sql.SQLException;

import com.campusmatching.model.service.UserManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class WithdrawController implements Controller {

    private final UserManager userManager = new UserManager();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Long)) {
            return "redirect:/login";
        }

        Long userId = (Long) session.getAttribute("userId");

        if ("GET".equalsIgnoreCase(request.getMethod())) {
            return "/pages/user/withdraw.jsp";
        }

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        request.setCharacterEncoding("UTF-8");

        String password = request.getParameter("password");
        String agreement = request.getParameter("agreeWithdraw");

        if (!"true".equals(agreement)) {
            request.setAttribute(
                "withdrawError",
                "회원 탈퇴 안내사항에 동의해 주세요."
            );
            return "/pages/user/withdraw.jsp";
        }

        try {
            boolean withdrawn = userManager.withdraw(userId, password);

            if (withdrawn) {
                session.invalidate();
                return "redirect:/login?withdrawn=1";
            }

            request.setAttribute(
                "withdrawError",
                "탈퇴 처리에 실패했습니다. 다시 시도해 주세요."
            );

        } catch (IllegalArgumentException e) {
            request.setAttribute("withdrawError", e.getMessage());

        } catch (SQLException e) {
            throw new Exception("회원 탈퇴 중 DB 오류가 발생했습니다.", e);
        }

        return "/pages/user/withdraw.jsp";
    }
}

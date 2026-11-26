package com.campusmatching.controller;

import java.sql.SQLException;

import com.campusmatching.model.dao.MemberScrapDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class MemberScrapController implements Controller {

    private static final String SESSION_USER_ID = "userId";

    private final MemberScrapDAO scrapDAO = new MemberScrapDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equals(request.getMethod())) {          // 스크랩은 POST 만 허용
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }
        String ctx = request.getContextPath();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(SESSION_USER_ID) == null) {
            return "redirect:/login";
        }
        long userId = ((Number) session.getAttribute(SESSION_USER_ID)).longValue();

        long targetUserId;
        try {
            targetUserId = Long.parseLong(request.getParameter("userId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }
        if (targetUserId == userId) {                    // 자기 자신은 스크랩할 수 없음
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        try {
            if (scrapDAO.exists(userId, targetUserId)) {
                scrapDAO.remove(userId, targetUserId);
            } else {
                scrapDAO.add(userId, targetUserId);
            }
        } catch (SQLException e) {
            throw new ServletException("팀원 스크랩 처리 중 DB 오류", e);
        }

        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains(request.getServerName() + (ctx.isEmpty() ? "" : ctx))) {
            response.sendRedirect(referer);
            return null;
        }
        return "redirect:/members";
    }
}

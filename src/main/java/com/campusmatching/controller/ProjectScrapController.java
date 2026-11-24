package com.campusmatching.controller;

import java.sql.SQLException;

import com.campusmatching.model.dao.ProjectScrapDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProjectScrapController implements Controller {

    private static final String SESSION_USER_ID = "userId";

    private final ProjectScrapDAO scrapDAO = new ProjectScrapDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equals(request.getMethod())) {       
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }
        String ctx = request.getContextPath();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(SESSION_USER_ID) == null) {
            return "redirect:/login";
        }
        long userId = ((Number) session.getAttribute(SESSION_USER_ID)).longValue();

        long projectId;
        try {
            projectId = Long.parseLong(request.getParameter("projectId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        try {
            if (scrapDAO.exists(userId, projectId)) {
                scrapDAO.remove(userId, projectId);
            } else {
                scrapDAO.add(userId, projectId);
            }
        } catch (SQLException e) {
            throw new ServletException("프로젝트 스크랩 처리 중 DB 오류", e);
        }

        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains(request.getServerName() + (ctx.isEmpty() ? "" : ctx))) {
            response.sendRedirect(referer);
            return null;
        }
        return "redirect:/projects";
    }
}

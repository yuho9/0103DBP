package com.campusmatching.controller;

import java.sql.SQLException;
import java.util.List;

import com.campusmatching.model.dao.CategoryDAO;
import com.campusmatching.model.dao.ProjectDAO;
import com.campusmatching.model.dao.ProjectScrapDAO;
import com.campusmatching.model.dao.TagDAO;
import com.campusmatching.model.domain.Category;
import com.campusmatching.model.domain.Project;
import com.campusmatching.model.domain.Tag;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProjectDetailController implements Controller {

    private static final String SESSION_USER_ID = "userId";
    private static final String VIEW = "/pages/project/project-detail.jsp";

    private final ProjectDAO projectDAO = new ProjectDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final TagDAO tagDAO = new TagDAO();
    private final ProjectScrapDAO scrapDAO = new ProjectScrapDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        long projectId;
        try {
            projectId = Long.parseLong(request.getParameter("projectId"));
        } catch (NumberFormatException e) {        
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        try {
            Project project = projectDAO.findById(projectId);
            if (project == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return null;
            }

            Category category = categoryDAO.findByProjectId(projectId);
            Category parentCategory = null;
            if (category != null && category.getParentId() != null) {
                parentCategory = categoryDAO.findById(category.getParentId());
            }
            List<Tag> tags = tagDAO.findByProjectId(projectId);
            int activeMemberCount = projectDAO.countActiveMembers(projectId);

            boolean scrapped = false;
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute(SESSION_USER_ID) != null) {
                long userId = ((Number) session.getAttribute(SESSION_USER_ID)).longValue();
                scrapped = scrapDAO.exists(userId, projectId);
            }

            request.setAttribute("project", project);
            request.setAttribute("category", category);
            request.setAttribute("parentCategory", parentCategory);
            request.setAttribute("tags", tags);
            request.setAttribute("activeMemberCount", activeMemberCount);
            request.setAttribute("scrapped", scrapped);
            return VIEW;

        } catch (SQLException e) {
            throw new ServletException("프로젝트 상세 조회 중 DB 오류", e);
        }
    }
}

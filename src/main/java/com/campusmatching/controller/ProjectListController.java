package com.campusmatching.controller;

import java.sql.SQLException;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.campusmatching.model.dao.CategoryDAO;
import com.campusmatching.model.dao.ProjectDAO;
import com.campusmatching.model.dao.ProjectScrapDAO;
import com.campusmatching.model.dao.TagDAO;
import com.campusmatching.model.domain.Category;
import com.campusmatching.model.domain.Project;
import com.campusmatching.model.domain.ProjectSearchCondition;
import com.campusmatching.model.domain.Tag;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProjectListController implements Controller {

    private static final String SESSION_USER_ID = "userId";
    private static final String VIEW = "/pages/project/project-list.jsp";

    private final ProjectDAO projectDAO = new ProjectDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final TagDAO tagDAO = new TagDAO();
    private final ProjectScrapDAO scrapDAO = new ProjectScrapDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

        Long userId = null;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute(SESSION_USER_ID) != null) {
            userId = ((Number) session.getAttribute(SESSION_USER_ID)).longValue();
        }

        ProjectSearchCondition cond = new ProjectSearchCondition();
        cond.setKeyword(request.getParameter("keyword"));
        cond.setCategoryId(toLong(request.getParameter("categoryId")));
        cond.setPositions(valuesOf(request, "position"));  
        cond.setSkills(valuesOf(request, "skill"));        
        cond.setSortByPopular("popular".equals(request.getParameter("sort")));

        if ("true".equals(request.getParameter("scrap"))) {
            if (userId == null) {                 
                return "redirect:/login";
            }
            cond.setScrappedByUserId(userId);
        }

        Set<Long> subIds = new HashSet<>();
        for (String s : valuesOf(request, "subCategoryId")) {
            Long v = toLong(s);
            if (v != null) subIds.add(v);
        }
        Set<String> modes = new HashSet<>(valuesOf(request, "mode"));
        Set<String> durations = new HashSet<>(valuesOf(request, "duration"));
        Integer minMember = toInt(request.getParameter("minMember"));
        Integer maxMember = toInt(request.getParameter("maxMember"));

        try {
            List<Project> found = projectDAO.search(cond);
            List<ProjectCard> cards = new ArrayList<>();

            for (Project p : found) {
                long pid = p.getProjectId();

                if (!modes.isEmpty()) {
                    String mt = (p.getMeetingType() == null) ? "" : p.getMeetingType().name();
                    if (!modes.contains(mt)) continue;
                }
                if (!durations.isEmpty() && !matchDuration(p, durations)) continue;
                if (minMember != null && p.getMaxMembers() < minMember) continue;
                if (maxMember != null && p.getMaxMembers() > maxMember) continue;

                Category category = categoryDAO.findByProjectId(pid);
                if (!subIds.isEmpty()) {
                    if (category == null || !subIds.contains(category.getCategoryId())) continue;
                }

                List<Tag> projectTags = tagDAO.findByProjectId(pid);
                int active = projectDAO.countActiveMembers(pid);
                int scrapCount = scrapDAO.countByProject(pid);
                boolean scrapped = (userId != null) && scrapDAO.exists(userId, pid);

                cards.add(new ProjectCard(p, category, projectTags, active, scrapCount, scrapped));
            }

            request.setAttribute("cards", cards);
            request.setAttribute("totalCount", cards.size());
            return VIEW;

        } catch (SQLException e) {
            throw new ServletException("프로젝트 목록 조회 중 DB 오류", e);
        }
    }

    private boolean matchDuration(Project p, Set<String> durations) {
        if (p.getStartDate() == null || p.getEndDate() == null) return false;
        long days = ChronoUnit.DAYS.between(p.getStartDate(), p.getEndDate());
        if (durations.contains("UNDER1M") && days <= 30) return true;
        if (durations.contains("1TO3M") && days > 30 && days <= 90) return true;
        if (durations.contains("OVER3M") && days > 90) return true;
        return false;
    }

    private List<String> valuesOf(HttpServletRequest request, String name) {
        List<String> list = new ArrayList<>();
        String[] arr = request.getParameterValues(name);
        if (arr != null) {
            for (String s : arr) {
                if (s != null && !s.trim().isEmpty()) list.add(s.trim());
            }
        }
        return list;
    }

    private Long toLong(String s) {
        try { return (s == null || s.trim().isEmpty()) ? null : Long.valueOf(s.trim()); }
        catch (NumberFormatException e) { return null; }
    }

    private Integer toInt(String s) {
        try { return (s == null || s.trim().isEmpty()) ? null : Integer.valueOf(s.trim()); }
        catch (NumberFormatException e) { return null; }
    }
}

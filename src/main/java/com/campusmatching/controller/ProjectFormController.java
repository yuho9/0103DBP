package com.campusmatching.controller;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.campusmatching.model.dao.ProjectFormDAO;
import com.campusmatching.model.domain.ProjectFormData;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProjectFormController implements Controller {

    private final ProjectFormDAO dao = new ProjectFormDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("userId") instanceof Long)) {
            return "redirect:/login";
        }
        long userId = (Long) session.getAttribute("userId");
        boolean edit = request.getRequestURI().endsWith("/projects/edit");
        Long projectId = edit ? parseId(request.getParameter("id")) : null;
        if (edit && projectId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            ProjectFormData data = edit ? dao.findOwned(userId, projectId) : new ProjectFormData();
            if (data == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return null;
            }
            request.setAttribute("projectFormData", data);
            return "/pages/project/projectForm.jsp";
        }
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }
        ProjectFormData data = new ProjectFormData();
        try {
            data = fromRequest(request);
            if (edit) data.setProjectId(projectId);
            validate(data);
            if (edit) {
                dao.update(userId, projectId, data);
            } else {
                dao.create(userId, data);
            }
            return "redirect:/mypage";
        } catch (IllegalArgumentException | java.sql.SQLException ex) {
            request.setAttribute("projectFormData", data);
            request.setAttribute("formError", ex.getMessage());
            return "/pages/project/projectForm.jsp";
        }
    }

    private ProjectFormData fromRequest(HttpServletRequest request) {
        ProjectFormData data = new ProjectFormData();
        data.setTitle(trim(request.getParameter("title")));
        data.setCategoryMain(trim(request.getParameter("categoryMain")));
        data.setCategorySub(trim(request.getParameter("categorySub")));
        data.setMeetingType(trim(request.getParameter("meetingType")));
        try {
            data.setCapacity(Integer.valueOf(trim(request.getParameter("capacity"))));
        } catch (NumberFormatException e) {
            data.setCapacity(null);
        }
        data.setRecruitStartDate(trim(request.getParameter("recruitStartDate")));
        data.setRecruitEndDate(trim(request.getParameter("recruitEndDate")));
        data.setProjectStartDate(trim(request.getParameter("projectStartDate")));
        data.setProjectEndDate(trim(request.getParameter("projectEndDate")));
        data.setDescription(trim(request.getParameter("description")));
        data.setSkills(normalize(request.getParameterValues("skills"), 20));
        data.setPositions(normalize(request.getParameterValues("positions"), 10));
        return data;
    }

    private List<String> normalize(String[] values, int max) {
        List<String> list = new ArrayList<>();
        if (values == null) return list;
        if (values.length > max) throw new IllegalArgumentException("태그 선택 개수를 초과했습니다.");
        for (String value : values) {
            String v = trim(value);
            if (v.length() > 40) throw new IllegalArgumentException("태그가 너무 깁니다.");
            if (!v.isEmpty() && list.stream().noneMatch(x -> x.equalsIgnoreCase(v))) list.add(v);
        }
        return list;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private Long parseId(String value) {
        try {
            long id = Long.parseLong(value);
            return id > 0 ? id : null;
        } catch (Exception e) {
            return null;
        }
    }

    private void validate(ProjectFormData data) {
        if (data.getTitle().isBlank() || data.getTitle().length() > 100) {
            throw new IllegalArgumentException("프로젝트 이름을 1~100자로 입력해주세요.");
        }
        if (data.getDescription().isBlank() || data.getDescription().length() > 5000) {
            throw new IllegalArgumentException("소개를 1~5000자로 입력해주세요.");
        }
        if (data.getCategoryMain().isBlank() || data.getCategorySub().isBlank()) {
            throw new IllegalArgumentException("모집 구분을 선택해주세요.");
        }
        if (!("ONLINE".equals(data.getMeetingType()) || "OFFLINE".equals(data.getMeetingType())
                || "HYBRID".equals(data.getMeetingType()))) {
            throw new IllegalArgumentException("진행 방식을 선택해주세요.");
        }
        if (data.getCapacity() == null || data.getCapacity() < 2 || data.getCapacity() > 100) {
            throw new IllegalArgumentException("정원을 2~100명으로 입력해주세요.");
        }
        try {
            LocalDate recruitStart = LocalDate.parse(data.getRecruitStartDate());
            LocalDate recruitEnd = LocalDate.parse(data.getRecruitEndDate());
            LocalDate projectStart = LocalDate.parse(data.getProjectStartDate());
            LocalDate projectEnd = LocalDate.parse(data.getProjectEndDate());
            if (recruitStart.isAfter(recruitEnd) || projectStart.isAfter(projectEnd)
                    || recruitEnd.isAfter(projectStart)) {
                throw new IllegalArgumentException("모집·프로젝트 날짜 순서를 확인해주세요.");
            }
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("날짜를 올바르게 입력해주세요.");
        }
        if (data.getSkills().isEmpty() && data.getPositions().isEmpty()) {
            throw new IllegalArgumentException("기술 또는 모집 포지션을 하나 이상 선택해주세요.");
        }
    }
}

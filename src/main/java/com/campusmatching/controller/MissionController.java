package com.campusmatching.controller;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import com.campusmatching.model.dao.MissionDAO;
import com.campusmatching.model.dao.WorkspaceAccessDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** 팀장만 팀 미션 생성/수정/삭제. 개인 TODO는 기존 TodoController 사용. */
public class MissionController implements Controller {
    private final MissionDAO missionDAO = new MissionDAO();
    private final WorkspaceAccessDAO accessDAO = new WorkspaceAccessDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long userId = WorkspaceAccess.loginUserId(request);
        if (userId == null) return "redirect:/login";
        Long projectId = WorkspaceAccess.projectId(request, response);
        if (projectId == null) return null;
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED); return null;
        }
        // 화면에서 버튼을 숨기는 것과 별개로 서버에서 권한 확인 필수
        if (!accessDAO.isLeader(projectId, userId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "프로젝트 팀장만 팀 미션을 변경할 수 있습니다.");
            return null;
        }
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        try {
            int changed;
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            LocalDate dueDate = date(request.getParameter("dueDate"));
            switch (action == null ? "" : action) {
                case "create": changed = missionDAO.create(projectId, title, description, dueDate); break;
                case "update": changed = missionDAO.update(projectId, positive(request.getParameter("missionId")), title, description, dueDate); break;
                case "delete": changed = missionDAO.delete(projectId, positive(request.getParameter("missionId"))); break;
                default: response.sendError(HttpServletResponse.SC_BAD_REQUEST, "알 수 없는 작업"); return null;
            }
            if (changed != 1) { response.sendError(HttpServletResponse.SC_CONFLICT, "미션이 없거나 상태/배정 때문에 변경할 수 없습니다."); return null; }
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage()); return null;
        }
        return "redirect:/myproject/todos?projectId=" + projectId;
    }
    private long positive(String raw) {
        long n = Long.parseLong(raw);
        if (n <= 0) throw new IllegalArgumentException("미션 ID 오류");
        return n;
    }
    private LocalDate date(String raw) {
        if (raw == null || raw.isBlank()) return null;
        try { return LocalDate.parse(raw); }
        catch (DateTimeParseException e) { throw new IllegalArgumentException("마감일 형식 오류"); }
    }
}

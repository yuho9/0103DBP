package com.campusmatching.controller;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Comparator;
import com.campusmatching.model.dao.TodoDAO;
import com.campusmatching.model.dao.MissionBoardDAO;
import com.campusmatching.model.dao.WorkspaceAccessDAO;
import com.campusmatching.model.domain.Todo;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class TodoController implements Controller {
    private final TodoDAO todoDAO = new TodoDAO();
    private final MissionBoardDAO missionBoardDAO = new MissionBoardDAO();
    private final WorkspaceAccessDAO accessDAO = new WorkspaceAccessDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long userId = WorkspaceAccess.loginUserId(request);
        if (userId == null) return "redirect:/login";
        Long projectId = WorkspaceAccess.projectId(request, response);
        if (projectId == null) return null;
        if (!accessDAO.canView(projectId, userId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }
        Long memberId = accessDAO.findActiveMemberId(projectId, userId);
        boolean leader = accessDAO.isLeader(projectId, userId);
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            List<Todo> todos = memberId == null ? new java.util.ArrayList<>() : todoDAO.findByMemberId(memberId);
            // 미완료 먼저 -> 마감일 빠른 순 -> 마감일 없는 항목 -> 완료된 항목 아래
            todos.sort(Comparator.comparing(Todo::isCompleted)
                    .thenComparing(Todo::getDueDate, Comparator.nullsLast(Comparator.naturalOrder()))
                    .thenComparing(Todo::getTodoId, Comparator.nullsLast(Comparator.naturalOrder())));
            request.setAttribute("personalTodos", todos);
            request.setAttribute("teamMissionViews", missionBoardDAO.findMissions(projectId, memberId));
            request.setAttribute("activeProjectMembers", missionBoardDAO.findActiveMembers(projectId));
            request.setAttribute("myProjectMemberId", memberId);
            request.setAttribute("project", new com.campusmatching.model.dao.WorkspaceProjectDAO().findById(projectId));
            request.setAttribute("isProjectLeader", leader);
            request.setAttribute("projectId", projectId);
            return "/pages/workspace/mission.jsp";
        }
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }
        if (memberId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "활성 프로젝트 참여자만 개인 TODO를 수정할 수 있습니다.");
            return null;
        }
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        try {
            int changed;
            switch (action == null ? "" : action) {
                case "create":
                    changed = todoDAO.create(new Todo(null, memberId, null,
                            request.getParameter("title"), request.getParameter("description"),
                            parseDate(request.getParameter("dueDate")), false));
                    break;
                case "update": {
                    long id = parseTodoId(request.getParameter("todoId"));
                    Todo todo = todoDAO.findById(id, memberId);
                    if (todo == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                        return null;
                    }
                    todo.setTitle(request.getParameter("title"));
                    todo.setDescription(request.getParameter("description"));
                    todo.setDueDate(parseDate(request.getParameter("dueDate")));
                    changed = todoDAO.update(todo);
                    break;
                }
                case "delete":
                    changed = todoDAO.delete(parseTodoId(request.getParameter("todoId")), memberId);
                    break;
                case "complete":
                    changed = todoDAO.setCompleted(parseTodoId(request.getParameter("todoId")), memberId, true);
                    break;
                case "reopen":
                    changed = todoDAO.setCompleted(parseTodoId(request.getParameter("todoId")), memberId, false);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "지원하지 않는 작업입니다.");
                    return null;
            }
            if (changed != 1) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "수정 대상이 없거나 처리되지 않았습니다.");
                return null;
            }
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
            return null;
        }
        return "redirect:/myproject/todos?projectId=" + projectId;
    }

    private long parseTodoId(String value) {
        long id = Long.parseLong(value);
        if (id <= 0) throw new IllegalArgumentException("Todo ID가 올바르지 않습니다.");
        return id;
    }

    private LocalDate parseDate(String date) {
        if (date == null || date.isBlank()) return null;
        try { return LocalDate.parse(date); }
        catch (DateTimeParseException e) { throw new IllegalArgumentException("마감일 형식이 올바르지 않습니다."); }
    }
}

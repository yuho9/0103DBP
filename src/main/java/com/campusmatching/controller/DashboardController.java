package com.campusmatching.controller;

import java.util.List;
import com.campusmatching.model.dao.DashboardStatsDAO;
import com.campusmatching.model.dao.TodoDAO;
import com.campusmatching.model.dao.WorkspaceAccessDAO;
import com.campusmatching.model.dao.WorkspaceProjectDAO;
import com.campusmatching.model.domain.DashboardStats;
import com.campusmatching.model.domain.Todo;
import com.campusmatching.model.domain.WorkspaceProject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DashboardController implements Controller {
    private final WorkspaceProjectDAO projectDAO = new WorkspaceProjectDAO();
    private final WorkspaceAccessDAO accessDAO = new WorkspaceAccessDAO();
    private final TodoDAO todoDAO = new TodoDAO();
    private final DashboardStatsDAO statsDAO = new DashboardStatsDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }
        Long userId = WorkspaceAccess.loginUserId(request);
        if (userId == null) return "redirect:/login";
        Long projectId = WorkspaceAccess.projectId(request, response);
        if (projectId == null) return null;
        if (!accessDAO.canView(projectId, userId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }
        WorkspaceProject project = projectDAO.findById(projectId);
        if (project == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return null;
        }

        Long memberId = accessDAO.findActiveMemberId(projectId, userId);
        List<Todo> personalTodos = memberId == null ? List.of() : todoDAO.findByMemberId(memberId);
        long remaining = personalTodos.stream().filter(todo -> !todo.isCompleted()).count();
        long completed = personalTodos.size() - remaining;
        int personalPercent = personalTodos.isEmpty() ? 0 : (int)(completed * 100 / personalTodos.size());
        DashboardStats stats = statsDAO.findByProjectId(projectId);

        request.setAttribute("project", project);
        request.setAttribute("projectId", projectId);
        request.setAttribute("personalTodos", personalTodos);
        request.setAttribute("remainingTodoCount", remaining);
        request.setAttribute("personalTodoCount", personalTodos.size());
        request.setAttribute("personalTodoProgressPercent", personalPercent);
        request.setAttribute("dashboardStats", stats);
        request.setAttribute("isProjectLeader", accessDAO.isLeader(projectId, userId));
        return "/pages/workspace/dashboard.jsp";
    }
}

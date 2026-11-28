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

/** 메인 상단 영역만 담당. 추천 영역은 기존 구현을 유지한다. */
public class HomeController implements Controller {
    private final WorkspaceProjectDAO projectDAO = new WorkspaceProjectDAO();
    private final WorkspaceAccessDAO accessDAO = new WorkspaceAccessDAO();
    private final DashboardStatsDAO statsDAO = new DashboardStatsDAO();
    private final TodoDAO todoDAO = new TodoDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        // 프로젝트/팀원 추천은 다른 팀원이 담당하므로 기존 요청 속성은 유지한다.
        request.setAttribute("recommendedProjects", projectDAO.findRecentRecruiting());

        Long userId = WorkspaceAccess.loginUserId(request);
        if (userId != null) {
            WorkspaceProject project = projectDAO.findLatestMine(userId);
            if (project != null) {
                Long memberId = accessDAO.findActiveMemberId(project.getProjectId(), userId);
                List<Todo> todos = memberId == null ? List.of() : todoDAO.findByMemberId(memberId);
                long remaining = todos.stream().filter(todo -> !todo.isCompleted()).count();
                DashboardStats stats = statsDAO.findByProjectId(project.getProjectId());

                request.setAttribute("homeProject", project);
                request.setAttribute("homeProjectId", project.getProjectId());
                request.setAttribute("homeDashboardStats", stats);
                request.setAttribute("homeRemainingTodoCount", remaining);
            }
        }
        return "/pages/common/index.jsp";
    }
}

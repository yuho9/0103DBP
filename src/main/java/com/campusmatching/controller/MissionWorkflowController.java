package com.campusmatching.controller;

import com.campusmatching.model.dao.MissionWorkflowDAO;
import com.campusmatching.model.dao.WorkspaceAccessDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** POST /myproject/mission-workflow - 배정/완료/승인 요청/승인/반려. */
public class MissionWorkflowController implements Controller {
    private final WorkspaceAccessDAO access = new WorkspaceAccessDAO();
    private final MissionWorkflowDAO workflow = new MissionWorkflowDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(405); return null;
        }
        Long userId = WorkspaceAccess.loginUserId(request);
        if (userId == null) return "redirect:/login";
        Long projectId = WorkspaceAccess.projectId(request, response);
        if (projectId == null) return null;
        if (!access.canView(projectId, userId)) { response.sendError(403); return null; }
        Long memberId = access.findActiveMemberId(projectId, userId);
        if (memberId == null) {
            response.sendError(403, "활성 프로젝트 팀원 정보가 없습니다."); return null;
        }
        final long missionId;
        try {
            missionId = parsePositive(request.getParameter("missionId"));
        } catch (IllegalArgumentException e) {
            response.sendError(400, "미션 번호가 잘못되었습니다."); return null;
        }
        String action = request.getParameter("action");
        boolean isLeader = access.isLeader(projectId, userId);
        boolean ok;
        switch (action == null ? "" : action) {
            case "assign":
                if (!isLeader) { response.sendError(403); return null; }
                long targetMemberId;
                try { targetMemberId = parsePositive(request.getParameter("targetMemberId")); }
                catch (IllegalArgumentException e) { response.sendError(400); return null; }
                ok = workflow.assign(projectId, missionId, targetMemberId);
                break;
            case "done":
                ok = workflow.markDone(projectId, missionId, memberId);
                break;
            case "requestApproval":
                ok = workflow.requestApproval(projectId, missionId, memberId);
                break;
            case "approve":
                if (!isLeader) { response.sendError(403); return null; }
                ok = workflow.approve(projectId, missionId, memberId);
                break;
            case "reject":
                if (!isLeader) { response.sendError(403); return null; }
                ok = workflow.reject(projectId, missionId);
                break;
            default: response.sendError(400, "지원되지 않는 미션 작업입니다."); return null;
        }
        if (!ok) { response.sendError(409, "현재 미션 상태·배정·권한 조건에서 실행할 수 없습니다."); return null; }
        return "redirect:/myproject/todos?projectId=" + projectId;
    }

    private long parsePositive(String raw) {
        long value = Long.parseLong(raw);
        if (value <= 0) throw new IllegalArgumentException();
        return value;
    }
}

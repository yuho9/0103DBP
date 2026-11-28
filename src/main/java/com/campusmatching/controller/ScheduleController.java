package com.campusmatching.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.campusmatching.model.dao.MemberAvailabilityDAO;
import com.campusmatching.model.domain.MemberAvailability;

import com.campusmatching.model.dao.ScheduleDAO;
import com.campusmatching.model.dao.WorkspaceAccessDAO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** /myproject/schedule: GET 팀 일정 조회, POST 등록/수정/삭제. */
public class ScheduleController implements Controller {
    private final WorkspaceAccessDAO accessDAO = new WorkspaceAccessDAO();
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();
    private final MemberAvailabilityDAO availabilityDAO = new MemberAvailabilityDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long userId = WorkspaceAccess.loginUserId(request);
        if (userId == null) return "redirect:/login";
        Long projectId = WorkspaceAccess.projectId(request, response);
        if (projectId == null) return null;

        if (!accessDAO.canView(projectId, userId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "프로젝트 접근 권한이 없습니다.");
            return null;
        }
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("projectId", projectId);
            request.setAttribute("isProjectLeader", accessDAO.isLeader(projectId, userId));
            request.setAttribute("schedules", scheduleDAO.findByProjectId(projectId, userId));
            request.setAttribute("availabilityMembers", availabilityDAO.findActiveMemberIds(projectId));
            request.setAttribute("availabilityMemberDetails", availabilityDAO.findActiveMemberDetails(projectId));
            request.setAttribute("availabilityRanges", availabilityDAO.findByProjectId(projectId));
            request.setAttribute("myProjectMemberId", accessDAO.findActiveMemberId(projectId, userId));
            return "/pages/workspace/schedule.jsp";
        }
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        int count;
        try {
            if ("saveAvailability".equals(action)) {
                availabilityDAO.replaceMine(projectId, userId, parseAvailability(request.getParameter("ranges")));
                return "redirect:/myproject/schedule?projectId=" + projectId;
            } else if ("delete".equals(action)) {
                long scheduleId = positiveId(request.getParameter("scheduleId"));
                count = scheduleDAO.delete(scheduleId, projectId, userId);
            } else if ("create".equals(action) || "update".equals(action)) {
                String title = request.getParameter("title");
                if (title == null || title.isBlank() || title.trim().length() > 100) {
                    throw new IllegalArgumentException("일정 제목은 1~100자로 입력해야 합니다.");
                }
                String description = request.getParameter("description");
                if (description != null && description.length() > 2000) {
                    throw new IllegalArgumentException("설명은 2000자 이하로 입력하세요.");
                }
                LocalDateTime startAt = LocalDateTime.parse(request.getParameter("startAt"));
                LocalDateTime endAt = LocalDateTime.parse(request.getParameter("endAt"));
                if (!startAt.isBefore(endAt)) {
                    throw new IllegalArgumentException("시작 시각은 종료 시각보다 빨라야 합니다.");
                }
                if ("create".equals(action)) {
                    // 프로젝트 ID, 작성자 ID를 브라우저 입력 그대로 신뢰하지 않는다.
                    Long memberId = accessDAO.findActiveMemberId(projectId, userId);
                    if (memberId == null) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN,
                                "일정을 등록하려면 ACTIVE 프로젝트 팀원이어야 합니다.");
                        return null;
                    }
                    count = scheduleDAO.create(projectId, memberId, title.trim(),
                            description, startAt, endAt);
                } else {
                    count = scheduleDAO.update(positiveId(request.getParameter("scheduleId")),
                            projectId, userId, title.trim(), description, startAt, endAt);
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "알 수 없는 일정 작업입니다.");
                return null;
            }
        } catch (SecurityException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
            return null;
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "일정 입력값을 확인하세요.");
            return null;
        }
        if (count != 1) {
            response.sendError(HttpServletResponse.SC_CONFLICT,
                    "일정이 존재하지 않거나 수정/삭제 권한이 없습니다.");
            return null;
        }
        return "redirect:/myproject/schedule?projectId=" + projectId;
    }

    /** ranges: 1,09:00,10:30;3,14:00,16:00 (월=1 ... 일=7). */
    private List<MemberAvailability> parseAvailability(String raw) {
        if (raw == null || raw.length() > 20000) throw new IllegalArgumentException("가능 시간 입력 오류");
        List<MemberAvailability> ranges = new ArrayList<>();
        if (raw.isBlank()) return ranges; // 모두 지우기 가능
        for (String token : raw.split(";", -1)) {
            String[] parts = token.split(",", -1);
            if (parts.length != 3) throw new IllegalArgumentException("가능 시간 형식 오류");
            int day = Integer.parseInt(parts[0]);
            ranges.add(new MemberAvailability(0, day, parts[1], parts[2]));
        }
        return ranges;
    }

    private long positiveId(String raw) {
        long result = Long.parseLong(raw);
        if (result <= 0) throw new IllegalArgumentException("ID는 양수여야 합니다.");
        return result;
    }
}

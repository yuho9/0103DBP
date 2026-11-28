package com.campusmatching.model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.campusmatching.model.domain.Schedule;

/** 팀 일정 CRUD. 인증된 userId는 컨트롤러에서 전달한다. */
public class ScheduleDAO {

    public List<Schedule> findByProjectId(long projectId, long currentUserId) throws SQLException {
        String sql = "SELECT s.schedule_id, s.title, s.description, s.start_at, s.end_at, " +
                "s.project_id, s.creator_member_id, " +
                "CASE WHEN pm.user_id = ? OR p.owner_id = ? THEN 1 ELSE 0 END AS can_edit " +
                "FROM schedule s " +
                "JOIN project_member pm ON pm.project_member_id = s.creator_member_id " +
                "JOIN project p ON p.project_id = s.project_id " +
                "WHERE s.project_id = ? ORDER BY s.start_at ASC, s.schedule_id ASC";
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, new Object[] {currentUserId, currentUserId, projectId});
        try {
            ResultSet rs = jdbc.executeQuery();
            List<Schedule> schedules = new ArrayList<>();
            while (rs.next()) {
                schedules.add(new Schedule(
                        rs.getLong("schedule_id"), rs.getString("title"),
                        rs.getString("description"),
                        rs.getTimestamp("start_at").toLocalDateTime(),
                        rs.getTimestamp("end_at").toLocalDateTime(),
                        rs.getLong("project_id"), rs.getLong("creator_member_id"),
                        rs.getInt("can_edit") == 1));
            }
            return schedules;
        } finally {
            jdbc.close();
        }
    }

    /** 작성자 project_member_id는 로그인 사용자의 ACTIVE 멤버 정보에서 가져와야 한다. */
    public int create(long projectId, long creatorMemberId, String title,
                      String description, LocalDateTime startAt, LocalDateTime endAt)
            throws SQLException {
        String sql = "INSERT INTO schedule " +
                "(title, description, start_at, end_at, project_id, creator_member_id) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        return executeDml(sql, new Object[] {title, description,
                Timestamp.valueOf(startAt), Timestamp.valueOf(endAt), projectId, creatorMemberId});
    }

    /** 작성자 또는 프로젝트 소유자만 수정 가능. */
    public int update(long scheduleId, long projectId, long userId, String title,
                      String description, LocalDateTime startAt, LocalDateTime endAt)
            throws SQLException {
        String sql = "UPDATE schedule s SET title = ?, description = ?, start_at = ?, end_at = ? " +
                "WHERE s.schedule_id = ? AND s.project_id = ? " +
                "AND (EXISTS (SELECT 1 FROM project_member pm WHERE pm.project_member_id = s.creator_member_id " +
                "AND pm.user_id = ?) OR EXISTS (SELECT 1 FROM project p " +
                "WHERE p.project_id = s.project_id AND p.owner_id = ?))";
        return executeDml(sql, new Object[] {title, description, Timestamp.valueOf(startAt),
                Timestamp.valueOf(endAt), scheduleId, projectId, userId, userId});
    }

    public int delete(long scheduleId, long projectId, long userId) throws SQLException {
        String sql = "DELETE FROM schedule s WHERE s.schedule_id = ? AND s.project_id = ? " +
                "AND (EXISTS (SELECT 1 FROM project_member pm WHERE pm.project_member_id = s.creator_member_id " +
                "AND pm.user_id = ?) OR EXISTS (SELECT 1 FROM project p " +
                "WHERE p.project_id = s.project_id AND p.owner_id = ?))";
        return executeDml(sql, new Object[] {scheduleId, projectId, userId, userId});
    }

    private int executeDml(String sql, Object[] params) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, params);
        try {
            int count = jdbc.executeUpdate();
            jdbc.commit();
            return count;
        } catch (SQLException e) {
            try { jdbc.rollback(); } catch (SQLException rollback) { e.addSuppressed(rollback); }
            throw e;
        } finally {
            jdbc.close();
        }
    }
}

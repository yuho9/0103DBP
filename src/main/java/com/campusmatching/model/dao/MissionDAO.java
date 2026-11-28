package com.campusmatching.model.dao;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import com.campusmatching.model.domain.Mission;

/** 프로젝트 공통 미션: 상태 전이는 DB의 CHECK 제약조건 확인 후 구현. */
public class MissionDAO {
    public List<Mission> findByProjectId(long projectId) throws SQLException {
        String sql = "SELECT mission_id, project_id, title, description, due_date, status, "
                   + "approved_at, approved_member_id FROM mission "
                   + "WHERE project_id = ? ORDER BY due_date ASC NULLS LAST, mission_id DESC";
        JDBCUtil jdbc = new JDBCUtil();
        try {
            jdbc.setSqlAndParameters(sql, new Object[]{projectId});
            ResultSet rs = jdbc.executeQuery();
            List<Mission> out = new ArrayList<>();
            while (rs.next()) {
                Date due = rs.getDate("due_date");
                long rawApprover = rs.getLong("approved_member_id");
                Long approver = rs.wasNull() ? null : rawApprover;
                out.add(new Mission(rs.getLong("mission_id"), rs.getLong("project_id"),
                        rs.getString("title"), rs.getString("description"),
                        due == null ? null : due.toLocalDate(), rs.getString("status"),
                        rs.getTimestamp("approved_at") == null ? null : rs.getTimestamp("approved_at").toLocalDateTime(),
                        approver));
            }
            return out;
        } finally { jdbc.close(); }
    }

    public int create(long projectId, String title, String description, LocalDate dueDate) throws SQLException {
        validate(title);
        // status는 테이블 DEFAULT 'TODO' 사용
        return dml("INSERT INTO mission (project_id, title, description, due_date) VALUES (?, ?, ?, ?)",
                new Object[]{projectId, title.trim(), description, asDate(dueDate)});
    }

    public int update(long projectId, long missionId, String title, String description, LocalDate dueDate) throws SQLException {
        validate(title);
        return dml("UPDATE mission SET title = ?, description = ?, due_date = ? "
                + "WHERE mission_id = ? AND project_id = ? AND status = 'TODO'",
                new Object[]{title.trim(), description, asDate(dueDate), missionId, projectId});
    }

    public int delete(long projectId, long missionId) throws SQLException {
        // 참조하는 assignment가 있으면 삭제를 허용하지 않음 (FK 오류 방지)
        return dml("DELETE FROM mission m WHERE m.mission_id = ? AND m.project_id = ? "
                + "AND m.status = 'TODO' AND NOT EXISTS "
                + "(SELECT 1 FROM mission_assignment a WHERE a.mission_id = m.mission_id)",
                new Object[]{missionId, projectId});
    }

    private void validate(String title) {
        if (title == null || title.isBlank() || title.length() > 200)
            throw new IllegalArgumentException("미션 제목은 1~200자여야 합니다.");
    }
    private Date asDate(LocalDate d) { return d == null ? null : Date.valueOf(d); }

    private int dml(String sql, Object[] params) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        try {
            jdbc.setSqlAndParameters(sql, params);
            int result = jdbc.executeUpdate();
            jdbc.commit();
            return result;
        } catch (SQLException e) {
            try { jdbc.rollback(); } catch (SQLException rollback) { e.addSuppressed(rollback); }
            throw e;
        } finally { jdbc.close(); }
    }
}

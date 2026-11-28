package com.campusmatching.model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.campusmatching.model.domain.WorkspaceProject;

public class WorkspaceProjectDAO {
    public WorkspaceProject findById(long projectId) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters("SELECT project_id, title, description, owner_id FROM project WHERE project_id = ?",
                new Object[]{projectId});
        try {
            ResultSet rs = jdbc.executeQuery();
            return rs.next() ? row(rs) : null;
        } finally { jdbc.close(); }
    }

    public List<WorkspaceProject> findRecentRecruiting() throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters("SELECT project_id, title, description, owner_id FROM project " +
                        "WHERE status = 'RECRUITING' ORDER BY project_id DESC FETCH FIRST 3 ROWS ONLY", null);
        try {
            ResultSet rs = jdbc.executeQuery();
            List<WorkspaceProject> list = new ArrayList<>();
            while (rs.next()) list.add(row(rs));
            return list;
        } finally { jdbc.close(); }
    }

    public WorkspaceProject findLatestMine(long userId) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        // 가장 최근 프로젝트: 프로젝트 ID 내림차순 (활동 중 팀원 혹은 탈퇴하지 않은 소유자).
        // 소유자여도 LEFT 기록이 있으면 메인에 다시 표시하지 않는다.
        jdbc.setSqlAndParameters("SELECT p.project_id, p.title, p.description, p.owner_id FROM project p " +
                "WHERE EXISTS (SELECT 1 FROM project_member pm WHERE pm.project_id = p.project_id " +
                "AND pm.user_id = ? AND pm.status = 'ACTIVE') " +
                "OR (p.owner_id = ? AND NOT EXISTS (SELECT 1 FROM project_member pm2 " +
                "WHERE pm2.project_id = p.project_id AND pm2.user_id = ? AND pm2.status = 'LEFT')) " +
                "ORDER BY p.project_id DESC FETCH FIRST 1 ROW ONLY", new Object[]{userId, userId, userId});
        try {
            ResultSet rs = jdbc.executeQuery();
            return rs.next() ? row(rs) : null;
        } finally { jdbc.close(); }
    }

    private WorkspaceProject row(ResultSet rs) throws SQLException {
        long projectId = rs.getLong("project_id");
        String title = rs.getString("title");
        String description = rs.getString("description");
        long owner = rs.getLong("owner_id");
        Long ownerId = rs.wasNull() ? null : owner;
        return new WorkspaceProject(projectId, title, description, ownerId);
    }
}

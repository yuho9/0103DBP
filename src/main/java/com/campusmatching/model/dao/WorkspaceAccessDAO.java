package com.campusmatching.model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;

public class WorkspaceAccessDAO {
    public boolean canView(long projectId, long userId) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters("SELECT COUNT(*) FROM project p WHERE p.project_id = ? " +
                "AND (p.owner_id = ? OR EXISTS (SELECT 1 FROM project_member pm " +
                "WHERE pm.project_id = p.project_id AND pm.user_id = ? AND pm.status = 'ACTIVE'))",
                new Object[]{projectId, userId, userId});
        try { ResultSet rs = jdbc.executeQuery(); return rs.next() && rs.getInt(1) > 0; }
        finally { jdbc.close(); }
    }

    public boolean isLeader(long projectId, long userId) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters("SELECT COUNT(*) FROM project WHERE project_id = ? AND owner_id = ?",
                new Object[]{projectId, userId});
        try { ResultSet rs = jdbc.executeQuery(); return rs.next() && rs.getInt(1) > 0; }
        finally { jdbc.close(); }
    }

    public Long findActiveMemberId(long projectId, long userId) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters("SELECT project_member_id FROM project_member " +
                "WHERE project_id = ? AND user_id = ? AND status = 'ACTIVE'",
                new Object[]{projectId, userId});
        try { ResultSet rs = jdbc.executeQuery(); return rs.next() ? rs.getLong(1) : null; }
        finally { jdbc.close(); }
    }
}

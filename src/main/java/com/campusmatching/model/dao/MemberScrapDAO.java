package com.campusmatching.model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class MemberScrapDAO {

    public int add(long userId, long targetUserId) throws SQLException {
        String sql = "INSERT INTO member_scrap (user_id, target_user_id) VALUES (?, ?)";
        return executeDml(sql, new Object[] { userId, targetUserId });
    }

    public int remove(long userId, long targetUserId) throws SQLException {
        String sql = "DELETE FROM member_scrap WHERE user_id = ? AND target_user_id = ?";
        return executeDml(sql, new Object[] { userId, targetUserId });
    }

    public boolean exists(long userId, long targetUserId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM member_scrap WHERE user_id = ? AND target_user_id = ?";
        return count(sql, new Object[] { userId, targetUserId }) > 0;
    }

    public int countByTarget(long targetUserId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM member_scrap WHERE target_user_id = ?";
        return count(sql, new Object[] { targetUserId });
    }

    public List<Long> findTargetIdsByUser(long userId) throws SQLException {
        String sql = "SELECT target_user_id FROM member_scrap WHERE user_id = ? "
                   + "ORDER BY scrapped_at DESC, scrap_id DESC";
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, new Object[] { userId });
        List<Long> list = new ArrayList<>();
        try {
            ResultSet rs = jdbc.executeQuery();
            if (rs == null) throw new SQLException("쿼리 실행 실패: " + sql);
            while (rs.next()) list.add(rs.getLong(1));
            return list;
        } finally {
            jdbc.close();
        }
    }

    private int count(String sql, Object[] param) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, param);
        try {
            ResultSet rs = jdbc.executeQuery();
            if (rs == null) throw new SQLException("쿼리 실행 실패: " + sql);
            return rs.next() ? rs.getInt(1) : 0;
        } finally {
            jdbc.close();
        }
    }

    private int executeDml(String sql, Object[] param) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, param);
        try {
            int result = jdbc.executeUpdate();
            jdbc.commit();
            return result;
        } catch (Exception e) {
            jdbc.rollback();
            if (e instanceof SQLException) throw (SQLException) e;
            throw new SQLException(e);
        } finally {
            jdbc.close();
        }
    }
}

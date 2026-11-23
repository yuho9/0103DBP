
package com.campusmatching.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.campusmatching.model.service.ConnectionManager;

public class ProjectCountDAO {

    private final ConnectionManager connectionManager =
            new ConnectionManager();

    public int countCreated(Long userId) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM PROJECT
                WHERE OWNER_ID = ?
                """;

        return count(sql, userId);
    }

    public int countParticipating(Long userId) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM PROJECT P
                WHERE P.STATUS = 'IN_PROGRESS'
                  AND P.OWNER_ID <> ?
                  AND EXISTS (
                      SELECT 1
                      FROM PROJECT_MEMBER PM
                      WHERE PM.PROJECT_ID = P.PROJECT_ID
                        AND PM.USER_ID = ?
                        AND PM.STATUS = 'ACTIVE'
                  )
                """;

        return count(sql, userId, userId);
    }

    public int countCompleted(Long userId) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM PROJECT P
                WHERE P.STATUS IN ('COMPLETED', 'FAILED')
                  AND (
                      P.OWNER_ID = ?
                      OR EXISTS (
                          SELECT 1
                          FROM PROJECT_MEMBER PM
                          WHERE PM.PROJECT_ID = P.PROJECT_ID
                            AND PM.USER_ID = ?
                            AND PM.STATUS = 'ACTIVE'
                      )
                  )
                """;

        return count(sql, userId, userId);
    }

    private int count(String sql, Long... userIds)
            throws SQLException {

        try (Connection conn = connectionManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            for (int i = 0; i < userIds.length; i++) {
                pstmt.setLong(i + 1, userIds[i]);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }
}

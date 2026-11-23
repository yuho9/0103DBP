
package com.campusmatching.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.campusmatching.model.service.ConnectionManager;

public class AchievementDAO {

    private final ConnectionManager connectionManager =
            new ConnectionManager();

    public int countSuccessfulProjects(Long userId) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM PROJECT P
                WHERE P.STATUS = 'COMPLETED'
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

        try (Connection conn = connectionManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, userId);
            pstmt.setLong(2, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public int countCompletedMissions(Long userId) throws SQLException {
        String sql = """
                SELECT COUNT(DISTINCT MA.MISSION_ID)
                FROM MISSION_ASSIGNMENT MA
                JOIN PROJECT_MEMBER PM
                  ON MA.PROJECT_MEMBER_ID = PM.PROJECT_MEMBER_ID
                JOIN MISSION M
                  ON MA.MISSION_ID = M.MISSION_ID
                WHERE PM.USER_ID = ?
                  AND PM.STATUS = 'ACTIVE'
                  AND MA.STATUS = 'DONE'
                  AND M.STATUS = 'COMPLETED'
                """;

        try (Connection conn = connectionManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public int countReceivedScraps(Long userId) throws SQLException {
        String sql = """
                SELECT COUNT(DISTINCT USER_ID)
                FROM MEMBER_SCRAP
                WHERE TARGET_USER_ID = ?
                  AND USER_ID <> TARGET_USER_ID
                """;

        try (Connection conn = connectionManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }
}

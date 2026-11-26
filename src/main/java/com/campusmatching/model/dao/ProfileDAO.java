
package com.campusmatching.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.campusmatching.model.domain.Profile;
import com.campusmatching.model.service.ConnectionManager;

public class ProfileDAO {

    private final ConnectionManager connectionManager =
            new ConnectionManager();

    public Profile findByUserId(Long userId) throws SQLException {
        try (Connection conn = connectionManager.getConnection()) {
            Profile profile = findProfile(conn, userId);

            if (profile != null) {
                profile.setSkills(
                        findSkills(conn, profile.getProfileId())
                );
            }

            return profile;
        }
    }

    private Profile findProfile(Connection conn, Long userId)
            throws SQLException {

        String sql = """
                SELECT PROFILE_ID,
                       USER_ID,
                       NICKNAME,
                       MAJOR,
                       GRADE,
                       DESIRED_POSITION,
                       DESIRED_PROJECT,
                       IMAGE_FILE_PATH
                FROM PROFILE
                WHERE USER_ID = ?
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                Profile profile = new Profile();

                profile.setProfileId(rs.getLong("PROFILE_ID"));
                profile.setUserId(rs.getLong("USER_ID"));
                profile.setNickname(rs.getString("NICKNAME"));
                profile.setMajor(rs.getString("MAJOR"));

                int grade = rs.getInt("GRADE");
                profile.setGrade(rs.wasNull() ? null : grade);

                profile.setDesiredPosition(
                        rs.getString("DESIRED_POSITION")
                );
                profile.setDesiredProject(
                        rs.getString("DESIRED_PROJECT")
                );
                profile.setImageFilePath(
                        rs.getString("IMAGE_FILE_PATH")
                );

                return profile;
            }
        }
    }

    private List<String> findSkills(
            Connection conn,
            Long profileId
    ) throws SQLException {

        String sql = """
                SELECT SKILL_NAME
                FROM PROFILE_SKILL
                WHERE PROFILE_ID = ?
                ORDER BY SKILL_NAME
                """;

        List<String> skills = new ArrayList<>();

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, profileId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    skills.add(rs.getString("SKILL_NAME"));
                }
            }
        }

        return skills;
    }

    public boolean saveOrUpdate(Profile profile) throws SQLException {
        try (Connection conn = connectionManager.getConnection()) {
            boolean originalAutoCommit = conn.getAutoCommit();

            try {
                conn.setAutoCommit(false);

                Long profileId = findProfileId(
                        conn,
                        profile.getUserId()
                );

                if (profileId == null) {
                    insertProfile(conn, profile);
                    profileId = findProfileId(
                            conn,
                            profile.getUserId()
                    );
                } else {
                    updateProfile(conn, profile);
                }

                if (profileId == null) {
                    conn.rollback();
                    return false;
                }

                replaceSkills(
                        conn,
                        profileId,
                        profile.getSkills()
                );

                conn.commit();

                profile.setProfileId(profileId);
                return true;

            } catch (SQLException | RuntimeException e) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackException) {
                    e.addSuppressed(rollbackException);
                }
                throw e;

            } finally {
                conn.setAutoCommit(originalAutoCommit);
            }
        }
    }

    public boolean update(Profile profile) throws SQLException {
        return saveOrUpdate(profile);
    }

    private void insertProfile(Connection conn, Profile profile)
            throws SQLException {

        String sql = """
                INSERT INTO PROFILE (
                    USER_ID,
                    NICKNAME,
                    MAJOR,
                    GRADE,
                    DESIRED_POSITION,
                    DESIRED_PROJECT,
                    IMAGE_FILE_PATH
                ) VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            bindProfileFields(pstmt, profile);
            pstmt.executeUpdate();
        }
    }

    private void updateProfile(Connection conn, Profile profile)
            throws SQLException {

        String sql = """
                UPDATE PROFILE
                SET NICKNAME = ?,
                    MAJOR = ?,
                    GRADE = ?,
                    DESIRED_POSITION = ?,
                    DESIRED_PROJECT = ?,
                    IMAGE_FILE_PATH = ?
                WHERE USER_ID = ?
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, profile.getNickname());
            pstmt.setString(2, profile.getMajor());

            if (profile.getGrade() == null) {
                pstmt.setNull(3, Types.INTEGER);
            } else {
                pstmt.setInt(3, profile.getGrade());
            }

            pstmt.setString(4, profile.getDesiredPosition());
            pstmt.setString(5, profile.getDesiredProject());
            pstmt.setString(6, profile.getImageFilePath());
            pstmt.setLong(7, profile.getUserId());

            if (pstmt.executeUpdate() != 1) {
                throw new SQLException(
                        "프로필 수정 대상이 존재하지 않습니다."
                );
            }
        }
    }

    private void bindProfileFields(
            PreparedStatement pstmt,
            Profile profile
    ) throws SQLException {

        pstmt.setLong(1, profile.getUserId());
        pstmt.setString(2, profile.getNickname());
        pstmt.setString(3, profile.getMajor());

        if (profile.getGrade() == null) {
            pstmt.setNull(4, Types.INTEGER);
        } else {
            pstmt.setInt(4, profile.getGrade());
        }

        pstmt.setString(5, profile.getDesiredPosition());
        pstmt.setString(6, profile.getDesiredProject());
        pstmt.setString(7, profile.getImageFilePath());
    }

    private Long findProfileId(
            Connection conn,
            Long userId
    ) throws SQLException {

        String sql = """
                SELECT PROFILE_ID
                FROM PROFILE
                WHERE USER_ID = ?
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("PROFILE_ID");
                }
            }
        }

        return null;
    }

    private void replaceSkills(
            Connection conn,
            Long profileId,
            List<String> skills
    ) throws SQLException {

        String deleteSql = """
                DELETE FROM PROFILE_SKILL
                WHERE PROFILE_ID = ?
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(deleteSql)) {
            pstmt.setLong(1, profileId);
            pstmt.executeUpdate();
        }

        if (skills == null || skills.isEmpty()) {
            return;
        }

        String insertSql = """
                INSERT INTO PROFILE_SKILL (
                    PROFILE_ID,
                    SKILL_NAME
                ) VALUES (?, ?)
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
            for (String skill : skills) {
                pstmt.setLong(1, profileId);
                pstmt.setString(2, skill);
                pstmt.addBatch();
            }

            pstmt.executeBatch();
        }
    }
}

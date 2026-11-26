package com.campusmatching.model.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.campusmatching.model.domain.ProjectFormData;
import com.campusmatching.model.service.ConnectionManager;

public class ProjectFormDAO {

    private final ConnectionManager connectionManager = new ConnectionManager();

    public long create(long userId, ProjectFormData data) throws SQLException {
        try (Connection conn = connectionManager.getConnection()) {
            conn.setAutoCommit(false);
            try {
                long categoryId = resolveCategory(conn, data);
                long projectId;
                String sql = "INSERT INTO PROJECT (OWNER_ID, TITLE, DESCRIPTION, MAX_MEMBERS, "
                        + "RECRUITMENT_START, RECRUITMENT_END, START_DATE, END_DATE, STATUS, MEETING_TYPE) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'RECRUITING', ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql, new String[] {"PROJECT_ID"})) {
                    ps.setLong(1, userId);
                    ps.setString(2, data.getTitle());
                    ps.setString(3, data.getDescription());
                    ps.setInt(4, data.getCapacity());
                    ps.setDate(5, Date.valueOf(data.getRecruitStartDate()));
                    ps.setDate(6, Date.valueOf(data.getRecruitEndDate()));
                    ps.setDate(7, Date.valueOf(data.getProjectStartDate()));
                    ps.setDate(8, Date.valueOf(data.getProjectEndDate()));
                    ps.setString(9, data.getMeetingType());
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) throw new SQLException("프로젝트 ID를 생성하지 못했습니다.");
                        projectId = rs.getLong(1);
                    }
                }
                saveCategory(conn, projectId, categoryId);
                replaceTags(conn, projectId, data);
                conn.commit();
                return projectId;
            } catch (Exception e) {
                conn.rollback();
                if (e instanceof SQLException) throw (SQLException) e;
                throw new SQLException("프로젝트 생성 실패", e);
            }
        }
    }

    public void update(long userId, long projectId, ProjectFormData data) throws SQLException {
        try (Connection conn = connectionManager.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String status = null;
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT STATUS FROM PROJECT WHERE PROJECT_ID = ? AND OWNER_ID = ? FOR UPDATE")) {
                    ps.setLong(1, projectId);
                    ps.setLong(2, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) status = rs.getString(1);
                    }
                }
                if (status == null) throw new SQLException("수정 권한이 없거나 프로젝트가 없습니다.");
                if ("COMPLETED".equals(status) || "FAILED".equals(status)) {
                    throw new SQLException("종료된 프로젝트는 수정할 수 없습니다.");
                }
                long categoryId = resolveCategory(conn, data);
                String sql = "UPDATE PROJECT SET TITLE = ?, DESCRIPTION = ?, MAX_MEMBERS = ?, "
                        + "RECRUITMENT_START = ?, RECRUITMENT_END = ?, START_DATE = ?, "
                        + "END_DATE = ?, MEETING_TYPE = ? WHERE PROJECT_ID = ? AND OWNER_ID = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, data.getTitle());
                    ps.setString(2, data.getDescription());
                    ps.setInt(3, data.getCapacity());
                    ps.setDate(4, Date.valueOf(data.getRecruitStartDate()));
                    ps.setDate(5, Date.valueOf(data.getRecruitEndDate()));
                    ps.setDate(6, Date.valueOf(data.getProjectStartDate()));
                    ps.setDate(7, Date.valueOf(data.getProjectEndDate()));
                    ps.setString(8, data.getMeetingType());
                    ps.setLong(9, projectId);
                    ps.setLong(10, userId);
                    if (ps.executeUpdate() != 1) throw new SQLException("프로젝트 수정 실패");
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM PROJECT_CATEGORY WHERE PROJECT_ID = ?")) {
                    ps.setLong(1, projectId);
                    ps.executeUpdate();
                }
                saveCategory(conn, projectId, categoryId);
                replaceTags(conn, projectId, data);
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                if (e instanceof SQLException) throw (SQLException) e;
                throw new SQLException("프로젝트 수정 실패", e);
            }
        }
    }

    public ProjectFormData findOwned(long userId, long projectId) throws SQLException {
        ProjectFormData data = null;
        try (Connection conn = connectionManager.getConnection()) {
            String sql = "SELECT PROJECT_ID, TITLE, DESCRIPTION, MAX_MEMBERS, "
                    + "RECRUITMENT_START, RECRUITMENT_END, START_DATE, END_DATE, MEETING_TYPE "
                    + "FROM PROJECT WHERE PROJECT_ID = ? AND OWNER_ID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, projectId);
                ps.setLong(2, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) return null;
                    data = new ProjectFormData();
                    data.setProjectId(rs.getLong("PROJECT_ID"));
                    data.setTitle(rs.getString("TITLE"));
                    data.setDescription(rs.getString("DESCRIPTION"));
                    data.setCapacity(rs.getInt("MAX_MEMBERS"));
                    data.setMeetingType(rs.getString("MEETING_TYPE"));
                    data.setRecruitStartDate(dateString(rs.getDate("RECRUITMENT_START")));
                    data.setRecruitEndDate(dateString(rs.getDate("RECRUITMENT_END")));
                    data.setProjectStartDate(dateString(rs.getDate("START_DATE")));
                    data.setProjectEndDate(dateString(rs.getDate("END_DATE")));
                }
            }
            String categorySql = "SELECT PARENT.NAME AS MAIN_NAME, CHILD.NAME AS SUB_NAME "
                    + "FROM PROJECT_CATEGORY PC JOIN CATEGORY CHILD ON PC.CATEGORY_ID = CHILD.CATEGORY_ID "
                    + "JOIN CATEGORY PARENT ON CHILD.PARENT_ID = PARENT.CATEGORY_ID "
                    + "WHERE PC.PROJECT_ID = ? FETCH FIRST 1 ROW ONLY";
            try (PreparedStatement ps = conn.prepareStatement(categorySql)) {
                ps.setLong(1, projectId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        data.setCategoryMain(rs.getString("MAIN_NAME"));
                        data.setCategorySub(rs.getString("SUB_NAME"));
                    }
                }
            }
            String tagSql = "SELECT T.NAME, T.TAG_TYPE FROM PROJECT_TAG PT "
                    + "JOIN TAG T ON PT.TAG_ID = T.TAG_ID WHERE PT.PROJECT_ID = ? ORDER BY T.TAG_ID";
            List<String> skills = new ArrayList<>();
            List<String> positions = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(tagSql)) {
                ps.setLong(1, projectId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        if ("POSITION".equals(rs.getString("TAG_TYPE"))) positions.add(rs.getString("NAME"));
                        if ("SKILL".equals(rs.getString("TAG_TYPE"))) skills.add(rs.getString("NAME"));
                    }
                }
            }
            data.setSkills(skills);
            data.setPositions(positions);
            return data;
        }
    }

    private String dateString(Date date) {
        return date == null ? "" : date.toLocalDate().toString();
    }

    private long resolveCategory(Connection conn, ProjectFormData data) throws SQLException {
        String sql = "SELECT C.CATEGORY_ID FROM CATEGORY C JOIN CATEGORY P "
                + "ON C.PARENT_ID = P.CATEGORY_ID WHERE P.NAME = ? AND C.NAME = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, data.getCategoryMain());
            ps.setString(2, data.getCategorySub());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new SQLException("존재하지 않는 모집 구분입니다.");
                return rs.getLong(1);
            }
        }
    }

    private void saveCategory(Connection conn, long projectId, long categoryId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO PROJECT_CATEGORY (PROJECT_ID, CATEGORY_ID) VALUES (?, ?)")) {
            ps.setLong(1, projectId);
            ps.setLong(2, categoryId);
            ps.executeUpdate();
        }
    }

    private void replaceTags(Connection conn, long projectId, ProjectFormData data) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM PROJECT_TAG WHERE PROJECT_ID = ?")) {
            ps.setLong(1, projectId);
            ps.executeUpdate();
        }
        Set<String> unique = new HashSet<>();
        for (String skill : data.getSkills()) {
            if (unique.add("SKILL:" + skill.toLowerCase())) linkTag(conn, projectId, skill, "SKILL");
        }
        for (String position : data.getPositions()) {
            if (unique.add("POSITION:" + position.toLowerCase())) linkTag(conn, projectId, position, "POSITION");
        }
    }

    private void linkTag(Connection conn, long projectId, String name, String type) throws SQLException {
        Long tagId = null;
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT TAG_ID FROM TAG WHERE NAME = ? AND TAG_TYPE = ? FETCH FIRST 1 ROW ONLY")) {
            ps.setString(1, name);
            ps.setString(2, type);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) tagId = rs.getLong(1);
            }
        }
        if (tagId == null) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO TAG (NAME, TAG_TYPE) VALUES (?, ?)", new String[] {"TAG_ID"})) {
                ps.setString(1, name);
                ps.setString(2, type);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) throw new SQLException("태그 ID 생성 실패");
                    tagId = rs.getLong(1);
                }
            }
        }
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO PROJECT_TAG (PROJECT_ID, TAG_ID) VALUES (?, ?)")) {
            ps.setLong(1, projectId);
            ps.setLong(2, tagId);
            ps.executeUpdate();
        }
    }
}

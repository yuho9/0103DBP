package com.campusmatching.model.dao;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.campusmatching.model.domain.MeetingType;
import com.campusmatching.model.domain.Project;
import com.campusmatching.model.domain.ProjectSearchCondition;
import com.campusmatching.model.domain.ProjectStatus;
import com.campusmatching.model.domain.Tag;
import com.campusmatching.model.domain.User;

public class ProjectDAO {

    public int create(Project p) throws SQLException {
        String sql = "INSERT INTO project "
                   + "(owner_id, title, description, max_members, "
                   + " recruitment_start, recruitment_end, start_date, end_date, status, meeting_type) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] param = new Object[] {
            p.getOwner().getUserId(),
            p.getTitle(),
            p.getDescription(),
            p.getMaxMembers(),
            toSqlDate(p.getRecruitmentStart()),
            toSqlDate(p.getRecruitmentEnd()),
            toSqlDate(p.getStartDate()),
            toSqlDate(p.getEndDate()),
            p.getStatus() == null ? ProjectStatus.RECRUITING.name() : p.getStatus().name(),
            p.getMeetingType() == null ? MeetingType.ONLINE.name() : p.getMeetingType().name()
        };
        return executeDml(sql, param);
    }

    public List<Project> findAll() throws SQLException {
        String sql = "SELECT * FROM project ORDER BY project_id DESC";
        return queryList(sql, null);
    }

    public Project findById(long projectId) throws SQLException {
        String sql = "SELECT * FROM project WHERE project_id = ?";
        List<Project> list = queryList(sql, new Object[] { projectId });
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Project> searchByTitle(String keyword) throws SQLException {
        String sql = "SELECT * FROM project WHERE title LIKE '%' || ? || '%' "
                   + "ORDER BY project_id DESC";
        return queryList(sql, new Object[] { keyword });
    }

    public List<Project> findByStatus(ProjectStatus status) throws SQLException {
        String sql = "SELECT * FROM project WHERE status = ? ORDER BY project_id DESC";
        return queryList(sql, new Object[] { status.name() });
    }

    public List<Project> findByOwnerId(long ownerId, ProjectStatus status) throws SQLException {
        if (status == null) {
            String sql = "SELECT * FROM project WHERE owner_id = ? ORDER BY project_id DESC";
            return queryList(sql, new Object[] { ownerId });
        }
        String sql = "SELECT * FROM project WHERE owner_id = ? AND status = ? ORDER BY project_id DESC";
        return queryList(sql, new Object[] { ownerId, status.name() });
    }

    public int countActiveMembers(long projectId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM project_member WHERE project_id = ? AND status = 'ACTIVE'";
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, new Object[] { projectId });
        try {
            ResultSet rs = jdbc.executeQuery();
            if (rs == null) throw new SQLException("쿼리 실행 실패: " + sql);
            return rs.next() ? rs.getInt(1) : 0;
        } finally {
            jdbc.close();
        }
    }

    public List<Project> search(ProjectSearchCondition cond) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM project p WHERE 1 = 1 ");
        List<Object> param = new ArrayList<>();

        if (cond.getKeyword() != null && !cond.getKeyword().trim().isEmpty()) {
            sql.append("AND p.title LIKE '%' || ? || '%' ");
            param.add(cond.getKeyword().trim());
        }
        if (cond.getCategoryId() != null) {
            sql.append("AND EXISTS (SELECT 1 FROM project_category pc "
                     + "JOIN category c ON c.category_id = pc.category_id "
                     + "WHERE pc.project_id = p.project_id "
                     + "AND (c.category_id = ? OR c.parent_id = ?)) ");
            param.add(cond.getCategoryId());
            param.add(cond.getCategoryId());
        }
        if (cond.getStatus() != null) {
            sql.append("AND p.status = ? ");
            param.add(cond.getStatus().name());
        }
        if (cond.getMeetingType() != null) {
            sql.append("AND p.meeting_type = ? ");
            param.add(cond.getMeetingType().name());
        }
        List<String> tags = distinctTags(cond.getTags());
        if (!tags.isEmpty()) {
            sql.append("AND (SELECT COUNT(DISTINCT t.tag_id) FROM project_tag pt "
                     + "JOIN tag t ON t.tag_id = pt.tag_id "
                     + "WHERE pt.project_id = p.project_id AND UPPER(t.name) IN (");
            for (int i = 0; i < tags.size(); i++) {
                sql.append(i == 0 ? "?" : ", ?");
                param.add(tags.get(i).toUpperCase());
            }
            sql.append(")) = ").append(tags.size()).append(" ");
        }
        List<String> positions = distinctValues(cond.getPositions());
        if (!positions.isEmpty()) {
            sql.append("AND EXISTS (SELECT 1 FROM project_tag pt "
                     + "JOIN tag t ON t.tag_id = pt.tag_id "
                     + "WHERE pt.project_id = p.project_id AND t.tag_type = '" + Tag.TYPE_POSITION + "' "
                     + "AND UPPER(t.name) IN (");
            for (int i = 0; i < positions.size(); i++) {
                sql.append(i == 0 ? "?" : ", ?");
                param.add(positions.get(i).toUpperCase());
            }
            sql.append(")) ");
        }
        List<String> skills = distinctTags(cond.getSkills());
        if (!skills.isEmpty()) {
            sql.append("AND (SELECT COUNT(DISTINCT t.tag_id) FROM project_tag pt "
                     + "JOIN tag t ON t.tag_id = pt.tag_id "
                     + "WHERE pt.project_id = p.project_id "
                     + "AND (t.tag_type = '" + Tag.TYPE_SKILL + "' OR t.tag_type IS NULL) "
                     + "AND UPPER(t.name) IN (");
            for (int i = 0; i < skills.size(); i++) {
                sql.append(i == 0 ? "?" : ", ?");
                param.add(skills.get(i).toUpperCase());
            }
            sql.append(")) = ").append(skills.size()).append(" ");
        }
        
        if (cond.getScrappedByUserId() != null) {
            sql.append("AND EXISTS (SELECT 1 FROM project_scrap s "
                     + "WHERE s.project_id = p.project_id AND s.user_id = ?) ");
            param.add(cond.getScrappedByUserId());
        }

        if (cond.isSortByPopular()) {
            sql.append("ORDER BY (SELECT COUNT(*) FROM project_scrap s2 "
                     + "WHERE s2.project_id = p.project_id) DESC, p.project_id DESC");
        } else {
            sql.append("ORDER BY p.project_id DESC");
        }
        return queryList(sql.toString(), param.isEmpty() ? null : param.toArray());
    }

    private List<String> distinctValues(List<String> input) {
        List<String> result = new ArrayList<>();
        if (input == null) return result;
        for (String v : input) {
            if (v == null || v.trim().isEmpty()) continue;
            String n = v.trim();
            boolean dup = false;
            for (String r : result) if (r.equalsIgnoreCase(n)) dup = true;
            if (!dup) result.add(n);
        }
        return result;
    }
    
    private List<String> distinctTags(List<String> input) {
        List<String> result = new ArrayList<>();
        if (input == null) return result;
        for (String t : input) {
            String n = TagDAO.normalize(t);
            boolean dup = false;
            for (String r : result) if (r.equalsIgnoreCase(n)) dup = true;
            if (!dup) result.add(n);
        }
        return result;
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

    private List<Project> queryList(String sql, Object[] param) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, param);
        List<Project> list = new ArrayList<>();
        try {
            ResultSet rs = jdbc.executeQuery();
            if (rs == null) {
                throw new SQLException("쿼리 실행 실패: " + sql);
            }
            while (rs.next()) {
                list.add(toProject(rs));
            }
            return list;
        } finally {
            jdbc.close();
        }
    }

    private Project toProject(ResultSet rs) throws SQLException {
        Project p = new Project();
        p.setProjectId(rs.getLong("project_id"));
        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));   // CLOB도 getString 가능
        p.setMaxMembers(rs.getInt("max_members"));
        p.setRecruitmentStart(toLocalDate(rs.getDate("recruitment_start")));
        p.setRecruitmentEnd(toLocalDate(rs.getDate("recruitment_end")));
        p.setStartDate(toLocalDate(rs.getDate("start_date")));
        p.setEndDate(toLocalDate(rs.getDate("end_date")));
        p.setStatus(ProjectStatus.valueOf(rs.getString("status")));
        p.setMeetingType(MeetingType.valueOf(rs.getString("meeting_type")));

        User owner = new User();
        owner.setUserId(rs.getLong("owner_id"));
        p.setOwner(owner);
        return p;
    }

    private Date toSqlDate(LocalDate d) {
        return d == null ? null : Date.valueOf(d);
    }

    private LocalDate toLocalDate(Date d) {
        return d == null ? null : d.toLocalDate();
    }
}

package com.campusmatching.model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.campusmatching.model.domain.Tag;

public class TagDAO {

    private static final int MAX_LENGTH = 50;

    public static String normalize(String input) {
        if (input == null) throw new IllegalArgumentException("태그가 비어 있습니다.");
        String s = input.trim();
        while (s.startsWith("#")) s = s.substring(1).trim();
        if (s.isEmpty()) throw new IllegalArgumentException("태그가 비어 있습니다.");
        if (s.length() > MAX_LENGTH) throw new IllegalArgumentException("태그는 " + MAX_LENGTH + "자 이하여야 합니다.");
        return s;
    }

    public List<Tag> findByProjectId(long projectId) throws SQLException {
        String sql = "SELECT t.tag_id, t.name, t.tag_type FROM tag t "
                   + "JOIN project_tag pt ON t.tag_id = pt.tag_id "
                   + "WHERE pt.project_id = ? ORDER BY t.name";
        return queryTags(sql, new Object[] { projectId });
    }

    public List<Tag> findByUserId(long userId) throws SQLException {
        String sql = "SELECT ps.skill_name FROM profile_skill ps "
                   + "JOIN profile p ON p.profile_id = ps.profile_id "
                   + "WHERE p.user_id = ? ORDER BY ps.skill_name";
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, new Object[] { userId });
        List<Tag> list = new ArrayList<>();
        try {
            ResultSet rs = jdbc.executeQuery();
            if (rs == null) throw new SQLException("쿼리 실행 실패: " + sql);
            while (rs.next()) {
                list.add(new Tag(0L, rs.getString("skill_name"), Tag.TYPE_SKILL));
            }
            return list;
        } finally {
            jdbc.close();
        }
    }

    private List<Tag> queryTags(String sql, Object[] param) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, param);
        List<Tag> list = new ArrayList<>();
        try {
            ResultSet rs = jdbc.executeQuery();
            if (rs == null) throw new SQLException("쿼리 실행 실패: " + sql);
            while (rs.next()) {
                list.add(new Tag(rs.getLong("tag_id"), rs.getString("name"), rs.getString("tag_type")));
            }
            return list;
        } finally {
            jdbc.close();
        }
    }
}

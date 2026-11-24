package com.campusmatching.model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.campusmatching.model.domain.Category;

public class CategoryDAO {

    public List<Category> findAll() throws SQLException {
        String sql = "SELECT category_id, parent_id, name FROM category "
                   + "ORDER BY NVL(parent_id, category_id), parent_id NULLS FIRST, name";
        return queryList(sql, null);
    }

    public List<Category> findTopLevel() throws SQLException {
        String sql = "SELECT category_id, parent_id, name FROM category "
                   + "WHERE parent_id IS NULL ORDER BY category_id";
        return queryList(sql, null);
    }

    public List<Category> findChildren(long parentId) throws SQLException {
        String sql = "SELECT category_id, parent_id, name FROM category "
                   + "WHERE parent_id = ? ORDER BY category_id";
        return queryList(sql, new Object[] { parentId });
    }

    public Category findById(long categoryId) throws SQLException {
        String sql = "SELECT category_id, parent_id, name FROM category WHERE category_id = ?";
        List<Category> list = queryList(sql, new Object[] { categoryId });
        return list.isEmpty() ? null : list.get(0);
    }

    public int setProjectCategory(long projectId, long categoryId) throws SQLException {
        Category c = findById(categoryId);
        if (c == null) {
            throw new IllegalArgumentException("없는 카테고리입니다: " + categoryId);
        }
        if (c.getParentId() == null) {
            throw new IllegalArgumentException("하위 카테고리를 선택해야 합니다: " + c.getName());
        }
        String sql = "MERGE INTO project_category pc "
                   + "USING (SELECT ? AS project_id, ? AS category_id FROM dual) s "
                   + "ON (pc.project_id = s.project_id) "
                   + "WHEN MATCHED THEN UPDATE SET pc.category_id = s.category_id "
                   + "WHEN NOT MATCHED THEN INSERT (project_id, category_id) "
                   + "VALUES (s.project_id, s.category_id)";
        return executeDml(sql, new Object[] { projectId, categoryId });
    }

    public int removeProjectCategory(long projectId) throws SQLException {
        String sql = "DELETE FROM project_category WHERE project_id = ?";
        return executeDml(sql, new Object[] { projectId });
    }

    public Category findByProjectId(long projectId) throws SQLException {
        String sql = "SELECT c.category_id, c.parent_id, c.name "
                   + "FROM category c JOIN project_category pc ON c.category_id = pc.category_id "
                   + "WHERE pc.project_id = ?";
        List<Category> list = queryList(sql, new Object[] { projectId });
        return list.isEmpty() ? null : list.get(0);
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

    private List<Category> queryList(String sql, Object[] param) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, param);
        List<Category> list = new ArrayList<>();
        try {
            ResultSet rs = jdbc.executeQuery();
            if (rs == null) {
                throw new SQLException("쿼리 실행 실패: " + sql);
            }
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getLong("category_id"));
                long parentId = rs.getLong("parent_id");
                c.setParentId(rs.wasNull() ? null : parentId);
                c.setName(rs.getString("name"));
                list.add(c);
            }
            return list;
        } finally {
            jdbc.close();
        }
    }
}

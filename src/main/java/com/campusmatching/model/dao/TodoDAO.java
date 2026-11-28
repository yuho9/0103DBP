package com.campusmatching.model.dao;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import com.campusmatching.model.domain.Todo;

public class TodoDAO {
    private static final String COLUMNS =
            "todo_id, project_member_id, mission_id, " +
            "title, description, due_date, completed ";

    public List<Todo> findByMemberId(long memberId) throws SQLException {
        String sql = "SELECT " + COLUMNS + "FROM todo WHERE project_member_id = ? " +
                     "ORDER BY due_date ASC NULLS LAST, todo_id DESC";
        JDBCUtil jdbcUtil = new JDBCUtil();
        jdbcUtil.setSqlAndParameters(sql, new Object[]{memberId});
        try {
            ResultSet rs = jdbcUtil.executeQuery();
            List<Todo> result = new ArrayList<>();
            while (rs.next()) result.add(mapRow(rs));
            return result;
        } finally { jdbcUtil.close(); }
    }

    public Todo findById(long todoId, long memberId) throws SQLException {
        String sql = "SELECT " + COLUMNS + "FROM todo " +
                     "WHERE todo_id = ? AND project_member_id = ?";
        JDBCUtil jdbcUtil = new JDBCUtil();
        jdbcUtil.setSqlAndParameters(sql, new Object[]{todoId, memberId});
        try {
            ResultSet rs = jdbcUtil.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        } finally { jdbcUtil.close(); }
    }

    public int create(Todo todo) throws SQLException {
        validateTodo(todo);
        String sql = "INSERT INTO todo " +
                     "(project_member_id, mission_id, title, description, due_date, completed) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        Object[] params = {todo.getProjectMemberId(), todo.getMissionId(),
                todo.getTitle(), todo.getDescription(), sqlDate(todo.getDueDate()),
                todo.isCompleted() ? "Y" : "N"};
        return executeDml(sql, params);
    }

    public int markCompleted(long todoId, long memberId) throws SQLException {
        return executeDml("UPDATE todo SET completed = 'Y' " +
                "WHERE todo_id = ? AND project_member_id = ? AND completed = 'N'",
                new Object[]{todoId, memberId});
    }

    public int setCompleted(long todoId, long memberId, boolean completed) throws SQLException {
        return executeDml("UPDATE todo SET completed = ? WHERE todo_id = ? AND project_member_id = ?",
                new Object[]{completed ? "Y" : "N", todoId, memberId});
    }

    public int update(Todo todo) throws SQLException {
        validateTodo(todo);
        if (todo.getTodoId() == null) throw new IllegalArgumentException("수정할 Todo ID가 필요합니다.");
        String sql = "UPDATE todo SET title = ?, description = ?, due_date = ?, mission_id = ? " +
                     "WHERE todo_id = ? AND project_member_id = ?";
        Object[] params = {todo.getTitle(), todo.getDescription(), sqlDate(todo.getDueDate()),
                todo.getMissionId(), todo.getTodoId(), todo.getProjectMemberId()};
        return executeDml(sql, params);
    }

    public int delete(long todoId, long memberId) throws SQLException {
        return executeDml("DELETE FROM todo WHERE todo_id = ? AND project_member_id = ?",
                new Object[]{todoId, memberId});
    }

    private int executeDml(String sql, Object[] params) throws SQLException {
        JDBCUtil jdbcUtil = new JDBCUtil();
        jdbcUtil.setSqlAndParameters(sql, params);
        try {
            jdbcUtil.setAutoCommit(false);
            int result = jdbcUtil.executeUpdate();
            jdbcUtil.commit();
            return result;
        } catch (Exception e) {
            SQLException error = e instanceof SQLException ? (SQLException)e : new SQLException("Todo DB 변경 실패", e);
            try { jdbcUtil.rollback(); } catch (SQLException rollback) { error.addSuppressed(rollback); }
            throw error;
        } finally { jdbcUtil.close(); }
    }

    private Date sqlDate(LocalDate date) { return date == null ? null : Date.valueOf(date); }

    private Todo mapRow(ResultSet rs) throws SQLException {
        long todoId = rs.getLong("todo_id");
        long memberId = rs.getLong("project_member_id");
        long rawMissionId = rs.getLong("mission_id");
        Long missionId = rs.wasNull() ? null : rawMissionId;
        Date due = rs.getDate("due_date");
        return new Todo(todoId, memberId, missionId,
                rs.getString("title"), rs.getString("description"),
                due == null ? null : due.toLocalDate(), "Y".equals(rs.getString("completed")));
    }

    private void validateTodo(Todo todo) {
        if (todo == null) throw new IllegalArgumentException("Todo 객체가 없습니다.");
        if (todo.getProjectMemberId() <= 0) throw new IllegalArgumentException("올바른 프로젝트 팀원 ID가 필요합니다.");
        if (todo.getTitle() == null || todo.getTitle().trim().isEmpty() || todo.getTitle().length() > 200)
            throw new IllegalArgumentException("제목은 1~200자로 입력하세요.");
    }
}


package com.campusmatching.model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.campusmatching.model.domain.User;

public class UserDAO {

    public User findByLoginId(String loginId) throws SQLException {
        String sql = "SELECT USER_ID, LOGIN_ID, PASSWORD_HASH, "
                   + "USER_NAME, EMAIL, PHONE, CREATED_AT "
                   + "FROM USER_INFO "
                   + "WHERE LOGIN_ID = ?";

        JDBCUtil jdbcUtil = new JDBCUtil();
        jdbcUtil.setSqlAndParameters(sql, new Object[] {loginId});

        try {
            ResultSet rs = jdbcUtil.executeQuery();

            if (rs.next()) {
                return new User(
                    rs.getLong("USER_ID"),
                    rs.getString("LOGIN_ID"),
                    rs.getString("PASSWORD_HASH"),
                    rs.getString("USER_NAME"),
                    rs.getString("EMAIL"),
                    rs.getString("PHONE"),
                    rs.getTimestamp("CREATED_AT").toLocalDateTime()
                );
            }

            return null;
        } finally {
            jdbcUtil.close();
        }
    }

    public boolean existsLoginId(String loginId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM USER_INFO WHERE LOGIN_ID = ?";

        JDBCUtil jdbcUtil = new JDBCUtil();
        jdbcUtil.setSqlAndParameters(sql, new Object[] {loginId});

        try {
            ResultSet rs = jdbcUtil.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

            return false;
        } finally {
            jdbcUtil.close();
        }
    }

    public boolean existsEmail(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM USER_INFO WHERE EMAIL = ?";

        JDBCUtil jdbcUtil = new JDBCUtil();
        jdbcUtil.setSqlAndParameters(sql, new Object[] {email});

        try {
            ResultSet rs = jdbcUtil.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

            return false;
        } finally {
            jdbcUtil.close();
        }
    }

    public int create(User user) throws SQLException {
        String sql = "INSERT INTO USER_INFO "
                   + "(LOGIN_ID, PASSWORD_HASH, USER_NAME, EMAIL, PHONE) "
                   + "VALUES (?, ?, ?, ?, ?)";

        JDBCUtil jdbcUtil = new JDBCUtil();
        jdbcUtil.setSqlAndParameters(sql, new Object[] {
            user.getLoginId(),
            user.getPasswordHash(),
            user.getUserName(),
            user.getEmail(),
            user.getPhone()
        });

        try {
            return jdbcUtil.executeUpdate();
        } finally {
            jdbcUtil.close();
        }
    }
}

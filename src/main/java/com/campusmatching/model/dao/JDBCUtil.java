
package com.campusmatching.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.campusmatching.model.service.ConnectionManager;

public class JDBCUtil {

    private static final ConnectionManager connMan = new ConnectionManager();

    private String sql = null;
    private Object[] parameters = null;

    private Connection conn = null;
    private PreparedStatement pstmt = null;
    private ResultSet rs = null;

    private int resultSetType = ResultSet.TYPE_FORWARD_ONLY;
    private int resultSetConcurrency = ResultSet.CONCUR_READ_ONLY;

    public JDBCUtil() {
    }

    public void setSqlAndParameters(String sql, Object[] parameters) {
        this.sql = sql;
        this.parameters = parameters;
        this.resultSetType = ResultSet.TYPE_FORWARD_ONLY;
        this.resultSetConcurrency = ResultSet.CONCUR_READ_ONLY;
    }

    private int getParameterSize() {
        return parameters == null ? 0 : parameters.length;
    }

    private Object getParameter(int index) {
        return parameters[index];
    }

    private PreparedStatement getPreparedStatement() throws SQLException {
        if (conn == null || conn.isClosed()) {
            conn = connMan.getConnection();
        }

        if (rs != null) {
            rs.close();
            rs = null;
        }

        if (pstmt != null) {
            pstmt.close();
            pstmt = null;
        }

        pstmt = conn.prepareStatement(sql, resultSetType, resultSetConcurrency);
        return pstmt;
    }

    private void setParameters() throws SQLException {
        for (int i = 0; i < getParameterSize(); i++) {
            pstmt.setObject(i + 1, getParameter(i));
        }
    }

    public ResultSet executeQuery() throws SQLException {
        pstmt = getPreparedStatement();
        setParameters();

        rs = pstmt.executeQuery();
        return rs;
    }

    public int executeUpdate() throws SQLException {
        pstmt = getPreparedStatement();
        setParameters();

        return pstmt.executeUpdate();
    }

    public void commit() throws SQLException {
        if (conn != null && !conn.isClosed() && !conn.getAutoCommit()) {
            conn.commit();
        }
    }

    public void rollback() throws SQLException {
        if (conn != null && !conn.isClosed() && !conn.getAutoCommit()) {
            conn.rollback();
        }
    }

    public void setAutoCommit(boolean autoCommit) throws SQLException {
        if (conn == null || conn.isClosed()) {
            conn = connMan.getConnection();
        }

        conn.setAutoCommit(autoCommit);
    }

    public void close() throws SQLException {
        SQLException error = null;

        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {
            error = e;
        } finally {
            rs = null;
        }

        try {
            if (pstmt != null) {
                pstmt.close();
            }
        } catch (SQLException e) {
            if (error == null) {
                error = e;
            } else {
                error.addSuppressed(e);
            }
        } finally {
            pstmt = null;
        }

        try {
            if (conn != null) {
                if (!conn.isClosed() && !conn.getAutoCommit()) {
                    conn.rollback();
                }
                conn.close();
            }
        } catch (SQLException e) {
            if (error == null) {
                error = e;
            } else {
                error.addSuppressed(e);
            }
        } finally {
            conn = null;
        }

        if (error != null) {
            throw error;
        }
    }
}

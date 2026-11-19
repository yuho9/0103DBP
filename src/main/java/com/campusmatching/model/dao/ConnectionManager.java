
package com.campusmatching.model.dao;

import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;

import org.apache.commons.dbcp2.BasicDataSource;

public class ConnectionManager {

    private static final DataSource ds;

    static {
        String dbUrl = System.getenv("CAMPUS_DB_URL");
        String dbUser = System.getenv("CAMPUS_DB_USER");
        String dbPassword = System.getenv("CAMPUS_DB_PASSWORD");

        if (dbUrl == null || dbUser == null || dbPassword == null) {
            throw new IllegalStateException("Oracle DB 환경변수가 설정되지 않았습니다.");
        }

        BasicDataSource bds = new BasicDataSource();
        bds.setDriverClassName("oracle.jdbc.OracleDriver");
        bds.setUrl(dbUrl);
        bds.setUsername(dbUser);
        bds.setPassword(dbPassword);
        bds.setInitialSize(2);
        bds.setMaxTotal(10);

        ds = bds;
    }

    public Connection getConnection() throws SQLException {
        return ds.getConnection();
    }
}

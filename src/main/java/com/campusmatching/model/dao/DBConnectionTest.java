package com.campusmatching.model.dao;

import java.sql.Connection;
import java.sql.SQLException;

import com.campusmatching.model.service.ConnectionManager;

public class DBConnectionTest {

    public static void main(String[] args) {
        ConnectionManager cm = new ConnectionManager();

        try (Connection conn = cm.getConnection()) {
            System.out.println("Oracle DB 연결 성공!");
            System.out.println("DB: " + conn.getMetaData().getDatabaseProductName());
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

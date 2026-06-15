package com.emrDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConfig {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/bitcare?serverTimezone=Asia/Seoul";

    private DbConfig() {}

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = getenv("DB_URL", DEFAULT_URL);
        String user = getenv("DB_USER", "dbtest");
        String password = getenv("DB_PASSWORD", "");
        return DriverManager.getConnection(url, user, password);
    }

    private static String getenv(String key, String defaultValue) {
        String value = System.getenv(key);
        return value == null || value.trim().isEmpty() ? defaultValue : value;
    }
}

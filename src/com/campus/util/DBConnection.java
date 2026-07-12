package com.campus.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DRIVER   = "com.mysql.cj.jdbc.Driver";
    private static final String URL      = "jdbc:mysql://localhost:3306/campus_recruitment?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "Haryana@123"; // *** Change to your MySQL password ***

    private static boolean driverLoaded = false;
    private static String  driverError  = null;

    static {
        try {
            Class.forName(DRIVER);
            driverLoaded = true;
        } catch (ClassNotFoundException e) {
            driverError = "MySQL JDBC Driver not found in classpath: " + e.getMessage();
            System.err.println("[DBConnection] " + driverError);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (!driverLoaded) {
            throw new SQLException("Cannot connect: " + driverError);
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception ignored) {}
            }
        }
    }
}

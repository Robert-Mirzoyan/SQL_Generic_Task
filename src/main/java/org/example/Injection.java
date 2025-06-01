package org.example;

import java.sql.*;

public class Injection {
    public static void main(String[] args) throws Exception {
        try (Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5435/world_db", "postgres", "postgres")) {
            loginWithStatement(conn);
            loginWithPreparedStatement(conn);
        }
    }

    static void loginWithStatement(Connection conn) throws SQLException {
        String query = "SELECT * FROM users WHERE username = 'rob' AND password = '' OR '1'='1'";
        System.out.println("\nStatement Query: " + query);
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                System.out.println("Statement: Login success");
            } else {
                System.out.println("Statement: Login failed");
            }
        }
    }

    static void loginWithPreparedStatement(Connection conn) throws SQLException {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        System.out.println("\nPreparedStatement Query: " + query);
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, "rob");
            pstmt.setString(2, "' OR '1'='1");
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                System.out.println("PreparedStatement: Login success");
            } else {
                System.out.println("PreparedStatement: Login failed");
            }
        }
    }
}


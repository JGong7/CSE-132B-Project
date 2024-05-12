<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Process Faculty Submission</title>
</head>
<body>
<%
    String action = request.getParameter("action");
    String name = request.getParameter("name");
    String title = request.getParameter("title");
    String[] departments = request.getParameterValues("departments[]");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";

        Class.forName("org.postgresql.Driver");

        // Establish the connection
        conn = DriverManager.getConnection(url, user, password);
        conn.setAutoCommit(false); // Start transaction

        int result = 0;
        if ("add".equals(action)) {
            String sql = "INSERT INTO Faculty (name, title) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, title);
            result += pstmt.executeUpdate();

            if (departments != null) {
                sql = "INSERT INTO Faculty_Department (name, department) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                for (String department : departments) {
                    pstmt.setString(2, department);
                    result += pstmt.executeUpdate();
                }
            }
        } else if ("update".equals(action)) {
            String sql = "UPDATE Faculty SET title = ? WHERE name = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, name);
            result += pstmt.executeUpdate();

            if (departments != null) {
                sql = "DELETE FROM Faculty_Department WHERE name = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                result += pstmt.executeUpdate();

                sql = "INSERT INTO Faculty_Department (name, department) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                for (String department : departments) {
                    pstmt.setString(2, department);
                    result += pstmt.executeUpdate();
                }
            }
        } else if ("delete".equals(action)) {
            String sql = "DELETE FROM Faculty WHERE name = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            result += pstmt.executeUpdate();
        } else {
            throw new IllegalArgumentException("Invalid action: " + action);
        }

        if (result > 0) {
            conn.commit();
            out.println("<p>Faculty details processed successfully.</p>");
        } else {
            conn.rollback();
            out.println("<p>No faculty details processed.</p>");
        }

    } catch (Exception e) {
        out.println("<p>Error processing faculty details: " + e.getMessage() + "</p>");
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException ex) {
            out.println("<p>Error during transaction rollback: " + ex.getMessage() + "</p>");
        }
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) { /* ignored */ }
        if (conn != null) try { conn.close(); } catch (SQLException ex) { /* ignored */ }
    }
%>
</body>
</html>

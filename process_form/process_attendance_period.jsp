<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Attendance Period Submission</title>
</head>
<body>
<%
    String action = request.getParameter("action");
    String studentId = request.getParameter("studentId");
    Date periodStart = Date.valueOf(request.getParameter("periodStart"));
    Date periodEnd = Date.valueOf(request.getParameter("periodEnd"));

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
            String sql = "INSERT INTO Attendance_period (student_id, period_start, period_end) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            pstmt.setDate(2, periodStart);
            pstmt.setDate(3, periodEnd);
            result = pstmt.executeUpdate();
        } else if ("update".equals(action)) {
            String sql = "UPDATE Attendance_period SET period_start = ?, period_end = ? WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setDate(1, periodStart);
            pstmt.setDate(2, periodEnd);
            pstmt.setString(3, studentId);
            result = pstmt.executeUpdate();
        } else if ("delete".equals(action)) {
            String sql = "DELETE FROM Attendance_period WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            result = pstmt.executeUpdate();
        } else {
            throw new IllegalArgumentException("Invalid action: " + action);
        }

        if (result > 0) {
            conn.commit();
            out.println("<p>Attendance period recorded successfully.</p>");
        } else {
            conn.rollback();
            out.println("<p>Failed to record attendance period.</p>");
        }
        
    } catch (Exception e) {
        out.println("<p>Error processing attendance period: " + e.getMessage() + "</p>");
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

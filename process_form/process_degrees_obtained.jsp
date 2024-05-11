<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Degrees Obtained Submission</title>
</head>
<body>
<%
    String studentId = request.getParameter("studentId");
    String degreeType = request.getParameter("degreeType");
    String major = request.getParameter("major");
    Date startDate = Date.valueOf(request.getParameter("startDate"));
    Date endDate = Date.valueOf(request.getParameter("endDate"));
    String university = request.getParameter("university");

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

        String sql = "INSERT INTO Degrees_obtained (student_id, degree_type, major, start_date, end_date, university) VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentId);
        pstmt.setString(2, degreeType);
        pstmt.setString(3, major);
        pstmt.setDate(4, startDate);
        pstmt.setDate(5, endDate);
        pstmt.setString(6, university);
        int result = pstmt.executeUpdate();

        if (result > 0) {
            out.println("<p>Record inserted successfully.</p>");
            conn.commit(); // Commit transaction
        } else {
            out.println("<p>Failed to insert record.</p>");
            conn.rollback(); // Rollback transaction
        }
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException ex) {
            out.println("<p>Error during rollback: " + ex.getMessage() + "</p>");
        }
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) { /* ignored */ }
        if (conn != null) try { conn.close(); } catch (SQLException ex) { /* ignored */ }
    }
%>
</body>
</html>

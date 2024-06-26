<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Pursuing Degree Submission</title>
</head>
<body>
<%
    String action = request.getParameter("action");
    String studentId = request.getParameter("studentId");
    String degreeId = request.getParameter("degreeId");

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
            String sql = "INSERT INTO Pursuing (student_id, degree_id) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            pstmt.setString(2, degreeId);
            result = pstmt.executeUpdate();
        } else if ("update".equals(action)) {
            String sql = "UPDATE Pursuing SET degree_id = ? WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, degreeId);
            pstmt.setString(2, studentId);
            result = pstmt.executeUpdate();
        } else if ("delete".equals(action)) {
            String sql = "DELETE FROM Pursuing WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            result = pstmt.executeUpdate();
        } else {
            throw new IllegalArgumentException("Invalid action: " + action);
        }

        if (result > 0) {
            conn.commit(); // Commit the transaction
            out.println("<p>Record inserted successfully.</p>");
        } else {
            conn.rollback(); // Rollback the transaction
            out.println("<p>Failed to insert the record.</p>");
        }
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) { out.println("<p>Error during rollback: " + ex.getMessage() + "</p>"); }
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) { /* ignored */ }
        if (conn != null) try { conn.close(); } catch (SQLException ex) { /* ignored */ }
    }
%>
</body>
</html>

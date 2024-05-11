<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thesis Committee Processing</title>
    <meta charset="UTF-8">
</head>
<body>
    <h1>Thesis Committee Submission Results</h1>
<%
    String studentId = request.getParameter("student_id");
    String[] internalProfessors = request.getParameterValues("internalProfessor[]");
    String isPhD = request.getParameter("isPhd");
    String[] externalProfessors = null;
    if ("true".equals(isPhD)) {
        externalProfessors = request.getParameterValues("externalProfessor[]");
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    int updates = 0;

    try {
        // Database connection details should be configured here
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";

        Class.forName("org.postgresql.Driver");

        // Establish connection
        conn = DriverManager.getConnection(url, user, password);

        // Prepare SQL statement
        String sql = "INSERT INTO Thesis_committee (student_id, professor) VALUES (?, ?)";
        pstmt = conn.prepareStatement(sql);

        // Insert internal professors
        for (String professor : internalProfessors) {
            pstmt.setString(1, studentId);
            pstmt.setString(2, professor);
            updates += pstmt.executeUpdate();
        }

        // Insert external professors if applicable
        if (externalProfessors != null) {
            for (String professor : externalProfessors) {
                pstmt.setString(1, studentId);
                pstmt.setString(2, professor);
                updates += pstmt.executeUpdate();
            }
        }

        // Output success message
        out.println("<p>Data successfully inserted for " + updates + " professors.</p>");
    } catch (Exception e) {
        // Handle potential exceptions
        out.println("<p>Error while inserting data: " + e.getMessage() + "</p>");
    } finally {
        // Close all resources
        if (pstmt != null) try { pstmt.close(); } catch (SQLException logOrIgnore) {}
        if (conn != null) try { conn.close(); } catch (SQLException logOrIgnore) {}
    }
%>
    <p><a href="index.jsp">Return to Home</a></p>
</body>
</html>

<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Probation Submission Result</title>
</head>
<body>
<%
    // Initialize connection variables
    String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
    String user = "postgres";
    String password = "James2085";
    Connection conn = null;
    PreparedStatement pstmt = null;
    boolean isSavedSuccessfully = false;

    // Get parameters from request
    String studentId = request.getParameter("student_id");
    String startDate = request.getParameter("start_date");
    String endDate = request.getParameter("end_date");
    String reason = request.getParameter("reason");

    try {
        // Register JDBC driver and open connection
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, user, password);

        // Create the SQL query
        String sql = "INSERT INTO Probation (student_id, start_date, end_date, reason) VALUES (?, ?, ?, ?)";

        // Set parameters and execute update
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentId);
        pstmt.setDate(2, Date.valueOf(startDate));
        pstmt.setDate(3, Date.valueOf(endDate));
        pstmt.setString(4, reason);
        int result = pstmt.executeUpdate();

        // Check the result
        if (result > 0) {
            isSavedSuccessfully = true;
        }
    } catch (Exception e) {
        // Handle errors for JDBC
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        // Finally block to close resources
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    // Output result based on success or failure
    if (isSavedSuccessfully) {
        out.println("<h1>Submission Successful</h1>");
        out.println("<p>Thank you! The probation details for Student ID " + studentId + " have been successfully recorded.</p>");
        out.println("<p>Probation Period: " + startDate + " to " + endDate + "</p>");
        out.println("<p>Reason for Probation: " + reason + "</p>");
    } else {
        out.println("<h1>Submission Failed</h1>");
        out.println("<p>There was a problem processing your request. Please try again later or contact support.</p>");
    }
%>
    <p><a href="index.jsp">Return to Home</a></p>
</body>
</html>

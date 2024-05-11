<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Class Enrollment Submission Results</title>
</head>
<body>
    <h1>Class Enrollment Submission Results</h1>
<%
    String studentId = request.getParameter("student_id");
    String[] courseNumbers = request.getParameterValues("course_number[]");
    String[] years = request.getParameterValues("year[]");
    String[] quarters = request.getParameterValues("quarter[]");
    String[] titles = request.getParameterValues("title[]");
    String[] sectionIds = request.getParameterValues("section_id[]");
    String[] statuses = request.getParameterValues("status[]");
    String[] grades = request.getParameterValues("grade[]");

    Connection conn = null;
    PreparedStatement pstmt = null;
    int updates = 0;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";
        // Load the database driver
        Class.forName("org.postgresql.Driver");
        // Establish connection
        conn = DriverManager.getConnection(url, user, password);

        // SQL to insert into Enrollment table
        String sql = "INSERT INTO Enrollment (student_id, class_id, section_id, enrollment_type, grading_option, units) VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);

        // Loop over each class entry
        for (int i = 0; i < courseNumbers.length; i++) {
            pstmt.setString(1, studentId);
            pstmt.setString(2, courseNumbers[i]);
            pstmt.setInt(3, Integer.parseInt(years[i]));
            pstmt.setString(4, quarters[i]);
            pstmt.setString(5, titles[i]);
            pstmt.setString(6, sectionIds[i]);
            pstmt.setString(7, statuses[i]);
            pstmt.setString(8, (statuses[i].equals("taken") ? grades[i] : null));  // Grade is only relevant if the status is "taken"
            updates += pstmt.executeUpdate();
        }

        // Output success message
        out.println("<p>Data successfully inserted for " + updates + " classes.</p>");
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

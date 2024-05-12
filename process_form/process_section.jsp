<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Process Section Results</title>
</head>
<body>
    <h1>Section Results</h1>
<%
    String courseNumber = request.getParameter("courseNumber");
    String title = request.getParameter("title");
    String year = request.getParameter("year");
    String quarter = request.getParameter("quarter");

    String[] section_ids = request.getParameterValues("section_id[]");
    String[] professors = request.getParameterValues("professor[]");
    String[] enrollmentLimit = request.getParameterValues("enrollmentLimit[]");
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

        String sql = "SELECT class_id FROM Class WHERE course_number = ? AND year = ? AND quarter = ? AND title = ?";
        pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, courseNumber);
        pstmt.setInt(2, Integer.parseInt(year));
        pstmt.setString(3, quarter);
        pstmt.setString(4, title);

        ResultSet result = pstmt.executeQuery();
        int class_id = -1;
        while (result.next()){
            class_id = result.getInt("class_id");            
        }

        sql = "INSERT INTO Section (section_id, class_id, professor, enrollment_limit) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(2, class_id);
        for (int i = 0; i < section_ids.length; i++){
            pstmt.setString(1, section_ids[i]);
            pstmt.setString(3, professors[i]);
            pstmt.setInt(4, Integer.parseInt(enrollmentLimit[i]));
            updates += pstmt.executeUpdate();
        }
        out.println(updates + " rows affected!");
        
        
    } catch (Exception e) {
        // Handle potential exceptions
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        // Close all resources
        if (pstmt != null) try { pstmt.close(); } catch (SQLException logOrIgnore) {}
        if (conn != null) try { conn.close(); } catch (SQLException logOrIgnore) {}
    }
%>
    <p><a href="index.jsp">Return to Home</a></p>
</body>
</html>

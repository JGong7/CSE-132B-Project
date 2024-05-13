<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Process Class Results</title>
</head>
<body>
    <h1>Class Results</h1>
<%
    String courseId = request.getParameter("id");
    String title = request.getParameter("title");
    String year = request.getParameter("year");
    String quarter = request.getParameter("quarter");
    String action = request.getParameter("action");

    String classId = request.getParameter("classid");

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
        
        if (action.equals("add")){
            // SQL to insert into Enrollment table
            String sql = "INSERT INTO Class (course_id, year, quarter, title) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(courseId));
            pstmt.setInt(2, Integer.parseInt(year));
            pstmt.setString(3, quarter);
            pstmt.setString(4, title);

            updates = pstmt.executeUpdate();
        }else if (action.equals("delete")){
            String sql = "DELETE FROM Class WHERE class_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(classId));
            updates = pstmt.executeUpdate();
        }else if (action.equals("update")){
            String sql = "UPDATE Class SET title = ?, course_id = ?, year = ?, quarter = ? WHERE class_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(2, Integer.parseInt(courseId));
            pstmt.setInt(3, Integer.parseInt(year));
            pstmt.setString(4, quarter);
            pstmt.setString(1, title);
            pstmt.setInt(5, Integer.parseInt(classId));

            updates = pstmt.executeUpdate();
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

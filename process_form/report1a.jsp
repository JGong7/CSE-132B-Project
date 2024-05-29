<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <title>Process SSN input</title>
</head>
<body>
<%
    String ssn = request.getParameter("ssn");

    // Optional: Connect to your database and insert the data
    String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
    String user = "postgres";
    String password = "James2085";

    try {
        // Load the database driver
        Class.forName("org.postgresql.Driver");

        // Establish connection
        Connection conn = DriverManager.getConnection(url, user, password);

        String sql = "SELECT * FROM Student WHERE ssn = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, ssn);
        ResultSet rs = pstmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>SSN</th><th>First Name</th><th>Middle Name</th><th>Last Name</th></tr>");
        String student_id = "";
        while (rs.next()) {
            student_id = rs.getString("student_id");
            out.println("<tr>");
            out.println("<td>" + rs.getString("ssn") + "</td>"); 
            out.println("<td>" + rs.getString("first_name") + "</td>");
            out.println("<td>" + rs.getString("middle_name") + "</td>");
            out.println("<td>" + rs.getString("last_name") + "</td>");
            out.println("</tr>");
        }
        sql =  "SELECT c.*, stc.* " +
                "FROM student_take_class stc " +
                "JOIN class c ON stc.class_id = c.class_id " +
                "WHERE stc.student_id = ? AND c.quarter = 'Spring' AND c.year = 2018";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, student_id);
        rs = pstmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>class_id</th><th>course_id</th><th>year</th><th>quarter</th><th>title</th><th>section</th><th>units</th></tr>");
        while (rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getString("class_id") + "</td>"); 
            out.println("<td>" + rs.getString("course_id") + "</td>");
            out.println("<td>" + rs.getString("year") + "</td>");
            out.println("<td>" + rs.getString("quarter") + "</td>");
            out.println("<td>" + rs.getString("title") + "</td>");
            out.println("<td>" + rs.getString("section_id") + "</td>");
            out.println("<td>" + rs.getString("units") + "</td>");
            out.println("</tr>");
        }

        
            



    } catch (ClassNotFoundException e) {
        out.println("<p>Error loading driver: " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p>Error in SQL: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>

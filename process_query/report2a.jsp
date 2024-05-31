<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.math.BigDecimal, java.util.ArrayList, java.util.HashSet, java.util.Set" %>
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
        sql =  "SELECT m.*, stc.*, c.* " +
                "FROM student_take_class stc " +
                "JOIN meeting m ON stc.class_id = m.class_id AND stc.section_id = m.section_id " +
                "JOIN class c ON stc.class_id = c.class_id " +
                "WHERE stc.student_id = ? AND c.quarter = 'Spring' AND c.year = 2018";
        // First find all the meetings of the classes the student is taking
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, student_id);
        rs = pstmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>class_id</th><th>course_id</th><th>year</th><th>quarter</th><th>title</th><th>section</th><th>units</th><th>meeting type</th><th>days_of_week</th><th>start time</th><th>end time</th></tr>");
        ArrayList<ArrayList<String>> classesTaking = new ArrayList<ArrayList<String>>();
        while (rs.next()) {
            ArrayList<String> classInfo = new ArrayList<String>();
            classInfo.add(rs.getString("class_id"));
            classInfo.add(rs.getString("title"));
            classInfo.add(rs.getString("section_id"));
            classInfo.add(rs.getString("days_of_week"));
            classInfo.add(rs.getString("time_start"));
            classInfo.add(rs.getString("time_end"));
            out.println("<tr>");
            out.println("<td>" + rs.getString("class_id") + "</td>"); 
            out.println("<td>" + rs.getString("course_id") + "</td>");
            out.println("<td>" + rs.getString("year") + "</td>");
            out.println("<td>" + rs.getString("quarter") + "</td>");
            out.println("<td>" + rs.getString("title") + "</td>");
            out.println("<td>" + rs.getString("section_id") + "</td>");
            out.println("<td>" + rs.getString("units") + "</td>");
            out.println("<td>" + rs.getString("type") + "</td>");
            out.println("<td>" + rs.getString("days_of_week") + "</td>");
            out.println("<td>" + rs.getString("time_start") + "</td>");
            out.println("<td>" + rs.getString("time_end") + "</td>");
            out.println("</tr>");
            classesTaking.add(classInfo);
        }

        // Then find all the classes currently offered in the Spring 2018 quarter
        sql =  "SELECT c.*, m.* " +
                "FROM class c " +
                "JOIN meeting m ON c.class_id = m.class_id " +
                "WHERE c.quarter = 'Spring' AND c.year = 2018";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>class_id</th><th>course_id</th><th>year</th><th>quarter</th><th>title</th><th>section</th><th>meeting type</th><th>days_of_week</th><th>start time</th><th>end time</th></tr>");
        ArrayList<ArrayList<String>> classesOffered = new ArrayList<ArrayList<String>>();
        while (rs.next()) {
            ArrayList<String> classInfo = new ArrayList<String>();
            classInfo.add(rs.getString("class_id"));
            classInfo.add(rs.getString("title"));
            classInfo.add(rs.getString("section_id"));
            classInfo.add(rs.getString("days_of_week"));
            classInfo.add(rs.getString("time_start"));
            classInfo.add(rs.getString("time_end"));
            out.println("<tr>");
            out.println("<td>" + rs.getString("class_id") + "</td>"); 
            out.println("<td>" + rs.getString("course_id") + "</td>");
            out.println("<td>" + rs.getString("year") + "</td>");
            out.println("<td>" + rs.getString("quarter") + "</td>");
            out.println("<td>" + rs.getString("title") + "</td>");
            out.println("<td>" + rs.getString("section_id") + "</td>");
            //out.println("<td>" + rs.getString("units") + "</td>");
            out.println("<td>" + rs.getString("type") + "</td>");
            out.println("<td>" + rs.getString("days_of_week") + "</td>");
            out.println("<td>" + rs.getString("time_start") + "</td>");
            out.println("<td>" + rs.getString("time_end") + "</td>");
            out.println("</tr>");
            classesOffered.add(classInfo);
        }
        out.println(classesOffered.size() + " classes are offered in Spring 2018.");
        out.println(classesTaking.size() + " classes are taken by the student in Spring 2018.");

       sql = "SELECT o.class_id AS o_class_id, o.title AS o_title, t.class_id AS t_class_id, t.title AS t_title " +
            "FROM " +
            "(SELECT c.class_id, c.title, m.days_of_week, m.time_start, m.time_end " +
            "FROM class c " +
            "JOIN meeting m ON c.class_id = m.class_id " +
            "WHERE c.quarter = 'Spring' AND c.year = 2018) o " + // classes offered
            "JOIN " +
            "(SELECT c.class_id, c.title, m.days_of_week, m.time_start, m.time_end " +
            "FROM student_take_class stc " +
            "JOIN meeting m ON stc.class_id = m.class_id AND stc.section_id = m.section_id " +
            "JOIN class c ON stc.class_id = c.class_id " +
            "WHERE stc.student_id = ? AND c.quarter = 'Spring' AND c.year = 2018) t " + // classes taking
            "ON " +
            "(o.days_of_week LIKE '%' || t.days_of_week || '%' OR t.days_of_week LIKE '%' || o.days_of_week || '%') AND " + // days of the week overlap
            "o.time_start < t.time_end AND o.time_end > t.time_start AND " +
            "o.class_id != t.class_id"; // times overlap
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, student_id);
        rs = pstmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>ClassCannotTake: class_id</th><th>ClassCannotTake: title</th><th>ClassOverlapped: class_id</th><th>ClassOverlapped: title</th></tr>");
        
        while (rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getString("o_class_id") + "</td>"); 
            out.println("<td>" + rs.getString("o_title") + "</td>");
            out.println("<td>" + rs.getString("t_class_id") + "</td>");
            out.println("<td>" + rs.getString("t_title") + "</td>");
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

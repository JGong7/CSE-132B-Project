<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Class Roster</title>
    <style>
        table, th, td {
            border: 1px solid black;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
        }
    </style>
</head>
<body>
    <h2>Class Roster</h2>
<%
    String classId = request.getParameter("classId");
    String title = request.getParameter("title");
    String quarter = request.getParameter("quarter");
    String year = request.getParameter("year");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, user, password);

        String query = "";
        if (classId != null && !classId.isEmpty()) {
            query = "SELECT s.student_id, s.first_name, s.last_name, e.units, e.grading_option " +
                    "FROM Enrollment e JOIN Student s ON e.student_id = s.student_id " +
                    "WHERE e.class_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(classId));
        } else {
            query = "SELECT s.student_id, s.first_name, s.last_name, e.units, e.grading_option " +
                    "FROM Class c JOIN Enrollment e ON c.class_id = e.class_id " +
                    "JOIN Student s ON e.student_id = s.student_id " +
                    "WHERE c.title = ? AND c.quarter = ? AND c.year = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, title);
            pstmt.setString(2, quarter);
            pstmt.setInt(3, Integer.parseInt(year));
        }

        rs = pstmt.executeQuery();

        if (!rs.next()) {
            out.println("<p>No students found for the given class.</p>");
        } else {
            out.println("<table>");
            out.println("<tr><th>Student ID</th><th>First Name</th><th>Last Name</th><th>Units</d><th>Grade Option</th></tr>");
            do {
                out.println("<tr>");
                out.println("<td>" + rs.getString("student_id") + "</td>");
                out.println("<td>" + rs.getString("first_name") + "</td>");
                out.println("<td>" + rs.getString("last_name") + "</td>");
                out.println("<td>" + rs.getInt("units") + "</td>");
                out.println("<td>" + rs.getString("grading_option") + "</td>");
                out.println("</tr>");
            } while (rs.next());
            out.println("</table>");
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
        if (conn != null) try { conn.close(); } catch (SQLException e) { }
    }
%>
</body>
</html>

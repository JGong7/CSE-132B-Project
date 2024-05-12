<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Course Submission</title>
</head>
<body>
<%
    String courseNumber = request.getParameter("courseNumber");
    String department = request.getParameter("department");
    boolean labRequired = Boolean.parseBoolean(request.getParameter("labRequired"));
    String[] gradeOptions = request.getParameterValues("gradeOptions[]");
    String[] availableUnits = request.getParameterValues("availableUnits[]");
    String[] prerequisites = request.getParameterValues("prerequisites[]");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";

        Class.forName("org.postgresql.Driver");

        // Establish the connection
        conn = DriverManager.getConnection(url, user, password);
        if (conn != null) {
            out.println("Connected to the database!");
        } else {
            out.println("Failed to make connection!");
        }

        // Insert into Course table
        String sql = "INSERT INTO Course (course_number, department, require_lab_work) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, courseNumber);
        pstmt.setString(2, department);
        pstmt.setBoolean(3, labRequired);
        pstmt.executeUpdate();

        // Insert into Units table
        if (availableUnits != null) {
            sql = "INSERT INTO Units (course_number, unit) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            for (String unit : availableUnits) {
                pstmt.setString(1, courseNumber);
                pstmt.setInt(2, Integer.parseInt(unit));
                pstmt.executeUpdate();
            }
        }

        // Insert into Grade_option table
        if (gradeOptions != null) {
            sql = "INSERT INTO Grade_option (course_number, option) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            for (String option : gradeOptions) {
                pstmt.setString(1, courseNumber);
                pstmt.setString(2, option);
                pstmt.executeUpdate();
            }
        }

        // Insert into Prerequisite table
        if (prerequisites != null) {
            sql = "INSERT INTO Prerequisite (course_number, required_course_number) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            for (String prerequisite : prerequisites) {
                pstmt.setString(1, courseNumber);
                pstmt.setString(2, prerequisite);
                pstmt.executeUpdate();
            }
        }

        out.println("<p>Course data successfully saved!</p>");
    } catch (Exception e) {
        out.println("<p>got an error in try/catch</p>");
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
</body>
</html>

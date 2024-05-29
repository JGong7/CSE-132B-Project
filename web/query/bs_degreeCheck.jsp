<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Undergraduate Degree Requirement Check</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
        select {
            min-width: 200px;
        }
    </style>
</head>
<body>
    <h2>Undergraduate Degree Requirement Check</h2>
    <form action="../../process_query/display_bs_degreeCheck.jsp" method="GET">
        <div class="input-group">
            <label for="studentId">Select an Undergraduate Student:</label>
            <select id="studentId" name="studentId">
                <option value="">Select an Undergraduate student</option>
                <% 
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
                        String user = "postgres";
                        String password = "James2085";
                        Class.forName("org.postgresql.Driver");
                        conn = DriverManager.getConnection(url, user, password);

                        String query = "SELECT s.student_id, s.ssn, s.first_name, s.middle_name, s.last_name " +
                                        "FROM Student s " +
                                        "LEFT JOIN Undergraduate_student u ON s.student_id = u.student_id " +
                                        "LEFT JOIN Bsms_student b ON s.student_id = b.student_id " +
                                        "WHERE u.student_id IS NOT NULL OR b.student_id IS NOT NULL";
                        pstmt = conn.prepareStatement(query);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            out.println("<option value=\"" + rs.getString("student_id") + "\">" + rs.getString("ssn") + " " + rs.getString("first_name") + " " + (rs.getString("middle_name") != null ? rs.getString("middle_name") + " " : "") + rs.getString("last_name") + "</option>");
                        }
                    } catch (Exception e) {
                        out.println("<p>Error connecting to database: " + e.getMessage() + "</p>");
                    }
                %>
            </select>
        </div>
        <div class="input-group">
            <label for="degreeId">Select a Degree:</label>
            <select id="degreeId" name="degreeId">
                <option value="">Select a degree</option>
                <% 
                    try {
                        String degreeQuery = "SELECT degree_id, degree_name, type FROM Degree WHERE type = 'B.S.'";
                        pstmt = conn.prepareStatement(degreeQuery);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            out.println("<option value=\"" + rs.getString("degree_id") + "\">" + rs.getString("degree_id") + " " + rs.getString("degree_name") + " (" + rs.getString("type") + ")</option>");
                        }
                    } catch (Exception e) {
                        out.println("<p>Error retrieving degrees: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { }
                    }
                %>
            </select>
        </div>
        <input type="submit" value="Check Requirements">
    </form>
</body>
</html>

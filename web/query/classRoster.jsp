<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Search Class Roster</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <h2>Enter Class Details to Search Roster</h2>
    <form action="../../process_query/display_classRoster.jsp" method="GET">
        <div class="input-group">
            <label for="classId">Select a Class:</label>
            <select id="classId" name="classId" onchange="if(this.value) this.form.submit();">
                <option value="">Select a class</option>
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

                        String query = "SELECT class_id, course_id, title, year, quarter FROM class";
                        pstmt = conn.prepareStatement(query);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            String displayText = rs.getInt("course_id") + "-" + rs.getString("quarter") + " " + rs.getInt("year") + " - " + rs.getString("title");
                            out.println("<option value=\"" + rs.getInt("class_id") + "\">" + displayText + "</a>");
                        }
                    } catch (Exception e) {
                        out.println("<p>Error connecting to database: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { }
                    }
                %>
            </select>
        </div>

        <p>OR</p>

        <p>Enter the information of class:</p>
        <div class="input-group">
            <label for="title">Title:</label>
            <input type="text" id="title" name="title">
        </div>
        <div class="input-group">
            <label for="quarter">Quarter:</label>
            <input type="text" id="quarter" name="quarter">
        </div>
        <div class="input-group">
            <label for="year">Year:</label>
            <input type="text" id="year" name="year">
        </div>
        <input type="submit" value="Search Roster">
    </form>
</body>
</html>
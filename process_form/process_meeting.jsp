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

    String section_id = request.getParameter("section_id");


    String[] types = request.getParameterValues("type[]");
    String[] rooms = request.getParameterValues("room[]");
    String[] buildings = request.getParameterValues("building[]");
    String[] timeStarts = request.getParameterValues("timeStart[]");
    String[] timeEnds = request.getParameterValues("timeEnd[]");
    String[] dateStarts = request.getParameterValues("dateStart[]");
    String[] dateEnds = request.getParameterValues("dateEnd[]");
    String[] mandatories = request.getParameterValues("mandatory[]");
    String[] days = request.getParameterValues("days[]");

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

        sql = "INSERT INTO Meeting (class_id, section_id, type, room, building, mandatory, time_start, time_end, date_start, date_end, days_of_week) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, class_id);
        pstmt.setString(2, section_id);
        for (int i = 0; i < rooms.length; i++){
            pstmt.setString(3, types[i]);
            pstmt.setString(4, rooms[i]);
            pstmt.setString(5, buildings[i]);
            if (mandatories[i] == "true"){
                pstmt.setBoolean(6, true);
            }else{
                pstmt.setBoolean(6, false);
            }
            String timeStartsSecond = timeStarts[i].replace("T", " ") + ":00";
            String timeEndsSecond = timeEnds[i].replace("T", " ") + ":00";
            pstmt.setTime(7, Time.valueOf(timeStartsSecond));
            pstmt.setTime(8, Time.valueOf(timeEndsSecond));
            pstmt.setDate(9, Date.valueOf(dateStarts[i]));
            pstmt.setDate(10, Date.valueOf(dateEnds[i]));
            pstmt.setString(11, days[i]);
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

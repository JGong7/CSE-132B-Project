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
    String action = request.getParameter("action");
    String[] meeting_ids = request.getParameterValues("meetingid[]");

    int class_id = Integer.parseInt(request.getParameter("classid"));

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

        String sql;

        if (action.equals("add")){
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
        }else if (action.equals("delete")){
            sql = "DELETE FROM Meeting WHERE class_id = ? AND section_id = ? AND meeting_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, class_id);
            pstmt.setString(2, section_id);
            for (int i = 0; i < meeting_ids.length; i++){
                pstmt.setInt(3, Integer.parseInt(meeting_ids[i]));
                updates += pstmt.executeUpdate();
            }
        }else if (action.equals("update")){
            sql = "UPDATE Meeting SET type = ?, room = ?, building = ?, mandatory = ?, time_start = ?, time_end = ?, date_start = ?, date_end = ?, days_of_week = ? WHERE class_id = ? AND section_id = ? AND meeting_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(10, class_id);
            pstmt.setString(11, section_id);
            for (int i = 0; i < meeting_ids.length; i++){
                pstmt.setInt(12, Integer.parseInt(meeting_ids[i]));
                pstmt.setString(1, types[i]);
                pstmt.setString(2, rooms[i]);
                pstmt.setString(3, buildings[i]);
                if (mandatories[i] == "true"){
                    pstmt.setBoolean(4, true);
                }else{
                    pstmt.setBoolean(4, false);
                }
                String timeStartsSecond = timeStarts[i].replace("T", " ") + ":00";
                String timeEndsSecond = timeEnds[i].replace("T", " ") + ":00";
                pstmt.setTime(5, Time.valueOf(timeStartsSecond));
                pstmt.setTime(6, Time.valueOf(timeEndsSecond));
                pstmt.setDate(7, Date.valueOf(dateStarts[i]));
                pstmt.setDate(8, Date.valueOf(dateEnds[i]));
                pstmt.setString(9, days[i]);
                updates += pstmt.executeUpdate();
            }
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

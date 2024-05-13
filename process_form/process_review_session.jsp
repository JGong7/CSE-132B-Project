<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Review Session Submission</title>
</head>
<body>
<%
    String action = request.getParameter("action");
    int classId = Integer.parseInt(request.getParameter("classid"));
    String sectionId = request.getParameter("section_id");
    String[] reviewSessionIds = request.getParameterValues("review_session_id[]");
    String[] rooms = request.getParameterValues("room[]");
    String[] buildings = request.getParameterValues("building[]");
    String[] timeStarts = request.getParameterValues("timeStart[]");
    String[] timeEnds = request.getParameterValues("timeEnd[]");
    String[] dates = request.getParameterValues("date[]");
    String[] mandatorys = request.getParameterValues("mandatory[]");

    java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HH:mm");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";

        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, user, password);
        conn.setAutoCommit(false); // Start transaction block

        int result = 0;
        if ("add".equals(action)) {
            String sql = "INSERT INTO Review_Session (class_id, section_id, room, building, mandatory, time_start, time_end, date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < rooms.length; i++) {
                pstmt.setInt(1, classId);
                pstmt.setString(2, sectionId);
                pstmt.setString(3, rooms[i]);
                pstmt.setString(4, buildings[i]);
                pstmt.setBoolean(5, Boolean.parseBoolean(mandatorys[i]));
                java.sql.Time startTime = new java.sql.Time(timeFormat.parse(timeStarts[i]).getTime());
                java.sql.Time endTime = new java.sql.Time(timeFormat.parse(timeEnds[i]).getTime());
                pstmt.setTime(6, startTime);
                pstmt.setTime(7, endTime);
                pstmt.setDate(8, Date.valueOf(dates[i]));
                result = pstmt.executeUpdate();
            }
        } else if ("update".equals(action) && reviewSessionIds != null) {
            String sql = "UPDATE Review_Session SET room = ?, building = ?, mandatory = ?, time_start = ?, time_end = ?, date = ? WHERE class_id = ? AND section_id = ? AND review_session_id = ?";
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < reviewSessionIds.length; i++) {
                pstmt.setString(1, rooms[i]);
                pstmt.setString(2, buildings[i]);
                pstmt.setBoolean(3, Boolean.parseBoolean(mandatorys[i]));
                java.sql.Time startTime = new java.sql.Time(timeFormat.parse(timeStarts[i]).getTime());
                java.sql.Time endTime = new java.sql.Time(timeFormat.parse(timeEnds[i]).getTime());
                pstmt.setTime(4, startTime);
                pstmt.setTime(5, endTime);
                pstmt.setDate(6, Date.valueOf(dates[i]));
                pstmt.setInt(7, classId);
                pstmt.setString(8, sectionId);
                pstmt.setInt(9, Integer.parseInt(reviewSessionIds[i]));
                result = pstmt.executeUpdate();
            }
        } else if ("delete".equals(action) && reviewSessionIds != null) {
            String sql = "DELETE FROM Review_Session WHERE class_id = ? AND section_id = ? AND review_session_id = ?";
            pstmt = conn.prepareStatement(sql);
            for (String reviewSessionId : reviewSessionIds) {
                pstmt.setInt(1, classId);
                pstmt.setString(2, sectionId);
                pstmt.setInt(3, Integer.parseInt(reviewSessionId));
                result = pstmt.executeUpdate();
            }
        }

        if (result > 0) {
            conn.commit(); // Commit transaction
            out.println("<p>Review session data processed successfully.</p>");
        } else {
            out.println("<p>No review session data processed.</p>");
        }

    }
     catch (Exception e) {
        out.println("<p>Error processing review session data: " + e.getMessage() + "</p>");
        try {
            if (conn != null) conn.rollback(); // Rollback transaction on error
        } catch (SQLException ex) {
            out.println("<p>Error during transaction rollback: " + ex.getMessage() + "</p>");
        }
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignored */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignored */ }
    }
%>
</body>
</html>

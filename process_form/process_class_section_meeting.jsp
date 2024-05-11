<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Class Submission</title>
</head>
<body>
<%
    String courseNumber = request.getParameter("courseNumber");
    String title = request.getParameter("title");
    int year = Integer.parseInt(request.getParameter("year"));
    String quarter = request.getParameter("quarter");
    String[] sectionIds = request.getParameterValues("section_id[]");
    String[] professors = request.getParameterValues("professor[]");
    String[] enrollmentLimits = request.getParameterValues("enrollmentLimit[]");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    //try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";

        Class.forName("org.postgresql.Driver");

        // Establish the connection
        conn = DriverManager.getConnection(url, user, password);
        conn.setAutoCommit(false); // Start transaction

        // Insert into Class table
        String sql = "INSERT INTO Class (course_number, year, quarter, title) VALUES (?, ?, ?, ?) RETURNING class_id";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, courseNumber);
        pstmt.setInt(2, year);
        pstmt.setString(3, quarter);
        pstmt.setString(4, title);
        rs = pstmt.executeQuery();
        int classId = -1;
        if (rs.next()) {
            classId = rs.getInt("class_id");
        }

        // Process each section and its meetings
        for (int i = 0; i < sectionIds.length; i++) {
            String sectionId = sectionIds[i];

            // Insert into Section table
            sql = "INSERT INTO Section (section_id, class_id, professor, enrollment_limit) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sectionId);
            pstmt.setInt(2, classId);
            pstmt.setString(3, professors[i]);
            pstmt.setInt(4, Integer.parseInt(enrollmentLimits[i]));
            pstmt.executeUpdate();

            // Process meetings for each section
            String[] types = request.getParameterValues("type" + sectionId + "[]");
            out.println("<p>types: " + types + "</p>");
            if (types != null) {
                String[] rooms = request.getParameterValues("room" + sectionId + "[]");
                String[] buildings = request.getParameterValues("building" + sectionId + "[]");
                String[] timeStarts = request.getParameterValues("timeStart" + sectionId + "[]");
                String[] timeEnds = request.getParameterValues("timeEnd" + sectionId + "[]");
                String[] dateStarts = request.getParameterValues("dateStart" + sectionId + "[]");
                String[] dateEnds = request.getParameterValues("dateEnd" + sectionId + "[]");
                String[] mandatories = request.getParameterValues("mandatory" + sectionId + "[]");

                for (int j = 0; j < types.length; j++) {
                    out.println("adding meeting " + j + " for section " + sectionId + " with type " + types[j] + " and room " + rooms[j] + " and building " + buildings[j] + " and time start " + timeStarts[j] + " and time end " + timeEnds[j] + " and date start " + dateStarts[j] + " and date end " + dateEnds[j] + " and mandatory " + mandatories[j] + "<br>");
                    sql = "INSERT INTO Meeting (class_id, section_id, type, room, building, time_start, time_end, date_start, date_end, mandatory) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, classId);
                    pstmt.setString(2, sectionId);
                    pstmt.setString(3, types[j]);
                    pstmt.setString(4, rooms[j]);
                    pstmt.setString(5, buildings[j]);
                    pstmt.setTime(6, Time.valueOf(timeStarts[j]));
                    pstmt.setTime(7, Time.valueOf(timeEnds[j]));
                    pstmt.setDate(8, Date.valueOf(dateStarts[j]));
                    pstmt.setDate(9, Date.valueOf(dateEnds[j]));
                    pstmt.setBoolean(10, Boolean.parseBoolean(mandatories[j]));
                    pstmt.executeUpdate();
                }
            }
        }

        conn.commit(); // Commit transaction
        out.println("<p>Class data successfully saved!</p>");
    // } catch (Exception e) {
    //     out.println("<p>Error processing class data: " + e.getMessage() + "</p>");
    //     e.printStackTrace();
    //     if (conn != null) try { conn.rollback(); } catch (SQLException ex) { out.println("<p>Error rolling back: " + ex.getMessage() + "</p>"); }
    // } finally {
    //     if (rs != null) try { rs.close(); } catch (SQLException ex) { /* ignored */ }
    //     if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) { /* ignored */ }
    //     if (conn != null) try { conn.close(); } catch (SQLException ex) { /* ignored */ }
    // }
%>
</body>
</html>

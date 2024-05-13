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

    String action = request.getParameter("action");

    int class_id = Integer.parseInt(request.getParameter("classId"));
    String[] section_ids = request.getParameterValues("section_id[]");
    String[] professors = request.getParameterValues("professor[]");
    String[] enrollmentLimit = request.getParameterValues("enrollmentLimit[]");
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
            sql = "INSERT INTO Section (section_id, class_id, professor, enrollment_limit) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(2, class_id);
            for (int i = 0; i < section_ids.length; i++){
                pstmt.setString(1, section_ids[i]);
                pstmt.setString(3, professors[i]);
                pstmt.setInt(4, Integer.parseInt(enrollmentLimit[i]));
                updates += pstmt.executeUpdate();
            }
            out.println(updates + " rows affected!");
        }else if (action.equals("delete")){
            sql = "DELETE FROM Section WHERE section_id = ? AND class_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(2, class_id);
            for (int i = 0; i < section_ids.length; i++){
                pstmt.setString(1, section_ids[i]);
                updates += pstmt.executeUpdate();
            }
            out.println(updates + " rows affected!");
        }else if (action.equals("update")){
            sql = "UPDATE Section SET professor = ?, enrollment_limit = ? WHERE section_id = ? AND class_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(4, class_id);
            for (int i = 0; i < section_ids.length; i++){
                pstmt.setString(3, section_ids[i]);
                pstmt.setInt(2, Integer.parseInt(enrollmentLimit[i]));
                pstmt.setString(1, professors[i]);
                updates += pstmt.executeUpdate();
            }
            out.println(updates + " rows affected!");
        }
        
        
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

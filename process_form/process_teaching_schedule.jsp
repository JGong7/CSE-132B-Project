<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Teaching Schedule Submission Results</title>
</head>
<body>
    <h1>Teaching Schedule Submission Results</h1>
<% 
    String action = request.getParameter("action");
    String facultyName = request.getParameter("name");
    // String[] years = request.getParameterValues("year[]");
    // String[] quarters = request.getParameterValues("quarter[]");
    // String[] titles = request.getParameterValues("title[]");
    // String[] courseNumbers = request.getParameterValues("course_number[]");
    String[] classIds = request.getParameterValues("id[]");

    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement selectStmt = null;
    int updates = 0;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";
        // Load the database driver
        Class.forName("org.postgresql.Driver");

        // Establish connection
        conn = DriverManager.getConnection(url, user, password);

        // SQL to fetch class_id
        String selectSql = "SELECT class_id FROM Class WHERE year = ? AND quarter = ? AND title = ? AND course_number = ?";
        selectStmt = conn.prepareStatement(selectSql);

        if (action.equals("add")){
            // SQL to insert into Teaching_Schedule
            String insertSql = "INSERT INTO Teaching_Schedule (name, class_id) VALUES (?, ?)";
            pstmt = conn.prepareStatement(insertSql);

            // Loop over each class entry
            for (int i = 0; i < classIds.length; i++) {
                pstmt.setString(1, facultyName);
                pstmt.setInt(2, Integer.parseInt(classIds[i]));
                updates += pstmt.executeUpdate();
                // Set parameters to fetch class_id
                // selectStmt.setInt(1, Integer.parseInt(years[i]));
                // selectStmt.setString(2, quarters[i]);
                // selectStmt.setString(3, titles[i]);
                // selectStmt.setString(4, courseNumbers[i]);
                // ResultSet rs = selectStmt.executeQuery();

                // // Check if the class_id was found
                // if (rs.next()) {
                //     int classId = rs.getInt("class_id");
                    
                //     // Insert into Teaching_Schedule using the retrieved class_id
                //     pstmt.setString(1, facultyName);
                //     pstmt.setInt(2, classId);
                //     updates += pstmt.executeUpdate();
                // }
            }
            // Output success message
            out.println("<p>Data successfully inserted for " + updates + " classes.</p>");
        }else if (action.equals("delete")){
            String deleteSql = "DELETE FROM Teaching_Schedule WHERE name = ? AND class_id = ?";
            pstmt = conn.prepareStatement(deleteSql);

            for (int i = 0; i < classIds.length; i++) {
                pstmt.setString(1, facultyName);
                pstmt.setInt(2, Integer.parseInt(classIds[i]));
                updates += pstmt.executeUpdate();
                // Set parameters to fetch class_id
                // selectStmt.setInt(1, Integer.parseInt(years[i]));
                // selectStmt.setString(2, quarters[i]);
                // selectStmt.setString(3, titles[i]);
                // selectStmt.setString(4, courseNumbers[i]);
                // ResultSet rs = selectStmt.executeQuery();

                // // Check if the class_id was found
                // if (rs.next()) {
                //     int classId = rs.getInt("class_id");
                    
                //     // Insert into Teaching_Schedule using the retrieved class_id
                //     pstmt.setString(1, facultyName);
                //     pstmt.setInt(2, classId);
                //     updates += pstmt.executeUpdate();
                // }
            }
        }else if (action.equals("update")){
            String updateSql = "UPDATE Teaching_Schedule SET name = ? WHERE class_id = ?";
            pstmt = conn.prepareStatement(updateSql);

            for (int i = 0; i < classIds.length; i++) {
                pstmt.setString(1, facultyName);
                pstmt.setInt(2, Integer.parseInt(classIds[i]));
                updates += pstmt.executeUpdate();
                // // Set parameters to fetch class_id
                // selectStmt.setInt(1, Integer.parseInt(years[i]));
                // selectStmt.setString(2, quarters[i]);
                // selectStmt.setString(3, titles[i]);
                // selectStmt.setString(4, courseNumbers[i]);
                // ResultSet rs = selectStmt.executeQuery();

                // // Check if the class_id was found
                // if (rs.next()) {
                //     int classId = rs.getInt("class_id");
                    
                //     // Insert into Teaching_Schedule using the retrieved class_id
                //     pstmt.setString(1, facultyName);
                //     pstmt.setInt(2, classId);
                //     updates += pstmt.executeUpdate();
                // }
            }
        }
    } catch (Exception e) {
        // Handle potential exceptions
        out.println("<p>Error while inserting data: " + e.getMessage() + "</p>");
    } finally {
        // Close all resources
        if (pstmt != null) try { pstmt.close(); } catch (SQLException logOrIgnore) {}
        if (conn != null) try { conn.close(); } catch (SQLException logOrIgnore) {}
    }
%>
    <p><a href="index.jsp">Return to Home</a></p>
</body>
</html>

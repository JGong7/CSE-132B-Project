<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Degree Requirements</title>
</head>
<body>
<%
    String action = request.getParameter("action");
    String degreeId = request.getParameter("degreeId");
    String degreeName = request.getParameter("degreeName");
    String type = request.getParameter("type");
    String department = request.getParameter("department");
    String[] concentrations = request.getParameterValues("concentration[]");
    String lowerUnits = request.getParameter("lowerUnits");
    String upperUnits = request.getParameter("upperUnits");
    String elecUnits = request.getParameter("elecUnits");

    int lowerUnitsInt = 0, upperUnitsInt = 0, elecUnitsInt = 0;
    try {
        if (lowerUnits != null && !lowerUnits.isEmpty()) lowerUnitsInt = Integer.parseInt(lowerUnits);
        if (upperUnits != null && !upperUnits.isEmpty()) upperUnitsInt = Integer.parseInt(upperUnits);
        if (elecUnits != null && !elecUnits.isEmpty()) elecUnitsInt = Integer.parseInt(elecUnits);
    } catch (NumberFormatException e) {
        out.println("<p>Error: Invalid number format for units.</p>");
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, user, password);
        conn.setAutoCommit(false); // Use transaction

        int result = 0;
        if ("add".equals(action)) {
            // Insert into degree table
            String sqlInsertDegree = "INSERT INTO Degree (degree_id, degree_name, type, department, lower_credits, upper_credits, elective_credits) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsertDegree);
            pstmt.setString(1, degreeId);
            pstmt.setString(2, degreeName);
            pstmt.setString(3, type);
            pstmt.setString(4, department);
            pstmt.setInt(5, lowerUnitsInt);
            pstmt.setInt(6, upperUnitsInt);
            pstmt.setInt(7, elecUnitsInt);
            result = pstmt.executeUpdate();

            // Insert into concentration table
            if (concentrations != null) {
                String sqlInsertConcentration = "INSERT INTO Concentration (degree_id, concentration, course_id) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(sqlInsertConcentration);
                for (int i = 0; i < concentrations.length; i++) {
                    String concentration = concentrations[i];
                    String[] courseIds = request.getParameterValues("courseId" + i + "[]");
                    for (String courseId : courseIds) {
                        pstmt.setString(1, degreeId);
                        pstmt.setString(2, concentration);
                        pstmt.setInt(3, Integer.parseInt(courseId));
                        pstmt.executeUpdate();
                    }
                }
            }
        } else if ("update".equals(action)) {
            // Update degree table
            String sqlUpdateDegree = "UPDATE Degree SET degree_name = ?, type = ?, department = ?, lower_credits = ?, upper_credits = ?, elective_credits = ? WHERE degree_id = ?";
            pstmt = conn.prepareStatement(sqlUpdateDegree);
            pstmt.setString(1, degreeName);
            pstmt.setString(2, type);
            pstmt.setString(3, department);
            pstmt.setInt(4, lowerUnitsInt);
            pstmt.setInt(5, upperUnitsInt);
            pstmt.setInt(6, elecUnitsInt);
            pstmt.setString(7, degreeId);
            result = pstmt.executeUpdate();

            // Update concentration table
            if (concentrations != null) {
                String sqlDeleteConcentration = "DELETE FROM Concentration WHERE degree_id = ?";
                pstmt = conn.prepareStatement(sqlDeleteConcentration);
                pstmt.setString(1, degreeId);
                pstmt.executeUpdate();

                String sqlInsertConcentration = "INSERT INTO Concentration (degree_id, concentration, course_id) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(sqlInsertConcentration);
                for (int i = 0; i < concentrations.length; i++) {
                    String concentration = concentrations[i];
                    String[] courseIds = request.getParameterValues("courseId" + i + "[]");
                    for (String courseId : courseIds) {
                        pstmt.setString(1, degreeId);
                        pstmt.setString(2, concentration);
                        pstmt.setInt(3, Integer.parseInt(courseId));
                        pstmt.executeUpdate();
                    }
                }
            }
        } else if ("delete".equals(action)) {
            // Delete from degree table
            String sqlDeleteDegree = "DELETE FROM Degree WHERE degree_id = ?";
            pstmt = conn.prepareStatement(sqlDeleteDegree);
            pstmt.setString(1, degreeId);
            result = pstmt.executeUpdate();
        }

        if (result > 0) {
            conn.commit(); // Commit transaction
            out.println("<p>Record processed successfully!</p>");
        } else {
            conn.rollback(); // Rollback transaction
            out.println("<p>Failed to process the record.</p>");
        }
    } catch (Exception e) {
        out.println("<p>Error processing degree data: " + e.getMessage() + "</p>");
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) { out.println("<p>Error rolling back: " + ex.getMessage() + "</p>"); }
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) { /* ignored */ }
        if (conn != null) try { conn.close(); } catch (SQLException ex) { /* ignored */ }
    }
%>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
    String concentration = request.getParameter("concentration");
    String upperUnits = request.getParameter("upperUnits");
    String lowerUnits = request.getParameter("lowerUnits");

    // Convert units to integers, handling possible empty or incorrect values gracefully
    int upperUnitsInt = 0, lowerUnitsInt = 0;
    try {
        if (upperUnits != null && !upperUnits.isEmpty()) upperUnitsInt = Integer.parseInt(upperUnits);
        if (lowerUnits != null && !lowerUnits.isEmpty()) lowerUnitsInt = Integer.parseInt(lowerUnits);
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

        // Establish connection
        conn = DriverManager.getConnection(url, user, password);
        conn.setAutoCommit(false); // Use transaction

        int result = 0;
        if ("add".equals(action)) {
            String sql = "INSERT INTO Degree (degree_id, degree_name, type, department, concentration, upper_credits, lower_credits) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, degreeId);
            pstmt.setString(2, degreeName);
            pstmt.setString(3, type);
            pstmt.setString(4, department);
            pstmt.setString(5, concentration);
            pstmt.setInt(6, upperUnitsInt);
            pstmt.setInt(7, lowerUnitsInt);
            result = pstmt.executeUpdate();
        } else if ("update".equals(action)) {
            String sql = "UPDATE Degree SET degree_name = ?, type = ?, department = ?, concentration = ?, upper_credits = ?, lower_credits = ? WHERE degree_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, degreeName);
            pstmt.setString(2, type);
            pstmt.setString(3, department);
            pstmt.setString(4, concentration);
            pstmt.setInt(5, upperUnitsInt);
            pstmt.setInt(6, lowerUnitsInt);
            pstmt.setString(7, degreeId);
            result = pstmt.executeUpdate();
        } else if ("delete".equals(action)) {
            String sql = "DELETE FROM Degree WHERE degree_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, degreeId);
            result = pstmt.executeUpdate();
        } else {
            throw new IllegalArgumentException("Invalid action: " + action);
        }

        if (result > 0) {
            conn.commit(); // Commit transaction only if insert succeeds
            out.println("<p>Record inserted successfully!</p>");
        } else {
            conn.rollback(); // Rollback transaction if insert fails
            out.println("<p>Failed to insert the record.</p>");
        }

    } catch (ClassNotFoundException e) {
        out.println("<p>Error loading driver: " + e.getMessage() + "</p>");
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) { out.println("<p>Error rolling back: " + ex.getMessage() + "</p>"); }
    } catch (SQLException e) {
        out.println("<p>Error in SQL: " + e.getMessage() + "</p>");
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) { out.println("<p>Error rolling back: " + ex.getMessage() + "</p>"); }
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) { /* ignored */ }
        if (conn != null) try { conn.close(); } catch (SQLException ex) { /* ignored */ }
    }
%>
</body>
</html>

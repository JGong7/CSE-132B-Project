<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Process Degree Requirements</title>
</head>
<body>
<%
    // Retrieve form data using request.getParameter
    String degreeName = request.getParameter("degreeName");
    String type = request.getParameter("type");
    String department = request.getParameter("department");
    String concentration = request.getParameter("concentration");
    String upperUnits = request.getParameter("upperUnits");
    String lowerUnits = request.getParameter("lowerUnits");

    // Optional: Connect to your database and insert the data
    String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
    String user = "postgres";
    String password = "James2085";

    try {
        // Load the database driver
        Class.forName("org.postgresql.Driver");

        // Establish connection
        Connection conn = DriverManager.getConnection(url, user, password);

        // Prepare SQL statement
        String sql = "INSERT INTO Degree (degree_name, type, department, concentration, upper_credits, lower_credits) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, degreeName);
        pstmt.setString(2, type);
        pstmt.setString(3, department);
        pstmt.setString(4, concentration);
        int upperUnitsInt = Integer.parseInt(upperUnits);
        int lowerUnitsInt = Integer.parseInt(lowerUnits);
        pstmt.setInt(5, upperUnitsInt);
        pstmt.setInt(6, lowerUnitsInt);

        // Execute update
        int rowsAffected = pstmt.executeUpdate();
        if (rowsAffected > 0) {
            out.println("<p>Record inserted successfully!</p>");
        } else {
            out.println("<p>Failed to insert the record.</p>");
        }
    } catch (ClassNotFoundException e) {
        out.println("<p>Error loading driver: " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p>Error in SQL: " + e.getMessage() + "</p>");
    }

    // Display received form data
    out.println("<h1>Received Degree Requirement Details</h1>");
    out.println("<p>Degree Name: " + degreeName + "</p>");
    out.println("<p>Type: " + type + "</p>");
    out.println("<p>Department: " + department + "</p>");
    out.println("<p>Concentration: " + concentration + "</p>");
    out.println("<p>Required Number of Upper Units: " + upperUnits + "</p>");
    out.println("<p>Required Number of Lower Units: " + lowerUnits + "</p>");
%>
</body>
</html>

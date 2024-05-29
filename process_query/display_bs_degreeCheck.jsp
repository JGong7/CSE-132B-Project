<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Degree Completion Status</title>
</head>
<body>
<%
    String studentId = request.getParameter("studentId");
    out.println("<p>Student ID: " + studentId + "</p>");
    String degreeId = request.getParameter("degreeId");
    out.println("<p>Degree ID: " + degreeId + "</p>");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, user, password);

        // Check if the student is pursuing the selected degree
        String sqlCheckPursuing = "SELECT * FROM Pursuing WHERE student_id = ? AND degree_id = ?";
        pstmt = conn.prepareStatement(sqlCheckPursuing);
        pstmt.setString(1, studentId);
        pstmt.setString(2, degreeId);
        rs = pstmt.executeQuery();
        if (!rs.next()) {
            out.println("<p>The selected student is not pursuing the selected degree.</p>");
        } else {
            // Display the remaining degree requirements
            String sql = "SELECT " +
                        "SUM(CASE WHEN cd.lower = TRUE THEN stc.units ELSE 0 END) AS lower_units, " +
                        "SUM(CASE WHEN cd.upper = TRUE THEN stc.units ELSE 0 END) AS upper_units, " +
                        "SUM(CASE WHEN cd.elective = TRUE THEN stc.units ELSE 0 END) AS elective_units " +
                        "FROM Student_take_class stc " +
                        "JOIN Class c ON stc.class_id = c.class_id " +
                        "JOIN Course_degree cd ON c.course_id = cd.course_id " +
                        "WHERE stc.student_id = ? AND cd.degree_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            pstmt.setString(2, degreeId);
            rs = pstmt.executeQuery();

            int totalLowerUnits = 0;
            int totalUpperUnits = 0;
            int totalElectiveUnits = 0;

            if (rs.next()) {
                totalLowerUnits = rs.getInt("lower_units");
                totalUpperUnits = rs.getInt("upper_units");
                totalElectiveUnits = rs.getInt("elective_units");
            } else {
                out.println("<p>No data found for this student and degree.</p>");
            }

            // Get degree requirements
            String sqlRequirements = "SELECT upper_credits, lower_credits, elective_credits FROM Degree WHERE degree_id = ?";
            pstmt = conn.prepareStatement(sqlRequirements);
            pstmt.setString(1, degreeId);
            ResultSet rsReq = pstmt.executeQuery();
            if (rsReq.next()) {
                int requiredLower = rsReq.getInt("lower_credits") - totalLowerUnits;
                int requiredUpper = rsReq.getInt("upper_credits") - totalUpperUnits;
                int requiredElective = rsReq.getInt("elective_credits") - totalElectiveUnits;

                out.println("<p>Remaining Lower Division Units: " + Math.max(0, requiredLower) + "</p>");
                out.println("<p>Remaining Upper Division Units: " + Math.max(0, requiredUpper) + "</p>");
                out.println("<p>Remaining Elective Units: " + Math.max(0, requiredElective) + "</p>");
            }
        }
    } catch (Exception e) {
        out.println("<p>Error processing data: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
        if (conn != null) try { conn.close(); } catch (SQLException e) { }
    }
%>
</body>
</html>

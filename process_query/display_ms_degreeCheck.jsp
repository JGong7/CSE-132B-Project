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
            // The student is pursuing the selected degree
            String sqlConcentrations = "SELECT DISTINCT concentration FROM Concentration WHERE degree_id = ?";
            pstmt = conn.prepareStatement(sqlConcentrations);
            pstmt.setString(1, degreeId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                String concentration = rs.getString("concentration");
                out.println("<h3>Concentration: " + concentration + "</h3>");

                // calculate the total units for this concentration
                String sqlConcentrationUnits = "SELECT COUNT(*) * 4 AS total_units FROM Concentration WHERE degree_id = ? AND concentration = ?";
                PreparedStatement pstmt2 = conn.prepareStatement(sqlConcentrationUnits);
                pstmt2.setString(1, degreeId);
                pstmt2.setString(2, concentration);
                ResultSet rs2 = pstmt2.executeQuery();
                rs2.next();
                int concentrationUnits = rs2.getInt("total_units");
                out.println("<p>Total units for " + concentration + ": " + concentrationUnits + "</p>");
                rs2.close();
                pstmt2.close();

                // Calculate the total units taken and GPA of the student for this concentration
                String sqlUnitsAndGpa = "SELECT SUM(Student_take_class.units) AS total_units, SUM(GRADE_CONVERSION.NUMBER_GRADE * Student_take_class.units) / SUM(Student_take_class.units) AS gpa " +
                                        "FROM Student_take_class " +
                                        "JOIN GRADE_CONVERSION ON Student_take_class.grade = GRADE_CONVERSION.LETTER_GRADE " +
                                        "JOIN Class ON Student_take_class.class_id = Class.class_id " +
                                        "JOIN Concentration ON Class.course_id = Concentration.course_id " +
                                        "WHERE student_id = ? AND degree_id = ? AND concentration = ?";
                pstmt2 = conn.prepareStatement(sqlUnitsAndGpa);
                pstmt2.setString(1, studentId);
                pstmt2.setString(2, degreeId);
                pstmt2.setString(3, concentration);
                rs2 = pstmt2.executeQuery();
                if (rs2.next()) {
                    int totalUnits = rs2.getInt("total_units");
                    out.println("<p>Total units taken for " + concentration + ": " + totalUnits + "</p>");
                    double gpa = rs2.getDouble("gpa");
                    out.println("<p>GPA for " + concentration + ": " + gpa + "</p>");

                    // Check if the concentration is completed
                    if (totalUnits >= concentrationUnits && gpa >= 3) {
                        out.println("<p>Concentration completed</p>");
                    }
                }
                rs2.close();
                pstmt2.close();

                // Select the courses that the student has not taken yet
                String sqlNotTaken = "SELECT course_id " +
                                    "FROM Concentration " +
                                    "WHERE degree_id = ? AND concentration = ? AND course_id NOT IN (" +
                                        "SELECT Class.course_id " +
                                        "FROM Class " +
                                        "JOIN Student_take_class ON Class.class_id = Student_take_class.class_id " +
                                        "WHERE student_id = ? AND (grade_option = 'Letter' AND EXISTS (" +
                                            "SELECT * FROM grade_conversion WHERE grade = Student_take_class.grade" +
                                        "))" +
                                    ")";
                PreparedStatement pstmtNotTaken = conn.prepareStatement(sqlNotTaken);
                pstmtNotTaken.setString(1, degreeId);
                pstmtNotTaken.setString(2, concentration);
                pstmtNotTaken.setString(3, studentId);
                ResultSet rsNotTaken = pstmtNotTaken.executeQuery();

                // For each course not taken yet, check if it will be available in the future
                while (rsNotTaken.next()) {
                    int courseId = rsNotTaken.getInt("course_id");

                    String sqlNextAvailable = "SELECT year, quarter " +
                                            "FROM Class " +
                                            "WHERE course_id = ? AND (year > 2018 OR (year = 2018 AND quarter = 'Fall')) " +
                                            "ORDER BY year, CASE quarter WHEN 'Winter' THEN 1 WHEN 'Spring' THEN 2 WHEN 'Fall' THEN 3 END " +
                                            "LIMIT 1";
                    PreparedStatement pstmtNextAvailable = conn.prepareStatement(sqlNextAvailable);
                    pstmtNextAvailable.setInt(1, courseId);
                    ResultSet rsNextAvailable = pstmtNextAvailable.executeQuery();

                    if (rsNextAvailable.next()) {
                        int nextYear = rsNextAvailable.getInt("year");
                        String nextQuarter = rsNextAvailable.getString("quarter");
                        out.println("<p>Course not yet taken: " + courseId + ", next time: " + nextQuarter + " " + nextYear + "</p>");
                    } else {
                        out.println("<p>Course not yet taken: " + courseId + ", not available in the future</p>");
                    }

                    rsNextAvailable.close();
                    pstmtNextAvailable.close();
                }

                rsNotTaken.close();
                pstmtNotTaken.close();
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

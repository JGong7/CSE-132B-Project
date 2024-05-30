<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Grade Distribution Results</title>
    <style>
        table, th, td {
            border: 1px solid black;
            border-collapse: collapse;
            padding: 8px;
            text-align: left;
        }
    </style>
</head>
<body>
<h2>Grade Distribution Results</h2>
<%
    String courseId = request.getParameter("courseId");
    String professor = request.getParameter("professor");
    String quarter = request.getParameter("quarter");
    String year = request.getParameter("year");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    PreparedStatement pstmtAvgGrade = null;
    ResultSet rsAvgGrade = null;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, user, password);

        String sql = "";
        String sqlGrade = "";
        if (!professor.isEmpty() && !quarter.isEmpty() && !year.isEmpty()) {
            // Given course id, professor, quarter, and year
            sql = "SELECT CASE WHEN grade IN ('A+', 'A', 'A-') THEN 'A' " +
                "WHEN grade IN ('B+', 'B', 'B-') THEN 'B' " +
                "WHEN grade IN ('C+', 'C', 'C-') THEN 'C' " +
                "WHEN grade IN ('D+', 'D', 'D-') THEN 'D' " +
                "ELSE 'other' END AS grade_category, COUNT(*) as count " +
                "FROM Student_take_class stc " +
                "JOIN Section s ON stc.section_id = s.section_id AND stc.class_id = s.class_id " +
                "WHERE s.professor = ? AND stc.class_id IN " +
                    "(SELECT class_id FROM Class WHERE course_id = ? AND quarter = ? AND year = ?) " +
                "GROUP BY grade_category";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, professor);
            pstmt.setInt(2, Integer.parseInt(courseId));
            pstmt.setString(3, quarter);
            pstmt.setInt(4, Integer.parseInt(year));
        } else if (!professor.isEmpty()) {
            // Given course id and professor
            sql = "SELECT CASE WHEN grade IN ('A+', 'A', 'A-') THEN 'A' " +
                "WHEN grade IN ('B+', 'B', 'B-') THEN 'B' " +
                "WHEN grade IN ('C+', 'C', 'C-') THEN 'C' " +
                "WHEN grade IN ('D+', 'D', 'D-') THEN 'D' " +
                "ELSE 'other' END AS grade_category, COUNT(*) as count " +
                "FROM Student_take_class stc " +
                "JOIN Section s ON stc.section_id = s.section_id AND stc.class_id = s.class_id " +
                "WHERE s.professor = ? AND stc.class_id IN " +
                    "(SELECT class_id FROM Class WHERE course_id = ?) " +
                "GROUP BY grade_category";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, professor);
            pstmt.setInt(2, Integer.parseInt(courseId));

            // define sqlGrade for calculating average grade later
            sqlGrade = "SELECT grade, COUNT(*) as count " +
                        "FROM Student_take_class stc " +
                        "JOIN Section s ON stc.section_id = s.section_id AND stc.class_id = s.class_id " +
                        "WHERE s.professor = ? AND stc.class_id IN " +
                            "(SELECT class_id FROM Class WHERE course_id = ?) " +
                        "GROUP BY grade";
        } else {
            // Given only course id
            sql = "SELECT CASE WHEN grade IN ('A+', 'A', 'A-') THEN 'A' " +
                "WHEN grade IN ('B+', 'B', 'B-') THEN 'B' " +
                "WHEN grade IN ('C+', 'C', 'C-') THEN 'C' " +
                "WHEN grade IN ('D+', 'D', 'D-') THEN 'D' " +
                "ELSE 'other' END AS grade_category, COUNT(*) as count " + 
                "FROM Student_take_class " + 
                "WHERE class_id IN " +
                    "(SELECT class_id FROM Class WHERE course_id = ?) " +
                "GROUP BY grade_category";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(courseId));
        }

        rs = pstmt.executeQuery();
        out.println("<table><tr><th>Grade</th><th>Count</th></tr>");
        while (rs.next()) {
            out.println("<tr><td>" + rs.getString("grade_category") + "</td><td>" + rs.getInt("count") + "</td></tr>");
        }
        out.println("</table>");

        // Calculate and display average grade
        if (!sqlGrade.equals("")) {
            out.println("<p>Calculating average grade...</p>");
            String sqlAvgGrade = "SELECT SUM(gc.number_grade * count) / SUM(count) as avg_grade " +
                                "FROM (" +
                                sqlGrade +
                                ") t " +
                                "JOIN grade_conversion gc ON t.grade = gc.letter_grade";
            pstmtAvgGrade = conn.prepareStatement(sqlAvgGrade);
            
            if (!professor.isEmpty() && !quarter.isEmpty() && !year.isEmpty()) {
                pstmtAvgGrade.setString(1, professor);
                pstmtAvgGrade.setInt(2, Integer.parseInt(courseId));
                pstmtAvgGrade.setString(3, quarter);
                pstmtAvgGrade.setInt(4, Integer.parseInt(year));
            } else if (!professor.isEmpty()) {
                pstmtAvgGrade.setString(1, professor);
                pstmtAvgGrade.setInt(2, Integer.parseInt(courseId));
            } else {
                pstmtAvgGrade.setInt(1, Integer.parseInt(courseId));
            }
            rsAvgGrade = pstmtAvgGrade.executeQuery();

            if (rsAvgGrade.next()) {
                out.println("<p>Average grade: " + rsAvgGrade.getDouble("avg_grade") + "</p>");
            }
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ex) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) { /* ignore */ }
        if (rsAvgGrade != null) try { rsAvgGrade.close(); } catch (SQLException e) { /* ignored */ }
        if (pstmtAvgGrade != null) try { pstmtAvgGrade.close(); } catch (SQLException e) { /* ignored */ }
        if (conn != null) try { conn.close(); } catch (SQLException ex) { /* ignore */ }
    }
%>
</body>
</html>

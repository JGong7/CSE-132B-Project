<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.math.BigDecimal, java.util.HashMap, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Process SSN input</title>
</head>
<body>
<%
    String ssn = request.getParameter("ssn");

    // Optional: Connect to your database and insert the data
    String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
    String user = "postgres";
    String password = "James2085";

    try {
        // Load the database driver
        Class.forName("org.postgresql.Driver");

        // Establish connection
        Connection conn = DriverManager.getConnection(url, user, password);

        String sql = "SELECT * FROM Student WHERE ssn = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, ssn);
        ResultSet rs = pstmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>SSN</th><th>First Name</th><th>Middle Name</th><th>Last Name</th></tr>");
        String student_id = "";
        while (rs.next()) {
            student_id = rs.getString("student_id");
            out.println("<tr>");
            out.println("<td>" + rs.getString("ssn") + "</td>"); 
            out.println("<td>" + rs.getString("first_name") + "</td>");
            out.println("<td>" + rs.getString("middle_name") + "</td>");
            out.println("<td>" + rs.getString("last_name") + "</td>");
            out.println("</tr>");
        }
        sql =  "SELECT c.year, c.quarter, c.class_id, c.course_id, c.title, stc.section_id, stc.units, stc.grade " +
       "FROM student_take_class stc " +
       "RIGHT JOIN class c ON stc.class_id = c.class_id " +
       "WHERE stc.student_id = ? AND stc.grade != 'IP' " +
       "GROUP BY c.year, c.quarter, c.class_id, c.course_id, c.title, stc.section_id, stc.units, stc.grade " +
       "ORDER BY c.year DESC, c.quarter DESC";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, student_id);
        rs = pstmt.executeQuery();

        //student_take_class: student_id, class_id, section_id, grade, units
        //class: class_id, course_id, year, quarter, title
        //display: class_id, course_id, year, quarter, title, section, units
        HashMap<String, Double> totalUnits = new HashMap<String, Double>();
        HashMap<String, Double> gradePoints = new HashMap<String, Double>();
        out.println("<table border='1'>");
        out.println("<tr><th>class_id</th><th>course_id</th><th>year</th><th>quarter</th><th>title</th><th>section</th><th>units</th><th>grade</th></tr>");
        while (rs.next()) {
            sql = "SELECT * FROM grade_conversion WHERE letter_grade = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, rs.getString("grade"));
            ResultSet rs2 = pstmt.executeQuery();
            Double gradePoint = -1.0;
            while (rs2.next()){
                gradePoint = rs2.getDouble("number_grade");
            }
            if (gradePoint != -1.0){
                String quarterYear = rs.getString("quarter") + " " +rs.getString("year");
                if (totalUnits.containsKey(quarterYear)){
                    totalUnits.put(quarterYear, totalUnits.get(quarterYear) + (double)rs.getInt("units"));
                }else{
                    totalUnits.put(quarterYear,(double)rs.getInt("units"));
                }
                if (gradePoints.containsKey(quarterYear)){
                    gradePoints.put(quarterYear, gradePoints.get(quarterYear) + (double)rs.getInt("units") / 4.0 * gradePoint);
                }else{
                    gradePoints.put(quarterYear, (double)rs.getInt("units") / 4.0 * gradePoint);
                }   
            }
            out.println("<tr>");
            out.println("<td>" + rs.getString("class_id") + "</td>"); 
            out.println("<td>" + rs.getString("course_id") + "</td>");
            out.println("<td>" + rs.getString("year") + "</td>");
            out.println("<td>" + rs.getString("quarter") + "</td>");
            out.println("<td>" + rs.getString("title") + "</td>");
            out.println("<td>" + rs.getString("section_id") + "</td>");
            out.println("<td>" + rs.getString("units") + "</td>");
            out.println("<td>" + rs.getString("grade") + "</td>");
            out.println("</tr>");
        }
        double cumulativeUnits = 0;
        double cumulativeGP = 0;
        out.println("<table border='1'>");
        out.println("<tr><th>quarter and year</th><th>gpa</th></tr>");
        for (Map.Entry<String, Double> entry : totalUnits.entrySet()) {
            String key = entry.getKey();
            Double totalUnit = entry.getValue();
            Double gradePoint = gradePoints.get(key);
            Double gpa = gradePoint / totalUnit * 4;
            out.println("<td>" + key + "</td>"); 
            out.println("<td>" + Double.toString(gpa) + "</td>");
            out.println("</tr>");
            cumulativeUnits += totalUnit;
            cumulativeGP += gradePoint;
        }



        
            



    } catch (ClassNotFoundException e) {
        out.println("<p>Error loading driver: " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p>Error in SQL: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <title>Report 2(a)</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <h2>Student Entry Form</h2>
    <form action="../../process_query/report2a.jsp" method="POST">
        <select id="ssn" name="ssn" onchange="if(this.value) this.form.submit();">
                <option value="">Select a student by ssn</option>
                <% 
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
                        String user = "postgres";
                        String password = "James2085";
                        Class.forName("org.postgresql.Driver");
                        conn = DriverManager.getConnection(url, user, password);

                        String query = "SELECT DISTINCT student_id FROM student_enrollment WHERE quarter = 'Spring' AND year = 2018";
                        pstmt = conn.prepareStatement(query);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            String student_id = rs.getString("student_id");
                            // out.println("<option value=\"" + displayText + "\">" + displayText + "</a >");
                            query = "SELECT * FROM student WHERE student_id = ?";
                            pstmt = conn.prepareStatement(query);
                            pstmt.setString(1, student_id);
                            ResultSet rs2 = pstmt.executeQuery();
                            while (rs2.next()){
                                String ssn = rs2.getString("ssn");
                                String displayText = "student_id: " + student_id + " SSN: " + rs2.getString("ssn") + " First Name: " + rs2.getString("first_name") + " Middle Name: " + rs2.getString("middle_name") + " Last Name: " + rs2.getString("last_name");
                                out.println("<option value=\"" + ssn + "\">" + displayText + "</a >");
                            } 
                        }
                    } catch (Exception e) {
                        out.println("<p>Error connecting to database: " + e.getMessage() + "</p >");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { }
                    }
                %>
            </select>
        <input type="submit" value="Submit">
    </form>

    <script>
    </script>
</body>
</html>

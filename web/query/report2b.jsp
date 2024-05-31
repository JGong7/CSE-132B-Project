<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <title>Report 2(b)</title>
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
    <form action="../../process_query/report2b.jsp" method="POST">
        <select id="sid" name="sid">
                <option value="">Select a section</option>
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

                        String query = "SELECT * FROM section";
                        pstmt = conn.prepareStatement(query);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            // out.println("<option value=\"" + displayText + "\">" + displayText + "</a >");
                            query = "SELECT * FROM class WHERE class_id = ? AND quarter = 'Spring' AND year = 2018";
                            pstmt = conn.prepareStatement(query);
                            pstmt.setInt(1, rs.getInt("class_id"));
                            ResultSet rs2 = pstmt.executeQuery();
                            while (rs2.next()){
                                query = "SELECT * FROM course WHERE course_id = ?";
                                pstmt = conn.prepareStatement(query);
                                pstmt.setInt(1, rs2.getInt("course_id"));
                                ResultSet rs3 = pstmt.executeQuery();
                                while (rs3.next()){
                                    String sid = rs.getString("section_id");
                                    String displayText = "Section id: " + sid + "; Course Number: " + rs3.getString("course_number") + "; Course Title: " + rs2.getString("title") + "; Class ID: " + rs2.getString("class_id");
                                    out.println("<option value=\"" + sid + " " + rs.getString("class_id") + "\">" + displayText + "</a >");
                                }
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
            <div class="input-group">
                <label for="start_date">Start Date:</label>
                <input type="date" id="start_date" name="start_date" required>
            </div>
            <div class="input-group">
                <label for="end_date">End Date:</label>
                <input type="date" id="end_date" name="end_date" required>
            </div>
        <input type="submit" value="Submit">
    </form>

    <script>
    </script>
</body>
</html>

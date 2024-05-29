<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Class Enrollment Submission Results</title>
</head>
<body>
    <h1>Class Enrollment Submission Results</h1>
<%
    String studentId = request.getParameter("student_id");
    String[] class_ids= request.getParameterValues("class_id[]");
    String[] sectionIds = request.getParameterValues("section_id[]");
    String[] statuses = request.getParameterValues("status[]");
    String[] grading_options = request.getParameterValues("grading_option[]");
    String[] units = request.getParameterValues("units[]");    
    String[] grades = request.getParameterValues("grade[]");
    String action = request.getParameter("action");

    Connection conn = null;
    PreparedStatement pstmt = null;
    int updates = 0;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";
        // Load the database driver
        Class.forName("org.postgresql.Driver");
        // Establish connection
        conn = DriverManager.getConnection(url, user, password);

        int gradeIndex = 0;
        

        if (action.equals("add")){
            //add into Student_take_class no matter what, then add to enrollment if currently taking.
            // Loop over each class entry
            for (int i = 0; i < class_ids.length; i++) {
                int class_id = Integer.parseInt(class_ids[i]);
                if (!statuses[i].equals("taken")){
                    String enroll_sql = "INSERT INTO Enrollment (student_id, class_id, section_id, enrollment_type, grading_option, units) VALUES (?, ?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(enroll_sql);
                    pstmt.setString(1, studentId);
                    pstmt.setInt(2, class_id);
                    pstmt.setString(3, sectionIds[i]);
                    pstmt.setString(4, statuses[i]);
                    pstmt.setString(5, grading_options[i]);
                    pstmt.setInt(6, Integer.parseInt(units[i]));
                    updates += pstmt.executeUpdate();
                }
                String sql = "INSERT INTO Student_take_class (student_id, class_id, section_id, grade, units) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, studentId);
                pstmt.setInt(2, class_id);
                pstmt.setString(3, sectionIds[i]);
                if (statuses[i].equals("taken")){
                    pstmt.setString(4, grades[gradeIndex]);
                    gradeIndex ++;
                }else{
                    pstmt.setString(4, "IP");
                }
                pstmt.setInt(5, Integer.parseInt(units[i]));
                updates += pstmt.executeUpdate();

                //First, get the quarter and year associated with the classid
                String getQuarterYear = "SELECT quarter, year FROM class WHERE class_id = ?";
                pstmt = conn.prepareStatement(getQuarterYear);
                pstmt.setInt(1, class_id);
                ResultSet rs = pstmt.executeQuery();
                String quarter = "";
                int year = 0;
                while (rs.next()){
                    quarter = rs.getString("quarter");
                    year = rs.getInt("year");
                }
                //Then, check if student is enrolled in that quarter
                String checkEnrollment = "SELECT * FROM student_enrollment WHERE student_id = ? AND quarter = ? AND year = ?";
                pstmt = conn.prepareStatement(checkEnrollment);
                pstmt.setString(1, studentId);
                pstmt.setString(2, quarter);
                pstmt.setInt(3, year);
                rs = pstmt.executeQuery();
                if (!rs.next()){
                    //If not, add them to student_enrollment
                    String addEnrollment = "INSERT INTO student_enrollment (student_id, quarter, year) VALUES (?, ?, ?)";
                    pstmt = conn.prepareStatement(addEnrollment);
                    pstmt.setString(1, studentId);
                    pstmt.setString(2, quarter);
                    pstmt.setInt(3, year);
                    pstmt.executeUpdate();
                }
                
            }
        } else if (action.equals("delete")){
            for (int i = 0; i < class_ids.length; i++) {
                int class_id = Integer.parseInt(class_ids[i]);
                String enroll_sql = "DELETE FROM Enrollment WHERE student_id = ? AND class_id = ? AND section_id = ?";
                pstmt = conn.prepareStatement(enroll_sql);
                pstmt.setString(1, studentId);
                pstmt.setInt(2, class_id);
                pstmt.setString(3, sectionIds[i]);
                updates += pstmt.executeUpdate();
                String sql = "DELETE FROM Student_take_class WHERE student_id = ? AND class_id = ? AND section_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, studentId);
                pstmt.setInt(2, class_id);
                pstmt.setString(3, sectionIds[i]);
                updates += pstmt.executeUpdate();

                //First, get the quarter and year associated with the classid
                String getQuarterYear = "SELECT quarter, year FROM class WHERE class_id = ?";
                pstmt = conn.prepareStatement(getQuarterYear);
                pstmt.setInt(1, class_id);
                ResultSet rs = pstmt.executeQuery();
                String quarter = "";
                int year = 0;
                while (rs.next()){
                    quarter = rs.getString("quarter");
                    year = rs.getInt("year");
                }
                //Then, check if the student still takes any class in that quarter. If not, delete from student_enrollment.
                String checkEnrollment = "SELECT * FROM student_take_class stc JOIN class c ON stc.class_id = c.class_id WHERE stc.student_id = ? AND c.quarter = ? AND c.year = ?";
                pstmt = conn.prepareStatement(checkEnrollment);
                pstmt.setString(1, studentId);
                pstmt.setString(2, quarter);
                pstmt.setInt(3, year);
                rs = pstmt.executeQuery();
                if (!rs.next()){
                    //If not, add them to student_enrollment
                    String deleteEnrollment = "DELETE FROM student_enrollment WHERE student_id = ? AND quarter = ? AND year = ?";
                    pstmt = conn.prepareStatement(deleteEnrollment);
                    pstmt.setString(1, studentId);
                    pstmt.setString(2, quarter);
                    pstmt.setInt(3, year);
                    pstmt.executeUpdate();
                }

            }
        } else if (action.equals("update")){
            for (int i = 0; i < class_ids.length; i++) {
                int class_id = Integer.parseInt(class_ids[i]);
                if (!statuses[i].equals("taken")) {
                    String enroll_sql = "UPDATE Enrollment SET enrollment_type = ?, grading_option = ?, units = ? WHERE student_id = ? AND class_id = ? AND section_id = ?";
                    pstmt = conn.prepareStatement(enroll_sql);
                    pstmt.setString(4, studentId);
                    pstmt.setInt(5, class_id);
                    pstmt.setString(6, sectionIds[i]);
                    pstmt.setString(1, statuses[i]);
                    pstmt.setString(2, grading_options[i]);
                    pstmt.setInt(3, Integer.parseInt(units[i]));
                    updates += pstmt.executeUpdate();
                } else {
                    String delete_sql = "DELETE FROM Enrollment WHERE student_id = ? AND class_id = ? AND section_id = ?";
                    pstmt = conn.prepareStatement(delete_sql);
                    pstmt.setString(1, studentId);
                    pstmt.setInt(2, class_id);
                    pstmt.setString(3, sectionIds[i]);
                    updates += pstmt.executeUpdate();
                }
                String sql = "UPDATE Student_take_class SET grade = ?, units = ? WHERE student_id = ? AND class_id = ? AND section_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(3, studentId);
                pstmt.setInt(4, class_id);
                pstmt.setString(5, sectionIds[i]);
                if (statuses[i].equals("taken")) {
                    pstmt.setString(1, grades[gradeIndex]);
                    gradeIndex ++;
                } else {
                    pstmt.setString(1, "IP");
                }
                pstmt.setInt(2, Integer.parseInt(units[i]));
                updates += pstmt.executeUpdate();
            }
        }

        // Output success message
        out.println("<p>Data successfully inserted for " + updates + " classes.</p>");
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

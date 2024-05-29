<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Course Submission</title>
</head>
<body>
<%
    String action = request.getParameter("action");
    int courseId = Integer.parseInt(request.getParameter("courseId"));
    String courseNumber = request.getParameter("courseNumber");
    String department = request.getParameter("department");
    boolean labRequired = Boolean.parseBoolean(request.getParameter("labRequired"));
    boolean consentRequired = Boolean.parseBoolean(request.getParameter("consentOfInstructorRequired"));
    String[] gradeOptions = request.getParameterValues("gradeOptions[]");
    String[] availableUnits = request.getParameterValues("availableUnits[]");
    String[] degrees = request.getParameterValues("degrees[]");
    String[] satisfyDegreeRequirements = request.getParameterValues("satisfyDegreeRequirements[]");
    String[] prerequisites = request.getParameterValues("prerequisites[]");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";

        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, user, password);
        conn.setAutoCommit(false); // Transaction block start

        int result = 0;
        if ("add".equals(action)) {
            // Insert into Course table
            String sqlInsertCourse = "INSERT INTO Course (course_id, course_number, department, require_lab_work, require_consent_of_instructor) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsertCourse);
            pstmt.setInt(1, courseId);
            pstmt.setString(2, courseNumber);
            pstmt.setString(3, department);
            pstmt.setBoolean(4, labRequired);
            pstmt.setBoolean(5, consentRequired);
            result = pstmt.executeUpdate();

            // Insert units
            if (availableUnits != null) {
                String sqlInsertUnits = "INSERT INTO Units (course_id, unit) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sqlInsertUnits);
                for (String unit : availableUnits) {
                    pstmt.setInt(1, courseId);
                    pstmt.setInt(2, Integer.parseInt(unit));
                    pstmt.executeUpdate();
                }
            }

            // Insert grade options
            if (gradeOptions != null) {
                String sqlInsertGradeOptions = "INSERT INTO Grade_option (course_id, option) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sqlInsertGradeOptions);
                for (String option : gradeOptions) {
                    pstmt.setInt(1, courseId);
                    pstmt.setString(2, option);
                    pstmt.executeUpdate();
                }
            }
            
            // Insert degrees
            String sqlInsertCourseDegree = "INSERT INTO Course_degree (course_id, degree_id, lower, upper, elective) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsertCourseDegree);
            for (int i = 0; i < degrees.length; i++) {
                pstmt.setInt(1, courseId);
                pstmt.setString(2, degrees[i]);
                pstmt.setBoolean(3, satisfyDegreeRequirements[i*3].equals("Yes"));
                pstmt.setBoolean(4, satisfyDegreeRequirements[i*3+1].equals("Yes"));
                pstmt.setBoolean(5, satisfyDegreeRequirements[i*3+2].equals("Yes"));
                pstmt.executeUpdate();
            }

            // Insert prerequisites
            if (prerequisites != null) {
                String sqlInsertPrerequisites = "INSERT INTO Prerequisite (course_id, required_course_id) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sqlInsertPrerequisites);
                for (String prereq : prerequisites) {
                    pstmt.setInt(1, courseId);
                    pstmt.setInt(2, Integer.parseInt(prereq)); // Assuming prereq is a course_id
                    pstmt.executeUpdate();
                }
            }
        } else if ("update".equals(action)) {
            // Update course
            String sqlUpdateCourse = "UPDATE Course SET course_number = ?, department = ?, require_lab_work = ?, require_consent_of_instructor = ? WHERE course_id = ?";
            pstmt = conn.prepareStatement(sqlUpdateCourse);
            pstmt.setString(1, courseNumber);
            pstmt.setString(2, department);
            pstmt.setBoolean(3, labRequired);
            pstmt.setBoolean(4, consentRequired);
            pstmt.setInt(5, courseId);
            result = pstmt.executeUpdate();

            // Update units
            if (availableUnits != null) {
                String sqlDeleteUnits = "DELETE FROM Units WHERE course_id = ?";
                pstmt = conn.prepareStatement(sqlDeleteUnits);
                pstmt.setInt(1, courseId);
                pstmt.executeUpdate();

                String sqlInsertUnits = "INSERT INTO Units (course_id, unit) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sqlInsertUnits);
                for (String unit : availableUnits) {
                    pstmt.setInt(1, courseId);
                    pstmt.setInt(2, Integer.parseInt(unit));
                    pstmt.executeUpdate();
                }
            }

            // Update grade options
            if (gradeOptions != null) {
                String sqlDeleteGradeOptions = "DELETE FROM Grade_option WHERE course_id = ?";
                pstmt = conn.prepareStatement(sqlDeleteGradeOptions);
                pstmt.setInt(1, courseId);
                pstmt.executeUpdate();

                String sqlInsertGradeOptions = "INSERT INTO Grade_option (course_id, option) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sqlInsertGradeOptions);
                for (String option : gradeOptions) {
                    pstmt.setInt(1, courseId);
                    pstmt.setString(2, option);
                    pstmt.executeUpdate();
                }
            }

            // Update degrees
            if (degrees != null) {
                String sqlDeleteCourseDegree = "DELETE FROM Course_degree WHERE course_id = ?";
                pstmt = conn.prepareStatement(sqlDeleteCourseDegree);
                pstmt.setInt(1, courseId);
                pstmt.executeUpdate();

                String sqlInsertCourseDegree = "INSERT INTO Course_degree (course_id, degree_id, lower, upper, elective) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sqlInsertCourseDegree);
                for (int i = 0; i < degrees.length; i++) {
                    pstmt.setInt(1, courseId);
                    pstmt.setString(2, degrees[i]);
                    pstmt.setBoolean(3, satisfyDegreeRequirements[i*3].equals("Yes"));
                    pstmt.setBoolean(4, satisfyDegreeRequirements[i*3+1].equals("Yes"));
                    pstmt.setBoolean(5, satisfyDegreeRequirements[i*3+2].equals("Yes"));
                    pstmt.executeUpdate();
                }
            }

            // Update prerequisites
            if (prerequisites != null) {
                String sqlDeletePrerequisites = "DELETE FROM Prerequisite WHERE course_id = ?";
                pstmt = conn.prepareStatement(sqlDeletePrerequisites);
                pstmt.setInt(1, courseId);
                pstmt.executeUpdate();

                String sqlInsertPrerequisites = "INSERT INTO Prerequisite (course_id, required_course_id) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sqlInsertPrerequisites);
                for (String prereq : prerequisites) {
                    pstmt.setInt(1, courseId);
                    pstmt.setInt(2, Integer.parseInt(prereq)); // Assuming prereq is a course_id
                    pstmt.executeUpdate();
                }
            }
        } else if ("delete".equals(action)) {
            // Delete course
            String sqlDeleteCourse = "DELETE FROM Course WHERE course_id = ?";
            pstmt = conn.prepareStatement(sqlDeleteCourse);
            pstmt.setInt(1, courseId);
            result = pstmt.executeUpdate();
        } else {
            throw new IllegalArgumentException("Invalid action: " + action);
        }

        if (result > 0) {
            conn.commit(); // Commit transaction
            out.println("<p>Insert successful. " + result + " row(s) affected.</p>");
        } else {
            conn.rollback(); // Rollback transaction
            out.println("<p>Insert failed. No rows affected.</p>");
        }

    } catch (Exception e) {
        out.println("<p>Error processing course data: " + e.getMessage() + "</p>");
        try {
            if (conn != null) conn.rollback(); // Rollback transaction on error
        } catch (SQLException ex) {
            out.println("<p>Error during transaction rollback: " + ex.getMessage() + "</p>");
        }
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignored */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignored */ }
    }
%>
</body>
</html>

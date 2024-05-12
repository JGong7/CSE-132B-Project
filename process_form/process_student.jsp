<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Student</title>
</head>
<body>
<%
    String action = request.getParameter("action");
    String studentId = request.getParameter("studentId");
    String firstName = request.getParameter("firstName");
    String middleName = request.getParameter("middleName");
    String lastName = request.getParameter("lastName");
    String ssn = request.getParameter("ssn");
    String residentialStatus = request.getParameter("residentialStatus");
    boolean enrolled = "true".equals(request.getParameter("enrolled"));
    String studentType = request.getParameter("studentType");
    out.println("Student Type: " + studentType + "<br>");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";

        Class.forName("org.postgresql.Driver");

        // Establish the connection
        conn = DriverManager.getConnection(url, user, password);
        conn.setAutoCommit(false); // Start transaction

        int result1 = 0;
        if ("add".equals(action)) {
            String sql = "INSERT INTO Student (student_id, first_name, middle_name, last_name, ssn, residential_status, enrolled) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            pstmt.setString(2, firstName);
            pstmt.setString(3, middleName);
            pstmt.setString(4, lastName);
            pstmt.setString(5, ssn);
            pstmt.setString(6, residentialStatus);
            pstmt.setBoolean(7, enrolled);
            result1 = pstmt.executeUpdate();
        } else if ("update".equals(action)) {
            String sql = "UPDATE Student SET first_name = ?, middle_name = ?, last_name = ?, ssn = ?, residential_status = ?, enrolled = ? WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, firstName);
            pstmt.setString(2, middleName);
            pstmt.setString(3, lastName);
            pstmt.setString(4, ssn);
            pstmt.setString(5, residentialStatus);
            pstmt.setBoolean(6, enrolled);
            pstmt.setString(7, studentId);
            result1 = pstmt.executeUpdate();
        } else if ("delete".equals(action)) {
            String sql = "DELETE FROM Student WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            result1 = pstmt.executeUpdate();
        } else {
            throw new IllegalArgumentException("Invalid action: " + action);
        }

        if (result1 > 0) {
            conn.commit(); // Commit the transaction
            out.println("Insert successful. " + result1 + " row(s) affected.");
        } else {
            conn.rollback(); // Rollback the transaction
            out.println("Insert failed. No rows affected.");
        }

        // Insert into specific student type table
        try {
            int result2 = 0;
            if ("Undergraduate".equals(studentType)) {
                String college = request.getParameter("undergraduateCollege");

                if ("add".equals(action)) {
                    String sql = "INSERT INTO Undergraduate_student (student_id, college) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, studentId);
                    pstmt.setString(2, college);
                    result2 = pstmt.executeUpdate();
                } else if ("update".equals(action)) {
                    String sql = "UPDATE Undergraduate_student SET college = ? WHERE student_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, college);
                    pstmt.setString(2, studentId);
                    result2 = pstmt.executeUpdate();
                } else {
                    out.println("Automatically deleted from Undergraduate_student table.");
                }
            } else if ("BSMS".equals(studentType)) {
                String college = request.getParameter("bsmsCollege");
                String department = request.getParameter("bsmsDepartment");
                String plan = request.getParameter("bsmsPlan");

                if ("add".equals(action)) {
                    String sql = "INSERT INTO BSMS_student (student_id, college, department, plan) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, studentId);
                    pstmt.setString(2, college);
                    pstmt.setString(3, department);
                    pstmt.setString(4, plan);
                    result2 = pstmt.executeUpdate();
                } else if ("update".equals(action)) {
                    String sql = "UPDATE BSMS_student SET college = ?, department = ?, plan = ? WHERE student_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, college);
                    pstmt.setString(2, department);
                    pstmt.setString(3, plan);
                    pstmt.setString(4, studentId);
                    result2 = pstmt.executeUpdate();
                } else {
                    out.println("Automatically deleted from BSMS_student table.");
                }
            } else if ("Master".equals(studentType)) {
                String department = request.getParameter("masterDepartment");
                String plan = request.getParameter("masterPlan");
                
                if ("add".equals(action)) {
                    String sql = "INSERT INTO Master_student (student_id, department, plan) VALUES (?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, studentId);
                    pstmt.setString(2, department);
                    pstmt.setString(3, plan);
                    result2 = pstmt.executeUpdate();
                } else if ("update".equals(action)) {
                    String sql = "UPDATE Master_student SET department = ?, plan = ? WHERE student_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, department);
                    pstmt.setString(2, plan);
                    pstmt.setString(3, studentId);
                    result2 = pstmt.executeUpdate();
                } else {
                    out.println("Automatically deleted from Master_student table.");
                }
            } else if ("PhD".equals(studentType)) {
                String department = request.getParameter("phdDepartment");
                String candidacyStatus = request.getParameter("candidacyStatus");
                String advisor = request.getParameter("advisor");
                
                if ("add".equals(action)) {
                    String sql = "INSERT INTO PhD_student (student_id, department, candidacy_status, advisor) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, studentId);
                    pstmt.setString(2, department);
                    pstmt.setString(3, candidacyStatus);
                    pstmt.setString(4, advisor);
                    result2 = pstmt.executeUpdate();
                } else if ("update".equals(action)) {
                    String sql = "UPDATE PhD_student SET department = ?, candidacy_status = ?, advisor = ? WHERE student_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, department);
                    pstmt.setString(2, candidacyStatus);
                    pstmt.setString(3, advisor);
                    pstmt.setString(4, studentId);
                    result2 = pstmt.executeUpdate();
                } else {
                    out.println("Automatically deleted from PhD_student table.");
                }
            } else {
                out.println("Error: Invalid student type");
            }

            if (result2 <= 0 && !"delete".equals(action)) {
                conn.rollback(); // Rollback the transaction
                out.println("Insert or update failed. No rows affected.");
            } else {
                conn.commit(); // Commit the transaction
                out.println("Insert or update successful. " + result2 + " row(s) affected.");
            }

        } catch (Exception e) {
            out.println("<p>Error: caught exception in inner try/catch</p>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (pstmt != null) { pstmt.close(); }
            if (conn != null) { conn.close(); }
        }

    } catch (SQLException e) {
        out.println("<p>Error: caught exception in outer try/catch</p>");
        out.println("<p>Error: " + e.getMessage() + "</p>");
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) { out.println("<p>Error during rollback: " + ex.getMessage() + "</p>"); }
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) { /* ignored */ }
        if (conn != null) try { conn.close(); } catch (SQLException ex) { /* ignored */ }
    }
%>
</body>
</html>

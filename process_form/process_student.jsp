<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Student</title>
</head>
<body>
<%
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

    //try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";

        Class.forName("org.postgresql.Driver");

        // Establish the connection
        conn = DriverManager.getConnection(url, user, password);
        if (conn != null) {
            out.println("Connected to the database!");
        } else {
            out.println("Failed to make connection!");
        }

        // Insert into Student table
        String sql = "INSERT INTO Student (student_id, first_name, middle_name, last_name, ssn, residential_status, enrolled) VALUES (?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentId);
        pstmt.setString(2, firstName);
        pstmt.setString(3, middleName);
        pstmt.setString(4, lastName);
        pstmt.setString(5, ssn);
        pstmt.setString(6, residentialStatus);
        pstmt.setBoolean(7, enrolled);
        int rowsAffected = pstmt.executeUpdate();

        out.println("Inserting into Student");
        if (rowsAffected > 0) {
            out.println("Insert successful. " + rowsAffected + " row(s) affected.");
        } else {
            out.println("Insert failed. No rows affected.");
        }

        // Insert into specific student type table
        try {
            if ("Undergraduate".equals(studentType)) {
                String college = request.getParameter("undergraduateCollege");
                out.println("Inserting into Undergraduate_student with college: " + college + "<br>");

                sql = "INSERT INTO Undergraduate_student (student_id, college) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, studentId);
                pstmt.setString(2, college);
                int row = pstmt.executeUpdate();
                if (row > 0) {
                    out.println("Insert successful. " + row + " row(s) affected.");
                } else {
                    out.println("Insert failed. No rows affected.");
                }
            } else if ("BSMS".equals(studentType)) {
                String college = request.getParameter("bsmsCollege");
                String department = request.getParameter("bsmsDepartment");
                String plan = request.getParameter("bsmsPlan");
                out.println("Inserting into BSMS_student with college: " + college + ", department: " + department + ", plan: " + plan + "<br>");

                sql = "INSERT INTO BSMS_student (student_id, college, department, plan) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, studentId);
                pstmt.setString(2, college);
                pstmt.setString(3, department);
                pstmt.setString(4, plan);
                int row = pstmt.executeUpdate();
                if (row > 0) {
                    out.println("Insert successful. " + row + " row(s) affected.");
                } else {
                    out.println("Insert failed. No rows affected.");
                }
            } else if ("Master".equals(studentType)) {
                String department = request.getParameter("masterDepartment");
                String plan = request.getParameter("masterPlan");
                out.println("Inserting into Master_student with plan: " + plan + ", department: " + department + "<br>");

                sql = "INSERT INTO Master_student (student_id, plan, department) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, studentId);
                pstmt.setString(2, plan);
                pstmt.setString(3, department);
                int row = pstmt.executeUpdate();
                if (row > 0) {
                    out.println("Insert successful. " + row + " row(s) affected.");
                } else {
                    out.println("Insert failed. No rows affected.");
                }
            } else if ("PhD".equals(studentType)) {
                String department = request.getParameter("phdDepartment");
                String candidacyStatus = request.getParameter("candidacyStatus");
                String advisor = request.getParameter("advisor");
                out.println("Inserting into PhD_student with department: " + department + ", candidacy status: " + candidacyStatus + ", advisor: " + advisor + "<br>");

                sql = "INSERT INTO Phd_student (student_id, department, candidacy_status, advisor) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, studentId);
                pstmt.setString(2, department);
                pstmt.setBoolean(3, candidacyStatus.equals("Candidate"));
                pstmt.setString(4, advisor);
                int row = pstmt.executeUpdate();
                if (row > 0) {
                    out.println("Insert successful. " + row + " row(s) affected.");
                } else {
                    out.println("Insert failed. No rows affected.");
                }
            } else {
                out.println("Error: Invalid student type");
            }
            out.println("<p>Student data successfully saved!</p>");

        } catch (Exception e) {
            out.println("<p>Error: caught exception in try/catch</p>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (pstmt != null) { pstmt.close(); }
            if (conn != null) { conn.close(); }
        }
%>
</body>
</html>

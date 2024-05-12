<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thesis Committee Processing</title>
    <meta charset="UTF-8">
</head>
<body>
    <h1>Thesis Committee Submission Results</h1>
<%
    String action = request.getParameter("action");
    String studentId = request.getParameter("student_id");
    String[] internalProfessors = request.getParameterValues("internalProfessor[]");
    String isPhD = request.getParameter("isPhd");
    String[] externalProfessors = null;
    if ("true".equals(isPhD)) {
        externalProfessors = request.getParameterValues("externalProfessor[]");
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";

        Class.forName("org.postgresql.Driver");

        // Establish connection
        conn = DriverManager.getConnection(url, user, password);
        conn.setAutoCommit(false); // Start transaction block

        int result = 0;
        if ("add".equals(action)) {
            String sql = "INSERT INTO Thesis_committee (student_id, professor, is_external) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            pstmt.setBoolean(3, false);
            for (String professor : internalProfessors) {
                pstmt.setString(2, professor);
                result += pstmt.executeUpdate();
            }

            if ("true".equals(isPhD)) {
                pstmt.setBoolean(3, true);
                for (String professor : externalProfessors) {
                    pstmt.setString(2, professor);
                    result += pstmt.executeUpdate();
                }
            }
        } else if ("update".equals(action)) {
            String sql = "DELETE FROM Thesis_committee WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            result = pstmt.executeUpdate();

            sql = "INSERT INTO Thesis_committee (student_id, professor, is_external) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            pstmt.setBoolean(3, false);
            for (String professor : internalProfessors) {
                pstmt.setString(2, professor);
                result += pstmt.executeUpdate();
            }

            if ("true".equals(isPhD)) {
                pstmt.setBoolean(3, true);
                for (String professor : externalProfessors) {
                    pstmt.setString(2, professor);
                    result += pstmt.executeUpdate();
                }
            }
        } else if ("delete".equals(action)) {
            String sql = "DELETE FROM Thesis_committee WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            result = pstmt.executeUpdate();
        } else {
            throw new IllegalArgumentException("Invalid action: " + action);
        }

        if (result > 0) {
            conn.commit(); // Commit transaction
            out.println("<p>Thesis committee details processed successfully.</p>");
        } else {
            conn.rollback(); // Rollback transaction
            out.println("<p>No thesis committee details processed.</p>");
        }

    } catch (Exception e) {
        out.println("<p>Error while inserting data: " + e.getMessage() + "</p>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException logOrIgnore) {}
        if (conn != null) try { conn.close(); } catch (SQLException logOrIgnore) {}
    }
%>
    <p><a href="index.jsp">Return to Home</a></p>
</body>
</html>

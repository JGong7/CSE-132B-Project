<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <title>Process Account Inputs</title>
</head>
<body>
<%
    // Retrieve form data using request.getParameter
    String student_id = request.getParameter("student_id");
    String account_num = request.getParameter("account");
    String balance = request.getParameter("balance");
    String[] methods = request.getParameterValues("paymentMethods[]");
    String[] amounts = request.getParameterValues("amountHistory[]");
    String[] times = request.getParameterValues("paymentTime[]");

    // Optional: Connect to your database and insert the data
    String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
    String user = "postgres";
    String password = "James2085";

    try {
        // Load the database driver
        Class.forName("org.postgresql.Driver");

        // Establish connection
        Connection conn = DriverManager.getConnection(url, user, password);


        String sql = "INSERT INTO Account (account_number, balance) VALUES (?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, account_num);
        pstmt.setBigDecimal(2, new BigDecimal(balance));
        pstmt.executeUpdate();

        sql = "INSERT INTO Student_to_account (student_id, account_number) VALUES (?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, student_id);
        pstmt.setString(2, account_num);
        pstmt.executeUpdate();

        sql = "INSERT INTO Payment_method (account_number, method) VALUES (?, ?)";
        pstmt = conn.prepareStatement(sql);
        for (String s : methods){
            pstmt.setString(1, account_num);
            pstmt.setString(2, s);
            pstmt.executeUpdate();
        }

        sql = "INSERT INTO Payment_history (account_number, amount, time) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        for (int i = 0; i < amounts.length; i++){
            pstmt.setString(1, account_num);
            pstmt.setBigDecimal(2, new BigDecimal(balance));
            String timeWithSeconds = times[i].replace("T", " ") + ":00";
            pstmt.setTimestamp(3, Timestamp.valueOf(timeWithSeconds));
            pstmt.executeUpdate();
        }


    } catch (ClassNotFoundException e) {
        out.println("<p>Error loading driver: " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p>Error in SQL: " + e.getMessage() + "</p>");
    }

    // Display received form data
    out.println("<p>Received form data:</p>");
    for (int i = 0; i < amounts.length; i++) {
        out.println("<p>Amount: " + amounts[i] + ", Time: " + times[i] + "</p>");
    }
%>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <title>Process Account Inputs</title>
</head>
<body>
<%
    String action = request.getParameter("action");
    // Retrieve form data using request.getParameter
    String student_id = request.getParameter("student_id");
    String account_num = request.getParameter("account");
    String balance = request.getParameter("balance");
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

        if (action.equals("add")){
            String sql = "INSERT INTO Account (account_number, student_id, balance) VALUES (?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, account_num);
            pstmt.setString(2, student_id);
            pstmt.setBigDecimal(3, new BigDecimal(balance));
            pstmt.executeUpdate();

            if (times != null){
                sql = "INSERT INTO Payment_history (account_number, amount, time) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                for (int i = 0; i < amounts.length; i++){
                    pstmt.setString(1, account_num);
                    pstmt.setBigDecimal(2, new BigDecimal(amounts[i]));
                    String timeWithSeconds = times[i].replace("T", " ") + ":00";
                    pstmt.setTimestamp(3, Timestamp.valueOf(timeWithSeconds));
                    pstmt.executeUpdate();
                }
            }
        }else if (action.equals("delete")){
            PreparedStatement pstmt;
            if (times != null){
                String sql = "DELETE FROM Payment_history WHERE account_number = ? AND time = ?";
                pstmt = conn.prepareStatement(sql);
                for (int i = 0; i < times.length; i++){
                    pstmt.setString(1, account_num);
                    String timeWithSeconds = times[i].replace("T", " ") + ":00";
                    pstmt.setTimestamp(2, Timestamp.valueOf(timeWithSeconds));
                    pstmt.executeUpdate();
                }
            }else {
                String sql = "DELETE FROM Account WHERE student_id = ? AND account_number = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, student_id);
                pstmt.setString(2, account_num);
                pstmt.executeUpdate();
            }
        }else if (action.equals("update")){
            PreparedStatement pstmt;
            if (times != null){
                String sql = "UPDATE Payment_history SET amount = ? WHERE account_number = ? AND time = ?";
                pstmt = conn.prepareStatement(sql);
                for (int i = 0; i < times.length; i++){
                    pstmt.setBigDecimal(1, new BigDecimal(amounts[i]));
                    pstmt.setString(2, account_num);
                    String timeWithSeconds = times[i].replace("T", " ") + ":00";
                    pstmt.setTimestamp(3, Timestamp.valueOf(timeWithSeconds));
                    pstmt.executeUpdate();
                }
            }
            String sql = "UPDATE Account SET balance = ?, student_id = ? WHERE account_number = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setBigDecimal(1, new BigDecimal(balance));
            pstmt.setString(2, student_id);
            pstmt.setString(3, account_num);
            pstmt.executeUpdate();
        }
            



    } catch (ClassNotFoundException e) {
        out.println("<p>Error loading driver: " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p>Error in SQL: " + e.getMessage() + "</p>");
    }

    // Display received form data
    out.println("<p>Received form data:</p>");
%>
</body>
</html>

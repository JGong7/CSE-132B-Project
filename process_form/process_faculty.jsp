<%@ page import="java.sql.*,java.io.*" %>
<html>
<head>
<title>Process Faculty</title>
</head>
<body>
<%
    String name = request.getParameter("name");
    String title = request.getParameter("title");

    out.println("Received name: " + name + "<br>");
    out.println("Received title: " + title + "<br>");
    String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
    String user = "postgres";
    String password = "James2085";

    Class.forName("org.postgresql.Driver");

    // Establish the connection
    Connection conn = DriverManager.getConnection(url, user, password);
    // If connection is successfully established, print a message
    if (conn != null) {
        out.println("Connected to the database!");
    } else {
        out.println("Failed to make connection!");
    }

    String sql = "INSERT INTO Faculty (name, title) VALUES (?, ?)";
    PreparedStatement pstmt = conn.prepareStatement(sql);

    pstmt.setString(1, name);
    pstmt.setString(2, title);
    int rowsAffected = pstmt.executeUpdate();

    if (rowsAffected > 0) {
        out.println("Insert successful. " + rowsAffected + " row(s) affected.");
    } else {
        out.println("Insert failed. No rows affected.");
    }
%>
<h1>Faculty Information</h1>
<p>Name: <%= name %></p>
<p>Title: <%= title %></p>
</body>
</html>
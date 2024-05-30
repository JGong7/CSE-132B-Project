<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Grade Distribution Report</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
        select {
            min-width: 200px;
        }
    </style>
</head>
<body>
    <h2>Grade Distribution Report</h2>
    <form action="../../process_query/display_gradeReport.jsp" method="GET">
        <div class="input-group">
            <label for="courseId">Course ID:</label>
            <input type="text" id="courseId" name="courseId" required>
        </div>
        <div class="input-group">
            <label for="professor">Professor:</label>
            <input type="text" id="professor" name="professor">
        </div>
        <div class="input-group">
            <label for="quarter">Quarter:</line>
            <input type="text" id="quarter" name="quarter" placeholder="quarter">
            <input type="number" id="year" name="year" placeholder="year">
        </div>
        <input type="submit" value="Generate Report">
    </form>
</body>
</html>

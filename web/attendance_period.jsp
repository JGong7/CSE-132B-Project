<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Attendance Period Entry Form</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <h2>Enter Attendance Period Details</h2>
    <form action="../process_form/process_attendance_period.jsp" method="POST">
        <div class="input-group">
            <label for="action">Action:</label>
            <select id="action" name="action">
                <option value="add">Add</option>
                <option value="update">Update</option>
                <option value="delete">Delete</option>
            </select>
        </div>
        <div class="input-group">
            <label for="studentId">Student ID:</label>
            <input type="text" id="studentId" name="studentId" required>
        </div>
        <div class="input-group">
            <label for="periodStart">Period Start Date:</label>
            <input type="date" id="periodStart" name="periodStart" required>
        </div>
        <div class="input-group">
            <label for="periodEnd">Period End Date:</label>
            <input type="date" id="periodEnd" name="periodEnd" required>
        </div>
        <input type="submit" value="Submit">
    </form>
</body>
</html>

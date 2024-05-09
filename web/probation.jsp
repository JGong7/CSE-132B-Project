<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Probation Entry Form</title>
</head>
<body>
    <h2>Enter Probation Details</h2>
    <form action="../process_form/process_probation.jsp" method="POST">
        <div>
            <label for="student_id">Student ID:</label>
            <input type="text" id="student_id" name="student_id" required pattern="[A-Za-z0-9]{9}" title="Student ID must be 9 alphanumeric characters.">
        </div>
        <div>
            <label for="start_date">Start Date:</label>
            <input type="date" id="start_date" name="start_date" required>
        </div>
        <div>
            <label for="end_date">End Date:</label>
            <input type="date" id="end_date" name="end_date" required>
        </div>
        <div>
            <label for="reason">Reason:</label>
            <textarea id="reason" name="reason" required></textarea>
        </div>
        <button type="submit">Submit Probation Details</button>
    </form>
</body>
</html>

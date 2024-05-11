<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Degrees Obtained Entry Form</title>
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
    <h2>Enter Degree Details</h2>
    <form action="../process_form/process_degrees_obtained.jsp" method="POST">
        <div class="input-group">
            <label for="studentId">Student ID:</label>
            <input type="text" id="studentId" name="studentId" required>
        </div>
        <div class="input-group">
            <label for="degreeType">Degree Type:</label>
            <input type="text" id="degreeType" name="degreeType" required>
        </div>
        <div class="input-group">
            <label for="major">Major:</label>
            <input type="text" id="major" name="major" required>
        </div>
        <div class="input-group">
            <label for="startDate">Start Date:</label>
            <input type="date" id="startDate" name="startDate" required>
        </div>
        <div class="input-group">
            <label for="endDate">End Date:</label>
            <input type="date" id="endDate" name="endDate" required>
        </div>
        <div class="input-group">
            <label for="university">University:</label>
            <input type="text" id="university" name="university" required>
        </div>
        <input type="submit" value="Submit">
    </form>
</body>
</html>

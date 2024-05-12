<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Pursuing Degree Entry Form</title>
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
    <h2>Enter Pursuing Degree Details</h2>
    <form action="../process_form/process_pursuing.jsp" method="POST">
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
            <label for="degreeId">Degree ID:</label>
            <input type="text" id="degreeId" name="degreeId" required>
        </div>
        <input type="submit" value="Submit">
    </form>
</body>
</html>

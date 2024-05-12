<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Class Entry Form</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
        .section, .meeting {
            margin-left: 20px;
            border: 1px dotted #666;
            padding: 10px;
        }
        button {
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <h2>Class Entry Form</h2>
    <form action="../process_form/process_class.jsp" method="POST">
        <div class="input-group">
            <label for="courseNumber">Course Number:</label>
            <input type="text" id="courseNumber" name="courseNumber" required>
        </div>
        <div class="input-group">
            <label for="title">Title:</label>
            <input type="text" id="title" name="title" required>
        </div>
        <div class="input-group">
            <label for="year">Year:</label>
            <input type="number" id="year" name="year" required>
        </div>
        <div class="input-group">
            <label for="quarter">Quarter:</label>
            <input type="text" id="quarter" name="quarter" required>
        </div>
        <br>
        <input type="submit" value="Submit Class">
    </form>

    <script>
    </script>

</body>
</html>

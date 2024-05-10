<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Review Session Entry Form</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
        button {
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <h2>Review Session Entry Form</h2>
    <form action="../process_form/process_review_session.jsp" method="POST">
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
        <div class="input-group">
            <label for="room">Room:</label>
            <input type="text" id="room" name="room" required>
        </div>
        <div class="input-group">
            <label for="building">Building:</label>
            <input type="text" id="building" name="building" required>
        </div>
        <div class="input-group">
            <label for="mandatory">Mandatory:</label>
            <select id="mandatory" name="mandatory" required>
                <option value="true">Yes</option>
                <option value="false">No</option>
            </select>
        </div>
        <div class="input-group">
            <label for="timeStart">Start Time:</label>
            <input type="time" id="timeStart" name="timeStart" required>
        </div>
        <div class="input-group">
            <label for="timeEnd">End Time:</label>
            <input type="time" id="timeEnd" name="timeEnd" required>
        </div>
        <div class="input-group">
            <label for="dateStart">Start Date:</label>
            <input type="date" id="dateStart" name="dateStart" required>
        </div>
        <div class="input-group">
            <label for="dateEnd">End Date:</label>
            <input type="date" id="dateEnd" name="dateEnd" required>
        </div>
        <input type="submit" value="Submit Review Session">
    </form>
</body>
</html>

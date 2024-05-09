<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Teaching Schedule Entry Form</title>
    <style>
        .input-group {
            margin-bottom: 10px;
        }
        .input-group label {
            display: block;
        }
        .remove-btn {
            display: block;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <h2>Enter Teaching Schedule Details</h2>
    <form action="../process_form/process_teaching_schedule.jsp" method="POST">
        <div>
            <label for="name">Faculty Name:</label>
            <input type="text" id="name" name="name" required>
        </div>
        <div id="classContainer">
            <label>Classes:</label>
        </div>
        <button type="button" onclick="addClassInput()">Add Class</button>
        <br><br>
        <button type="submit">Submit Teaching Schedule Details</button>
    </form>
</body>
<script>
    function addClassInput() {
        var container = document.getElementById('classContainer');
        var inputGroup = document.createElement('div');
        inputGroup.className = 'input-group';
        inputGroup.innerHTML = '<label>Year:</label><input type="number" name="year[]" placeholder="Enter Year" required>'
                             + '<label>Quarter:</label><input type="text" name="quarter[]" placeholder="Enter Quarter" required>'
                             + '<label>Title:</label><input type="text" name="title[]" placeholder="Enter Class Title" required>'
                             + '<label>Course Number:</label><input type="text" name="course_number[]" placeholder="Enter Course Number" required>'
                             + '<button type="button" class="remove-btn" onclick="removeClassInput(this)">Remove Class</button>';
        container.appendChild(inputGroup);
    }

    function removeClassInput(btn) {
        var inputGroup = btn.parentNode;
        inputGroup.parentNode.removeChild(inputGroup);
    }
</script>
</html>

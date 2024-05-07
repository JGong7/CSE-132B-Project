<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Course Entry Form</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
        .input-group label,
        .input-group input,
        .input-group select,
        .input-group button {
            margin-right: 10px;
        }
        button.remove-btn {
            color: red;
            margin-left: 5px;
        }
    </style>
</head>
<body>
    <h2>Course Entry Form</h2>
    <form action="SubmitCourseServlet" method="POST">
        <div class="input-group">
            <label for="courseNumber">Course Number:</label>
            <input type="text" id="courseNumber" name="courseNumber" required>
        </div>
        <div class="input-group">
            <label for="department">Department:</label>
            <input type="text" id="department" name="department" required>
        </div>
        <div class="input-group">
            <label for="labRequired">Requires Lab Work:</label>
            <select id="labRequired" name="labRequired">
                <option value="true">True</option>
                <option value="false">False</option>
            </select>
        </div>
        <div id="prerequisitesContainer">
            <label>Prerequisites:</label>
        </div>
        <button type="button" onclick="addPrerequisiteInput()">Add Prerequisite</button>
        <br>
        <input type="submit" value="Submit Course">
    </form>

    <script>
        function addPrerequisiteInput() {
            var container = document.getElementById('prerequisitesContainer');
            var inputGroup = document.createElement('div');
            inputGroup.className = 'input-group';
            inputGroup.innerHTML = '<input type="text" name="prerequisites[]" placeholder="Enter prerequisite course number">'
                                 + '<button type="button" class="remove-btn" onclick="removePrerequisiteInput(this)">Remove</button>';
            container.appendChild(inputGroup);
        }

        function removePrerequisiteInput(btn) {
            var inputGroup = btn.parentNode;
            inputGroup.parentNode.removeChild(inputGroup);
        }
    </script>
</body>
</html>

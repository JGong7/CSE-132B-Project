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
        .checkbox-group {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <h2>Course Entry Form</h2>
    <form action="../process_form/process_course.jsp" method="POST">
        <div class="input-group">
            <label for="action">Action:</label>
            <select id="action" name="action">
                <option value="add">Add</option>
                <option value="update">Update</option>
                <option value="delete">Delete</option>
            </select>
        </div>
        <div class="input-group">
            <label for="courseId">Course ID:</label>
            <input type="number" id="courseId" name="courseId" required>
        </div>
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
            <select id="labRequired" name="labRequired" required>
                <option value="false">False</option>
                <option value="true">True</option>
            </select>
        </div>
        <div class="input-group">
            <label for="consentOfInstructorRequired">Requires Consent of Instructor as Prerequisite:</label>
            <select id="consentOfInstructorRequired" name="consentOfInstructorRequired" required>
                <option value="false">False</option>
                <option value="true">True</option>
            </select>
        </div>
        <div class="checkbox-group">
            <label>Grade Options:</label><br>
            <input type="checkbox" id="gradeLetter" name="gradeOptions[]" value="Letter">
            <label for="gradeLetter">Letter</label><br>
            <input type="checkbox" id="gradePassNoPass" name="gradeOptions[]" value="Pass/No Pass">
            <label for="gradePassNoPass">Pass/No Pass</label><br>
            <input type="checkbox" id="gradeSU" name="gradeOptions[]" value="S/U">
            <label for="gradeSU">S/U</label>
        </div>
        <div class="checkbox-group">
            <label>Available Units:</label><br>
            <input type="checkbox" id="unit1" name="availableUnits[]" value="1">
            <label for="unit1">1</label><br>
            <input type="checkbox" id="unit2" name="availableUnits[]" value="2">
            <label for="unit2">2</label><br>
            <input type="checkbox" id="unit3" name="availableUnits[]" value="3">
            <label for="unit3">3</label><br>
            <input type="checkbox" id="unit4" name="availableUnits[]" value="4">
            <label for="unit4">4</label><br>
            <input type="checkbox" id="unit5" name="availableUnits[]" value="5">
            <label for="unit5">5</label><br>
            <input type="checkbox" id="unit6" name="availableUnits[]" value="6">
            <label for="unit6">6</label>
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
            inputGroup.innerHTML = '<input type="text" name="prerequisites[]" placeholder="Enter prerequisite course number" required>'
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

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Class Enrollment Form</title>
    <script>
        function addClassInput() {
            var container = document.getElementById('classContainer');
            var inputGroup = document.createElement('div');
            inputGroup.className = 'class-group';
            
            var html = '<div>' +
                       '<label>Course Number:</label>' +
                       '<input type="text" name="course_number[]" required>' +
                       '<label>Year:</label>' +
                       '<input type="text" name="year[]" required>' +
                       '<label>Quarter:</label>' +
                       '<input type="text" name="quarter[]" required>' +
                       '<label>Title:</label>' +
                       '<input type="text" name="title[]" required>' +
                       '<label>Section ID:</label>' +
                       '<input type="text" name="section_id[]" required pattern="[A-Za-z0-9]{3}" title="Section ID must be 3 alphanumeric characters.">' +
                       '<label>Status:</label>' +
                       '<select name="status[]" onchange="toggleGradeInput(this)">' +
                       '<option value="taking">Currently Taking</option>' +
                       '<option value="taken">Already Taken</option>' +
                       '</select>' +
                       '<label class="gradeLabel" style="display:none;">Grade:</label>' +
                       '<input type="text" name="grade[]" class="gradeInput" style="display:none;" maxlength="2">' +
                       '<button type="button" onclick="removeClassInput(this)">Remove Class</button>' +
                       '</div>';
            inputGroup.innerHTML = html;
            container.appendChild(inputGroup);
        }

        function removeClassInput(button) {
            var inputGroup = button.parentNode;
            container.removeChild(inputGroup);
        }

        function toggleGradeInput(select) {
            var gradeInput = select.parentNode.querySelector('.gradeInput');
            var gradeLabel = select.parentNode.querySelector('.gradeLabel');
            if (select.value === 'taken') {
                gradeInput.style.display = '';
                gradeLabel.style.display = '';
                gradeInput.required = true;
            } else {
                gradeInput.style.display = 'none';
                gradeLabel.style.display = 'none';
                gradeInput.required = false;
            }
        }
    </script>
</head>
<body>
    <h2>Class Enrollment Details</h2>
    <form action="../processStudentTakeClass.jsp" method="POST">
        <div>
            <label for="student_id">Student ID:</label>
            <input type="text" id="student_id" name="student_id" required pattern="[A-Za-z0-9]{9}" title="Student ID must be 9 alphanumeric characters.">
        </div>
        <div id="classContainer">
            <label>Classes:</label>
            <div>
                <label>Course Number:</label>
                <input type="text" name="course_number[]" required>
                <label>Year:</label>
                <input type="text" name="year[]" required>
                <label>Quarter:</label>
                <input type="text" name="quarter[]" required>
                <label>Title:</label>
                <input type="text" name="title[]" required>
                <label>Section ID:</label>
                <input type="text" name="section_id[]" required pattern="[A-Za-z0-9]{3}" title="Section ID must be 3 alphanumeric characters.">
                <label>Status:</label>
                <select name="status[]" onchange="toggleGradeInput(this)">
                    <option value="taking">Currently Taking</option>
                    <option value="taken">Already Taken</option>
                </select>
                <label class="gradeLabel" style="display:none;">Grade:</label>
                <input type="text" name="grade[]" class="gradeInput" style="display:none;" maxlength="2">
            </div>
            
            <button type="button" onclick="addClassInput()">Add Class</button>
        </div>
        <br><br>
        <button type="submit">Submit Enrollment Details</button>
    </form>
</body>
</html>


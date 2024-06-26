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
            
            let html = `
                <div>
                    <label>Class ID:</label>
                    <input type="text" name="class_id[]" required>
                    <label>Section ID:</label>
                    <input type="text" name="section_id[]">
                    <label>Grading Option:</label>
                    <select name="grading_option[]">
                        <option value="P/NP">P/NP</option>
                        <option value="Letter">Letter</option>
                        <option value="S/U">S/U</option>
                    </select>
                    <label>Units:</label>
                    <select name="units[]">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                    </select>
                    <label>Status:</label>
                    <select name="status[]" onchange="toggleGradeInput(this)">
                        <option value="taking">Currently Taking</option>
                        <option value="taken">Already Taken</option>
                        <option value="waitlisting">Currently Waitlisting</option>
                    </select>
                    <label class="gradeLabel" style="display:none;">Grade:</label>
                    <input type="text" name="grade[]" class="gradeInput" style="display:none;" maxlength="2">
                    <button type="button" onclick="removeClassInput(this)">Remove Class</button>
                </div>
                `;

            inputGroup.innerHTML = html;
            container.appendChild(inputGroup);
        }

        function removeClassInput(button) {
            var inputGroup = button.parentNode.parentNode; // To move up to the parent <div> of the button which is the container of the entire class group
            var container = document.getElementById('classContainer');
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
    <form action="../../process_form/process_class_enrollment.jsp" method="POST">
        <div class="input-group">
            <label for="action">Action:</label>
            <select id="action" name="action">
                <option value="add">Add</option>
                <option value="update">Update</option>
                <option value="delete">Delete</option>
            </select>
        </div>
        <div>
            <label for="student_id">Student ID:</label>
            <input type="text" id="student_id" name="student_id">
        </div>
        <div id="classContainer">
            <label>Classes:</label>
            <div>
                <label>Class ID:</label>
                <input type="text" name="class_id[]" required>
                <label>Section ID:</label>
                <input type="text" name="section_id[]">
                <label>Grading Option:</label>
                <select name="grading_option[]">
                    <option value="P/NP">P/NP</option>
                    <option value="Letter">Letter</option>
                    <option value="S/U">S/U</option>
                </select>
                <label>Units:</label>
                <select name="units[]">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                </select>
                <label>Status:</label>
                <select name="status[]" onchange="toggleGradeInput(this)">
                    <option value="taking">Currently Taking</option>
                    <option value="taken">Already Taken</option>
                    <option value="waitlisting">Currently Waitlisting</option>
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


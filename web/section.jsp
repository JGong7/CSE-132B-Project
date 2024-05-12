<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Section Entry Form</title>
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
    <h2>Section Entry Form</h2>
    <h3>First, indicate the class of the section:</h3>
    <form action="../process_form/process_section.jsp" method="POST">
        <div class="input-group">
            <label for="action">Action:</label>
            <select id="action" name="action">
                <option value="add">Add</option>
                <option value="update">Update</option>
                <option value="delete">Delete</option>
            </select>
        </div>
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

        <div id="sectionsContainer">
            <button type="button" onclick="addSection()">Add Section</button>
        </div>
        <br>
        <input type="submit" value="Submit Section">
    </form>

    <script>
        function addSection() {
            var container = document.getElementById('sectionsContainer');
            var sectionDiv = document.createElement('div');
            sectionDiv.className = 'section';
            sectionDiv.innerHTML = `
                <div class="input-group">
                    <label>Section ID:</label>
                    <input type="text" id="sectionIdInput" name="section_id[]" required>
                </div>
                <div class="input-group">
                    <label>Professor:</label>
                    <input type="text" id="professorInput" name="professor[]" required>
                </div>
                <div class="input-group">
                    <label>Enrollment Limit:</label>
                    <input type="number" id="enrollmentLimitInput" name="enrollmentLimit[]" required>
                </div>
                <div>
                    <button type="button" onclick="this.parentNode.parentNode.remove()">Delete Section</button>
                </div>
            `;
            container.appendChild(sectionDiv);
        }
    </script>

</body>
</html>

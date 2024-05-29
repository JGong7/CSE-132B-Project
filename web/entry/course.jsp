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
    <form action="../../process_form/process_course.jsp" method="POST">
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
        <div id="degreeRequirementsContainer">
            <div class="input-group">
                <label for="degree">Degree ID:</label>
                <input type="text" id="degree" name="degrees[]" required>
                <button type="button" onclick="addDegreeRequirement()">Add Another Degree</button>
            </div>
            <div class="select-group">
                <label for="satisfyLower">Satisfy Lower Degree Requirement:</label><br>
                <select id="satisfyLower" name="satisfyDegreeRequirements[]">
                    <option value="No">No</option>
                    <option value="Yes">Yes</option>
                </select>
            </div>
            <div class="select-group">
                <label for="satisfyUpper">Satisfy Upper Degree Requirement:</label><br>
                <select id="satisfyUpper" name="satisfyDegreeRequirements[]">
                    <option value="No">No</option>
                    <option value="Yes">Yes</option>
                </select>
            </div>
            <div class="select-group">
                <label for="satisfyElective">Satisfy Technical Elective Degree Requirement:</label><br>
                <select id="satisfyElective" name="satisfyDegreeRequirements[]">
                    <option value="No">No</option>
                    <option value="Yes">Yes</option>
                </select>
            </div>
        </div>
        <div id="prerequisitesContainer">
            <label>Prerequisites:</label>
        </div>
        <button type="button" onclick="addPrerequisiteInput()">Add Prerequisite</button>
        <br>
        <input type="submit" value="Submit Course">
    </form>

    <script>
        function addDegreeRequirement() {
            var container = document.getElementById('degreeRequirementsContainer');
            var inputGroup = document.createElement('div');
            inputGroup.className = 'input-group';
            inputGroup.innerHTML = `
                <input type="text" name="degrees[]" placeholder="Enter Degree ID" required>
                <div class="select-group">
                    <label for="satisfyLower">Satisfy Lower Degree Requirement:</label><br>
                    <select id="satisfyLower" name="satisfyDegreeRequirements[]">
                        <option value="No">No</option>
                        <option value="Yes">Yes</option>
                    </select>
                </div>
                <div class="select-group">
                    <label for="satisfyUpper">Satisfy Upper Degree Requirement:</label><br>
                    <select id="satisfyUpper" name="satisfyDegreeRequirements[]">
                        <option value="No">No</option>
                        <option value="Yes">Yes</option>
                    </select>
                </div>
                <div class="select-group">
                    <label for="satisfyElective">Satisfy Technical Elective Degree Requirement:</label><br>
                    <select id="satisfyElective" name="satisfyDegreeRequirements[]">
                        <option value="No">No</option>
                        <option value="Yes">Yes</option>
                    </select>
                </div>
                <button type="button" class="remove-btn" onclick="removeDegreeRequirement(this)">Remove</button>
            `;
            container.appendChild(inputGroup);
        }

        function removeDegreeRequirement(btn) {
            var inputGroup = btn.parentNode;
            inputGroup.parentNode.removeChild(inputGroup);
        }

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

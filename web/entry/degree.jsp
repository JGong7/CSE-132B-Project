<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Degree Requirements Entry Form</title>
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
        .concentration-container {
            margin-left: 20px;
            border: 1px dotted #666;
            padding: 10px;
        }
    </style>
</head>
<body>
    <h2>Degree Requirements Entry Form</h2>
    <form action="../../process_form/process_degree.jsp" method="POST">
        <div class="input-group">
            <label for="action">Action:</label>
            <select id="action" name="action">
                <option value="add">Add</option>
                <option value="update">Update</option>
                <option value="delete">Delete</option>
            </select>
        </div>
        <div class="input-group">
            <label for="degreeId">Degree Code:</label>
            <input type="text" id="degreeId" name="degreeId" required>
        </div>
        <div class="input-group">
            <label for="degreeName">Degree Name:</label>
            <input type="text" id="degreeName" name="degreeName" required>
        </div>
        <div class="input-group">
            <label for="type">Degree Type:</label>
            <select id="type" name="type">
                <option value="B.S.">B.S.</option>
                <option value="B.A.">B.A.</option>
                <option value="B.S./M.S.">B.S./M.S.</option>
                <option value="M.S.">M.S.</option>
                <option value="M.A.">M.A.</option>
                <option value="M.Eng">M.Eng</option>
                <option value="MFA">MFA</option>
                <option value="MAS">MAS</option>
                <option value="PhD">PhD</option>
            </select>
        </div>
        <div class="input-group">
            <label for="department">Department:</label>
            <input type="text" id="department" name="department" required>
        </div>
        <div id="concentrationsContainer" style="display:none;">
            <button type="button" onclick="addConcentration()">Add Concentration</button>
        </div>
        <div class="input-group">
            <label for="lowerUnits">Required Number of Lower Units:</label>
            <input type="text" id="lowerUnits" name="lowerUnits">
        </div>
        <div class="input-group">
            <label for="upperUnits">Required Number of Upper Units:</label>
            <input type="text" id="upperUnits" name="upperUnits">
        </div>
        <div class="input-group">
            <label for="elecUnits">Required Number of Technical Elective Units:</label>
            <input type="text" id="elecUnits" name="elecUnits">
        </div>
        <br>
        <input type="submit" value="Submit Degree Requirement">
    </form>

    <script>
        var selectType = document.getElementById('type');
        var concentrationsContainer = document.getElementById('concentrationsContainer');

        selectType.addEventListener('change', function() {
            if (this.value === 'M.S.' || this.value === 'M.A.' || this.value === 'M.Eng' || this.value === 'MFA' || this.value === 'MAS') {
                concentrationsContainer.style.display = 'block';
            } else {
                concentrationsContainer.style.display = 'none';
            }
        });

        function addConcentration() {
            var container = document.createElement('div');
            container.className = 'concentration-container';
            container.innerHTML = `
                <div class="input-group">
                    <label>Concentration:</label>
                    <input type="text" name="concentration[]" required>
                    <button type="button" class="remove-btn" onclick="removeConcentration(this)">Remove</button>
                </div>
                <button type="button" onclick="addCourse(this.parentNode)">Add Course</button>
            `;
            concentrationsContainer.appendChild(container);
            concentrationCount++;
        }

        function addCourse(concentrationDiv) {
            var courseInput = document.createElement('div');
            courseInput.className = 'input-group';
            courseInput.innerHTML = `
                <label>Course ID:</label>
                <input type="number" name="courseId` + getConcentrationIndex(concentrationDiv) + `[]" required>
                <button type="button" class="remove-btn" onclick="removeInput(this)">Remove</button>
            `;
            concentrationDiv.appendChild(courseInput);
        }

        function getConcentrationIndex(concentrationDiv) {
            return Array.from(concentrationsContainer.children).indexOf(concentrationDiv) - 1;
        }

        function removeConcentration(button) {
            button.parentNode.parentNode.remove();
            concentrationCount--;
        }

        function removeInput(button) {
            button.parentNode.remove();
        }
    </script>
</body>
</html>

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
    </style>
</head>
<body>
    <h2>Degree Requirements Entry Form</h2>
    <form action="../process_form/process_degree.jsp" method="POST">
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
                <option value="M.S">M.S.</option>
                <option value="M.A">M.A.</option>
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
        <div class="input-group">
            <label for="concentration">Degree Concentration:</label>
            <input type="text" id="concentration" name="concentration">
        </div>
        <div class="input-group">
            <label for="upperUnits">Required Number of Upper Units:</label>
            <input type="text" id="upperUnits" name="upperUnits">
        </div>
        <div class="input-group">
            <label for="lowerUnits">Required Number of Lower Units:</label>
            <input type="text" id="lowerUnits" name="lowerUnits">
        </div>
        <br>
        <input type="submit" value="Submit Degree Requirement">
    </form>

    <script>
            var selectType = document.getElementById('type');
            var concentrationGroup = document.getElementById('concentration').parentNode;
            var concentrationInput = document.getElementById('concentration');
    
            // Hide the concentration input field initially
            concentrationGroup.style.display = 'none';
    
            selectType.addEventListener('change', function() {
                // Check the selected value
                if (this.value === 'B.S.' || this.value === 'B.A.' || this.value === 'PhD') {
                    concentrationGroup.style.display = 'none';
                    concentrationInput.value = '';
                } else {
                    concentrationGroup.style.display = 'block';
                }
            });
    </script>
</body>
</html>
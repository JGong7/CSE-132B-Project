<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Faculty Entry Form</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <h2>Enter Faculty Details</h2>
    <form action="../../process_form/process_faculty.jsp" method="POST">
        <div class="input-group">
            <label for="action">Action:</label>
            <select id="action" name="action">
                <option value="add">Add</option>
                <option value="update">Update</option>
                <option value="delete">Delete</option>
            </select>
        </div>
        <div class="input-group">
            <label for="name">Faculty Name:</label>
            <input type="text" id="name" name="name" required>
        </div>
        <div class="input-group">
            <label for="title">Title:</label>
            <input type="text" id="title" name="title" required>
        </div>
        <div id="departmentContainer" class="input-group">
            <label>Department:</label>
            <input type="text" name="departments[]" required>
        </div>
        <button type="button" onclick="addDepartmentInput()">Add Department</button>
        
        <button type="submit">Submit Faculty Details</button>
    </form>
</body>
<script>
    function addDepartmentInput() {
            var container = document.getElementById('departmentContainer');
            var inputGroup = document.createElement('div');
            inputGroup.className = 'input-group';
            inputGroup.innerHTML = '<input type="text" name="departments[]" placeholder="Enter department">'
                                 + '<button type="button" class="remove-btn" onclick="removeDepartmentInput(this)">Remove</button>';
            container.appendChild(inputGroup);
        }

    function removeDepartmentInput(btn) {
        var inputGroup = btn.parentNode;
        inputGroup.parentNode.removeChild(inputGroup);
    }
</script>
</html>

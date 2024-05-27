<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thesis Committee Entry Form</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
        .professor-field {
            margin-bottom: 5px;
        }
        .remove-btn {
            margin-left: 10px;
            cursor: pointer;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <h1>Thesis Committee Entry Form</h1>
    <form action="../../process_form/process_thesis_committee.jsp" method="post">
        <div class="input-group">
            <label for="action">Action:</label>
            <select id="action" name="action">
                <option value="add">Add</option>
                <option value="update">Update</option>
                <option value="delete">Delete</option>
            </select>
        </div>
        <div class="input-group">
            <label for="student_id">Student ID:</label>
            <input type="text" id="student_id" name="student_id" maxlength="9" required>
        </div>
        <div class="input-group">
            <label for="department">Department:</label>
            <input type="text" id="department" name="department" required>
        </div>
        <div class="input-group">
            <label>Internal Professors:</label>
            <div id="internalProfessors">
                <!-- Initialize three internal professor fields -->
                <div class="professor-field">
                    <input type="text" name="internalProfessor[]" placeholder="Professor Name">
                </div>
                <div class="professor-field">
                    <input type="text" name="internalProfessor[]" placeholder="Professor Name">
                </div>
                <div class="professor-field">
                    <input type="text" name="internalProfessor[]" placeholder="Professor Name">
                </div>
            </div>
            <button type="button" onclick="addProfessorField(false)">Add Another Professor Within Department</button>
        </div>
        <div class="input-group">
            <label>Are you a PhD student?</label>
            <select id="isPhd" name="isPhd" onchange="toggleExternalField()" required>
                <option value="false">No</option>
                <option value="true">Yes</option>
            </select>
        </div>
        <div id="externalProfessors" class="hidden">
            <label>External Professors:</label>
            <div class="professor-field">
                <input type="text" name="externalProfessor[]" placeholder="External Professor Name">
            </div>
            <button type="button" onclick="addProfessorField(true)">Add Another Professor Outside Department</button>
        </div>
        <input type="submit" value="Submit Thesis Committee">
    </form>

<script>
    function addProfessorField(isExternal) {
        var container = isExternal ? document.getElementById("externalProfessors") : document.getElementById("internalProfessors");
        var div = document.createElement("div");
        div.className = 'professor-field';
        div.innerHTML = `<input type="text" name="${isExternal ? 'externalProfessor[]' : 'internalProfessor[]'}" placeholder="${isExternal ? 'External Professor Name' : 'Professor Name'}">
                         <button type="button" class="remove-btn" onclick="removeInputField(this)">Remove</button>`;
        container.appendChild(div);
    }

    function removeInputField(element) {
        var field = element.parentNode;
        if(field.parentNode) {
            field.parentNode.removeChild(field);
        }
    }

    function toggleExternalField() {
        var isPhd = document.getElementById("isPhd").value;
        var externalDiv = document.getElementById("externalProfessors");
        
        externalDiv.style.display = isPhd === 'true' ? 'block' : 'none';
    }
</script>
</body>
</html>

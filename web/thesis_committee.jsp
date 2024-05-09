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
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <h1>Thesis Committee Entry Form</h1>
    <form action="submitForm.jsp" method="post">
        <div id="input-group">
            <label for="student_id">Student ID:</label>
            <input type="text" id="student_id" name="student_id" maxlength="9" required>
        </div>
        <div id="input-group">
            <label for="department">Department:</label>
            <input type="text" id="department" name="department" required>
        </div>
        <div id="input-group">
            <label>Internal Professors:</label>
            <div id="internalProfessors">
                <!-- Initialize three internal professor fields -->
                <input type="text" name="internalProfessor[]" placeholder="Professor Name">
                <input type="text" name="internalProfessor[]" placeholder="Professor Name">
                <input type="text" name="internalProfessor[]" placeholder="Professor Name">
            </div>
            <button type="button" onclick="addProfessorField(false)">Add Another Professor Within Department</button>
        </div>
        <div id="input-group">
            <label>Are you a PhD student?</label>
            <select id="isPhd" name="isPhd" onchange="toggleExternalField()" required>
                <option value="false">No</option>
                <option value="true">Yes</option>
            </select>
        </div>
        <div id="externalProfessors" style="display: none;">
            <label>External Professors:</label>
            <input type="text" name="externalProfessor[]" placeholder="External Professor Name">
            <button type="button" onclick="addProfessorField(true)">Add Another Professor Outside Department</button>
        </div>
        <input type="submit" value="Submit Thesis Committee">
    </form>

<script>
    function addProfessorField(isExternal) {
        var container = isExternal ? document.getElementById("externalProfessors") : document.getElementById("internalProfessors");
        var input = document.createElement("input");
        input.type = "text";
        input.name = isExternal ? "externalProfessor[]" : "internalProfessor[]";
        input.placeholder = isExternal ? "External Professor Name" : "Professor Name";
        container.appendChild(input);
        container.appendChild(document.createElement("br"));
    }

    function toggleExternalField() {
        var isPhd = document.getElementById("isPhd").value;
        var externalDiv = document.getElementById("externalProfessors");
        
        externalDiv.style.display = isPhd === 'true' ? 'block' : 'none';
    }
</script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Entry Form</title>
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
    <h2>Student Entry Form</h2>
    <form action="../process_form/process_student.jsp" method="POST">
        <div class="input-group">
            <label for="studentType">Student Type:</label>
            <select id="studentType" name="studentType" onchange="showRelevantFields()">
                <option value="">Select type</option>
                <option value="Undergraduate">Undergraduate</option>
                <option value="BSMS">BSMS</option>
                <option value="Master">Master</option>
                <option value="PhD">PhD</option>
            </select>
        </div>

        <div class="input-group">
            <label for="studentId">Student ID:</label>
            <input type="text" id="studentId" name="studentId" required>
        </div>
        <div class="input-group">
            <label for="firstName">First Name:</label>
            <input type="text" id="firstName" name="firstName" required>
        </div>
        <div class="input-group">
            <label for="middleName">Middle Name:</label>
            <input type="text" id="middleName" name="middleName">
        </div>
        <div class="input-group">
            <label for="lastName">Last Name:</label>
            <input type="text" id="lastName" name="lastName" required>
        </div>
        <div class="input-group">
            <label for="ssn">SSN:</label>
            <input type="text" id="ssn" name="ssn">
        </div>
        <div class="input-group">
            <label for="residentialStatus">Residential Status:</label>
            <input type="text" id="residentialStatus" name="residentialStatus">
        </div>
        <div class="input-group">
            <label for="enrolled">Enrolled:</label>
            <select id="enrolled" name="enrolled" required>
                <option value="true">Yes</option>
                <option value="false">No</option>
            </select>
        </div>

        <!-- Undergraduate Fields -->
        <div id="undergraduateFields" class="hidden">
            <div class="input-group">
                <label for="undergraduateCollege">College:</label>
                <input type="text" id="undergraduateCollege" name="undergraduateCollege">
            </div>
        </div>

        <!-- BSMS Fields -->
        <div id="bsmsFields" class="hidden">
            <div class="input-group">
                <label for="bsmsCollege">College:</label>
                <input type="text" id="bsmsCollege" name="bsmsCollege">
            </div>
            <div class="input-group">
                <label for="bsmsDepartment">Department:</label>
                <input type="text" id="bsmsDepartment" name="bsmsDepartment">
            </div>
            <div class="input-group">
                <label for="bsmsPlan">Plan:</label>
                <input type="text" id="bsmsPlan" name="bsmsPlan">
            </div>
        </div>

        <!-- Master Fields -->
        <div id="masterFields" class="hidden">
            <div class="input-group">
                <label for="masterDepartment">Department:</label>
                <input type="text" id="masterDepartment" name="masterDepartment">
            </div>
            <div class="input-group">
                <label for="masterPlan">Plan:</label>
                <input type="text" id="masterPlan" name="masterPlan">
            </div>
        </div>

        <!-- PhD Fields -->
        <div id="phdFields" class="hidden">
            <div class="input-group">
                <label for="phdDepartment">Department:</label>
                <input type="text" id="phdDepartment" name="phdDepartment">
            </div>
            <div class="input-group">
                <label for="candidacyStatus">Candidacy Status:</label>
                <select id="candidacyStatus" name="candidacyStatus" required>
                    <option value="select">-- Select Status --</option>
                    <option value="pre-candidacy">Pre-Candidacy</option>
                    <option value="candidate">Candidate</option>
                </select>
            </div>
            <div class="input-group">
                <label for="advisor">Advisor:</label>
                <input type="text" id="advisor" name="advisor">
            </div>
        </div>

        <input type="submit" value="Submit Student">
    </form>

    <script>
        function showRelevantFields() {
            // Hide all fields first
            document.getElementById('undergraduateFields').style.display = 'none';
            document.getElementById('bsmsFields').style.display = 'none';
            document.getElementById('masterFields').style.display = 'none';
            document.getElementById('phdFields').style.display = 'none';

            // Show fields based on selection
            var studentType = document.getElementById('studentType').value;
            switch (studentType) {
                case 'Undergraduate':
                    document.getElementById('undergraduateFields').style.display = 'block';
                    break;
                case 'BSMS':
                    document.getElementById('bsmsFields').style.display = 'block';
                    break;
                case 'Master':
                    document.getElementById('masterFields').style.display = 'block';
                    break;
                case 'PhD':
                    document.getElementById('phdFields').style.display = 'block';
                    break;
            }
        }
    </script>
</body>
</html>

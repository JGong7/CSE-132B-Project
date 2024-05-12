<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Class Entry Form</title>
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
    <h2>Class Entry Form</h2>
    <form action="../process_form/process_class_section_meeting.jsp" method="POST">
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
        <input type="submit" value="Submit Class">
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
                    <button type="button" onclick="addMeeting(this.parentNode.parentNode)">Add Meeting</button>
                </div>
                <div>
                    <button type="button" onclick="this.parentNode.parentNode.remove()">Delete Section</button>
                </div>
            `;
            container.appendChild(sectionDiv);
        }

        function addMeeting(sectionDiv) {
            let sectionID = sectionDiv.querySelector('#sectionIdInput').value;
            console.log(sectionID);

            if (!sectionID) {
                alert('Please enter a Section ID before adding meetings.');
                return; // Exit if no section ID is entered
            }

            let meetingDiv = document.createElement('div');
            meetingDiv.className = 'meeting';
            meetingDiv.innerHTML = `
                <div class="input-group">
                    <label>Type:</label>
                    <input type="text" name="type` + sectionID + `[]" required>
                </div>
                <div class="input-group">
                    <label>Room:</label>
                    <input type="text" name="room` + sectionID + `[]" required>
                </div>
                <div class="input-group">
                    <label>Building:</label>
                    <input type="text" name="building` + sectionID + `[]" required>
                </div>
                <div class="input-group">
                    <label>Start Time:</label>
                    <input type="time" name="timeStart` + sectionID + `[]" required>
                </div>
                <div class="input-group">
                    <label>End Time:</label>
                    <input type="time" name="timeEnd` + sectionID + `[]" required>
                </div>
                <div class="input-group">
                    <label>Start Date:</label>
                    <input type="date" name="dateStart` + sectionID + `[]" required>
                </div>
                <div class="input-group">
                    <label>End Date:</label>
                    <input type="date" name="dateEnd` + sectionID + `[]" required>
                </div>
                <div class="input-group">
                    <label>Mandatory:</label>
                    <select name="mandatory` + sectionID + `[]" required>
                        <option value="true">Yes</option>
                        <option value="false">No</option>
                    </select>
                </div>
                <div class="checkbox-group">
                    <label>Days:</label><br>
                    <input type="checkbox" name="days` + sectionID + `[]" value="Monday"> Monday<br>
                    <input type="checkbox" name="days` + sectionID + `[]" value="Tuesday"> Tuesday<br>
                    <input type="checkbox" name="days` + sectionID + `[]" value="Wednesday"> Wednesday<br>
                    <input type="checkbox" name="days` + sectionID + `[]" value="Thursday"> Thursday<br>
                    <input type="checkbox" name="days` + sectionID + `[]" value="Friday"> Friday
                </div>
                <div>
                    <button type="button" onclick="this.parentNode.parentNode.remove()">Delete Meeting</button>
                </div>
            `; 
            sectionDiv.appendChild(meetingDiv);
        }
    </script>

</body>
</html>

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
    <form action="../process_form/process_class.jsp" method="POST">
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
                    <label>Professor:</label>
                    <input type="text" name="professor[]" required>
                </div>
                <div class="input-group">
                    <label>Enrollment Limit:</label>
                    <input type="number" name="enrollmentLimit[]" required>
                </div>
                <div>
                    <button type="button" onclick="addMeeting(this.parentNode)">Add Meeting</button>
                </div>
            `;
            container.appendChild(sectionDiv);
        }

        function addMeeting(sectionDiv) {
            var meetingDiv = document.createElement('div');
            meetingDiv.className = 'meeting';
            meetingDiv.innerHTML = `
                <div class="input-group">
                    <label>Type:</label>
                    <input type="text" name="type[]" required>
                </div>
                <div class="input-group">
                    <label>Room:</label>
                    <input type="text" name="room[]" required>
                </div>
                <div class="input-group">
                    <label>Building:</label>
                    <input type="text" name="building[]" required>
                </div>
                <div class="input-group">
                    <label>Start Time:</label>
                    <input type="time" name="timeStart[]" required>
                </div>
                <div class="input-group">
                    <label>End Time:</label>
                    <input type="time" name="timeEnd[]" required>
                </div>
                <div class="input-group">
                    <label>Start Date:</label>
                    <input type="date" name="dateStart[]" required>
                </div>
                <div class="input-group">
                    <label>End Date:</label>
                    <input type="date" name="dateEnd[]" required>
                </div>
                <div class="input-group">
                    <label>Mandatory:</label>
                    <select name="mandatory[]" required>
                        <option value="true">Yes</option>
                        <option value="false">No</option>
                    </select>
                </div>
                <div class="checkbox-group">
                    <label>Days:</label><br>
                    <input type="checkbox" name="days[${sectionDiv.children.length - 1}][]" value="Monday"> Monday<br>
                    <input type="checkbox" name="days[${sectionDiv.children.length - 1}][]" value="Tuesday"> Tuesday<br>
                    <input type="checkbox" name="days[${sectionDiv.children.length - 1}][]" value="Wednesday"> Wednesday<br>
                    <input type="checkbox" name="days[${sectionDiv.children.length - 1}][]" value="Thursday"> Thursday<br>
                    <input type="checkbox" name="days[${sectionDiv.children.length - 1}][]" value="Friday"> Friday
                </div>
            `;
            sectionDiv.appendChild(meetingDiv);
        }
    </script>
</body>
</html>

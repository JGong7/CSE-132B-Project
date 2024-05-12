<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Meeting Entry Form</title>
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
    <h2>Meeting Entry Form</h2>
    <h3>First indicate the class and the section that this meeting corresponds to:</h3>
    <form action="../process_form/process_meeting.jsp" method="POST">
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

        <div class="input-group">
            <label>Section ID:</label>
            <input type="text" id="section_id" name="section_id" required>
        </div>
        <div>
            <button type="button" onclick="addMeeting(this.parentNode.parentNode)">Add Meeting</button>
        </div>
        <br>
        <input type="submit" value="Submit Meeting">
    </form>

    <script>

        function addMeeting(sectionDiv) {

            let meetingDiv = document.createElement('div');
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
                    <input type="text" name="days[]"><br>
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

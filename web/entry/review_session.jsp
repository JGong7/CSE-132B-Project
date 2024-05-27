<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Review Session Entry Form</title>
    <style>
        form {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ccc;
        }
        .input-group {
            margin-bottom: 10px;
        }
        .section, .session {
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
    <h2>Review Session Entry Form</h2>
    <h3>First indicate the class and the section that this review session corresponds to:</h3>
    <form action="../../process_form/process_review_session.jsp" method="POST">
        <div class="input-group">
            <label for="action">Action:</label>
            <select id="action" name="action">
                <option value="add">Add</option>
                <option value="update">Update</option>
                <option value="delete">Delete</option>
            </select>
        </div>
        <div class="input-group">
            <label for="classid">Class ID:</label>
            <input type="text" id="classid" name="classid" required>
        </div>

        <div class="input-group">
            <label>Section ID:</label>
            <input type="text" id="section_id" name="section_id" required>
        </div>
        <div>
            <button type="button" onclick="addSession(this.parentNode.parentNode)">Add Review Session</button>
        </div>
        <br>
        <input type="submit" value="Submit Review Session">
    </form>

    <script>

        function addSession(sectionDiv) {

            let sessionDiv = document.createElement('div');
            sessionDiv.className = 'session';
            sessionDiv.innerHTML = `
                <div class="input-group">
                    <label>Review session id: (only put this if you want to update/delete) </label>
                    <input type="number" name="review_session_id[]">
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
                    <label>Date:</label>
                    <input type="date" name="date[]" required>
                </div>
                <div class="input-group">
                    <label>Mandatory:</label>
                    <select name="mandatory[]" required>
                        <option value="true">Yes</option>
                        <option value="false">No</option>
                    </select>
                </div>
                <div>
                    <button type="button" onclick="this.parentNode.parentNode.remove()">Delete Review Session</button>
                </div>
            `; 
            sectionDiv.appendChild(sessionDiv);
        }
    </script>

</body>
</html>

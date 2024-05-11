<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Account Entry Form</title>
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
        .checkbox-group {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <h2>Account Entry Form</h2>
    <form action="../process_form/process_account.jsp" method="POST">
        <div class="input-group">
            <label for="student_id">Student ID:</label>
            <input type="text" id="student_id" name="student_id" required>
        </div>
        <div class="input-group">
            <label for="account">Account Number:</label>
            <input type="text" id="account" name="account" required>
        </div>
        <div class="input-group">
            <label for="balance">Account Balance:</label>
            <input type="text" id="balance" name="balance" required>
        </div>
        <div id="paymentContainer" class="input-group">
            <label>Payment Methods:</label>
            <input type="text" name="paymentMethods[]">
            <button type="button" onclick="addMethodField(true)">Add Another Payment Method</button>
        </div>
        <div id="historyContainer" class="input-group">
            <label>Payment History:</label>
            <button type="button" onclick="addHistoryField(true)">Add Another Previous Payment</button>
        </div>
        <br>
        <input type="submit" value="Submit Account">
    </form>

    <script>
        function addMethodField() {
            var container = document.getElementById('paymentContainer');
            var inputGroup = document.createElement('div');
            inputGroup.className = 'input-group';
            inputGroup.innerHTML = '<input type="text" name="paymentMethods[]" placeholder="Enter payment method" required>'
                                + '<button type="button" class="remove-btn" onclick="removeMethodInput(this)">Remove</button>';
            container.appendChild(inputGroup);
        }

        function removeMethodInput(btn) {
            var inputGroup = btn.parentNode;
            inputGroup.parentNode.removeChild(inputGroup);
        }

        function addHistoryField() {
            var container = document.getElementById('historyContainer');
            var inputGroup = document.createElement('div');
            inputGroup.className = 'input-group';
            inputGroup.innerHTML = '<input type="number" step="0.01" name="amountHistory[]" placeholder="Enter amount of payment" required>'
                                + '<input type="datetime-local" name="paymentTime[]" placeholder="Enter time of payment" required>'
                                + '<button type="button" class="remove-btn" onclick="removeHistoryInput(this)">Remove</button>';
            container.appendChild(inputGroup);
        }

        function removeHistoryInput(btn) {
            var inputGroup = btn.parentNode;
            inputGroup.parentNode.removeChild(inputGroup);
        }
    </script>
</body>
</html>

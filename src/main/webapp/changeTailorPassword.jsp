<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Tailor Password</title>

<style>
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: #0f172a;
    color: #e5e7eb;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.card {
    background: #020617;
    padding: 30px;
    border-radius: 12px;
    width: 100%;
    max-width: 400px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
}

input {
    width: 100%;
    padding: 12px;
    margin-bottom: 8px;
    border-radius: 8px;
    border: 1px solid #334155;
    background: #0f172a;
    color: white;
    transition: all 0.3s ease;
    box-sizing: border-box;
}

input:focus {
    outline: none;
    border-color: #22c55e;
    box-shadow: 0 0 5px rgba(34, 197, 94, 0.3);
}

.valid { border-color: #22c55e; }
.invalid { border-color: #ef4444; }

.error-message {
    color: #ef4444;
    font-size: 12px;
    display: none;
    margin-bottom: 8px;
    animation: fadeIn 0.3s ease;
}

.success-message {
    color: #22c55e;
    font-size: 14px;
    padding: 10px;
    background: #14532d;
    border-radius: 5px;
    margin-bottom: 15px;
    text-align: center;
    animation: slideDown 0.5s ease;
}

.error-alert {
    color: #ef4444;
    font-size: 14px;
    padding: 10px;
    background: #7f1d1d;
    border-radius: 5px;
    margin-bottom: 15px;
    text-align: center;
    animation: slideDown 0.5s ease;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.validation-rules {
    margin: 10px 0;
    padding: 10px;
    background: #0f172a;
    border-radius: 8px;
}

.validation-rules ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.validation-rules li {
    padding: 5px 0;
    font-size: 12px;
    transition: color 0.3s ease;
}

.validation-rules li.valid { 
    color: #22c55e; 
}

.validation-rules li.invalid { 
    color: #94a3b8; 
}

.validation-rules li.valid::before {
    content: "✓ ";
    color: #22c55e;
}

.validation-rules li.invalid::before {
    content: "✗ ";
    color: #94a3b8;
}

.strength-bar-container {
    height: 8px;
    background: #334155;
    border-radius: 5px;
    margin: 10px 0;
    overflow: hidden;
}

#strengthBar {
    height: 100%;
    width: 0%;
    transition: width 0.3s ease, background 0.3s ease;
    border-radius: 5px;
}

.strength-text {
    font-size: 11px;
    margin-top: 5px;
    text-align: right;
}

.change-btn {
    background: #22c55e;
    color: black;
    border-radius: 30px;
    padding: 12px;
    margin: 8px 0;
    font-weight: bold;
    cursor: pointer;
    border: none;
    width: 100%;
    transition: all 0.3s ease;
}

.change-btn:hover:not(:disabled) {
    background: #16a34a;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.change-btn:disabled {
    background: #64748b;
    cursor: not-allowed;
    opacity: 0.6;
}

.back-btn {
    background: #2563eb;
    color: white;
    border-radius: 30px;
    padding: 12px;
    margin: 8px 0;
    font-weight: bold;
    cursor: pointer;
    border: none;
    width: 100%;
    transition: all 0.3s ease;
}

.back-btn:hover {
    background: #1e40af;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.button-row {
    display: flex;
    gap: 15px;
    margin-top: 20px;
}

.button-row button {
    flex: 1;
}

h2 {
    text-align: center;
    margin-bottom: 25px;
    color: #22c55e;
}
</style>
</head>

<body>

<div class="card">
    <div id="messageContainer"></div>
    
    <h2>Change Password</h2>

    <form id="passwordForm" action="TailorPasswordChange" method="post">
        <input type="password" id="oldPassword" name="oldPassword" placeholder="Old Password">
        <div id="oldPasswordError" class="error-message"></div>

        <input type="password" id="newPassword" name="newPassword" placeholder="New Password">
        <div id="newPasswordError" class="error-message"></div>

        <div class="strength-bar-container">
            <div id="strengthBar"></div>
        </div>
        <div id="strengthText" class="strength-text"></div>

        <div class="validation-rules">
            <ul>
                <li id="rule-length">At least 8 characters</li>
                <li id="rule-uppercase">Uppercase letter (A-Z)</li>
                <li id="rule-lowercase">Lowercase letter (a-z)</li>
                <li id="rule-digit">Digit (0-9)</li>
                <li id="rule-special">Special character (@$!%*?&amp;)</li>
            </ul>
        </div>

        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password">
        <div id="confirmPasswordError" class="error-message"></div>

        <div class="button-row">
            <button type="submit" id="submitBtn" class="change-btn" disabled>Change Password</button>
            <button type="button" class="back-btn" onclick="location.href='tailorAccount.jsp'">Back</button>
        </div>
    </form>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const oldPassword = document.getElementById('oldPassword');
    const newPassword = document.getElementById('newPassword');
    const confirmPassword = document.getElementById('confirmPassword');
    const submitBtn = document.getElementById('submitBtn');
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');
    
    const errorOld = document.getElementById('oldPasswordError');
    const errorNew = document.getElementById('newPasswordError');
    const errorConfirm = document.getElementById('confirmPasswordError');
    
    const rules = {
        length: document.getElementById('rule-length'),
        uppercase: document.getElementById('rule-uppercase'),
        lowercase: document.getElementById('rule-lowercase'),
        digit: document.getElementById('rule-digit'),
        special: document.getElementById('rule-special')
    };
    
    function displayMessage(type, message) {
        const container = document.getElementById('messageContainer');
        const messageDiv = document.createElement('div');
        messageDiv.className = type === 'error' ? 'error-alert' : 'success-message';
        messageDiv.textContent = message;
        container.innerHTML = '';
        container.appendChild(messageDiv);
        
        if (type === 'error') {
            setTimeout(() => {
                messageDiv.style.opacity = '0';
                setTimeout(() => {
                    if (messageDiv.parentNode) {
                        messageDiv.remove();
                    }
                }, 500);
            }, 5000);
        }
    }
    
    <% 
    String error = (String) session.getAttribute("errorMsg");
    if (error != null) { 
    %>
        displayMessage('error', '<%= error %>');
        <% session.removeAttribute("errorMsg"); %>
    <% 
    }

    %>
    
    function areAllFieldsFilled() {
        return oldPassword.value.trim() !== "" && 
               newPassword.value.trim() !== "" && 
               confirmPassword.value.trim() !== "";
    }
    
    function isNewPasswordDifferent() {
        if (oldPassword.value.trim() === "" || newPassword.value.trim() === "") {
            return true;
        }
        return oldPassword.value.trim() !== newPassword.value.trim();
    }
    
    function getPasswordStrength(password) {
        let strength = 0;
        let checks = {
            length: password.length >= 8,
            uppercase: /[A-Z]/.test(password),
            lowercase: /[a-z]/.test(password),
            digit: /[0-9]/.test(password),
            special: /[@$!%*?&]/.test(password)
        };
        
        if (checks.length) strength++;
        if (checks.uppercase) strength++;
        if (checks.lowercase) strength++;
        if (checks.digit) strength++;
        if (checks.special) strength++;
        
        rules.length.className = checks.length ? 'valid' : 'invalid';
        rules.uppercase.className = checks.uppercase ? 'valid' : 'invalid';
        rules.lowercase.className = checks.lowercase ? 'valid' : 'invalid';
        rules.digit.className = checks.digit ? 'valid' : 'invalid';
        rules.special.className = checks.special ? 'valid' : 'invalid';
        
        return { strength, checks };
    }
    
    function updateStrengthMeter(password) {
        if (password === "") {
            strengthBar.style.width = "0%";
            strengthBar.style.background = "#334155";
            strengthText.textContent = "";
            return;
        }
        
        const { strength } = getPasswordStrength(password);
        const percent = (strength / 5) * 100;
        strengthBar.style.width = percent + "%";
        
        let color, text;
        if (strength <= 2) {
            color = "#ef4444";
            text = "Weak";
        } else if (strength <= 3) {
            color = "#f59e0b";
            text = "Medium";
        } else if (strength <= 4) {
            color = "#84cc16";
            text = "Strong";
        } else {
            color = "#22c55e";
            text = "Very Strong";
        }
        
        strengthBar.style.background = color;
        strengthText.textContent = text;
        strengthText.style.color = color;
    }
    
    function validateOld() {
        if (oldPassword.value.trim() === "") {
            errorOld.style.display = "block";
            errorOld.textContent = "Old password is required";
            oldPassword.classList.add("invalid");
            return false;
        }
        errorOld.style.display = "none";
        oldPassword.classList.remove("invalid");
        return true;
    }
    
    function validateNew() {
        const p = newPassword.value.trim();
        
        if (p === "") {
            errorNew.style.display = "none";
            newPassword.classList.remove("invalid");
            updateStrengthMeter("");
            return false;
        }
        
        const { strength, checks } = getPasswordStrength(p);
        const isValid = strength === 5; 
        
        if (!isValid) {
            errorNew.style.display = "block";
            errorNew.textContent = "Password does not meet all requirements";
            newPassword.classList.add("invalid");
            return false;
        }
        
        if (oldPassword.value.trim() !== "" && p === oldPassword.value.trim()) {
            errorNew.style.display = "block";
            errorNew.textContent = "New password cannot be same as old password!";
            newPassword.classList.add("invalid");
            return false;
        }
        
        errorNew.style.display = "none";
        newPassword.classList.remove("invalid");
        return true;
    }
    
    function validateConfirm() {
        if (confirmPassword.value.trim() === "") {
            errorConfirm.style.display = "none";
            confirmPassword.classList.remove("invalid");
            return false;
        }
        
        if (newPassword.value.trim() === confirmPassword.value.trim()) {
            errorConfirm.style.display = "none";
            confirmPassword.classList.remove("invalid");
            return true;
        } else {
            errorConfirm.style.display = "block";
            errorConfirm.textContent = "x Passwords do not match!";
            confirmPassword.classList.add("invalid");
            return false;
        }
    }
    
    function updateSubmitButton() {
        const oldValid = validateOld();
        const newValid = validateNew();
        const confirmValid = validateConfirm();
        const allFilled = areAllFieldsFilled();
        const differentPassword = isNewPasswordDifferent();
        
        if (allFilled && oldValid && newValid && confirmValid && differentPassword) {
            submitBtn.disabled = false;
        } else {
            submitBtn.disabled = true;
        }
    }
    
    function clearServerMessages() {
        const container = document.getElementById('messageContainer');
        if (container.children.length > 0) {
            container.innerHTML = '';
        }
    }
    
    oldPassword.addEventListener('input', () => {
        validateOld();
        updateSubmitButton();
        clearServerMessages();
        
        if (newPassword.value.trim() !== "") {
            validateNew();
            updateSubmitButton();
        }
    });
    
    newPassword.addEventListener('input', () => {
        updateStrengthMeter(newPassword.value);
        validateNew();
        validateConfirm();
        updateSubmitButton();
        clearServerMessages();
    });
    
    confirmPassword.addEventListener('input', () => {
        validateConfirm();
        updateSubmitButton();
        clearServerMessages();
    });
    
    document.getElementById('passwordForm').addEventListener('submit', function(e) {
        if (!areAllFieldsFilled()) {
            e.preventDefault();
            validateOld();
            if (newPassword.value.trim() === "") {
                errorNew.style.display = "block";
                errorNew.textContent = "Password is required";
            }
            if (confirmPassword.value.trim() === "") {
                errorConfirm.style.display = "block";
                errorConfirm.textContent = "Please confirm your password";
            }
            return;
        }
        
        if (!validateOld() || !validateNew() || !validateConfirm()) {
            e.preventDefault();
            return;
        }
        
        if (!isNewPasswordDifferent()) {
            e.preventDefault();
            errorNew.style.display = "block";
            errorNew.textContent = " New password cannot be same as old password!";
            return;
        }
        
        submitBtn.disabled = true;
        submitBtn.textContent = "Processing...";
    });
    
    updateSubmitButton();
});
</script>
</body>
</html>
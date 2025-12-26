<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Tailor Password</title>
<link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600&display=swap" rel="stylesheet">
<style>
body {
    margin: 0;
    padding: 0;
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
    box-shadow: 0 4px 15px rgba(0,0,0,0.3);
    text-align: center;
}

.card h2 {
    margin-bottom: 25px;
    color: #60a5fa;
}

.card input[type="password"] {
    width: 100%;
    padding: 12px;
    margin-bottom: 8px;
    border-radius: 8px;
    border: 1px solid #334155;
    background: #0f172a;
    color: #e5e7eb;
    font-size: 14px;
    outline: none;
    transition: 0.3s;
    box-sizing: border-box;
}

.card input[type="password"]:focus {
    border: 1px solid #2563eb;
    background: #1e293b;
}

.card input[type="password"].valid {
    border-color: #22c55e;
}

.card input[type="password"].invalid {
    border-color: #ef4444;
}

.validation-rules {
    text-align: left;
    margin-bottom: 15px;
    padding: 10px 15px;
    background: #0f172a;
    border-radius: 6px;
    border: 1px solid #334155;
}

.validation-rules h4 {
    margin-top: 0;
    margin-bottom: 8px;
    color: #94a3b8;
    font-size: 14px;
}

.validation-rules ul {
    margin: 0;
    padding-left: 20px;
}

.validation-rules li {
    font-size: 12px;
    color: #94a3b8;
    margin-bottom: 4px;
    list-style-type: none;
    position: relative;
}

.validation-rules li:before {
    content: "•";
    position: absolute;
    left: -15px;
}

.validation-rules li.valid {
    color: #22c55e;
}

.validation-rules li.invalid {
    color: #94a3b8;
}

.validation-rules li.valid:before {
    content: "✓";
    color: #22c55e;
}

.validation-rules li.invalid:before {
    content: "✗";
    color: #94a3b8;
}

.error-message {
    color: #ef4444;
    font-size: 12px;
    margin-bottom: 10px;
    text-align: left;
    display: none;
}

.button-row {
    display: flex;
    gap: 10px;
    margin-top: 15px;
    flex-wrap: wrap;
    justify-content: center;
}

.button-row button {
    flex: 1;
    min-width: 120px;
    padding: 10px 16px;
    border: none;
    border-radius: 8px;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
}

.button-row button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.change-password-btn {
    background: #22c55e;
    color: #000;
}
.change-password-btn:hover:not(:disabled) {
    background: #16a34a;
}

.dashboard-btn {
    background: #2563eb;
    color: #e5e7eb;
}
.dashboard-btn:hover {
    background: #1e40af;
}

@media(max-width: 400px){
    .button-row button {
        flex: 100%;
    }
}
</style>
</head>
<body>

<div class="card">
    <h2>Change Password</h2>
    <form id="passwordForm" action="TailorPasswordChange" method="post">
        
        <input type="password" id="newPassword" name="newPassword" placeholder="New Password" required>
        
        <div id="newPasswordError" class="error-message"></div>
        
        <div class="validation-rules">
            <h4>Password must contain:</h4>
            <ul>
                <li id="rule-length">At least 8 characters</li>
                <li id="rule-uppercase">One uppercase letter (A-Z)</li>
                <li id="rule-lowercase">One lowercase letter (a-z)</li>
                <li id="rule-digit">One digit (0-9)</li>
                <li id="rule-special">One special character</li>
            </ul>
        </div>
        
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm New Password" required>
        <div id="confirmPasswordError" class="error-message"></div>

        <div class="button-row">
            <button type="submit" id="submitBtn" class="change-password-btn" disabled>Change Password</button>
            <button type="button" class="dashboard-btn" onclick="location.href='tailorAccount.jsp'">Back</button>
        </div>
    </form>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const newPasswordInput = document.getElementById('newPassword');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const submitBtn = document.getElementById('submitBtn');
    const form = document.getElementById('passwordForm');
    
    const rules = {
        length: document.getElementById('rule-length'),
        uppercase: document.getElementById('rule-uppercase'),
        lowercase: document.getElementById('rule-lowercase'),
        digit: document.getElementById('rule-digit'),
        special: document.getElementById('rule-special')
    };
    
    const errorMessages = {
        newPassword: document.getElementById('newPasswordError'),
        confirmPassword: document.getElementById('confirmPasswordError')
    };
    
    const regex = {
        uppercase: /[A-Z]/,
        lowercase: /[a-z]/,
        digit: /[0-9]/,
        special: /[@$!%*?&]/,
        minLength: /^.{8,}$/
    };
    
    let newPasswordValid = false;
    let confirmPasswordValid = false;
    
    function validatePassword(password) {
        const validations = {
            length: regex.minLength.test(password),
            uppercase: regex.uppercase.test(password),
            lowercase: regex.lowercase.test(password),
            digit: regex.digit.test(password),
            special: regex.special.test(password)
        };
        
        Object.keys(validations).forEach(rule => {
            if (rules[rule]) {
                if (validations[rule]) {
                    rules[rule].classList.add('valid');
                    rules[rule].classList.remove('invalid');
                } else {
                    rules[rule].classList.add('invalid');
                    rules[rule].classList.remove('valid');
                }
            }
        });
        
        if (password.length === 0) {
            newPasswordInput.classList.remove('valid', 'invalid');
            errorMessages.newPassword.style.display = 'none';
            return false;
        }
        
        const isValid = Object.values(validations).every(v => v === true);
        
        if (isValid) {
            newPasswordInput.classList.add('valid');
            newPasswordInput.classList.remove('invalid');
            errorMessages.newPassword.style.display = 'none';
        } else {
            newPasswordInput.classList.add('invalid');
            newPasswordInput.classList.remove('valid');
            errorMessages.newPassword.style.display = 'block';
            errorMessages.newPassword.textContent = 'Password does not meet all requirements';
        }
        
        return isValid;
    }
    
    function validateConfirmPassword() {
        const newPassword = newPasswordInput.value;
        const confirmPassword = confirmPasswordInput.value;
        
        if (confirmPassword.length === 0) {
            confirmPasswordInput.classList.remove('valid', 'invalid');
            errorMessages.confirmPassword.style.display = 'none';
            return false;
        }
        
        if (newPassword === confirmPassword) {
            confirmPasswordInput.classList.add('valid');
            confirmPasswordInput.classList.remove('invalid');
            errorMessages.confirmPassword.style.display = 'none';
            return true;
        } else {
            confirmPasswordInput.classList.add('invalid');
            confirmPasswordInput.classList.remove('valid');
            errorMessages.confirmPassword.style.display = 'block';
            errorMessages.confirmPassword.textContent = 'Passwords do not match';
            return false;
        }
    }
    
    function updateSubmitButton() {
        submitBtn.disabled = !(newPasswordValid && confirmPasswordValid);
    }
    
    newPasswordInput.addEventListener('input', function() {
        newPasswordValid = validatePassword(this.value);
        if (confirmPasswordInput.value.length > 0) {
            confirmPasswordValid = validateConfirmPassword();
        }
        updateSubmitButton();
    });
    
    confirmPasswordInput.addEventListener('input', function() {
        confirmPasswordValid = validateConfirmPassword();
        updateSubmitButton();
    });
    
    form.addEventListener('submit', function(event) {
        if (!newPasswordValid || !confirmPasswordValid) {
            event.preventDefault();
            
            if (!newPasswordValid) {
                newPasswordInput.classList.add('invalid');
                errorMessages.newPassword.style.display = 'block';
                errorMessages.newPassword.textContent = 'Please fix password requirements';
            }
            
            if (!confirmPasswordValid) {
                confirmPasswordInput.classList.add('invalid');
                errorMessages.confirmPassword.style.display = 'block';
                errorMessages.confirmPassword.textContent = 'Passwords do not match';
            }
            
            alert('Please fix all validation errors before submitting.');
        }
    });
    
    validatePassword('');
    validateConfirmPassword();
});
</script>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Admin Password</title>
<link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600&display=swap" rel="stylesheet">
<style>
:root {
    --primary: #2563eb;
    --secondary: #10b981;
    --danger: #ef4444;
    --warning: #f59e0b;
    --dark: #0f172a;
    --darker: #020617;
    --light: #e5e7eb;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', sans-serif;
    background: var(--dark);
    color: var(--light);
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 20px;
}

.card {
    background: var(--darker);
    padding: 30px;
    border-radius: 12px;
    width: 100%;
    max-width: 450px;
    box-shadow: 0 10px 30px rgba(37, 99, 235, 0.2);
    border: 1px solid rgba(37, 99, 235, 0.3);
}

.card h2 {
    margin-bottom: 25px;
    color: var(--primary);
    text-align: center;
    font-size: 1.8rem;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
}

.card h2 i {
    color: var(--secondary);
}

.input-group {
    margin-bottom: 20px;
}

.input-group label {
    display: block;
    margin-bottom: 8px;
    color: var(--light);
    font-weight: 500;
}

.card input[type="password"] {
    width: 100%;
    padding: 12px 15px;
    border-radius: 8px;
    border: 1px solid rgba(37, 99, 235, 0.3);
    background: rgba(30, 41, 59, 0.5);
    color: var(--light);
    font-size: 16px;
    outline: none;
    transition: all 0.3s ease;
}

.card input[type="password"]:focus {
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    background: rgba(30, 41, 59, 0.8);
}

.card input[type="password"]::placeholder {
    color: #94a3b8;
}

.button-row {
    display: flex;
    gap: 15px;
    margin-top: 25px;
    flex-wrap: wrap;
}

.button-row button {
    flex: 1;
    min-width: 140px;
    padding: 12px 20px;
    border: none;
    border-radius: 8px;
    font-weight: bold;
    font-size: 16px;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

.change-password-btn {
    background: linear-gradient(135deg, var(--secondary), #059669);
    color: white;
    box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
}

.change-password-btn:hover {
    background: linear-gradient(135deg, #059669, var(--secondary));
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}

.dashboard-btn {
    background: linear-gradient(135deg, var(--primary), #1d4ed8);
    color: white;
    box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
}

.dashboard-btn:hover {
    background: linear-gradient(135deg, #1d4ed8, var(--primary));
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
}

.message {
    padding: 12px;
    border-radius: 8px;
    margin-bottom: 20px;
    text-align: center;
    font-weight: 500;
    animation: fadeIn 0.3s ease;
}

.success {
    background: rgba(16, 185, 129, 0.1);
    color: var(--secondary);
    border: 1px solid rgba(16, 185, 129, 0.3);
}

.error {
    background: rgba(239, 68, 68, 0.1);
    color: var(--danger);
    border: 1px solid rgba(239, 68, 68, 0.3);
}

.info {
    background: rgba(37, 99, 235, 0.1);
    color: var(--primary);
    border: 1px solid rgba(37, 99, 235, 0.3);
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-10px); }
    to { opacity: 1; transform: translateY(0); }
}

.password-strength {
    margin-top: 5px;
    font-size: 0.85rem;
}

.password-strength.weak { color: var(--danger); }
.password-strength.medium { color: var(--warning); }
.password-strength.strong { color: var(--secondary); }

.info-note {
    background: rgba(37, 99, 235, 0.05);
    padding: 10px 15px;
    border-radius: 8px;
    margin-bottom: 20px;
    border-left: 4px solid var(--primary);
    font-size: 0.9rem;
    color: #94a3b8;
}

.info-note i {
    color: var(--primary);
    margin-right: 8px;
}

@media (max-width: 500px) {
    .card {
        padding: 20px;
    }
    
    .button-row button {
        flex: 100%;
        min-width: 100%;
    }
    
    .button-row {
        gap: 10px;
    }
}
</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<%
String adminName = (String) session.getAttribute("adminName");
String adminEmail = (String) session.getAttribute("adminEmail");
if (adminName == null || adminEmail == null) {
    response.sendRedirect("unifiedLogin.jsp");
    return;
}

String successMsg = (String) session.getAttribute("successMsg");
String errorMsg = (String) session.getAttribute("errorMsg");
%>

<div class="card">
    <h2><i class="fas fa-lock"></i> Change Password</h2>
    
    <div class="info-note">
        <i class="fas fa-info-circle"></i>
        You can set a new password directly without entering the old password.
    </div>
    
    <% if (successMsg != null) { %>
        <div class="message success">
            <i class="fas fa-check-circle"></i> <%= successMsg %>
        </div>
        <% session.removeAttribute("successMsg"); %>
    <% } %>
    
    <% if (errorMsg != null) { %>
        <div class="message error">
            <i class="fas fa-exclamation-circle"></i> <%= errorMsg %>
        </div>
        <% session.removeAttribute("errorMsg"); %>
    <% } %>
    
    <form action="AdminPasswordChangeServlet" method="post" id="passwordForm">
        <div class="input-group">
            <label for="newPassword"><i class="fas fa-lock"></i> New Password</label>
            <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" required 
                   onkeyup="checkPasswordStrength(this.value)">
            <div id="passwordStrength" class="password-strength"></div>
        </div>
        
        <div class="input-group">
            <label for="confirmPassword"><i class="fas fa-lock"></i> Confirm New Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password" required>
        </div>
        
        <div class="button-row">
            <button type="submit" class="change-password-btn">
                <i class="fas fa-sync-alt"></i> Change Password
            </button>
            <button type="button" class="dashboard-btn" onclick="location.href='adminDashboard.jsp'">
                <i class="fas fa-home"></i> Back to Dashboard
            </button>
        </div>
    </form>
</div>

<script>
function checkPasswordStrength(password) {
    const strength = document.getElementById('passwordStrength');
    let strengthText = '';
    let strengthClass = '';
    
    if (password.length === 0) {
        strengthText = '';
    } else if (password.length < 6) {
        strengthText = 'Weak (minimum 6 characters)';
        strengthClass = 'weak';
    } else if (password.length < 8) {
        strengthText = 'Medium';
        strengthClass = 'medium';
    } else {
    	
        const hasUpper = /[A-Z]/.test(password);
        const hasLower = /[a-z]/.test(password);
        const hasNumbers = /\d/.test(password);
        const hasSymbols = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);
        
        const complexity = (hasUpper ? 1 : 0) + (hasLower ? 1 : 0) + 
                          (hasNumbers ? 1 : 0) + (hasSymbols ? 1 : 0);
        
        if (complexity >= 3) {
            strengthText = 'Strong';
            strengthClass = 'strong';
        } else if (complexity >= 2) {
            strengthText = 'Medium';
            strengthClass = 'medium';
        } else {
            strengthText = 'Weak - add uppercase, numbers, or symbols';
            strengthClass = 'weak';
        }
    }
    
    strength.textContent = strengthText;
    strength.className = 'password-strength ' + strengthClass;
}

document.getElementById('passwordForm').addEventListener('submit', function(event) {
    const newPass = document.getElementById('newPassword').value;
    const confirmPass = document.getElementById('confirmPassword').value;
    
    if (newPass !== confirmPass) {
        alert('New passwords do not match!');
        event.preventDefault();
        return;
    }
    
    if (newPass.length < 6) {
        alert('Password must be at least 6 characters long!');
        event.preventDefault();
        return;
    }
    
    if (!confirm('Are you sure you want to change your password?')) {
        event.preventDefault();
        return;
    }
});
</script>

</body>
</html>
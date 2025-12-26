<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Password Recovery</title>

<style>
* {
    margin: 0; padding: 0;
    box-sizing: border-box;
    font-family: "Poppins", sans-serif;
}
body {
    background: radial-gradient(circle at top, #1e1e2e, #000);
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    overflow: hidden;
}

body::before {
    content: "";
    position: absolute;
    width: 500px;
    height: 500px;
    background: rgba(0, 150, 255, 0.25);
    filter: blur(150px);
    top: -150px;
    left: -150px;
}
.auth-box {
    width: 420px;
    padding: 35px;
    border-radius: 20px;
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255,255,255,0.15);
    backdrop-filter: blur(12px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
    animation: fadeIn 0.6s ease-in-out;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

h2 {
    text-align: center;
    color: #00c3ff;
    margin-bottom: 20px;
}

.input-group {
    margin-bottom: 18px;
}

label {
    color: #ddd;
    font-size: 14px;
}

.input-group input,
.input-group select {
    width: 100%;
    padding: 12px;
    margin-top: 6px;
    font-size: 15px;
    border-radius: 10px;
    border: 1px solid rgba(255,255,255,0.1);
    background: rgba(255,255,255,0.07);
    color: #fff;
    transition: 0.3s;
}

.input-group input:focus,
.input-group select:focus {
    border-color: #00c3ff;
    box-shadow: 0 0 10px #00c3ff;
    outline: none;
}

.btn {
    width: 100%;
    padding: 12px;
    border-radius: 10px;
    border: none;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    color: #000;
    background: linear-gradient(135deg, #00eaff, #00ff8c);
    transition: 0.3s;
}

.btn:hover {
    transform: scale(1.03);
    box-shadow: 0 0 15px #00eaff;
}

.redirect {
    text-align: center;
    margin-top: 18px;
    color: #ccc;
}

.redirect a {
    color: #00c3ff;
    font-weight: 500;
    text-decoration: none;
}

.redirect a:hover {
    text-decoration: underline;
}
.message p {
    text-align: center;
    font-size: 14px;
    margin-top: 12px;
}

.success { color: #00ff9d; }
.error   { color: #ff4f4f; }

@keyframes fadeOut {
    from { opacity: 1; }
    to { opacity: 0; }
}
.fade-out {
    animation: fadeOut 1s forwards;
}
</style>
</head>

<body>

<div class="auth-box">



<h2>Password Recovery</h2>

<form action="RecoverServlet" method="POST">

<%
    String step = (String) request.getAttribute("step");
    if (step == null) step = "email";
%>

<% if ("email".equals(step)) { %>
    <div class="input-group">
        <label>Enter your registered email:</label>
        <input type="email" name="email" required>
    </div>
    <button type="submit" name="action" value="send_otp" class="btn">Send OTP</button>
<% } else if ("select_user_type".equals(step)) {
    @SuppressWarnings("unchecked")
    List<String[]> types = (List<String[]>) request.getAttribute("userTypes");
%>
    <div class="input-group">
        <label>Select account type:</label>
        <select name="userTable" required>
            <% for (String[] type : types) { %>
                <option value="<%= type[0] %>"><%= type[1] %></option>
            <% } %>
        </select>
    </div>
    <button type="submit" name="action" value="send_otp_selected" class="btn">Send OTP</button>

<% } else if ("otp".equals(step)) { %>
    <div class="input-group">
        <label>Enter OTP sent to your email:</label>
        <input type="text" name="otp" required>
    </div>
    <button type="submit" name="action" value="verify_otp" class="btn">Verify OTP</button>
<% } else if ("reset".equals(step)) { %>
    <div class="input-group">
    <label>Enter new password:</label>
    <input type="password" id="password" name="password" required>
    <div id="strength-message" style="margin-top:5px;font-weight:bold;"></div>
</div>
<button type="submit" name="action" value="reset_password" class="btn">Reset Password</button>

<% } %>

</form>

<div class="message">
<%
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");

    if (message != null) { 
%>
    <p class="success" id="msg"><%= message %></p>

<% } else if (error != null) { %>

    <p class="error" id="msg"><%= error %></p>

<% } %>
</div>

<p class="redirect"><a href="unifiedLogin.jsp">Back to Login</a></p>

</div>

<script>
window.addEventListener("DOMContentLoaded", () => {
    let msg = document.getElementById("msg");
    if (msg) {
        setTimeout(() => msg.classList.add("fade-out"), 4000);
    }
});

const passwordInput = document.getElementById('password');
const strengthMessage = document.getElementById('strength-message');

if(passwordInput) {
    passwordInput.addEventListener('input', () => {
        const val = passwordInput.value;
        let strength = "";
        let color = "red";

        if(val.length < 8) {
            strength = "Too short";
            color = "red";
        } else if(!/[A-Z]/.test(val)) {
            strength = "Add uppercase letter";
            color = "red";
        } else if(!/[a-z]/.test(val)) {
            strength = "Add lowercase letter";
            color = "red";
        } else if(!/\d/.test(val)) {
            strength = "Add a number";
            color = "orange";
        } else if(!/[@$!%*?&]/.test(val)) {
            strength = "Add a special character";
            color = "orange";
        } else {
            strength = "Strong password ✔";
            color = "green";
        }

        strengthMessage.textContent = strength;
        strengthMessage.style.color = color;
    });

    const form = passwordInput.closest('form');
    form.onsubmit = () => {
        const pattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,20}$/;
        if(!pattern.test(passwordInput.value)) {
            alert("Password must be 8-20 characters, include uppercase, lowercase, number, and special character.");
            return false; 
        }
        return true; 
    }
}
</script>
</body>
</html>

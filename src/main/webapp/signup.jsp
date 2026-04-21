<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sign Up</title>

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
    overflow: hidden;
    position: relative;
}

/* Floating light effect */
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

/* ---------------------------
   FORM CARD (GLASS EFFECT)
--------------------------- */
.form-box {
    width: 420px;
    padding: 35px;
    border-radius: 20px;
    background: rgba(255,255,255,0.06);
    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
    border: 1px solid rgba(255,255,255,0.15);
    backdrop-filter: blur(12px);
    animation: fadeIn 0.6s ease-in-out;
    position: relative;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}

h2 {
    color: #00c3ff;
    text-align: center;
    margin-bottom: 20px;
    letter-spacing: 1px;
}

.input-group {
    margin-bottom: 18px;
}

label {
    color: #fff;
    font-size: 14px;
}

.input-group input {
    width: 100%;
    padding: 12px;
    font-size: 15px;
    color: #fff;
    margin-top: 6px;
    background: rgba(255,255,255,0.07);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 10px;
    transition: 0.3s;
}

.input-group input:focus {
    border-color: #00c3ff;
    box-shadow: 0 0 10px #00c3ff;
    outline: none;
}

.validation-msg {
    font-size: 12px;
    margin-top: 4px;
    font-weight: 600;
}

.success { color: #00ff9d; }
.error { color: #ff4f4f; }

.btn-signup {
    width: 100%;
    margin-top: 10px;
    padding: 12px;
    border-radius: 10px;
    font-size: 16px;
    border: none;
    color: #000;
    background: linear-gradient(135deg, #00eaff, #00ff8c);
    cursor: pointer;
    font-weight: bold;
    transition: 0.3s;
}

.btn-signup:hover {
    transform: scale(1.03);
    box-shadow: 0 0 15px #00eaff;
}

.redirect {
    color: #ddd;
    margin-top: 15px;
    text-align: center;
}

.redirect a { color: #00c3ff; }

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

<div class="form-box">

<h2>Create Account</h2>

<form id="signupForm" action="SignUpServlet" method="POST">

    <div class="input-group">
        <label>Username</label>
        <input type="text" id="username" name="username" maxlength="12" required>
        <p id="usernameMsg" class="validation-msg"></p>
    </div>

    <div class="input-group">
        <label>Email</label>
        <input type="email" id="email" name="email" required maxlength="40">
        <p id="emailMsg" class="validation-msg"></p>
    </div>

    <div class="input-group">
        <label>Password</label>
        <input type="password" id="password" name="password" required maxlength="20">
        <p id="passMsg" class="validation-msg"></p>
    </div>

    <button type="submit" class="btn-signup">Sign Up</button>

</form>

<p class="redirect">Already have an account? <a href="unifiedLogin.jsp">Login</a></p>
<p class="redirect">Back to home? <a href="index.jsp">Home</a></p>

<%
String message = (String) request.getAttribute("message");
String type = (String) request.getAttribute("messageType");
if (message != null && type != null) {
%>
<p id="formMessage" class="<%= type %>" style="text-align:center;margin-top:12px;font-size:15px;"><%= message %></p>
<% } %>

</div>

<script>
function debounce(fn, delay){
  let t;
  return function(...args){
    clearTimeout(t);
    t = setTimeout(() => fn.apply(this,args), delay);
  };
}

const usernameEl = document.getElementById("username");
const usernameMsg = document.getElementById("usernameMsg");

const checkUsername = debounce(() => {
    let u = usernameEl.value.trim();
    const usernamePattern = /^(?=.*[a-z])(?=.*\d)[a-z\d]{6,12}$/;
    if (!usernamePattern.test(u)) {
        usernameMsg.textContent = "6-12 chars, must include small letters & numbers";
        usernameMsg.className = "validation-msg error";
        return;
    }
    fetch("ValidateUserServlet?username=" + encodeURIComponent(u), {cache: 'no-store'})
        .then(r => r.text())
        .then(t => {
            t = t.trim();
            if(t === "exists") {
                usernameMsg.textContent = "Username already taken ❌";
                usernameMsg.className = "validation-msg error";
            } else if(t === "ok") {
                usernameMsg.textContent = "Username available ✔";
                usernameMsg.className = "validation-msg success";
            } else {
                usernameMsg.textContent = "Server error";
                usernameMsg.className = "validation-msg error";
            }
        })
        .catch(() => {
            usernameMsg.textContent = "Server error";
            usernameMsg.className = "validation-msg error";
        });
}, 400);

usernameEl.addEventListener("input", checkUsername);

const emailEl = document.getElementById("email");
const emailMsg = document.getElementById("emailMsg");

const checkEmail = debounce(() => {
    let e = emailEl.value.trim();

    if (!e.endsWith("@gmail.com")) {
        emailMsg.textContent = "Domain must be @gmail.com only";
        emailMsg.className = "validation-msg error";
        return;
    }

    const local = e.split("@")[0] || "";

    if (!/^[a-z0-9]*$/.test(local)) {
        emailMsg.textContent = "No special characters or Capital letters allowed before @";
        emailMsg.className = "validation-msg error";
        return;
    }

    if (local.length < 6 || local.length > 30) {
        emailMsg.textContent = "Length must be 6–30 characters before @";
        emailMsg.className = "validation-msg error";
        return;
    }

    const letters = (local.match(/[a-z]/g) || []).length;
    const digits = (local.match(/\d/g) || []).length;

    if (digits > 8) {
        emailMsg.textContent = "Maximum 8 digits allowed";
        emailMsg.className = "validation-msg error";
        return;
    }

    if (digits < 3) {
        emailMsg.textContent = "At least 3 digits required";
        emailMsg.className = "validation-msg error";
        return;
    }

    if (letters > 22) {
        emailMsg.textContent = "Maximum 22 letters allowed";
        emailMsg.className = "validation-msg error";
        return;
    }

    if (letters < 4) {
        emailMsg.textContent = "At least 4 letters required";
        emailMsg.className = "validation-msg error";
        return;
    }

    fetch("ValidateEmailServlet?email=" + encodeURIComponent(e), { cache: 'no-store' })
        .then(r => r.text())
        .then(t => {
            t = t.trim();
            if (t === "exists") {
                emailMsg.textContent = "Email already registered ❌";
                emailMsg.className = "validation-msg error";
            } else if (t === "ok") {
                emailMsg.textContent = "Email available ✔";
                emailMsg.className = "validation-msg success";
            } else {
                emailMsg.textContent = "Server error";
                emailMsg.className = "validation-msg error";
            }
        })
        .catch(() => {
            emailMsg.textContent = "Server error";
            emailMsg.className = "validation-msg error";
        });

}, 400);
emailEl.addEventListener("input", checkEmail);

const passwordEl = document.getElementById("password");
const passMsg = document.getElementById("passMsg");

passwordEl.addEventListener("input", () => {
    let p = passwordEl.value;
    const strongRegex = /^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[@#$%^&+=!]).{8,}$/;
    if (p.length === 0) {
        passMsg.textContent = "";
        return;
    }
    if (!strongRegex.test(p)) {
        passMsg.textContent = "Password must contain A-Z, a-z, number, symbol & 8+ chars";
        passMsg.className = "validation-msg error";
    } else {
        passMsg.textContent = "Strong password ✔";
        passMsg.className = "validation-msg success";
    }
});

window.addEventListener("DOMContentLoaded", () => {
    const msgEl = document.getElementById("formMessage");
    if(msgEl) {
        setTimeout(() => {
            msgEl.classList.add("fade-out");
        }, 4000); 
    }
});
</script>

</body>
</html>

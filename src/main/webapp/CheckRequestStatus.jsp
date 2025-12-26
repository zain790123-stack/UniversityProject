<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Check Status</title>

<style>
* {
    margin: 0; 
    padding: 0;
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

.status-box {
    width: 420px;
    padding: 35px;
    border-radius: 20px;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.15);
    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
    backdrop-filter: blur(12px);
    animation: fadeIn 0.6s ease-in-out;
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

label {
    color: #fff;
    font-size: 14px;
}

input[type="text"] {
    width: 100%;
    padding: 12px;
    margin-top: 6px;
    font-size: 15px;
    color: #fff;
    background: rgba(255,255,255,0.07);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 10px;
    transition: 0.3s;
}

input[type="text"]:focus {
    border-color: #00c3ff;
    box-shadow: 0 0 10px #00c3ff;
    outline: none;
}

.btn-check {
    width: 100%;
    margin-top: 15px;
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

.btn-check:hover {
    transform: scale(1.03);
    box-shadow: 0 0 15px #00eaff;
}

.redirect {
    text-align: center;
    color: #ddd;
    margin-top: 15px;
}

.redirect a {
    color: #00c3ff;
}
#status-message, #error-message {
    padding: 10px;
    border-radius: 10px;
    text-align: center;
    margin-top: 15px;
    font-size: 15px;
    display: none;
}

#status-message {
    background: rgba(0, 255, 150, 0.2);
    color: #00ff9d;
    border: 1px solid #00ff9d;
}

#error-message {
    background: rgba(255, 70, 70, 0.2);
    color: #ff4f4f;
    border: 1px solid #ff4f4f;
}
@keyframes fadeOut {
    from { opacity: 1; }
    to { opacity: 0; }
}
.fade-out { animation: fadeOut 1s forwards; }

</style>
</head>

<body>

<div class="status-box">

<h2>Check Request Status</h2>

<div id="error-message"></div>
<div id="status-message"></div>

<form id="statusForm" method="post" action="checkUnifiedStatus" onsubmit="return handleSubmit(event)">
    
    <label for="requestId">Request / Order ID</label>
    <input type="text" id="requestId" name="requestId" placeholder="Enter ID..." required>

    <button type="submit" class="btn-check">Check Status</button>
</form>

<p class="redirect"><a href="loinIndex.jsp">Back</a></p>

</div>

<script>
async function handleSubmit(event) {
    event.preventDefault();

    const requestId = document.getElementById("requestId").value.trim();

    const errorBox = document.getElementById("error-message");
    const statusBox = document.getElementById("status-message");

    errorBox.style.display = 'none';
    statusBox.style.display = 'none';

    try {
        const response = await fetch('checkUnifiedStatus', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'requestId=' + encodeURIComponent(requestId)
        });

        const data = await response.json();

        if (data.status) {
            statusBox.innerHTML = "Status: <strong>" + data.status + "</strong>";
            statusBox.style.display = 'block';
            setTimeout(() => statusBox.classList.add("fade-out"), 4000);
        } else if (data.error) {
            errorBox.innerHTML = data.error;
            errorBox.style.display = 'block';
            setTimeout(() => errorBox.classList.add("fade-out"), 4000);
        }

    } catch (error) {
        errorBox.innerHTML = "Something went wrong. Try again.";
        errorBox.style.display = 'block';
        setTimeout(() => errorBox.classList.add("fade-out"), 4000);
    }
}
</script>

</body>
</html>

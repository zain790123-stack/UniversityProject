<%@ page contentType="text/html;charset=UTF-8" %>
<%
String error = (String) session.getAttribute("error");
session.removeAttribute("error");
String rememberedEmail = "";
Cookie[] cookies = request.getCookies();
if(cookies != null){
    for(Cookie c : cookies){
        if("rememberEmail".equals(c.getName())){
            rememberedEmail = c.getValue();
        }
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:"Poppins",sans-serif;
}
body{
 background:radial-gradient(circle at top,#1e1e2e,#000);
 height:100vh;
 display:flex;
 justify-content:center;
 align-items:center;
 overflow:hidden;
}

body::before{
 content:"";
 position:absolute;
 width:500px;height:500px;
 background:rgba(0,150,255,.25);
 filter:blur(150px);
 top:-150px;left:-150px;
}

.form-box{
 width:420px;
 padding:35px;
 border-radius:20px;
 background:rgba(255,255,255,.06);
 box-shadow:0 8px 25px rgba(0,0,0,.4);
 border:1px solid rgba(255,255,255,.15);
 backdrop-filter:blur(12px);
 animation:fadeIn .6s ease;
}

@keyframes fadeIn{
 from{
 opacity:0;
 transform:translateY(20px)
 }
 to{
 opacity:1;
 transform:translateY(0)
 }
}

h2{
 color:#00c3ff;
 text-align:center;
 margin-bottom:20px;
}

.input-group{
margin-bottom:18px;
}
label{
color:#fff;font-size:14px;
}

input,select{
 width:100%;
 padding:12px;
 margin-top:6px;
 background:rgba(255,255,255,.07);
 border:1px solid rgba(255,255,255,.1);
 border-radius:10px;
 color:#fff;
 font-size:15px;
}

select option{
color:#000;
}

input:focus,select:focus{
 border-color:#00c3ff;
 box-shadow:0 0 10px #00c3ff;
 outline:none;
}

.password-box {
    position: relative;
}

.password-box input {
    padding-right: 45px;
}

.toggle-pass {
    position: absolute;
    right: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: #ccc;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
}

.toggle-pass i {
    font-size: 16px;
}

.btn-login{
 width:100%;
 margin-top:15px;
 padding:12px;
 border:none;
 border-radius:10px;
 font-size:16px;
 font-weight:bold;
 cursor:pointer;
 background:linear-gradient(135deg,#00eaff,#00ff8c);
 transition: all 0.3s ease;
}

.btn-login:hover{
 transform:scale(1.03);
 box-shadow:0 0 15px #00eaff;
}

.links-container {
    margin-top: 20px;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.link-item {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 10px;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.05);
    transition: all 0.3s ease;
    text-decoration: none;
    color: #ddd;
    border: 1px solid transparent;
}

.link-item:hover {
    background: rgba(0, 195, 255, 0.1);
    border-color: rgba(0, 195, 255, 0.3);
    transform: translateY(-2px);
    color: #fff;
}

.link-item i {
    color: #00c3ff;
    font-size: 14px;
}

.link-text {
    font-size: 14px;
    font-weight: 500;
}

#signupLink {
    display: none; /* Hidden by default */
    animation: fadeIn 0.4s ease;
}

.error{
 color:#ff4f4f;
 text-align:center;
 margin-top:12px;
 animation:fadeOut 1s forwards 4s;
}

@keyframes fadeOut{
to{opacity:0
}}
</style>
</head>

<body>

<div class="form-box">
<h2>Login</h2>

<form id="loginForm" method="post">

<div class="input-group">
<label>Login As</label>
<select id="role" required onchange="switchRole()">
<option value="">Select Role</option>
<option value="admin">Admin</option>
<option value="tailor">Tailor</option>
<option value="user">User</option>
<option value="manager">Manager</option>
</select>
</div>

<div class="input-group">
<label>Email</label>
<input type="email" name="email" value="<%= rememberedEmail %>" required>
</div>

<div class="input-group password-box">
    <label>Password</label>
    <input type="password" id="password" name="password" required>
    <span class="toggle-pass" onclick="togglePass()">
        <i class="fa fa-eye"></i>
    </span>
</div>

<div class="input-group" id="adminKeyBox" style="display:none">
<label>Admin Key</label>
<input type="text" name="adminKey" id="adminKey">
</div>

<button class="btn-login">Login</button>

<% if(error!=null){ %>
<p class="error"><%= error %></p>
<% } %>

</form>

<div class="links-container">

    <a href="ForgotUnified.jsp" class="link-item">
        <i class="fas fa-key"></i>
        <span class="link-text">Forgot Password?</span>
    </a>
    
    <a href="signup.jsp" class="link-item" id="signupLink">
        <i class="fas fa-user-plus"></i>
        <span class="link-text">Create New Account</span>
    </a>
    
    <a href="index.jsp" class="link-item">
        <i class="fas fa-home"></i>
        <span class="link-text">Back to Home</span>
    </a>
</div>

</div>

<script>
function togglePass(){
 let p=document.getElementById("password");
 p.type=p.type==="password"?"text":"password";
}

function switchRole(){
 let roleSelect = document.getElementById("role").value;
 let form = document.getElementById("loginForm");
 let signupLink = document.getElementById("signupLink");
 let adminKeyBox = document.getElementById("adminKeyBox");
 
 adminKeyBox.style.display = (roleSelect === "admin") ? "block" : "none";
 
 if (roleSelect === "user") {
     signupLink.style.display = "flex";
 } else {
     signupLink.style.display = "none";
 }
 
 switch(roleSelect) {
     case "admin":
         form.action = "AdminLoginServlet";
         break;
     case "tailor":
         form.action = "TailorLoginServlet";
         break;
     case "manager":
         form.action = "ManagerLoginServlet";
         break;
     case "user":
         form.action = "UserLoginServlet";
         break;
     default:
         form.action = "";
 }
}

document.addEventListener('DOMContentLoaded', function() {

    switchRole();
});
</script>

</body>
</html>
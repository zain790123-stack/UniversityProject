<%@ page contentType="text/html;charset=UTF-8" %>
<%
String error = (String) session.getAttribute("error");
session.removeAttribute("error");

String rememberedEmail = "";
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie c : cookies) {
        if ("rememberEmail".equals(c.getName())) {
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
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/unifiedLogin.css">
</head>
<body>

<div class="form-box">
    <h2>Login</h2>

    <form id="loginForm" method="post" action="UnifiedLoginServlet">

        <div class="input-group">
            <label>Login As</label>
            <select id="role" name="role" required onchange="switchRoleUI()">
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
        <div class="input-group remember-me">
        <label>
            <input type="checkbox" name="rememberMe"
            <%= rememberedEmail.isEmpty() ? "" : "checked" %>>
            Remember Me
        </label>
    </div>

        <button type="submit" class="btn-login">Login</button>

        <% if (error != null) { %>
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

<script src="<%=request.getContextPath()%>/javascript/unifiedLogin.js"></script>

</body>
</html>

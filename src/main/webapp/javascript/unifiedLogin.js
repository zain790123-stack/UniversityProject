function togglePass(){
    let p = document.getElementById("password");
    p.type = p.type === "password" ? "text" : "password";
}

function switchRoleUI(){
    let role = document.getElementById("role").value;
    let signupLink = document.getElementById("signupLink");
    let adminKeyBox = document.getElementById("adminKeyBox");

    // Show admin key only for admin
    adminKeyBox.style.display = (role === "admin") ? "block" : "none";

    // Show signup link only for user
    signupLink.style.display = (role === "user") ? "flex" : "none";
}

document.addEventListener("DOMContentLoaded", switchRoleUI);
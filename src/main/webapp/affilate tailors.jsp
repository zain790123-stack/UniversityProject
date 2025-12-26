<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tailor Affiliation Form</title>

<style>
body{
font-family:'Poppins',sans-serif;
background:#1e1e2e;color:#fff;
margin:0;padding:20px;
}
.form-box{
max-width:600px;
margin:auto;
padding:30px;
background:rgba(255,255,255,0.06);
border-radius:20px;
backdrop-filter:blur(12px);
}
h2
{
text-align:center;
color:#00c3ff;
}
input,textarea,button{width:100%;
padding:10px;
margin-top:5px;
border-radius:8px;
border:1px solid rgba(255,255,255,0.3);
background:rgba(255,255,255,0.05);
color:#fff;
}
.btn{
background:linear-gradient(135deg,#00eaff,#00ff8c);
color:#000;
font-weight:bold;
cursor:pointer;
margin-top:15px;
}
.validation-msg{
font-size:12px;
font-weight:bold;
margin-top:4px;
opacity:1;
transition:opacity .5s;
}
.success{
color:#00ff9d;
} .error{
color:#ff4f4f;
}
.alert{
width:80%;
margin:10px auto;
padding:15px;
border-radius:8px;
text-align:center;
font-weight:bold;
opacity:.9;
}
.success-alert{
background:#00ff9d;
color:#000;
}
 .error-alert{
 background:#ff4f4f;
 color:#fff;
 }
.action-buttons{
display:flex;
gap:10px;
margin-top:20px;
}
.action-buttons a{
flex:1;
text-align:center;
text-decoration:none;
padding:10px;
border-radius:8px;
font-weight:bold;
background:#00c3ff;
color:#000;
}
</style>
</head>
<body>

<% if(session.getAttribute("successMessage")!=null){ %>
<div class="alert success-alert"><%=session.getAttribute("successMessage")%></div>
<script>setTimeout(()=>document.querySelector('.success-alert').remove(),5000);</script>
<% session.removeAttribute("successMessage"); } %>

<% if(session.getAttribute("errorMessage")!=null){ %>
<div class="alert error-alert"><%=session.getAttribute("errorMessage")%></div>
<script>setTimeout(()=>document.querySelector('.error-alert').remove(),5000);</script>
<% session.removeAttribute("errorMessage"); } %>

<div class="form-box">
<h2>Tailor Affiliation Form</h2>

<form id="tailorForm" action="TailorHandler?action=TailorRegistrationServlet" method="post" enctype="multipart/form-data">

<label>Tailor Name:</label>
<input type="text" name="tailorName" id="tailorName" required>
<p id="nameMsg" class="validation-msg"></p>

<label>Phone:</label>
<input type="text" name="tailorPhone" id="tailorPhone" required>
<p id="phoneMsg" class="validation-msg"></p>

<label>Address:</label>
<textarea name="tailorAddress" rows="3" required></textarea>

<label>Upload Face:</label>
<input type="file" name="tailorPicture" accept="image/*" required>

<label>Specialty:</label>
<input type="text" name="specialty" required>

<label>Experience (0-99):</label>
<input type="number" name="experience" id="experience" min="0" max="99" required>
<p id="expMsg" class="validation-msg"></p>

<label>Username:</label>
<input type="text" name="username" id="username" maxlength="12" required>
<p id="usernameMsg" class="validation-msg"></p>

<label>Email:</label>
<input type="email" name="email" id="email" required>
<p id="emailMsg" class="validation-msg"></p>

<label>Password:</label>
<input type="password" name="password" id="password" required>
<p id="passMsg" class="validation-msg"></p>

<label>OTP:</label>
<input type="text" name="otp" id="otp" maxlength="6" required>
<button type="button" class="btn" onclick="generateOtp()">Generate OTP</button>
<p id="otpMsg" class="validation-msg"></p>

<input type="submit" value="Register Tailor" class="btn">

<div class="action-buttons">
    <a href="index.jsp"> Home</a>
    <a href="unifiedLogin.jsp"> Login</a>
</div>

</form>
</div>

<script>
const contextPath='<%=request.getContextPath()%>';

const debounce=(fn,delay)=>{let t;
return(...a)=>{clearTimeout(t);
t=setTimeout(()=>fn.apply(this,a),delay);
}};

const showMsg=(el,text,type)=>{el.textContent=text;
el.className="validation-msg "+type;
el.style.opacity=1;
setTimeout(()=>el.style.opacity=0,4000);
};

document.getElementById("tailorName").addEventListener("input",debounce(()=>{
	const v=tailorName.value.trim();
	/^[A-Za-z\s]{2,50}$/.test(v)?showMsg(nameMsg,"OK ","success"):showMsg(nameMsg,"Only letters & spaces (2–50 chars)","error");
	},300));

const validatePhone=(el,msg)=>/^03\d{9}$/.test(el.value.trim())?showMsg(msg,"OK ","success"):showMsg(msg,"Must start with 03 and be 11 digits","error");
tailorPhone.addEventListener("input",debounce(()=>validatePhone(tailorPhone,phoneMsg),300));

experience.addEventListener("input",()=>{let v=parseInt(experience.value);
(!v&&v!==0)||v<0||v>99?showMsg(expMsg,"Value 0–99 only","error"):showMsg(expMsg,"OK ","success");
});

username.addEventListener("input",debounce(()=>{
    const v=username.value.trim();
    if(!/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{4,12}$/.test(v)){showMsg(usernameMsg,"4–12 chars; letters & numbers","error");
    return;
    }
    fetch(contextPath+"/ValidateUserServlet?username="+encodeURIComponent(v)).then(r=>r.text()).then(t=>{
        t=t.trim();
        t==="exists"?showMsg(usernameMsg,"Taken ❌","error"):t==="ok"?showMsg(usernameMsg,"Available ","success"):showMsg(usernameMsg,"Server error","error");
    }).catch(()=>showMsg(usernameMsg,"Server error","error"));
},400));

email.addEventListener("input",debounce(()=>{
    const v=email.value.trim();
    if(!/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+@[A-Za-z\d]+\.[A-Za-z]{2,}$/.test(v)){showMsg(emailMsg,"Must include letters & digits; no special chars","error");
    return;
    }
    fetch(contextPath+"/ValidateEmailServlet?email="+encodeURIComponent(v)).then(r=>r.text()).then(t=>{
        t=t.trim();
        t==="exists"?showMsg(emailMsg,"Registered ","error"):t==="ok"?showMsg(emailMsg,"Available ","success"):showMsg(emailMsg,"Server error","error");
    }).catch(()=>showMsg(emailMsg,"Server error","error"));
},400));

password.addEventListener("input",()=>/^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[@#$%^&+=!]).{8,}$/.test(password.value)?showMsg(passMsg,"Strong ","success"):showMsg(passMsg,"Need A-Z,a-z,number,symbol & 8+ chars","error"));

const form = document.getElementById("tailorForm");

form.addEventListener("submit", (e)=>{
 const otpVal = otp.value.trim();
 if(otpVal.length !== 6 || !/^\d{6}$/.test(otpVal)){
     e.preventDefault();
     showMsg(otpMsg, "OTP must be 6 digits", "error");
 }
});

const generateOtp = () => {
 const e = email.value.trim();
 if (!e) { 
     alert("Enter a valid email first"); 
     return; 
 }

 const otpValue = Math.floor(100000 + Math.random() * 900000).toString();

 console.log("Generated OTP for " + e + ": " + otpValue);
 fetch('<%=request.getContextPath()%>/TailorHandler', {
     method: 'POST',
     headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
     body: 'action=sendOTP&email=' + encodeURIComponent(e) + '&otp=' + encodeURIComponent(otpValue)
 }).then(res => res.text()).then(t => console.log("Server OTP stored in session"))
   .catch(()=>console.log("Failed to store OTP in session"));

 otpMsg.textContent = "OTP generated! Check the console for the OTP.";
 otpMsg.className = "validation-msg success";
};

</script>

</body>
</html>

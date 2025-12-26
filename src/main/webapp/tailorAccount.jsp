<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
Integer tailorId = (Integer) session.getAttribute("tailorId");
if (tailorId == null) {
    response.sendRedirect("unifiedLogin.jsp");
    return;
}

Connection con = DriverManager.getConnection( "jdbc:mysql://localhost:3306/tailor_db","root","12345");
PreparedStatement ps = con.prepareStatement( "SELECT * FROM tailors WHERE id=?");
ps.setInt(1, tailorId);
ResultSet t = ps.executeQuery();
t.next();
%>

<!DOCTYPE html>
<html>
<head>
<title>Tailor Profile</title>

<style>

body{
background:#0f172a;
color:#e5e7eb;
font-family:Segoe UI;
padding:30px
}
.card{
background:#020617;
padding:25px;
border-radius:12px;
max-width:700px;
margin:auto
}
input,textarea{
width:100%;
padding:10px;
border-radius:6px;
border:none;
background:#020617;
color:#fff
}
.button-row {
    display: flex;
    gap: 15px; 
    margin-top: 20px;
    flex-wrap: wrap; 
}

.button-row button {
    flex: 1;
    min-width: 120px; 
}

button.home {
    background:#2563eb;
    color:#e5e7eb;
    border-radius:8px;
    font-weight:bold;
    padding:10px 16px;
    border:none;
    cursor:pointer;
    transition:0.3s;
}
button.home:hover { 
background:#1e40af;
 }

button.save {
    background:#22c55e;
    color:#000;
    border:none;
    border-radius:8px;
    font-weight:bold;
    padding:10px 16px;
    cursor:pointer;
    transition:0.3s;
}
button.save:hover {
 background:#16a34a; 
 }

button.change-password {
    background:#0284c7;
    color:#e5e7eb;
    border:none;
    border-radius:8px;
    font-weight:bold;
    padding:10px 16px;
    cursor:pointer;
    transition:0.3s;
}
button.change-password:hover { 
background:#0369a1;
 }

.preview{
background:#3b82f6;
color:#fff
}
img{
width:120px;
height:120px;
border-radius:50%;
object-fit:cover
}
.modal{
display:none;
position:fixed;
inset:0;
background:rgba(0,0,0,.8);
align-items:center;
justify-content:center
}
.modal img{
width:300px;
height:300px
}
</style>
</head>

<body>
<%
String success = (String) session.getAttribute("successMsg");
String error = (String) session.getAttribute("errorMsg");
if(success != null || error != null) {
%>
<div id="flashMsg" 
style="
    padding: 12px;
    margin-bottom: 15px;
    text-align: center;
    border-radius: 6px;
    font-weight: bold;
    border: 1px solid;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    background-color: <%= (success!=null)?"#d1fae5":"#fee2e2" %>;
    color: <%= (success!=null)?"#065f46":"#b91c1c" %>;
">
    <%= (success!=null)?success:error %>
</div>
<%
    session.removeAttribute("successMsg");
    session.removeAttribute("errorMsg");
}
%>

<div class="card">
<h2>Edit Profile</h2>

<img src="uploads/TailorPictures/<%=t.getString("picture_path")%>" onclick="openModal()">

<form action="TailorProfileUpdate" method="post" enctype="multipart/form-data">

<label>Phone</label>
<input name="phone" value="<%=t.getString("phone")%>">

<label>Address</label>
<textarea name="address"><%=t.getString("address")%></textarea>

<label>Specialty</label>
<input name="specialty" value="<%=t.getString("specialty")%>">

<label>Experience</label>
<input type="number" name="experience" value="<%=t.getInt("experience")%>">

<label>Change Picture</label>
<input type="file" name="picture">

<br><br>
<button type="submit" class="save">Save Changes</button>
</form>

<hr>
<div class="button-row">
  <button type="button" class="home" onclick="location.href='TailorDB.jsp'">Back</button>
            
<button type="button" class="change-password" onclick="location.href='changeTailorPassword.jsp'">Change Password</button>
        </div></div>

<div class="modal" id="imgModal" onclick="this.style.display='none'">
<img src="uploads/TailorPictures/<%=t.getString("picture_path")%>">
</div>

<script>
function openModal(){
document.getElementById("imgModal").style.display="flex";
}

setTimeout(function() {
    var msg = document.getElementById("flashMsg");
    if(msg){
        msg.style.transition = "opacity 0.5s ease";
        msg.style.opacity = "0";
        setTimeout(() => msg.style.display = "none", 500);
    }
}, 5000);
</script>

</body>
</html>

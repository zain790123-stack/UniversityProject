<%@page import="java.util.Iterator"%>
<%@ page import="java.util.List" language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
List<String> tailors = new java.util.ArrayList<>();

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/tailor_db", "root", "12345");

    String sql = "SELECT name FROM tailors WHERE status = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setString(1, "approved");

    ResultSet rs = ps.executeQuery();
    while(rs.next()){
        tailors.add(rs.getString("name"));
    }
    conn.close();

} catch(Exception e){
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Suit Stitching Request</title>

<style>
*{
    margin:0; padding:0;
    box-sizing:border-box;
    font-family:"Poppins", sans-serif;
}

body{
    background: radial-gradient(circle at top, #1e1e2e, #000);
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:flex-start;
    padding:40px 0;
}

body::before{
    content:"";
    position:absolute;
    width:600px;
    height:600px;
    background:rgba(0, 150, 255, 0.25);
    filter:blur(150px);
    top:-200px;
    left:-150px;
}

.container{
    width:90%;
    max-width:850px;
    padding:35px;
    background:rgba(255,255,255,0.07);
    border-radius:20px;
    border:1px solid rgba(255,255,255,0.18);
    backdrop-filter:blur(15px);
    box-shadow:0 8px 25px rgba(0,0,0,0.4);
    animation:fadeIn 0.7s ease-in-out;
    color:white;
}

@keyframes fadeIn{
    from{opacity:0; transform:translateY(20px);}
    to{opacity:1; transform:translateY(0);}
}

select {
    width: 100%;
    margin-top: 6px;
    padding: 12px;
    border-radius: 10px;
    border: 1px solid rgba(255,255,255,0.25);
    background: rgba(255,255,255,0.1);
    color: #00eaff;
    font-weight: 600;
    font-size: 15px;
    transition: 0.3s;
    appearance: none;
    cursor: pointer;
}

select:focus {
    border-color: #00eaff;
    color: #00ffea;
    background: rgba(0, 30, 50, 0.7);
    box-shadow: 0 0 15px #00eaff;
    outline: none;
}

select option {
    background: #0a0a0a;
    color: #00eaff;
    font-weight: 600;
    padding: 10px;
}

select option:hover {
    background: #003b4f;
    color: #00ffbf;
}

select option:checked {
    background: #005d6e;
    color: white;
}

h1{
    text-align:center;
    margin-bottom:20px;
    color:#00eaff;
    font-size:28px;
    letter-spacing:1px;
}

label{
    margin-top:18px;
    display:block;
    font-weight:600;
    font-size:14px;
}

input[type="text"],
input[type="file"],
textarea,
input[type="date"]{
    width:100%;
    margin-top:6px;
    padding:12px;
    border-radius:10px;
    border:1px solid rgba(255,255,255,0.20);
    background:rgba(255,255,255,0.08);
    color:white;
    font-size:15px;
    transition:0.3s;
}

input:focus,
textarea:focus{
    border-color:#00eaff;
    box-shadow:0 0 10px #00eaff;
    outline:none;
}
input.valid, textarea.valid {
    border-color:#00ff9d;
    box-shadow:0 0 10px #00ff9d;
}
input.invalid, textarea.invalid {
    border-color:#ff4f4f;
    box-shadow:0 0 10px #ff4f4f;
}

.error-msg {
    color:#ff4f4f;
    font-size:13px;
    margin-top:4px;
    display:none;
}

input[type="file"] {
    background: rgba(0,0,0,0.3);
    padding: 12px;
    border-radius: 10px;
    border: 1px solid rgba(255,255,255,0.2);
    cursor: pointer;
    color: #00eaff;
    font-weight: bold;
}

input[type="file"]::-webkit-file-upload-button {
    background: linear-gradient(135deg, #00eaff, #00ff8c);
    border: none;
    padding: 10px 15px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: bold;
    color: black;
    transition: 0.3s;
}

input[type="file"]::-webkit-file-upload-button:hover {
    transform: scale(1.05);
    box-shadow: 0 0 10px #00eaff;
}

.date-picker-wrapper {
    margin-top: 15px;
    background: rgba(255,255,255,0.07);
    border: 1px solid rgba(255,255,255,0.1);
    padding: 12px;
    border-radius: 10px;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    transition: 0.3s;
}

.date-picker-wrapper:hover {
    border-color: #00eaff;
    box-shadow: 0 0 10px #00eaff;
}

.date-picker-wrapper input[type="date"] {
    background: transparent;
    border: none;
    padding: 8px 0;
    color: #00eaff;
    font-size: 15px;
    cursor: pointer;
    outline: none;
}

input[type="submit"]{
    width:100%;
    padding:13px;
    font-size:17px;
    margin-top:25px;
    font-weight:bold;
    border:none;
    border-radius:12px;
    cursor:pointer;
    color:black;
    background:linear-gradient(135deg, #00eaff, #00ff8c);
    transition:0.3s;
}

input[type="submit"]:hover{
    transform:scale(1.03);
    box-shadow:0 0 15px #00eaff;
}

.price-display{
    margin-top:15px;
    font-size:17px;
    font-weight:bold;
    color:#00eaff;
}

.redirect{
    margin-top:18px;
    text-align:center;
}

.redirect a{
    color:#00eaff;
    text-decoration:none;
}

.redirect a:hover{
    text-decoration:underline;
}
</style>
</head>

<body>

<div class="container">

<h1>Suit Stitching Request</h1>

<form id="suitForm" action="suitServlet" method="POST" enctype="multipart/form-data">

    <label>Suit Stitching</label>
    <select name="garment" required>
        <option value="">-- Please choose --</option>
        <option value="shalwar_kameez">Shalwar Kameez</option>
        <option value="kurta_pajama">Kurta Pajama</option>
    </select>

    <label>Select Tailor</label>
    <select name="tailor" required>
    <option value="">-- Please choose --</option>
    <% for(String t : tailors){ %>
        <option value="<%=t%>"><%=t%></option>
    <% } %>
    </select>

    <label>Slai</label>
    <select id="slai" name="slai" required onchange="calculatePrice()">
        <option value="">-- Please choose --</option>
        <option value="single">Single 1000</option>
        <option value="double">Double 1500</option>
    </select>

    <label>Deadline</label>
    <div class="date-picker-wrapper" onclick="openDatePicker()">
        <input type="date" id="date" name="date" required  onchange="validateDate(); calculatePrice();">
    </div>

    <div id="price-display" class="price-display">Estimated Price: Rs 0</div>

    <label>Upload Cloth Picture</label>
    <input type="file" name="face-picture" accept="image/*" required>
    
    <label>Upload Client Picture</label>
    <input type="file" name="client-picture" accept="image/*">
    <label>
    <input type="checkbox" id="hasMeasurements" name="hasMeasurements" value="yes" onchange="toggleMeasurements()">
    I want to enter measurements
    </label>
    <div id="measurementsBox" style="display:none; margin-top:15px;">
    <label>Measurements</label>

    <input type="text" name="teera" class="measure" placeholder="Teera">
    <input type="text" name="ghera" class="measure" placeholder="Ghera">
    <input type="text" name="hip" class="measure" placeholder="Hip">
    <input type="text" name="chest" class="measure" placeholder="Chest">
    <input type="text" name="belly" class="measure" placeholder="Belly">
    <input type="text" name="shalwar" class="measure" placeholder="Shalwar Length">
    <input type="text" name="kameez" class="measure" placeholder="Kameez Length">
    <input type="text" name="shoulder" class="measure" placeholder="Shoulder">
    <input type="text" name="sleeve" class="measure" placeholder="Sleeve">
    <input type="text" name="cuff" class="measure" placeholder="Cuff">
    <input type="text" name="neck" class="measure" placeholder="Neck">
    <input type="text" name="pancha" class="measure" placeholder="Pancha">
    </div>
    
    <label>Your Name</label>
    <input type="text" id="customer-name" name="customer-name" placeholder="Enter your name" required oninput="validateName()">
    <span id="name-error" class="error-msg">Name must contain only alphabets and spaces</span>

    <label>Your Phone Number</label>
    <input type="text" id="customer-phone" name="customer-phone" placeholder="Enter your phone number" required oninput="validatePhone(this)">
    <span id="phone-error" class="error-msg">Phone must be 13–14 digits</span>

    <label>Your WhatsApp Number</label>
    <input type="text" id="customer-whatsapp" name="customer-whatsapp" placeholder="Enter your WhatsApp number" oninput="validatePhone(this)">
    <span id="whatsapp-error" class="error-msg">WhatsApp must be 13–14 digits</span>

    <label>Your Address</label>
    <textarea name="customer-address" rows="3" required placeholder="Enter your address"></textarea>

    <label>Additional Notes</label>
    <textarea name="notes" rows="4" placeholder="Write measurement details or instructions"></textarea>

    <input type="submit" value="Submit Request">
    </form>

    <%
    String success = (String) session.getAttribute("success");
    String errorMsg = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
    %>

    <% if (success != null) { %>
    <p style="color:#00ff9d; background:rgba(0,255,150,0.15); border:1px solid rgba(0,255,150,0.3); padding:10px; border-radius:10px; font-weight:bold; text-align:center; margin-top:15px;"><%= success %></p>
    <% } %>

    <% if (errorMsg != null) { %>
    <p style="color:#ff4f4f; background:rgba(255,80,80,0.15); border:1px solid rgba(255,80,80,0.3); padding:10px; border-radius:10px; font-weight:bold; text-align:center; margin-top:15px;"><%= errorMsg %></p>
    <% } %>

    <p class="redirect">Back to home? <a href="loginIndex.jsp">Home</a></p>
    </div>

   <script>
    function calculatePrice(){
    const slai = document.getElementById("slai").value;
    const dateInput = document.getElementById("date").value;
    const priceDisplay = document.getElementById("price-display");

    let base = 0;
    if(slai === "single") base = 1000;
    if(slai === "double") base = 2000;

    if(dateInput){
        const today = new Date();
        const deadline = new Date(dateInput);
        const diff = Math.ceil((deadline - today) / (1000 * 60 * 60 * 24));

        if(diff < 7) base += 500;
    }

    priceDisplay.textContent = "Estimated Price: Rs " + base;
   }

   function openDatePicker() {
    const dateInput = document.getElementById("date");
    if(dateInput.showPicker){
        dateInput.showPicker();
    } else {
        dateInput.focus();
    }
  }

   function validateName() {
    const name = document.getElementById('customer-name');
    const error = document.getElementById('name-error');
    const regex = /^[A-Za-z\s]+$/;
    if(regex.test(name.value)){
        name.classList.add('valid');
        name.classList.remove('invalid');
        error.style.display = 'none';
    } else {
        name.classList.add('invalid');
        name.classList.remove('valid');
        error.style.display = 'block';
    }
  }

  function validatePhone(input){
    const val = input.value.trim();
    const error = input.id === 'customer-phone' ? document.getElementById('phone-error') : document.getElementById('whatsapp-error');
    if(/^\d{13,14}$/.test(val)){
        input.classList.add('valid');
        input.classList.remove('invalid');
        error.style.display = 'none';
    } else {
        input.classList.add('invalid');
        input.classList.remove('valid');
        error.style.display = 'block';
    }
   }

   document.getElementById('suitForm').addEventListener('submit', function(e){
    const name = document.getElementById('customer-name');
    const phone = document.getElementById('customer-phone');
    const whatsapp = document.getElementById('customer-whatsapp');

    if(!/^[A-Za-z\s]+$/.test(name.value)){
        e.preventDefault();
        name.classList.add('invalid');
        document.getElementById('name-error').style.display='block';
        return;
    }
    if(!/^\d{13,14}$/.test(phone.value)){
        e.preventDefault();
        phone.classList.add('invalid');
        document.getElementById('phone-error').style.display='block';
        return;
    }
    if(whatsapp.value && !/^\d{13,14}$/.test(whatsapp.value)){
        e.preventDefault();
        whatsapp.classList.add('invalid');
        document.getElementById('whatsapp-error').style.display='block';
        return;
    }
  });
   function toggleMeasurements(){
    const box = document.getElementById("measurementsBox");
    box.style.display = document.getElementById("hasMeasurements").checked
        ? "block" : "none";
  }
  document.querySelectorAll(".measure").forEach(input => {
    input.addEventListener("input", function () {
        this.value = this.value.replace(/[^0-9]/g, "");
        if (this.value.length > 2) {
            this.value = this.value.slice(0, 2);
        }
    });
  });
  function setMinDate() {
    const dateInput = document.getElementById("date");

    const now = new Date();
    const today = new Date(
        now.getFullYear(),
        now.getMonth(),
        now.getDate()
    );

    const yyyy = today.getFullYear();
    const mm = String(today.getMonth() + 1).padStart(2, '0');
    const dd = String(today.getDate()).padStart(2, '0');

    const minDate = `${yyyy}-${mm}-${dd}`;

    dateInput.setAttribute("min", minDate);
   }
   window.addEventListener("DOMContentLoaded", setMinDate);
   function validateDate() {
    const dateInput = document.getElementById("date");
    if (!dateInput.value) return;

    const selected = new Date(dateInput.value);
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    if (selected < today) {
        alert("Past dates are not allowed. Please select today or a future date.");
        dateInput.value = "";
    }
  }
 </script>

</body>
</html>

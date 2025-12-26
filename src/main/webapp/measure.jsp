<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tailoring Measurements</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

<style>
* {
 margin:0; 
 padding:0;
  box-sizing:border-box;
   font-family:'Poppins', sans-serif;
    }
body { 
background: radial-gradient(circle at top,#1e1e2e,#000); 
color:white;
min-height:100vh;
display:flex;
flex-direction:column;
align-items:center;
padding:50px 20px; 
     }
body::before {
     content:""; 
     position:absolute; 
     width:700px;
     height:700px;
     background:rgba(0, 150, 255,0.1);
     filter:blur(150px);
     top:-200px;
     left:-200px;
     z-index:0;
        }

.header {
   text-align:center;
   margin-bottom:30px;
   z-index:1;
   position:relative;
     }
.header h1 {
 font-size:2.5rem;
  color:#00eaff;
   font-weight:700;
    }
.header p {
 color:#ccc;
  font-size:1.2rem;
   margin-top:5px;
    }

.form-container {
 background:rgba(255,255,255,0.07);
  border-radius:20px;
   border:1px solid rgba(255,255,255,0.2);
    backdrop-filter:blur(15px);
     padding:30px; max-width:500px;
      width:100%;
       z-index:1;
        position:relative;
         }
         
label {
 display:block;
  font-weight:600;
   margin-bottom:5px;
    color:#00eaff;
     }
input[type="text"], button {
 width:100%;
  padding:12px;
   margin-bottom:10px;
    border-radius:10px;
     border:none;
      font-size:1rem;
       }
input[type="text"] {
 background:rgba(255,255,255,0.1);
  color:white;
   border:1px solid rgba(0,255,255,0.3);
    }
input[type="text"]::placeholder {
 color:rgba(255,255,255,0.6);
  }

.error-msg {
 color:#ff4d4d; 
 font-size:0.9rem;
  margin-bottom:10px;
   display:none;
    }

button {
 background:
 linear-gradient(135deg,#00eaff,#00ff8c);
  font-weight:bold;
   color:black; 
   cursor:pointer;
    transition:0.3s;
     border:1px solid #00eaff;
      }
button:hover {
 transform:scale(1.05);
  box-shadow:0 0 15px #00eaff,0 0 25px #00ff9d;
   }
button:disabled {
 background: rgba(0,255,140,0.5);
  cursor: not-allowed;
   }

.result {
 background:rgba(255,255,255,0.07);
  border-radius:20px;
   border:1px solid rgba(0,255,255,0.2);
    padding:25px;
     max-width:500px; 
     margin-top:25px;
      z-index:1;
       position:relative;
        }
.result h2 {
 color:#00eaff; 
 margin-bottom:15px;
  text-align:center;
   }
.result ul {
 list-style:none; 
 padding:0; 
 }
.result ul li {
 margin-bottom:10px;
  font-size:1rem;
   color:#00ff9d;
    display:flex;
     align-items:center;
      gap:10px;
       }
.result ul li i { 
color:#00eaff; 
}
.result ul li span {
  display:inline-block;
  animation: neonPulse 1.5s infinite alternate;
  font-weight:bold;
  color:#00ff9d;
}
@keyframes neonPulse {
  0% { text-shadow: 0 0 5px #00ff9d, 0 0 10px #00ff9d; }
  100% { text-shadow: 0 0 15px #00ff9d, 0 0 25px #00ff9d; }
}

.copy-btn {
    margin-top:10px;
    padding:10px 20px;
    background:#00eaff;
    border:none;
    border-radius:10px;
    font-weight:bold;
    cursor:pointer;
    color:black;
}
.copy-btn:hover {
 background:#00ff8c;
  }

.disclaimer {
 font-size:0.85rem;
  color:#ffcc00;
   margin-top:10px;
    text-align:center;
     }

.redirect {
 text-align:center;
  margin-top:20px;
   }
.redirect a {
 color:#00eaff; 
 text-decoration:none; 
 font-weight:bold;
  }
.redirect a:hover {
 text-decoration:underline;
  }

@media(max-width:480px){
    .header h1{font-size:1.8rem;}
    .header p{font-size:1rem;}
    button, .copy-btn{
    padding:10px;
     font-size:0.95rem;
     }
}
</style>
</head>
<body>

<div class="header">
    <h1><i class="fas fa-ruler-combined"></i> Tailoring Measurements</h1>
    <p>Estimate your garment measurements easily</p>
</div>

<div class="form-container">
    <form method="post" id="measurementForm">
        <label for="chest_size">Chest Size (10-50 inches) <i class="fas fa-tshirt"></i></label>
        <input type="text" id="chest_size" name="chest_size" placeholder="Enter chest size" required>
        <div class="error-msg" id="chestError">Enter a valid number between 10 and 50.</div>

        <label for="kameez_length">Kameez Length (10-50 inches) <i class="fas fa-arrows-alt-v"></i></label>
        <input type="text" id="kameez_length" name="kameez_length" placeholder="Optional">
        <div class="error-msg" id="kameezError">Enter a valid number between 10 and 50.</div>

        <label for="shalwar_length">Shalwar Length (10-50 inches) <i class="fas fa-arrows-alt-v"></i></label>
        <input type="text" id="shalwar_length" name="shalwar_length" placeholder="Optional">
        <div class="error-msg" id="shalwarError">Enter a valid number between 10 and 50.</div>

        <button type="submit" id="calculateBtn"><i class="fas fa-calculator"></i> Calculate</button>
<button type="button" id="resetBtn"><i class="fas fa-undo"></i> Reset</button>

        <p class="disclaimer"><i class="fas fa-exclamation-triangle"></i> Disclaimer: These measurements are estimations and may not be perfectly accurate, especially for special cases like belly, extreme body types, or bodybuilders.</p>
    </form>
</div>

<% 
if (request.getMethod().equalsIgnoreCase("POST")) {
    String chestSizeParam = request.getParameter("chest_size");
    String kameezLengthParam = request.getParameter("kameez_length");
    String shalwarLengthParam = request.getParameter("shalwar_length");

    double chestSize = Double.parseDouble(chestSizeParam);
    Double kameezLength = (kameezLengthParam != null && !kameezLengthParam.isEmpty()) 
                           ? Double.parseDouble(kameezLengthParam) : null;
    Double shalwarLength = (shalwarLengthParam != null && !shalwarLengthParam.isEmpty()) 
                            ? Double.parseDouble(shalwarLengthParam) : null;

    double fullChest = chestSize;
    double halfChest = fullChest / 2;
    double kandhaNormal = fullChest / 4;
    double kandhaFitting = kandhaNormal - 1;
    double teeraNormal = (fullChest / 4) + 7;
    double teeraFitting = teeraNormal - 1;
    double gheraKhula = halfChest + 6;
    double gheraNormal = halfChest + 5;
    double gheraFitting = halfChest + 4;
    double hip = gheraNormal - 1;
    double waist = gheraNormal - 2;
    Double pancha = (shalwarLength != null) ? shalwarLength / 4 : null;
    Double sleeves = (kameezLength != null) ? (kameezLength / 2 + 4) : null;
%>

<div class="result" id="measurementResult">
    <h2><i class="fas fa-ruler"></i> Calculated Measurements</h2>
    <ul>
        <li><i class="fas fa-arrows-alt"></i> Kandha Normal (Armhole): <span><%= String.format("%.2f", kandhaNormal) %></span></li>
        <li><i class="fas fa-arrows-alt"></i> Kandha Fitting (Armhole): <span><%= String.format("%.2f", kandhaFitting) %></span></li>
        <li><i class="fas fa-expand-arrows-alt"></i> Teera Normal (Waist Curve): <span><%= String.format("%.2f", teeraNormal) %></span></li>
        <li><i class="fas fa-expand-arrows-alt"></i> Teera Fitting (Waist Curve): <span><%= String.format("%.2f", teeraFitting) %></span></li>
        <li><i class="fas fa-circle-notch"></i> Ghera Khula: <span><%= String.format("%.2f", gheraKhula) %></span></li>
        <li><i class="fas fa-circle-notch"></i> Ghera Normal: <span><%= String.format("%.2f", gheraNormal) %></span></li>
        <li><i class="fas fa-circle-notch"></i> Ghera Fitting: <span><%= String.format("%.2f", gheraFitting) %></span></li>
        <li><i class="fas fa-arrows-alt-h"></i> Hip: <span><%= String.format("%.2f", hip) %></span></li>
        <li><i class="fas fa-arrows-alt-h"></i> Waist: <span><%= String.format("%.2f", waist) %></span></li>
        <% if (pancha != null) { %>
        <li><i class="fas fa-caret-down"></i> Pancha: <span><%= String.format("%.2f", pancha) %></span></li>
        <% } if (sleeves != null) { %>
        <li><i class="fas fa-hand-paper"></i> Sleeves: <span><%= String.format("%.2f", sleeves) %></span></li>
        <% } %>
    </ul>
    <button class="copy-btn" onclick="copyMeasurements()"><i class="fas fa-copy"></i> Copy Measurements</button>
</div>

<% } %>

<p class="redirect">Back to home page? <a href="loginIndex.jsp">Home</a></p>

<script>
const chestInput = document.getElementById('chest_size');
const kameezInput = document.getElementById('kameez_length');
const shalwarInput = document.getElementById('shalwar_length');
const calculateBtn = document.getElementById('calculateBtn');

const chestError = document.getElementById('chestError');
const kameezError = document.getElementById('kameezError');
const shalwarError = document.getElementById('shalwarError');

function validateNumber(input, errorElem, required = false){
    const value = input.value.trim();
    if(required && value === "") { errorElem.style.display = "block"; return false; }
    if(value !== "" && (!/^\d+(\.\d+)?$/.test(value) || parseFloat(value)<10 || parseFloat(value)>50)){ errorElem.style.display = "block"; return false; }
    errorElem.style.display = "none";
    return true;
}

function validateForm() {
    const chestValid = validateNumber(chestInput, chestError, true);
    const kameezValid = validateNumber(kameezInput, kameezError, false);
    const shalwarValid = validateNumber(shalwarInput, shalwarError, false);
    calculateBtn.disabled = !(chestValid && kameezValid && shalwarValid);
}

chestInput.addEventListener('input', validateForm);
kameezInput.addEventListener('input', validateForm);
shalwarInput.addEventListener('input', validateForm);
validateForm();

function copyMeasurements(){
    const result = document.getElementById('measurementResult');
    if(result){
        let text = "";
        result.querySelectorAll('li').forEach(li=>{
            text += li.innerText + "\n";
        });
        navigator.clipboard.writeText(text).then(()=>{
            alert("Measurements copied to clipboard!");
        });
    }
}

const resetBtn = document.getElementById('resetBtn');
resetBtn.addEventListener('click', () => {
   
    chestInput.value = '';
    kameezInput.value = '';
    shalwarInput.value = '';
  
    chestError.style.display = 'none';
    kameezError.style.display = 'none';
    shalwarError.style.display = 'none';

    const resultDiv = document.getElementById('measurementResult');
    if(resultDiv){
        resultDiv.style.display = 'none';
    }

    calculateBtn.disabled = false;
});

</script>

</body>
</html>

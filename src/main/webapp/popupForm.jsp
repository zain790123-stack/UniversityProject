<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Form</title>
<style>
* {
 margin:0;
  padding:0; 
  box-sizing:border-box; 
  font-family:"Poppins", sans-serif; 
  }

body {
    background: radial-gradient(circle at top, #1e1e2e, #000);
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:flex-start;
    padding:40px 0;
    color:white;
    position:relative;
}
body::before {
    content:"";
    position:absolute;
    width:600px;
    height:600px;
    background:rgba(0, 150, 255,0.1);
    filter:blur(150px);
    top:-200px;
    left:-200px;
}
.container {
    width:90%;
    max-width:500px;
    padding:35px;
    background:rgba(255,255,255,0.07);
    border-radius:20px;
    border:1px solid rgba(255,255,255,0.18);
    backdrop-filter:blur(15px);
    box-shadow:0 8px 25px rgba(0,0,0,0.4);
    animation:fadeIn 0.7s ease-in-out;
    position:relative;
}

@keyframes fadeIn {
 from{
 opacity:0; 
 transform:translateY(20px);
 } 
 to{
  opacity:1;
  transform:translateY(0);
  } }

h1 { 
  text-align:center; 
  color:#00eaff;
  margin-bottom:25px;
  font-weight:700;
   }

label {
   display:block;
   margin-top:15px;
   font-weight:600;
   color:white;
    }
input[type="text"], input[type="tel"], textarea, select {
    width:100%;
    margin-top:6px;
    padding:12px; 
    border-radius:10px; 
    border:1px solid rgba(255,255,255,0.25);
    background: rgba(255,255,255,0.08); 
    color:white;
    font-size:15px;
    transition:0.3s;
}
input:focus, textarea:focus, select:focus { 
border-color:#00eaff;
 box-shadow:0 0 10px #00eaff; 
 outline:none; 
 }
textarea {
 resize:vertical; 
 }

select {
 appearance:none; 
 cursor:pointer;
 color:#00eaff; 
 font-weight:600;
 background: rgba(255,255,255,0.08); 
   }
select option {
 background:#0a0a0a; 
 color:#00eaff; 
 font-weight:600;
  }
select option:hover { 
background:#003b4f;
 color:#00ffbf;
  }
button[type="submit"] {
    width:100%;
    padding:13px;
    margin-top:20px; 
    border:none;
    border-radius:12px;
    font-size:16px;
    font-weight:bold; 
    color:black;
    background:linear-gradient(135deg,#00eaff,#00ff8c);
    cursor:pointer; 
    transition:0.3s;
}
button[type="submit"]:hover { 
transform:scale(1.03);
 box-shadow:0 0 15px #00eaff; 
 }

.error-msg { 
color:#ff4f4f;
 font-size:14px;
  margin-top:4px;
   display:none;
    }

@media(max-width:480px) {
 .container { 
 padding:25px; 
 }
  h1
   {
    font-size:1.8rem;
     } }

</style>
<script>
window.onload = function () {
    const params = new URLSearchParams(window.location.search);
    const product = params.get("product");
    const price = params.get("price");
    if(product) document.getElementById("product").value = product;
    if(price) document.getElementById("price").value = price;

    const nameInput = document.getElementById("name");
    const phoneInput = document.getElementById("phone");
    const whatsappInput = document.getElementById("whatsapp");

    nameInput.addEventListener("input", ()=> {
        const regex = /^[A-Za-z\s]+$/;
        const error = document.getElementById("nameError");
        if(!regex.test(nameInput.value)) {
            error.style.display="block";
        } else {
            error.style.display="none";
        }
    });

    phoneInput.addEventListener("input", ()=>{
        const error = document.getElementById("phoneError");
        const val = phoneInput.value.replace(/\D/g,'');
        phoneInput.value = val;
        if(val.length<13 || val.length>14) {
            error.style.display="block";
        } else {
            error.style.display="none";
        }
    });

    if(whatsappInput){
        whatsappInput.addEventListener("input", ()=>{
            const error = document.getElementById("whatsappError");
            const val = whatsappInput.value.replace(/\D/g,'');
            whatsappInput.value = val;
            if(val.length<13 || val.length>14) {
                error.style.display="block";
            } else {
                error.style.display="none";
            }
        });
    }
}
</script>
</head>
<body>

<div class="container">
    <h1>Order Form</h1>
    <form action="submitOrder" method="POST">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required>
        <div id="nameError" class="error-msg">Name must contain only alphabets!</div>

        <label for="phone">Phone Number:</label>
        <input type="tel" id="phone" name="phone" required placeholder="13-14 digits">
        <div id="phoneError" class="error-msg">Phone number must be 13-14 digits!</div>

        <label for="address">Address:</label>
        <textarea id="address" name="address" rows="3" required></textarea>

        <label for="product">Product Name:</label>
        <input type="text" id="product" name="product" required>

        <label for="price">Price:</label>
        <input type="text" id="price" name="price" required>

        <label for="payment">Payment Method:</label>
        <select id="payment" name="payment" required>
            <option value="">-- Please choose --</option>
            <option value="Credit Card">Credit/Debit Card</option>
            <option value="JazzCash">JazzCash</option>
            <option value="Bank Transfer">Bank Transfer</option>
            <option value="Cash on Delivery">Cash on Delivery</option>
        </select>

        <button type="submit">Buy Product</button>
    </form>
</div>

</body>
</html>

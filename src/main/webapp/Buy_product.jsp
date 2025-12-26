<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Shalwar Kameez Designs</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

<style>
* {
    box-sizing: border-box;
    margin:0; padding:0;
    font-family:"Poppins", sans-serif;
}

body {
    background: radial-gradient(circle at top, #1e1e2e, #000);
    color:white;
    min-height:100vh;
    overflow-x:hidden;
    position:relative;
}

body::before {
    content:"";
    position:absolute;
    width:700px; height:700px;
    background:rgba(0, 150, 255,0.1);
    filter:blur(150px);
    top:-200px; left:-200px;
    z-index:0;
}

.header {
    text-align:center;
    padding:30px 0;
    position:relative;
    z-index:1;
}

.header h1 {
    color:#00eaff;
    font-size:2.5rem;
    margin-bottom:10px;
    font-weight:700;
    text-shadow:none;
}

.header p {
    color:#ccc;
    font-size:1.2rem;
    text-shadow:none;
}

.products-container {
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
    gap:25px;
    padding:20px;
    max-width:1200px;
    margin:0 auto;
    position:relative;
    z-index:1;
}

.product-card {
    background:rgba(255,255,255,0.05);
    border-radius:15px;
    border:1px solid rgba(0,255,255,0.2);
    overflow:hidden;
    text-align:center;
    padding-bottom:15px;
    transition: all 0.3s ease;
    box-shadow:0 8px 20px rgba(0,0,0,0.5);
}

.product-card:hover {
    transform:translateY(-5px) scale(1.02);
    box-shadow:0 0 15px #00eaff,0 0 25px #00ff9d;
    border-color:#00eaff;
}

/* FIXED IMAGE SIZE */
.product-card img {
    width:100%;
    height:250px;        /* fixed height */
    object-fit:cover;     /* maintain aspect ratio, crop if necessary */
    border-bottom:1px solid rgba(255,255,255,0.2);
}

.product-card h3 {
    color:#00eaff;
    margin:15px 10px 5px;
    font-weight:600;
}

.product-card .price {
    color:#00ff9d;
    font-weight:bold;
    margin-bottom:10px;
}

.product-card p {
    font-size:0.95rem;
    color:#ccc;
    margin:0 10px 10px;
}

.product-card .btn {
    display:inline-block;
    margin:10px;
    padding:12px 25px;
    background:linear-gradient(135deg,#00eaff,#00ff8c);
    color:black;
    border-radius:10px;
    font-weight:bold;
    text-decoration:none;
    transition:0.3s;
    box-shadow:0 0 5px #00eaff,0 0 10px #00ff8c;
}

.product-card .btn:hover {
    transform:scale(1.05);
    box-shadow:0 0 10px #00eaff,0 0 20px #00ff9d;
}

.payment-methods {
    background:rgba(255,255,255,0.05);
    padding:30px 20px;
    text-align:center;
    max-width:1200px;
    margin:40px auto 30px;
    border-radius:15px;
    border:1px solid rgba(0,255,255,0.2);
    box-shadow:0 8px 20px rgba(0,0,0,0.5);
}

.payment-methods h2 {
    color:#00eaff;
    margin-bottom:20px;
    font-weight:600;
    text-shadow:none;
}

.payment-methods ul {
    list-style:none;
    padding:0;
    display:flex;
    justify-content:center;
    gap:30px;
    flex-wrap:wrap;
}

.payment-methods ul li {
    color:#00ff9d;
    font-weight:600;
    display:flex;
    align-items:center;
    gap:10px;
    font-size:1.1rem;
}

.payment-methods ul li i {
    color:#00eaff;
    font-size:1.5rem;
}

.footer {
    text-align:center;
    margin-top:30px;
    color:#ccc;
    font-size:0.95rem;
    padding-bottom:50px;  /* added bottom padding */
}
.redirect{
padding-bottom:10px;
}
.redirect a{
    color:#00eaff;
    text-decoration:none;
    font-weight:bold;
}

.redirect a:hover{
    text-decoration:underline;
}

@media (max-width:480px){
    .header h1{font-size:1.8rem;}
    .header p{font-size:1rem;}
    .product-card .btn{padding:10px 18px; font-size:0.9rem;}
    .payment-methods ul{gap:15px;}
    .payment-methods ul li{font-size:0.95rem;}
}
</style>
</head>
<body>

<header class="header">
    <h1>Buy Our Tailoring Products</h1>
    <p>Explore our latest and new tailoring items!</p>
</header>

<main class="products-container">
    <div class="product-card">
        <img src="images/Blazer.webp" alt="Elegant Pent Shirt">
        <h3>Elegant Blazer</h3>
        <p class="price">Rs 2500.00</p>
        <p>Stylish and comfortable outfit for any occasion.</p>
        <a class="btn" href="popupForm.jsp?product=Elegant Pent Shirt&price=2500">Add to Cart</a>
    </div>

    <div class="product-card">
        <img src="images/kurta pajama.webp" alt="Classic Kurta Pajama">
        <h3>Classic Kurta Pajama</h3>
        <p class="price">Rs 1800.00</p>
        <p>Perfect for formal events and traditional gatherings.</p>
        <a class="btn" href="popupForm.jsp?product=Classic Kurta Pajama&price=1800">Add to Cart</a>
    </div>

    <div class="product-card">
        <img src="images/shalwar kameez.webp" alt="Casual Shalwar Kameez">
        <h3>Casual Shalwar Kameez</h3>
        <p class="price">Rs 1600.00</p>
        <p>Designed for comfort and style in everyday wear.</p>
        <a class="btn" href="popupForm.jsp?product=Casual Shalwar Kameez&price=1600">Add to Cart</a>
    </div>

    <div class="product-card">
        <img src="images/sw1.jpg" alt="Compact Sewing Machine">
        <h3>Compact Sewing Machine</h3>
        <p class="price">Rs 35600.00</p>
        <p>Lightweight and easy-to-use for beginners.</p>
        <a class="btn" href="popupForm.jsp?product=Compact Sewing Machine&price=35600">Add to Cart</a>
    </div>

    <div class="product-card">
        <img src="images/sw2.jpg" alt="Professional juki Sewing Machine">
        <h3>Professional juki Sewing Machine</h3>
        <p class="price">Rs 40000.00</p>
        <p>Advanced features for professional and home use.</p>
        <a class="btn" href="popupForm.jsp?product=Professional juki Sewing Machine&price=40000">Add to Cart</a>
    </div>

    <div class="product-card">
        <img src="images/sw3.jpg" alt="Singer Sewing Machine">
        <h3>Singer Sewing Machine</h3>
        <p class="price">Rs 12000.00</p>
        <p>Ideal for sewing thick fabrics like denim.</p>
        <a class="btn" href="popupForm.jsp?product=Singer Sewing Machine&price=12000">Add to Cart</a>
    </div>
</main>

<footer class="footer">
    <div class="payment-methods">
        <h2>Payment Methods:</h2>
        <ul>
            <li><i class="fas fa-credit-card"></i> Credit/Debit Cards</li>
            <li>JazzCash</li>
            <li><i class="fas fa-university"></i> Bank Transfer</li>
            <li><i class="fas fa-money-bill-wave"></i> Cash on Delivery</li>
        </ul>
    </div>
    <p class="redirect">Back to home page? <a href="loginIndex.jsp">Home</a></p>
    <p>&copy; 2025 ZTailor Craft. All rights reserved.</p>
</footer>

</body>
</html>

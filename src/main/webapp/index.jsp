<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ZTailor Craft</title>

<link rel="icon" href="images/fav.png">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&family=Playfair+Display:wght@600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css">

<style>
*{
margin:0;
padding:0;
box-sizing:border-box
}
body{
font-family:Poppins,sans-serif;
background:#0e0e0e;
color:#fff
}

.navbar{
position:fixed;
top:0;width:100%;
z-index:1000;
display:flex;
justify-content:space-between;
align-items:center;
padding:15px 40px;
background:rgba(0,0,0,.6);
backdrop-filter:blur(6px)
}
.logo-wrap{
display:flex;
align-items:center;
gap:10px;
text-decoration:none
}
.logo-wrap img{
height:40px
}
.logo-wrap span{
font-family:Playfair Display,serif;
font-size:1.8em;
color:#ff6147
}
.nav-links a{
margin-left:20px;
color:#fff;
text-decoration:none
}
.nav-links a:hover{
color:#ff6147
}

.slider{
margin-top:70px;
height:100vh;
position:relative;
overflow:hidden
}
.slides img{

position:absolute;
width:100%;
height:100%;
object-fit:cover;
opacity:0;
animation:fade 20s infinite
}
.slides img:nth-child(1){
animation-delay:0s
}
.slides img:nth-child(2){
animation-delay:5s
}
.slides img:nth-child(3){
animation-delay:10s
}
.slides img:nth-child(4){
animation-delay:15s
}
@keyframes fade{
0%{opacity:0}10%{opacity:1}30%{opacity:1}40%{opacity:0}100%{opacity:0}
}

.hero-text{
position:absolute;
top:50%;
left:50%;
transform:translate(-50%,-50%);
text-align:center
}
.hero-text h1{
font-family:Playfair Display,serif;
font-size:3.4em;color:#ff6147;
text-shadow:0 0 25px rgba(0,0,0,.7)
}
.hero-text p{
margin-top:15px;
font-size:1.3em
}
.cta-btn{
margin-top:25px;
display:inline-block;
padding:15px 35px;
border-radius:8px;
background:linear-gradient(45deg,#ff6147,#ff3b2e);
color:#fff;
text-decoration:none
}

.features{
padding:80px 40px;
text-align:center
}
.features h2{
color:#ff6147;
font-size:2.5em;
margin-bottom:40px
}
.feature-container{
display:flex;
justify-content:center;
gap:30px;
flex-wrap:wrap
}
.feature-card{
width:280px;
background:#1a1a1a;
padding:30px;
border-radius:12px;
border:1px solid #292929
}
.feature-card i{
font-size:2.5em;
color:#ff6147;
margin-bottom:15px
}

.reviews{
padding:80px 40px;
background:#141414
}
.review-wrapper{
max-width:1200px;
margin:auto;
display:flex;
gap:40px;
align-items:flex-start
}
.review-form, .review-box{
flex:1;
background:#1a1a1a;
padding:30px;
border-radius:12px;
border:1px solid #292929
}
.review-form h3, .review-box h3{
color:#ff6147;
margin-bottom:15px
}

.review-form input,
.review-form textarea{
width:100%;
padding:12px;
margin-bottom:12px;
border:none;
border-radius:6px;
outline:none
}
.review-form button{
background:#28a745;
color:#fff;
padding:12px 25px;
border:none;
border-radius:6px;
font-size:1em;
cursor:pointer
}
.review-form button:hover{
background:#218838
}
#successMsg{
display:none;
background:#28a745;
color:#fff;
padding:10px;
margin-top:10px;
border-radius:6px;
animation:fadeOut 4s forwards
}
@keyframes fadeOut{
0%{opacity:1}
80%{opacity:1}
100%{opacity:0;display:none}
}

.review-slider{
max-height:280px;
overflow:hidden
}
.review-slider ul{
list-style:none;
animation:slideReviews 15s linear infinite
}
.review-slider li{
margin-bottom:15px
}
.review-text{
color:#8aff8a
}
@keyframes slideReviews{0%{transform:translateY(0)}100%{transform:translateY(-100%)}}

section.affiliates{
padding:80px 40px;
text-align:center
}

footer{
background:#111;
padding:40px;
text-align:center
}
.socials a{
color:#fff;
font-size:1.6em;
margin:0 12px;
transition:.3s
}
.socials a:hover{
color:#ff6147}

.whatsapp-float{
position:fixed;
bottom:20px;
right:20px;
width:60px;
height:60px;
border-radius:50%;
background:#25D366;
color:#fff;
display:flex;
align-items:center;
justify-content:center;
font-size:30px;
z-index:999
}

@media(max-width:900px){
.review-wrapper{flex-direction:column}
.hero-text h1{font-size:2.6em}
}
</style>
</head>

<body>

<div class="navbar">
<a href="index.jsp" class="logo-wrap">
<img src="images/logo1.png">
<span>ZTailor Craft</span>
</a>
<div class="nav-links">
<a href="unifiedLogin.jsp">Login</a>
<a href="signup.jsp">Sign Up</a>
<a href="affilate tailors.jsp">Affiliate Tailor</a>
</div>
</div>

<div class="slider">
<div class="slides">
<img src="images/t3.jpg">
<img src="images/land1.png">
<img src="images/t6.jpg">
<img src="images/t4.png">
</div>
<div class="hero-text">
<h1>Perfect Fit For Perfect Body Trusted Tailoring</h1>
<p>Custom stitching  Doorstep service  Premium craftsmanship</p>
<a href="about_us.html" class="cta-btn">More About Us</a>
</div>
</div>

<section class="features">
<h2 data-aos="fade-up">Why Choose Us?</h2>
<div class="feature-container">
<div class="feature-card" data-aos="zoom-in">
<i class="fas fa-scissors"></i>
<h3>Custom Tailoring</h3>
<p>Expert cutting and stitching for perfect fitting.</p>
</div>
<div class="feature-card" data-aos="zoom-in">
<i class="fas fa-ruler-combined"></i>
<h3>Online Measurement</h3>
<p>Easy measurement process from your home.</p>
</div>
<div class="feature-card" data-aos="zoom-in">
<i class="fas fa-truck-fast"></i>
<h3>Pickup &amp; Delivery</h3>
<p>We pick, stitch and deliver at your doorstep.</p>
</div>
</div>
</section>

<section class="reviews">
<h2 style="color:#ff6147;text-align:center;font-size:2.5em;margin-bottom:40px">Customer Reviews</h2>

<div class="review-wrapper">

<div class="review-form">
<h3>Write a Review</h3>
<form action="SubmitReviewServlet" method="post">
<input type="text" name="name" placeholder="Your Name" required>
<textarea name="review" rows="4" placeholder="Your Review" required></textarea>
<button type="submit">Submit Review</button>
<div id="successMsg">Review submitted successfully!</div>
</form>
</div>

<div class="review-box">
<h3>What Customers Say</h3>
<div class="review-slider">
<ul>
<%
String url="jdbc:mysql://localhost:3306/tailor_shop";
String dbUser="root";
String dbPassword="12345";
try{
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con=DriverManager.getConnection(url,dbUser,dbPassword);
PreparedStatement ps=con.prepareStatement(
"SELECT name, review, created_at FROM reviews ORDER BY created_at DESC");
ResultSet rs=ps.executeQuery();
while(rs.next()){
%>
<li>
<strong><%=rs.getString("name")%></strong><br>
<span class="review-text"><%=rs.getString("review")%></span>
</li>
<%}
rs.close();ps.close();con.close();
}catch(Exception e){out.println(e.getMessage());}%>
</ul>
</div>
</div>

</div>
</section>

<section style="padding:80px 40px;text-align:center">
<h2 style="color:#ff6147;font-size:2.5em">Benefits for Tailor Affiliates</h2>
<p style="max-width:700px;margin:auto;color:#ccc">
Join ZTailor Craft as an affiliate tailor and grow your customer base.
</p>

<div style="display:flex;justify-content:center;gap:25px;flex-wrap:wrap;margin-top:40px">
<div style="width:300px;background:#1a1a1a;padding:25px;border-radius:12px">
<h3 style="color:#ff6147">Requirements</h3>
<ul style="text-align:left;line-height:1.8">
<li>Valid Picture</li>
<li>1+ Year Experience</li>
<li>Dedicated</li>
<li>Basic Tools</li>
</ul>
</div>

<div style="width:300px;background:#1a1a1a;padding:25px;border-radius:12px">
<h3 style="color:#ff6147">What You Get</h3>
<ul style="text-align:left;line-height:1.8">
<li>Verified Badge</li>
<li>Guaranteed Orders</li>
<li>Delivery Support</li>
<li>Tailor Dashboard</li>
</ul>
</div>
</div>
</section>

<footer>
<p>© 2025 ZTailor Craft</p>
<div class="socials">
<a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i></a>
<a href="https://youtube.com" target="_blank"><i class="fab fa-youtube"></i></a>
<a href="https://x.com" target="_blank"><i class="fab fa-x-twitter"></i></a>
</div>
</footer>

<a href="https://wa.me/923049289203" class="whatsapp-float" target="_blank">
<i class="fab fa-whatsapp"></i>
</a>

<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>AOS.init();</script>

<script>
const params=new URLSearchParams(window.location.search);
if(params.get("success")==="true"){
const msg=document.getElementById("successMsg");
msg.style.display="block";
setTimeout(()=>msg.style.display="none",4000);
}
</script>

</body>
</html>

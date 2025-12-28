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
<link rel="stylesheet" type="text/css" href="css/style.css">

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
<h1>From Fabric to Fabulous</h1>
<p>Custom stitching  Doorstep service  Premium craftsmanship</p>
<a href="about_us.html" class="cta-btn">About Us</a>
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
<h3>Measurement Estimation</h3>
<p>Calculate measurement from your home.</p>
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
<a href="https://www.instagram.com/" target="_blank"> <i class="fab fa-instagram"></i>
</a>

</div>
</footer>

<a href="https://wa.me/923049289203" class="whatsapp-float" target="_blank">
<i class="fab fa-whatsapp"></i>
</a>

<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script src="${pageContext.request.contextPath}/javascript/script.js"></script>

</body>
</html>

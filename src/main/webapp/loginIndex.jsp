<%
HttpSession s = request.getSession(false);
if (s == null || s.getAttribute("username") == null) {
    response.sendRedirect("unifiedLogin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ZTailor Craft</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="images/fav.png">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/loginIndex.css">
 
</head>
<body>
    <div class="container">
    <div class="landing_page">
   <div class="navbar">
<a href="loginIndex.jsp" class="logo-wrap">
<img src="images/logo1.png">
<span>ZTailor Craft</span>
</a>
<div class="nav-links">
<a  href="measure.jsp">Calculate Your Meaurements</a>
     <a href="CheckRequestStatus.jsp">Request Status</a>
       <a href="logout.jsp">Logout</a>
</div>
</div>
  
    <div class="content">
      <h1 class="header">ZTailor Craft</h1>
      <p class="subheader">A brand for style and quality</p>
  
      <div id="services" class="services">
        <div class="service-card">
          <i class="fas fa-tshirt fa-2x"></i>
          <h3>Suit Tailoring</h3>
          <p>Perfect fits for your professional needs</p>
          <a href="StitchForm.jsp">Click Now</a>
        </div>
        <div class="service-card">
          <i class="fas fa-cut fa-2x"></i>
          <h3>Alterations</h3>
          <p>Ensure your clothes fit and stylish</p>
          <a href="alterForm.jsp">Click Now</a>
        </div>
        <div class="service-card">
          <i class="fas fa-shopping-bag fa-2x"></i>
          <h3>Buy Products</h3>
          <p>Buy our tailoring products</p>
          <a href="Buy_product.jsp">Click Now</a>
        </div>
      </div>
    </div>

<div class="slider-container">
    <h1>Tailoring Gallery</h1>
    <div class="slider">
        <div class="slider-track">
            <div class="slide"><img src="images/t1.jpg" alt="Slide 1"></div>
            <div class="slide"><img src="images/t2.jpg" alt="Slide 2"></div>
            <div class="slide"><img src="images/t4.png" alt="Slide 3"></div>
            <div class="slide"><img src="images/t5.jpg" alt="Slide 4"></div>
            <div class="slide"><img src="images/t6.jpg" alt="Slide 5"></div>
        </div>
        <button class="slider-btn left" id="prevBtn">&#10094;</button>
        <button class="slider-btn right" id="nextBtn">&#10095;</button>
        <div class="slider-dots" id="sliderDots"></div>
    </div>
</div>

<div class="affiliated-tailors">
    <h1>Meet Our Affiliated Tailors</h1>
    <div class="tailor-grid">
        <div class="tailor-card">
            <img src="images/ta1.jpg" alt="Tailor 1">
            <h3>Mohsin Raza</h3>
            <p><strong>Experience:</strong> 10 years</p>
            <p><strong>Specialty:</strong> Shalwar Kameez, Kurta</p>
            <p><strong>Efficiency:</strong> On-time delivery</p>
            <p><strong>Start Price:</strong>  Rs 1200</p>
            <p><strong>Rating:</strong> &#9733;&#9733;&#9733;&#9733;&#9734;</p>
            <span class="status busy">Busy</span>
        </div>
        <div class="tailor-card">
            <img src="images/tail2.jpg" alt="Tailor 2">
            <h3>Ali Raza</h3>
            <p><strong>Experience:</strong> 7 years</p>
            <p><strong>Specialty:</strong> Trouser specialist</p>
            <p><strong>Efficiency:</strong> High-quality design</p>
            <p><strong>Start Price:</strong>  1100</p>
           <p><strong>Rating:</strong> &#9733;&#9733;&#9733;&#9733;&#9734;</p>
           <span class="status available">Available</span>
        </div>
        <div class="tailor-card">
            <img src="images/tailor.jpg" alt="Tailor 3" >
            <h3>Shehbaz Umer</h3>
            <p><strong>Experience:</strong> 9 years</p>
            <p><strong>Specialty:</strong> Traditional wear</p>
            <p><strong>Efficiency:</strong> Custom fittings</p>
            <p><strong>Start Price:</strong>  Rs 1400</p>
            <p><strong>Rating:</strong> &#9733;&#9733;&#9733;&#9733;&#9734;</p>
            <span class="status available">Available</span>
        </div>
    </div>
</div>
<div class="trust">
    <div class="trust-item">
        <i class="fa-solid fa-check"></i>
        <span>10+ Years Experience</span>
    </div>
    <div class="trust-item">
        <i class="fa-solid fa-check"></i>
        <span>Perfect Fit Guarantee</span>
    </div>
    <div class="trust-item">
        <i class="fa-solid fa-check"></i>
        <span>500+ Happy Clients</span>
    </div>
</div>
      
<footer>
    <div class="footer-content">
        <h3>Tailoring Service</h3>
        <p>We provide premium tailoring services to bring out your best style.</p>
        <ul class="socials">
            <li><a href="https://www.facebook.com/"><i class="fa-brands fa-facebook"></i></a></li>
            <li><a href="https://x.com/"><i class="fab fa-x"></i></a></li>
            <li><a href="https://www.instagram.com/"><i class="fab fa-instagram"></i></a></li>
            <li><a href="https://www.youtube.com/"><i class="fab fa-youtube"></i></a></li>
            <li><a href="https://www.whatsapp.com/"><i class="fab fa-whatsapp"></i></a></li>
        </ul>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2025 ZTailor Craft | All Rights Reserved</p>
    </div>
</footer>
    </div>
     </div>
         <a href="https://wa.me/923049289203" class="whatsapp-float" target="_blank">
    <i class="fab fa-whatsapp"></i>
</a> 

<script src="${pageContext.request.contextPath}/javascript/loginIndex.js"></script>
</body>
</html>


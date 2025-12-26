<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ZTailor Craft</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="images/fav.png">
    <style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif;
}

body {
    background: #0d0d0d;
    color: #fff;
}
.container {
    max-width: 1400px;
    margin: auto;
    padding: 0 20px;
}

.navbar{
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 1000;

    display: flex;
    justify-content: space-between;
    align-items: center;

    padding: 15px 80px; 
    background: rgba(0,0,0,0.65);
    backdrop-filter: blur(8px);
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

.content {
    text-align: center;
    padding:120px;
}

.content .header {
    font-size: 3.2em;
    color: #ff6147;
    text-shadow: 0 0 15px rgba(255,97,71,0.7);
    margin-bottom: 15px;
}

.content .subheader {
    font-size: 1.3em;
    color: #ddd;
    margin-bottom: 20px;
}

.content .cta-button {
    padding: 12px 30px;
    background: linear-gradient(135deg,#ff6147,#ff3b2e);
    color: #fff;
    text-decoration: none;
    border-radius: 12px;
    font-weight: 500;
    box-shadow: 0 5px 15px rgba(255,97,71,0.4);
    transition: 0.3s;
}

.content .cta-button:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 20px rgba(255,97,71,0.6);
}

.services {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 25px;
    margin: 80px;
}

.service-card {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 20px;
    padding: 25px;
    width: 250px;
    text-align: center;
    border: 1px solid rgba(255,255,255,0.1);
    backdrop-filter: blur(12px);
    transition: 0.3s;
}

.service-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 30px rgba(255,97,71,0.3);
}

.service-card i {
    font-size: 2.5em;
    color: #ff6147;
    margin-bottom: 15px;
}

.service-card h3 {
    margin: 10px 0;
    color: #fff;
}

.service-card p {
    font-size: 0.95em;
    color: #ccc;
}

.service-card a {
    display: inline-block;
    margin-top: 12px;
    color: #ff6147;
    text-decoration: none;
    font-weight: 500;
}

.slider-container {
    max-width: 1000px;
    margin: 80px auto;
    position: relative;
}

.slider-container h1 {
    text-align: center;
    color: #ff6147;
    margin-bottom: 20px;
}

.slider {
    height: 400px;
    border-radius: 20px;
    overflow: hidden;
}

.slider-track {
    display: flex;
    overflow-x: auto;
    overflow-y: hidden;
    scroll-snap-type: x mandatory;

    scrollbar-width: none;
    -ms-overflow-style: none;
}

.slider-track::-webkit-scrollbar {
    display: none;
}

.slide {
    flex: 0 0 100%;
    scroll-snap-align: start;
}

.slide img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.slider-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    background: rgba(0,0,0,0.5);
    border: none;
    color: white;
    font-size: 2em;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    cursor: pointer;
    z-index: 10;
}

.slider-btn.left { left: 10px; }
.slider-btn.right { right: 10px; }

.slider-btn:hover {
    background: #ff6147;
}

.slider-dots {
    position: absolute;
    bottom: 15px;
    width: 100%;
    text-align: center;
}

.slider-dots span {
    display: inline-block;
    width: 12px;
    height: 12px;
    margin: 0 5px;
    background: rgba(255,255,255,0.5);
    border-radius: 50%;
    cursor: pointer;
    transition: background 0.3s;
}

.slider-dots span.active {
    background: #ff6147;
}
.affiliated-tailors {
    text-align: center;
    padding: 60px 20px;
}
.affiliated-tailors h1{
    color: #ff6147;
    margin-bottom: 40px;
}
.tailor-grid {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 25px;
}
.tailor-card {
    background: rgba(255,255,255,0.05);
    border-radius: 15px;
    padding: 20px;
    width: 250px;
    text-align: center;
    border: 1px solid rgba(255,255,255,0.1);
    transition: transform 0.3s, box-shadow 0.3s;
}

.tailor-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(255,97,71,0.3);
}

.tailor-card img {
    width: 100%;
    border-radius: 15px;
    margin-bottom: 10px;
}

.tailor-card h3 {
    color: #ff6147;
    margin-bottom: 10px;
}

.tailor-card p {
    font-size: 0.9em;
    color: #ccc;
    margin-bottom: 5px;
}

.status {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 12px;
    font-size: 0.75rem;
}
.available { background: #2ecc71; }
.busy { background: #e74c3c; }

.trust {
    margin: 60px auto;
    max-width: 900px;
    display: flex;
    justify-content: center;
    gap: 40px;
    flex-wrap: wrap;
}

.trust-item {
    display: flex;
    align-items: center;
    gap: 10px;
    background: rgba(255, 255, 255, 0.05);
    padding: 14px 20px;
    border-radius: 14px;
    font-size: 1rem;
    color: #fff;
    border: 1px solid rgba(255,255,255,0.1);
    backdrop-filter: blur(10px);
    transition: 0.3s ease;
}

.trust-item i {
    color: #ff6147;
    font-size: 1.2rem;
}

.trust-item:hover {
    transform: translateY(-4px);
    box-shadow: 0 10px 20px rgba(255,97,71,0.3);
}
footer {
    background: rgba(20, 20, 20, 0.95);
    padding: 50px 20px 30px;
    text-align: center;
    border-radius: 30px 30px 0 0;
    margin-top: 60px;
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255,255,255,0.05);
}


.footer-content {
    max-width: 1000px;
    margin: auto;
}

.footer-content h3 {
    color: #ff6147;
    margin-bottom: 10px;
}

.footer-content p {
    color: #ccc;
    margin-bottom: 20px;
}

footer .socials {
    list-style: none;
    padding: 0;
    display: flex;
    justify-content: center;
    gap: 20px;
}

footer .socials li {
    list-style: none;
}

footer .socials a {
    color: #fff;
    font-size: 1.5em;
    transition: 0.3s;
}

footer .socials a:hover {
    color: #ff6147;
    text-shadow: 0 0 10px #ff6147;
}

.footer-bottom {
    margin-top: 25px;
    font-size: 0.9em;
    color: #aaa;
}
.whatsapp-float {
    position: fixed;
    bottom: 25px;
    right: 25px;
    width: 55px;
    height: 55px;
    background: #25d366;
    color: #fff;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.8em;
    box-shadow: 0 5px 15px rgba(0,0,0,0.4);
    z-index: 9999;
    transition: 0.3s;
}

.whatsapp-float:hover {
    transform: scale(1.1);
    box-shadow: 0 0 20px #25d366;
}

@media (max-width: 600px) {
    .services,
    .tailor-grid {
        flex-direction: column;
        align-items: center;
    }

    .content {
        padding: 80px 20px;
    }

    .content .header {
        font-size: 2.2em;
        line-height: 1.2;
    }

    .trust {
        gap: 20px;
        padding: 0 15px;
    }

    .trust-item {
        width: 100%;
        justify-content: center;
        text-align: center;
    }
        .slider {
        height: 220px;
    }

    .navbar {
        padding: 12px 20px;
    }

    .nav-links {
        display: none;
    }    
}
    
    </style>
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
  
      <!-- Services Section -->
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
<script>
document.addEventListener("DOMContentLoaded", () => {
    const slider = document.querySelector(".slider-track");
    const slides = document.querySelectorAll(".slide");
    const nextBtn = document.getElementById("nextBtn");
    const prevBtn = document.getElementById("prevBtn");
    const dotsContainer = document.getElementById("sliderDots");

    let index = 0;
    slides.forEach((_, i) => {
        const dot = document.createElement("span");
        if (i === 0) dot.classList.add("active");
        dot.onclick = () => goToSlide(i);
        dotsContainer.appendChild(dot);
    });

    const dots = dotsContainer.querySelectorAll("span");

    function goToSlide(i) {
        index = i;
        slider.scrollLeft = slides[i].offsetLeft;
        updateDots();
    }

    function updateDots() {
        dots.forEach(d => d.classList.remove("active"));
        dots[index].classList.add("active");
    }

    nextBtn.onclick = () => {
        index = (index + 1) % slides.length;
        goToSlide(index);
    };

    prevBtn.onclick = () => {
        index = (index - 1 + slides.length) % slides.length;
        goToSlide(index);
    };

    setInterval(() => {
        index = (index + 1) % slides.length;
        goToSlide(index);
    }, 4000);
});
</script>

</body>
</html>


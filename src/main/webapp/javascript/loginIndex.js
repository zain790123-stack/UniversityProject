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
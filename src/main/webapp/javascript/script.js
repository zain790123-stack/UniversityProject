
//Initialize AOS (Animate On Scroll)
AOS.init();

//Show success message if URL contains ?success=true
const params=new URLSearchParams(window.location.search);
if(params.get("success")==="true"){
const msg=document.getElementById("successMsg");
msg.style.display="block";
setTimeout(()=>msg.style.display="none",4000);
}
AOS.init();

const params=new URLSearchParams(window.location.search);
if(params.get("success")==="true"){
const msg=document.getElementById("successMsg");
msg.style.display="block";
setTimeout(()=>msg.style.display="none",4000);
}
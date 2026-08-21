// Lista estática de imágenes (rutas relativas). Modifica aquí agregando tus archivos en assets/slides/
const images = [
  "assets/slides/20251007_125013.jpg",
 
];

const captions = [
  "Descripción 1",
  "Descripción 2",
  "Descripción 3"
];

let index = 0;
let timer = null;

const imgEl = document.getElementById("slideImage");
const captionEl = document.getElementById("caption");
const prevBtn = document.getElementById("prev");
const nextBtn = document.getElementById("next");
const autoplayCheckbox = document.getElementById("autoplay");
const intervalInput = document.getElementById("interval");
const fullscreenBtn = document.getElementById("fullscreen");

function preloadAll(){
  images.forEach(src => {
    const i = new Image();
    i.src = src;
  });
}

function show(i){
  if(i < 0) i = images.length - 1;
  if(i >= images.length) i = 0;
  index = i;
  imgEl.style.opacity = 0;
  setTimeout(() => {
    imgEl.src = images[index];
    captionEl.textContent = captions[index] || "";
    imgEl.style.opacity = 1;
  }, 200);
}

function next(){
  show(index + 1);
}

function prev(){
  show(index - 1);
}

function startAutoplay(){
  stopAutoplay();
  const sec = Math.max(1, Number(intervalInput.value) || 5);
  timer = setInterval(next, sec * 1000);
}

function stopAutoplay(){
  if(timer) { clearInterval(timer); timer = null; }
}

prevBtn.addEventListener("click", () => { prev(); resetAutoplay(); });
nextBtn.addEventListener("click", () => { next(); resetAutoplay(); });

autoplayCheckbox.addEventListener("change", () => {
  if(autoplayCheckbox.checked) startAutoplay(); else stopAutoplay();
});
intervalInput.addEventListener("change", () => {
  if(autoplayCheckbox.checked) startAutoplay();
});

fullscreenBtn.addEventListener("click", async () => {
  const el = document.documentElement;
  if(!document.fullscreenElement) {
    await el.requestFullscreen().catch(()=>{/*silenciar*/});
  } else {
    await document.exitFullscreen().catch(()=>{/*silenciar*/});
  }
});

function resetAutoplay(){
  if(autoplayCheckbox.checked) startAutoplay();
}

document.addEventListener("keydown", (e) => {
  if(e.key === "ArrowLeft") { prev(); resetAutoplay(); }
  if(e.key === "ArrowRight") { next(); resetAutoplay(); }
  if(e.key === " ") { autoplayCheckbox.checked = !autoplayCheckbox.checked; autoplayCheckbox.dispatchEvent(new Event('change')); }
});

// Inicialización
preloadAll();
if(images.length === 0){
  imgEl.alt = "No hay imágenes en la lista. Añade rutas en slideshow.js";
} else {
  show(0);
  if(autoplayCheckbox.checked) startAutoplay();
}

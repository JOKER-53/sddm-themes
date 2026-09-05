/* ─────────────────────────────────────────────────────
   JOKER53 · SDDM Themes  —  Site Script
   Vanilla JS, no deps
───────────────────────────────────────────────────── */

const themes = [
  { id: "marvel",                  name: "MARVEL",              tag: "cinematic title card",       accent: "#ed1d24", cats: ["marvel","dark"] },
  { id: "classic-jdm",             name: "CLASSIC JDM",         tag: "instrument cluster HUD",     accent: "#ffb020", cats: ["cars"] },
  { id: "alienx",                  name: "ALIEN X",             tag: "omnitrix command console",   accent: "#39ff14", cats: ["cyber","dark"] },
  { id: "drag-racer",              name: "DRAG RACER",          tag: "racing telemetry overlay",   accent: "#ff3b30", cats: ["cars"] },
  { id: "gojo",                    name: "GOJO",                tag: "manga monochrome split",     accent: "#cfcfcf", cats: ["anime"] },
  { id: "kawaii",                  name: "KAWAII",              tag: "pastel rounded card",        accent: "#ff9ec7", cats: ["anime"] },
  { id: "joker",                   name: "JOKER",               tag: "off-center theatrical strip",accent: "#8bc34a", cats: ["dark","marvel"] },
  { id: "rdr2",                    name: "RDR2",                tag: "wanted-poster western",      accent: "#c79a4a", cats: ["dark"] },
  { id: "deadpool",                name: "DEADPOOL",            tag: "snarky chat-bubble panel",   accent: "#d4202c", cats: ["marvel"] },
  { id: "bmw",                     name: "BMW MUSEUM",          tag: "M-stripe ignition HUD",      accent: "#1c69d4", cats: ["cars"] },
  { id: "neon-gif",                name: "NEON",                tag: "animated cyberpunk loop",    accent: "#00ffcc", cats: ["cyber"] },
  { id: "zoro-dragon",             name: "ZORO DRAGON",         tag: "anime swordsman aura",       accent: "#00ff44", cats: ["anime","dark"] },
  { id: "bmw-m3",                  name: "BMW M3",              tag: "euro racing dash",           accent: "#1c69d4", cats: ["cars"] },
  { id: "nissan",                  name: "NISSAN DRIFT",        tag: "JDM street vibes",           accent: "#ffb020", cats: ["cars"] },
  { id: "oni-anime-girl",          name: "ONI GIRL",            tag: "neon demon aesthetics",      accent: "#ff00ff", cats: ["anime","cyber"] },
  { id: "mazda-mx5",               name: "MAZDA MX5",           tag: "synthwave night drive",      accent: "#ff2a6d", cats: ["cars","cyber"] },
  { id: "oni-robot",               name: "MECHA ONI",           tag: "glitchy mecha HUD",          accent: "#ff5500", cats: ["cyber","dark"] },
  { id: "dodge",                   name: "DODGE HELLCAT",       tag: "american muscle red",        accent: "#d4202c", cats: ["cars"] },
  { id: "spiderverse",             name: "SPIDER-VERSE",        tag: "comic book halftone",        accent: "#00ffff", cats: ["marvel"] },
  { id: "spiderman",               name: "SPIDERMAN",           tag: "classic red blue hero",      accent: "#e23636", cats: ["marvel"] },
  { id: "sakura-lake",             name: "SAKURA LAKE",         tag: "calm pink petals",           accent: "#ffb7c5", cats: ["nature","anime"] },
  { id: "mountain-sunset",         name: "MOUNTAIN SUNSET",     tag: "retro 80s outrun",           accent: "#ff007f", cats: ["nature","cyber"] },
  { id: "mount-fuji",              name: "MOUNT FUJI",          tag: "minimal zen white",          accent: "#d4f1f9", cats: ["nature"] },
  { id: "the-dark-river",          name: "THE DARK RIVER",      tag: "moody gold gothic",          accent: "#c5a059", cats: ["dark","nature"] },
  { id: "purrple-cat",             name: "PURRPLE CAT",         tag: "lo-fi hip hop chill",        accent: "#a854f7", cats: ["anime","nature"] },
  { id: "hitagi-senjougahara",     name: "SENJOUGAHARA",        tag: "monogatari geometric red",   accent: "#ff0000", cats: ["anime"] },
  { id: "hilda-and-tepig",         name: "HILDA & TEPIG",       tag: "playful rounded orange",     accent: "#ff8c00", cats: ["anime"] },
  { id: "hoodie",                  name: "HOODIE HACKER",       tag: "urban glitch green",         accent: "#39ff14", cats: ["cyber","dark"] },
  { id: "neko-anime",              name: "NEKO KAWAII",         tag: "pastel pink cyan box",       accent: "#00ffff", cats: ["anime"] },
  { id: "zoro-blue",               name: "ZORO BLUE",           tag: "intense sword aura",         accent: "#00aaff", cats: ["anime"] },
  { id: "cat-pond",                name: "CAT POND",            tag: "tranquil nature vibe",       accent: "#4caf50", cats: ["nature"] },
  { id: "cosmic-gateway",          name: "COSMIC GATEWAY",      tag: "deep space portal",          accent: "#9c27b0", cats: ["dark","cyber"] },
  { id: "everest",                 name: "MT. EVEREST",         tag: "snowy peak minimal",         accent: "#00bcd4", cats: ["nature"] },
  { id: "fish-in-rock-pond",       name: "KOI POND",            tag: "zen rock pool",              accent: "#ff9800", cats: ["nature"] },
  { id: "moonlit-rooftop-cat",     name: "MOONLIT ROOFTOP",     tag: "lo-fi starry night",         accent: "#673ab7", cats: ["anime","nature"] },
  { id: "neverness-to-everness",   name: "NTE ANIME",           tag: "action character frame",     accent: "#e91e63", cats: ["anime"] },
  { id: "nissan-skyline",          name: "NISSAN SKYLINE",      tag: "r34 pure JDM",               accent: "#f44336", cats: ["cars"] },
  { id: "ocean-in-jar",            name: "OCEAN JAR",           tag: "surreal desktop pet",        accent: "#03a9f4", cats: ["nature"] },
  { id: "pink-bloom",              name: "PINK BLOOM",          tag: "soft floral pastel",         accent: "#e91e63", cats: ["nature"] },
  { id: "pirates-of-the-caribbean",name: "BLACK PEARL",         tag: "cinematic stormy sea",       accent: "#795548", cats: ["dark"] },
  { id: "pixel-gaming-room",       name: "PIXEL GAMING",        tag: "retro 8-bit den",            accent: "#8bc34a", cats: ["pixel"] },
  { id: "pixel-sakura-city",       name: "PIXEL SAKURA",        tag: "retro tokyo dusk",           accent: "#f06292", cats: ["pixel","anime"] },
  { id: "pokeball",                name: "POKEBALL",            tag: "clean catch layout",         accent: "#f44336", cats: ["anime","pixel"] },
  { id: "super-mario-pixel",       name: "SUPER MARIO",         tag: "nostalgic 8-bit",            accent: "#e52521", cats: ["pixel"] },
];

/* wallpaper url — gif > png > jpg */
const GIF_IDS = new Set([
  "neon-gif","zoro-dragon","bmw-m3","nissan","oni-anime-girl","mazda-mx5",
  "oni-robot","dodge","spiderverse","spiderman","sakura-lake","mountain-sunset",
  "mount-fuji","the-dark-river","purrple-cat","hitagi-senjougahara",
  "hilda-and-tepig","hoodie","neko-anime","zoro-blue","cat-pond",
  "cosmic-gateway","everest","fish-in-rock-pond","moonlit-rooftop-cat",
  "neverness-to-everness","nissan-skyline","ocean-in-jar","pink-bloom",
  "pirates-of-the-caribbean","pixel-gaming-room","pixel-sakura-city",
  "pokeball","super-mario-pixel",
]);
const PNG_IDS = new Set(["alienx","gojo","kawaii"]);

function wpUrl(id) {
  if (GIF_IDS.has(id)) return `./${id}/assets/wallpaper.gif`;
  if (PNG_IDS.has(id)) return `./${id}/assets/wallpaper.png`;
  return `./${id}/assets/wallpaper.jpg`;
}
function thumbUrl(id) {
  return `./${id}/assets/thumbnail.jpg`;
}

/* ── DOM refs ─────────────────────────────── */
const $bg     = document.getElementById("spotlightBg");
const $name   = document.getElementById("spotlightName");
const $desc   = document.getElementById("spotlightDesc");
const $line   = document.getElementById("spotlightLine");
const $cmd    = document.getElementById("spotlightCmd");
const $grid   = document.getElementById("grid");
const $noRes  = document.getElementById("noResults");
const $toast  = document.getElementById("toast");
const $dots   = document.getElementById("slideDots");
const $play   = document.getElementById("playBtn");
const $prev   = document.getElementById("prevBtn");
const $next   = document.getElementById("nextBtn");

/* ── Slideshow state ──────────────────────── */
let activeIndex = 0;
let activeFilter = "all";
let searchQ = "";
let autoplay = false;
let autoTimer = null;
const AUTOPLAY_INTERVAL = 4000; // ms per slide

/* progress bar el */
const $progress = document.createElement("div");
$progress.className = "slide-progress";
document.querySelector(".spotlight-screen").appendChild($progress);

/* ── Build dots ───────────────────────────── */
function buildDots() {
  $dots.innerHTML = "";
  // show only first 8 dots to avoid overflow
  const visible = Math.min(themes.length, 8);
  for (let i = 0; i < visible; i++) {
    const d = document.createElement("div");
    d.className = "sdot" + (i === 0 ? " active" : "");
    d.addEventListener("click", () => goTo(i));
    $dots.appendChild(d);
  }
}

function updateDots(idx) {
  const dots = $dots.querySelectorAll(".sdot");
  const vis = dots.length;
  dots.forEach((d, i) => {
    // sliding window: show dots around current
    const offset = idx < vis ? idx : vis - 1;
    d.classList.toggle("active", i === Math.min(idx, vis - 1));
  });
}

/* ── Spotlight ────────────────────────────── */
function goTo(idx, skipScroll) {
  activeIndex = (idx + themes.length) % themes.length;
  const t = themes[activeIndex];

  // fade out
  $bg.style.opacity = "0";
  setTimeout(() => {
    $bg.style.backgroundImage = `url(${wpUrl(t.id)})`;
    $bg.style.opacity = "1";
  }, 200);

  $name.textContent = t.name;
  $desc.textContent = t.tag;
  $line.style.background = t.accent;
  $line.style.width = "40px";
  $cmd.textContent  = `sudo ./install.sh ${t.id}`;

  // highlight active card
  document.querySelectorAll(".card").forEach(c =>
    c.classList.toggle("active-card", c.dataset.id === t.id)
  );

  updateDots(activeIndex);
  resetProgress();
}

/* ── Progress bar ─────────────────────────── */
function resetProgress() {
  $progress.style.transition = "none";
  $progress.style.width = "0%";
  if (autoplay) {
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        $progress.style.transition = `width ${AUTOPLAY_INTERVAL}ms linear`;
        $progress.style.width = "100%";
      });
    });
  }
}

/* ── Auto-play ────────────────────────────── */
function startAuto() {
  autoplay = true;
  $play.textContent = "⏸";
  $play.classList.add("playing");
  resetProgress();
  autoTimer = setInterval(() => goTo(activeIndex + 1), AUTOPLAY_INTERVAL);
}

function stopAuto() {
  autoplay = false;
  $play.textContent = "▶";
  $play.classList.remove("playing");
  clearInterval(autoTimer);
  $progress.style.transition = "none";
  $progress.style.width = "0%";
}

$play.addEventListener("click", () => autoplay ? stopAuto() : startAuto());
$prev.addEventListener("click", () => { stopAuto(); goTo(activeIndex - 1); });
$next.addEventListener("click", () => { stopAuto(); goTo(activeIndex + 1); });

// pause on hover
document.querySelector(".spotlight-screen").addEventListener("mouseenter", () => {
  if (autoplay) { clearInterval(autoTimer); $progress.style.transition = "none"; }
});
document.querySelector(".spotlight-screen").addEventListener("mouseleave", () => {
  if (autoplay) {
    const remaining = (parseFloat($progress.style.width) / 100) * AUTOPLAY_INTERVAL;
    $progress.style.transition = `width ${remaining}ms linear`;
    $progress.style.width = "100%";
    autoTimer = setInterval(() => goTo(activeIndex + 1), AUTOPLAY_INTERVAL);
  }
});

/* ── Copy helpers ─────────────────────────── */
function showToast(msg) {
  $toast.textContent = msg || "Copied!";
  $toast.classList.add("show");
  setTimeout(() => $toast.classList.remove("show"), 2200);
}

document.getElementById("spotlightCopy").addEventListener("click", () => {
  navigator.clipboard.writeText($cmd.textContent);
  showToast("Command copied!");
});

document.getElementById("copyBtn").addEventListener("click", () => {
  navigator.clipboard.writeText("sudo ./install.sh");
  showToast("Copied!");
});

/* ── Grid ──────────────────────────────────── */
function buildGrid() {
  const q = searchQ.trim().toLowerCase();
  const filtered = themes.filter(t => {
    const matchCat = activeFilter === "all" || t.cats.includes(activeFilter);
    const matchQ   = !q || t.name.toLowerCase().includes(q) || t.id.includes(q) || t.tag.includes(q);
    return matchCat && matchQ;
  });

  $noRes.hidden = filtered.length > 0;
  $grid.innerHTML = "";

  filtered.forEach(t => {
    const card = document.createElement("div");
    card.className = "card" + (t.id === themes[activeIndex].id ? " active-card" : "");
    card.dataset.id = t.id;

    // Use background-image so both JPG thumbnails and GIFs render correctly
    card.style.backgroundImage = `url(${thumbUrl(t.id)})`;
    card.style.backgroundSize = "cover";
    card.style.backgroundPosition = "center";

    card.innerHTML = `
      <div class="card-overlay"></div>
      <div class="card-info">
        <div class="card-name">${t.name}</div>
        <div class="card-tag">${t.tag}</div>
      </div>
      <div class="card-accent-bar" style="background:${t.accent}"></div>
    `;

    card.addEventListener("click", () => {
      stopAuto();
      activeIndex = themes.indexOf(t);
      goTo(activeIndex);
      document.getElementById("themes").scrollIntoView({ behavior: "smooth", block: "start" });
    });

    $grid.appendChild(card);
  });
}

/* ── Filters ───────────────────────────────── */
document.getElementById("filters").addEventListener("click", e => {
  const btn = e.target.closest(".filter");
  if (!btn) return;
  document.querySelectorAll(".filter").forEach(b => b.classList.remove("active"));
  btn.classList.add("active");
  activeFilter = btn.dataset.tag;
  buildGrid();
});

/* ── Search ────────────────────────────────── */
document.getElementById("search").addEventListener("input", e => {
  searchQ = e.target.value;
  buildGrid();
});

window.clearSearch = () => {
  document.getElementById("search").value = "";
  searchQ = "";
  buildGrid();
};

/* ── Init ──────────────────────────────────── */
buildDots();
goTo(0);
buildGrid();

// Start autoplay automatically after 2s
setTimeout(startAuto, 2000);
